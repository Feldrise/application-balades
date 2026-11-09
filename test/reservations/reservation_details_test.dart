import 'package:balade/features/admin/design/design.dart';
import 'package:balade/features/guides/models/guide/guide.dart';
import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../management/management_app.dart';
import 'booker_app.dart';

/// Before the confirmation period of the balade, held on 1 December 2026: it opens on 28 November.
final _beforePeriod = Clock.fixed(DateTime.utc(2026, 11, 20, 10));

/// Within the confirmation period: from 28 November until the deadline, 30 November in the evening.
final _withinPeriod = Clock.fixed(DateTime.utc(2026, 11, 29, 10));

/// Once the deadline has passed.
final _afterDeadline = Clock.fixed(DateTime.utc(2026, 12, 1, 6));

/// Opens the reservation 12 of the booker, on a phone, at [now], and runs [check] on it.
Future<void> _onDetail(WidgetTester tester, {required BookerApi api, Clock? now, Future<void> Function()? check}) async {
  await withFakeApi(api, () async {
    await withClock(now ?? _withinPeriod, () async {
      await pumpManagementApp(tester, api: api, location: '/mes-reservations/12', user: booker, size: phone);
      await check?.call();
      expect(tester.takeException(), isNull, reason: 'nothing overflows at 390 px');
    });
  });
}

BookerApi _api({
  List<Guide> guides = const [guideWithPhone],
  String status = 'pending',
  int amountPaid = 0,
  String? meetingPoint = 'Parking de l\'étang, Paimpont',
  double? latitude = 48.0156,
  double? longitude = -2.1696,
}) => BookerApi(
  ramble: publicBalade(guides: guides, meetingPoint: meetingPoint, latitude: latitude, longitude: longitude),
  bookings: [bookerReservation(status: status, amountPaid: amountPaid)],
);

