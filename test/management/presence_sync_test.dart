import 'dart:async';
import 'dart:convert';

import 'package:balade/features/admin/ramble_details_page/presence/presence_sync.dart';
import 'package:balade/features/reservations/models/reservation/reservation.dart';
import 'package:balade/features/reservations/reservations_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _claire = Participant(1, firstName: 'Claire', lastName: 'Martin');
const _leo = Participant(2, firstName: 'Léo', lastName: 'Martin');

/// The presence API: no network until [online], then each change gets the outcome of [outcomes] (applied by default).
class _PresenceApi {
  bool online = false;
  final Map<int, Map<String, Object?>> outcomes = {};
  final List<List<Map<String, Object?>>> batches = [];

  /// When set, the API refuses every batch with this answer.
  http.Response? refusal;

  /// When set, the next answer waits for it: the batch is on its way.
  Completer<void>? onTheWay;

  Future<http.Response> handle(http.Request request) async {
    final wait = onTheWay;
    if (wait != null) {
      onTheWay = null;
      await wait.future;
    }
    if (!online) throw http.ClientException('no network');
    if (refusal != null) {
      batches.add(const []);
      return refusal!;
    }
    expect(request.method, 'PUT');
    expect(request.url.path, '/api/v1/reservations/admin/rambles/1/presence');
    final changes = [for (final c in (jsonDecode(request.body) as Map<String, Object?>)['changes'] as List) c as Map<String, Object?>];
    batches.add(changes);
    return http.Response(
      jsonEncode({
        'participants': [
          for (final c in changes)
            outcomes[c['participant_id']] ??
                {'participant_id': c['participant_id'], 'outcome': 'applied', 'present': c['present'], 'presence_marked_at': c['marked_at'], 'presence_marked_by': 2},
        ],
      }),
      200,
    );
  }
}

