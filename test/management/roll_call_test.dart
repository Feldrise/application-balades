import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'management_app.dart';

final _martins = reservation(
  1,
  participants: [
    participant(1, 'Claire', 'Martin', isBooker: true),
    participant(2, 'Léo', 'Martin', priceLabel: 'Enfant', priceAmount: 6),
  ],
);

Finder _box(String name) => find.bySemanticsLabel('Présence de $name');

List<Object?> _presenceChanges(FakeApi api) => [
  for (final r in api.requests)
    if (r.method == 'PUT' && r.url.path.endsWith('/presence'))
      ...((jsonDecode(r.body) as Map<String, Object?>)['changes'] as List).map((c) => [(c as Map)['participant_id'], c['present']]),
];

void main() {
  testWidgets('before the day of the balade, there is nothing to tick', (tester) async {
    final semantics = tester.ensureSemantics();
    final api = FakeApi(rambles: [balade(1, inDays: 1)], reservations: [_martins], myGuide: vera);
    await withFakeApi(api, () async {
      await pumpManagementApp(tester, api: api, location: '/admin/balade/1', user: guide, size: phone);

      expect(find.text('Claire Martin'), findsWidgets);
      expect(_box('Claire Martin'), findsNothing);
      expect(find.text('0 / 2 présents'), findsNothing);
    });
    semantics.dispose();
  });

  testWidgets('on the day of the balade, its guide ticks the present participants and can untick them', (tester) async {
    final semantics = tester.ensureSemantics();
    final api = FakeApi(rambles: [balade(1, inDays: 0)], reservations: [_martins], myGuide: vera);
    await withFakeApi(api, () async {
      await pumpManagementApp(tester, api: api, location: '/admin/balade/1', user: guide, size: phone);

      expect(_box('Claire Martin'), findsOneWidget);
      expect(_box('Léo Martin'), findsOneWidget);
      expect(find.text('0 / 2 présents'), findsOneWidget);

      await tester.tap(_box('Claire Martin'));
      await tester.pumpAndSettle();
      expect(find.text('1 / 2 présents'), findsOneWidget);
      expect(find.text('Synchronisé'), findsOneWidget);

      await tester.tap(_box('Claire Martin'));
      await tester.pumpAndSettle();
      expect(find.text('0 / 2 présents'), findsOneWidget);
      expect(_presenceChanges(api), [
        [1, true],
        [1, null],
      ]);
    });
    semantics.dispose();
  });

  testWidgets('without network, the ticks stay on the phone and the pending changes are shown', (tester) async {
    final semantics = tester.ensureSemantics();
    final api = FakeApi(rambles: [balade(1, inDays: 0)], reservations: [_martins], myGuide: vera, unanswered: [RegExp(r'/presence$')]);
    await withFakeApi(api, () async {
      await pumpManagementApp(tester, api: api, location: '/admin/balade/1', user: guide, size: phone);

      await tester.tap(_box('Claire Martin'));
      await tester.pump();
      expect(find.text('1 / 2 présents'), findsOneWidget);
      expect(find.text('1 modification en attente'), findsOneWidget);

      await tester.tap(_box('Léo Martin'));
      await tester.pump();
      expect(find.text('2 / 2 présents'), findsOneWidget);
      expect(find.text('2 modifications en attente'), findsOneWidget);
    });
    semantics.dispose();
  });

  testWidgets('the presence already marked is shown when the sheet opens again', (tester) async {
    final api = FakeApi(
      rambles: [balade(1, inDays: 0)],
      reservations: [
        reservation(1, participants: [participant(1, 'Claire', 'Martin', isBooker: true, present: true), participant(2, 'Léo', 'Martin')]),
      ],
      myGuide: vera,
    );
    await withFakeApi(api, () async {
      await pumpManagementApp(tester, api: api, location: '/admin/balade/1', user: guide, size: phone);

      expect(find.text('1 / 2 présents'), findsOneWidget);
    });
  });

  testWidgets('an admin does the roll call of any balade, on desktop too', (tester) async {
    final semantics = tester.ensureSemantics();
    final api = FakeApi(
      rambles: [
        balade(1, inDays: -1, guides: [val]),
      ],
      reservations: [_martins],
    );
    await withFakeApi(api, () async {
      await pumpManagementApp(tester, api: api, location: '/admin/balade/1', user: admin, size: desktop);

      await tester.tap(_box('Léo Martin'));
      await tester.pumpAndSettle();
      expect(find.text('1 / 2 présents'), findsOneWidget);
      expect(_presenceChanges(api), [
        [2, true],
      ]);
    });
    semantics.dispose();
  });

  testWidgets('once the roll call is synced, refreshing the feuille shows the presence changed from another device', (tester) async {
    final semantics = tester.ensureSemantics();
    final api = FakeApi(rambles: [balade(1, inDays: 0)], reservations: [_martins], myGuide: vera);
    await withFakeApi(api, () async {
      await pumpManagementApp(tester, api: api, location: '/admin/balade/1', user: guide, size: phone);
      await tester.tap(_box('Claire Martin'));
      await tester.pumpAndSettle();
      expect(find.text('1 / 2 présents'), findsOneWidget);

      // An admin unticks Claire from another device.
      api.reservations[0] = {
        ...api.reservations[0],
        'participants': [
          for (final p in api.reservations[0]['participants'] as List) {...p as Map<String, Object?>, 'present': null},
        ],
      };
      await tester.fling(find.text('1 / 2 présents'), const Offset(0, 400), 1000);
      await tester.pumpAndSettle();

      expect(find.text('0 / 2 présents'), findsOneWidget);
      expect(find.text('Synchronisé'), findsOneWidget);
    });
    semantics.dispose();
  });

  testWidgets('unticking a participant already present takes them out of the present ones', (tester) async {
    final semantics = tester.ensureSemantics();
    final api = FakeApi(
      rambles: [balade(1, inDays: 0)],
      reservations: [
        reservation(1, participants: [participant(1, 'Claire', 'Martin', isBooker: true, present: true), participant(2, 'Léo', 'Martin')]),
      ],
      myGuide: vera,
    );
    await withFakeApi(api, () async {
      await pumpManagementApp(tester, api: api, location: '/admin/balade/1', user: guide, size: phone);
      expect(find.text('1 / 2 présents'), findsOneWidget);

      await tester.tap(_box('Claire Martin'));
      await tester.pumpAndSettle();

      expect(find.text('0 / 2 présents'), findsOneWidget);
      expect(find.text('Synchronisé'), findsOneWidget);
    });
    semantics.dispose();
  });
}