void main() {
  testWidgets('the detail tells where to meet and links the meeting point to Maps', (tester) async {
    await _onDetail(
      tester,
      api: _api(),
      check: () async {
        expect(find.text('Parking de l\'étang, Paimpont'), findsOneWidget);
        expect(find.text('Ouvrir dans Maps'), findsOneWidget);
      },
    );
  });

  testWidgets('the detail gives the phone and the email of the guide', (tester) async {
    await _onDetail(
      tester,
      api: _api(),
      check: () async {
        expect(find.text('VOTRE GUIDE'), findsOneWidget);
        expect(find.text('Vera Lemoine'), findsOneWidget);
        expect(find.text('vera@example.com'), findsOneWidget);
        expect(find.textContaining('12 34 56 78'), findsOneWidget);
      },
    );
  });

  testWidgets('a guide without a phone is contacted by email only', (tester) async {
    const noPhone = Guide(7, firstName: 'Vera', lastName: 'Lemoine', email: 'vera@example.com', isActive: true);
    await _onDetail(
      tester,
      api: _api(guides: const [noPhone]),
      check: () async {
        expect(find.text('Vera Lemoine'), findsOneWidget);
        expect(find.text('vera@example.com'), findsOneWidget);
        expect(find.byIcon(Icons.call_outlined), findsNothing);
      },
    );
  });

  testWidgets('a balade with several guides lists each of them', (tester) async {
    const second = Guide(8, firstName: 'Val', lastName: 'Morin', email: 'val@example.com', phone: '+33687654321', isActive: true);
    await _onDetail(
      tester,
      api: _api(guides: const [guideWithPhone, second]),
      check: () async {
        expect(find.text('VOS GUIDES'), findsOneWidget);
        expect(find.text('Vera Lemoine'), findsOneWidget);
        expect(find.text('Val Morin'), findsOneWidget);
      },
    );
  });

  testWidgets('a pending reservation tells the confirmation period', (tester) async {
    await _onDetail(
      tester,
      api: _api(),
      now: _beforePeriod,
      check: () async {
        expect(find.textContaining('À confirmer entre le 28 novembre'), findsOneWidget);
        expect(find.textContaining('et le 30 novembre'), findsOneWidget);
      },
    );
  });

  testWidgets('a confirmed reservation has no confirmation period', (tester) async {
    await _onDetail(
      tester,
      api: _api(status: 'confirmed', amountPaid: 1850),
      check: () async {
        expect(find.textContaining('À confirmer entre'), findsNothing);
        expect(find.text('Confirmer et payer'), findsNothing);
      },
    );
  });

  testWidgets('« Confirmer et payer » is offered within the confirmation period only', (tester) async {
    await _onDetail(
      tester,
      api: _api(),
      now: _withinPeriod,
      check: () async {
        expect(find.widgetWithText(FilledButton, 'Confirmer et payer'), findsOneWidget);
      },
    );
    await _onDetail(
      tester,
      api: _api(),
      now: _beforePeriod,
      check: () async {
        expect(find.text('Confirmer et payer'), findsNothing);
      },
    );
    await _onDetail(
      tester,
      api: _api(),
      now: _afterDeadline,
      check: () async {
        expect(find.text('Confirmer et payer'), findsNothing);
        expect(find.textContaining('Le délai de confirmation est dépassé'), findsOneWidget);
      },
    );
  });

  testWidgets('the detail shows the equipment and the prerequisites', (tester) async {
    await _onDetail(
      tester,
      api: _api(),
      check: () async {
        expect(find.text('Chaussures de marche et une gourde'), findsOneWidget);
        expect(find.text('Savoir marcher deux heures'), findsOneWidget);
      },
    );
  });

  testWidgets('a reservation in the waiting list says it will pass when places free up', (tester) async {
    await _onDetail(
      tester,
      api: _api(status: 'waiting_list'),
      check: () async {
        expect(find.text('Liste d\'attente'), findsOneWidget);
        expect(find.textContaining('vous passerez dès que des places se libèrent'), findsOneWidget);
      },
    );
  });

  testWidgets('a confirmed reservation says the place is confirmed', (tester) async {
    await _onDetail(
      tester,
      api: _api(status: 'confirmed', amountPaid: 1850),
      check: () async {
        expect(find.text('Confirmée'), findsOneWidget);
        expect(find.textContaining('Votre place est confirmée'), findsOneWidget);
      },
    );
  });

  testWidgets('the status uses the badge of the management area', (tester) async {
    await _onDetail(
      tester,
      api: _api(),
      check: () async {
        expect(find.byType(ReservationStatusBadge), findsOneWidget);
        expect(find.text('À confirmer'), findsOneWidget);
      },
    );
  });

  testWidgets('the booker still adds participants, removes one and cancels', (tester) async {
    final api = _api();
    await _onDetail(
      tester,
      api: api,
      check: () async {
        expect(find.text('Ajouter des participants'), findsOneWidget);
        expect(find.byTooltip('Retirer'), findsNWidgets(2));
        expect(find.byTooltip('Modifier'), findsNWidgets(2));
        expect(find.text('Annuler la réservation'), findsOneWidget);

        await tester.ensureVisible(find.byTooltip('Retirer').last);
        await tester.tap(find.byTooltip('Retirer').last);
        await tester.pumpAndSettle();
        await tester.tap(find.widgetWithText(FilledButton, 'Retirer'));
        await tester.pumpAndSettle();
        expect(api.requests.where((r) => r.method == 'DELETE').single.url.path, endsWith('/reservations/12/participants/2'));
        expect(find.text('Léo Martin'), findsNothing);

        await tester.ensureVisible(find.text('Annuler la réservation'));
        await tester.tap(find.text('Annuler la réservation'));
        await tester.pumpAndSettle();
        await tester.tap(find.descendant(of: find.byType(AlertDialog), matching: find.widgetWithText(FilledButton, 'Annuler la réservation')));
        await tester.pumpAndSettle();
        expect(api.requests.where((r) => r.method == 'PUT').single.url.path, endsWith('/reservations/12/cancel'));
        expect(find.text('Annulée'), findsOneWidget);
        expect(find.text('Annuler la réservation'), findsNothing);
      },
    );
  });

  testWidgets('a cancelled reservation offers no action', (tester) async {
    await _onDetail(
      tester,
      api: _api(status: 'cancelled'),
      check: () async {
        expect(find.text('Annulée'), findsOneWidget);
        expect(find.text('Ajouter des participants'), findsNothing);
        expect(find.byTooltip('Retirer'), findsNothing);
      },
    );
  });

  testWidgets('without GPS coordinates the Maps link still opens the meeting point', (tester) async {
    await _onDetail(
      tester,
      api: _api(latitude: null, longitude: null),
      check: () async {
        expect(find.text('Ouvrir dans Maps'), findsOneWidget);
      },
    );
  });

  testWidgets('a balade that could not be loaded leaves the reservation readable', (tester) async {
    final api = BookerApi(ramble: publicBalade(id: 99), bookings: [bookerReservation()]);
    await _onDetail(
      tester,
      api: api,
      check: () async {
        expect(find.textContaining('n\'ont pas pu être chargés'), findsOneWidget);
        expect(find.text('Claire Martin (vous)'), findsOneWidget);
      },
    );
  });
}