void main() {
  late _PresenceApi api;
  late DateTime now;

  PresenceSync openSync({Duration retryDelay = const Duration(minutes: 1), bool disposedByTest = false}) {
    final sync = PresenceSync(
      rambleId: 1,
      retryDelay: retryDelay,
      service: ReservationsService(client: MockClient(api.handle), baseUrl: 'http://api.test/api/v1'),
      token: 'guide-token',
      clock: () => now,
    );
    if (!disposedByTest) addTearDown(sync.dispose);
    return sync;
  }

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    api = _PresenceApi();
    now = DateTime.utc(2026, 11, 8, 9, 30);
  });

  test('a change is recorded on the phone right away, even without network', () async {
    final sync = openSync();
    await sync.load();

    await sync.mark(_claire, true);

    expect(sync.presenceOf(_claire), isTrue);
    expect(sync.presenceOf(_leo), isNull);
    expect(sync.pendingCount, 1);
  });

  test('the changes not sent are still there after the app restarts', () async {
    final before = openSync();
    await before.load();
    await before.mark(_claire, true);
    await before.mark(_leo, false);

    final after = openSync();
    await after.load();

    expect(after.presenceOf(_claire), isTrue);
    expect(after.presenceOf(_leo), isFalse);
    expect(after.pendingCount, 2);
  });

  test('the changes waiting are sent in one batch once the network is back, then nothing is pending', () async {
    final sync = openSync();
    await sync.load();
    await sync.mark(_claire, true);
    now = now.add(const Duration(minutes: 1));
    await sync.mark(_leo, true);
    expect(api.batches, isEmpty);

    api.online = true;
    await sync.send();

    expect(api.batches, [
      [
        {'participant_id': 1, 'present': true, 'marked_at': '2026-11-08T09:30:00.000Z'},
        {'participant_id': 2, 'present': true, 'marked_at': '2026-11-08T09:31:00.000Z'},
      ],
    ]);
    expect(sync.pendingCount, 0);
    expect(sync.presenceOf(_claire), isTrue, reason: 'the presence recorded by the API is still shown');
    expect(sync.presenceOf(_leo), isTrue);

    final restarted = openSync();
    await restarted.load();
    expect(restarted.pendingCount, 0, reason: 'what was sent is no longer on the phone');
  });

  test('an outdated change gives way to the later presence recorded by the API', () async {
    final sync = openSync();
    await sync.load();
    await sync.mark(_claire, true);

    api.online = true;
    api.outcomes[1] = {'participant_id': 1, 'outcome': 'outdated', 'present': false, 'presence_marked_at': '2026-11-08T09:45:00Z', 'presence_marked_by': 1};
    await sync.send();

    expect(sync.presenceOf(_claire), isFalse);
    expect(sync.pendingCount, 0);
  });

  test('a change refused for a cancelled reservation or an unknown participant leaves the queue without blocking the others', () async {
    const zoe = Participant(3, firstName: 'Zoé', lastName: 'Petit');
    final sync = openSync();
    await sync.load();
    await sync.mark(_claire, true);
    await sync.mark(_leo, true);
    await sync.mark(zoe, true);

    api.online = true;
    api.outcomes[1] = {'participant_id': 1, 'outcome': 'reservation_cancelled', 'present': null, 'presence_marked_at': null, 'presence_marked_by': null};
    api.outcomes[3] = {'participant_id': 3, 'outcome': 'unknown_participant', 'present': null, 'presence_marked_at': null, 'presence_marked_by': null};
    await sync.send();

    expect(sync.pendingCount, 0);
    expect(sync.presenceOf(_leo), isTrue);
    expect(sync.presenceOf(_claire), isNull, reason: 'the presence recorded by the API is shown');

    await sync.send();
    expect(api.batches, hasLength(1), reason: 'nothing is left to send');
  });

  test('a change made while a batch is on its way is sent afterwards, the latest change winning', () async {
    final sync = openSync();
    await sync.load();
    await sync.mark(_claire, true);

    api.online = true;
    final sending = sync.send();
    now = now.add(const Duration(seconds: 5));
    await sync.mark(_claire, null);
    await sending;

    expect(sync.presenceOf(_claire), isNull);
    expect(sync.pendingCount, 0);
    expect(api.batches.last, [
      {'participant_id': 1, 'present': null, 'marked_at': '2026-11-08T09:30:05.000Z'},
    ]);
  });

  test('without network, the changes are sent again by themselves until the network is back', () async {
    final sync = openSync(retryDelay: const Duration(milliseconds: 20));
    await sync.load();
    await sync.mark(_claire, true);
    expect(sync.pendingCount, 1);

    api.online = true;
    await Future<void>.delayed(const Duration(milliseconds: 100));

    expect(sync.pendingCount, 0);
    expect(api.batches, hasLength(1));
  });

  test('a batch answered after the feuille was closed does not lose the changes made since it reopened', () async {
    final closed = openSync(disposedByTest: true);
    await closed.load();
    api.online = true;
    api.onTheWay = Completer<void>();
    final answer = api.onTheWay!;
    final sending = closed.mark(_claire, true);
    await pumpEventQueue();
    closed.dispose();

    final reopened = openSync();
    await reopened.load();
    api.online = false;
    await reopened.mark(_leo, true);

    api.online = true;
    answer.complete();
    await sending;

    final restarted = openSync();
    await restarted.load();
    expect(restarted.presenceOf(_leo), isTrue, reason: 'the change made after reopening is still on the phone');
    expect(restarted.pendingCount, 1, reason: 'only the change the API recorded left the phone');
  });

  test('once the participants are reloaded, they tell the presence of the changes already sent; the changes waiting still win', () async {
    final sync = openSync();
    await sync.load();
    api.online = true;
    await sync.mark(_claire, true);
    api.online = false;
    await sync.mark(_leo, true);

    // Meanwhile an admin unticked Claire and Léo from another device.
    sync.participantsReloaded();

    expect(sync.presenceOf(_claire.copyWith(present: null)), isNull, reason: 'the reloaded state is the latest one recorded by the API');
    expect(sync.presenceOf(_leo.copyWith(present: null)), isTrue, reason: 'the change not sent yet is newer');
  });

  test('a change refused by the API stays on the phone, the refusal is shown and it is not sent again by itself', () async {
    final sync = openSync(retryDelay: const Duration(milliseconds: 20));
    await sync.load();
    api.online = true;
    api.refusal = http.Response('{"error":"presence can be marked from the day of the ramble","reason":"ramble_not_started"}', 409);

    await sync.mark(_claire, true);
    await Future<void>.delayed(const Duration(milliseconds: 100));

    expect(sync.pendingCount, 1);
    expect(sync.presenceOf(_claire), isTrue);
    expect(sync.refusal, 'Le pointage n\'est possible qu\'à partir du jour de la balade.');
    expect(api.batches, hasLength(1), reason: 'a refusal is not sent again every few seconds');

    api.refusal = null;
    await sync.send();
    expect(sync.pendingCount, 0);
    expect(sync.refusal, isNull);
  });

  test('a change the guide may not make is refused with its reason', () async {
    final sync = openSync();
    await sync.load();
    api.online = true;
    api.refusal = http.Response('{"error":"forbidden"}', 403);

    await sync.mark(_claire, true);

    expect(sync.pendingCount, 1);
    expect(sync.refusal, 'Vous n\'avez pas le droit de pointer cette balade.');
  });
}
