import 'dart:convert';

import 'package:balade/features/admin/design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'management_app.dart';

final _claire = reservation(
  1,
  email: 'claire@example.com',
  phone: '06 12 34 56 78',
  amountPaid: 2400,
  estimatedAmount: 2400,
  participants: [
    participant(1, 'Claire', 'Martin', isBooker: true),
    participant(2, 'Léo', 'Martin', priceLabel: 'Enfant', priceAmount: 6),
  ],
);

void main() {
  testWidgets('on a phone, the feuille de balade opens on the participants of the reservations', (tester) async {
    final api = FakeApi(
      rambles: [balade(1, inDays: 3, title: 'Champignons de Paimpont')],
      reservations: [_claire],
    );
    await withFakeApi(api, () async {
      await pumpManagementApp(tester, api: api, location: '/admin/balade/1', user: admin, size: phone);

      expect(find.text('Champignons de Paimpont'), findsOneWidget);
      expect(find.text('Claire Martin'), findsWidgets);
      expect(find.text('claire@example.com'), findsOneWidget);
      expect(find.text('Confirmée'), findsOneWidget);
      expect(find.text('Payé 24 €'), findsOneWidget);
      expect(find.text('Léo Martin'), findsOneWidget);
      expect(find.text('Enfant · 6 €'), findsOneWidget);
      expect(find.text('Tarifs'), findsNothing, reason: 'the Balade tab is not open');
    });
  });

  testWidgets('at 390 px, the numbers strip wraps and shows every figure', (tester) async {
    final api = FakeApi(
      rambles: [balade(1, inDays: 3, max: 12)],
      reservations: [
        _claire,
        reservation(2, status: 'pending', email: 'paul@example.com', participants: [participant(3, 'Paul', 'Durand', isBooker: true, present: true)]),
        reservation(3, status: 'cancelled', email: 'zoe@example.com', participants: [participant(4, 'Zoé', 'Petit', isBooker: true)]),
      ],
    );
    await withFakeApi(api, () async {
      await pumpManagementApp(tester, api: api, location: '/admin/balade/1', user: admin, size: phone);

      final strip = find.byType(NumbersStrip);
      expect(find.descendant(of: strip, matching: find.text('3/12')), findsOneWidget);
      expect(find.descendant(of: strip, matching: find.text('1/3')), findsOneWidget);
      for (final label in ['places prises', 'présents', 'confirmées', 'à confirmer', 'annulées']) {
        final rect = tester.getRect(find.descendant(of: strip, matching: find.text(label)));
        expect(rect.right, lessThanOrEqualTo(phone.width), reason: '$label is not cut');
      }
      expect(tester.getTopLeft(find.text('à confirmer')).dy, greaterThan(tester.getTopLeft(find.text('présents')).dy), reason: 'the strip wraps');
    });
  });

  testWidgets('« Appeler » is offered only when the booker gave a phone, « Écrire » always', (tester) async {
    final api = FakeApi(
      rambles: [balade(1, inDays: 3)],
      reservations: [
        _claire,
        reservation(2, email: 'paul@example.com', participants: [participant(3, 'Paul', 'Durand', isBooker: true)]),
      ],
    );
    await withFakeApi(api, () async {
      await pumpManagementApp(tester, api: api, location: '/admin/balade/1', user: admin, size: phone);

      expect(find.byTooltip('Appeler'), findsOneWidget);
      expect(find.byTooltip('Écrire'), findsNWidgets(2));
    });
  });

  testWidgets('an unknown tarif reads « tarif à préciser », and the waiting list and cancelled ones are apart', (tester) async {
    final api = FakeApi(
      rambles: [balade(1, inDays: 3)],
      reservations: [
        reservation(1, status: 'cancelled', email: 'zoe@example.com', participants: [participant(4, 'Zoé', 'Petit', isBooker: true)]),
        reservation(2, status: 'waiting_list', email: 'max@example.com', participants: [participant(5, 'Max', 'Roux', isBooker: true)]),
        reservation(3, hasMissingPrices: true, estimatedAmount: 0, email: 'ana@example.com', participants: [participant(6, 'Ana', 'Leroy', isBooker: true, priceMissing: true)]),
      ],
    );
    await withFakeApi(api, () async {
      await pumpManagementApp(tester, api: api, location: '/admin/balade/1', user: admin, size: phone);

      expect(find.text('tarif à préciser'), findsOneWidget);
      final order = ['ATTENDUES · 1', 'ana@example.com', 'LISTE D\'ATTENTE · 1', 'max@example.com', 'ANNULÉES · 1', 'zoe@example.com'];
      for (var i = 1; i < order.length; i++) {
        expect(tester.getTopLeft(find.text(order[i])).dy, greaterThan(tester.getTopLeft(find.text(order[i - 1])).dy), reason: '${order[i]} comes after ${order[i - 1]}');
      }
    });
  });

  testWidgets('the search finds a reservation by participant name or email', (tester) async {
    final api = FakeApi(
      rambles: [balade(1, inDays: 3)],
      reservations: [
        _claire,
        reservation(2, email: 'paul@example.com', participants: [participant(3, 'Paul', 'Durand', isBooker: true)]),
      ],
    );
    await withFakeApi(api, () async {
      await pumpManagementApp(tester, api: api, location: '/admin/balade/1', user: admin, size: phone);

      await tester.enterText(find.byType(TextField), 'léo');
      await tester.pumpAndSettle();
      expect(find.text('claire@example.com'), findsOneWidget);
      expect(find.text('paul@example.com'), findsNothing);

      await tester.enterText(find.byType(TextField), 'PAUL@');
      await tester.pumpAndSettle();
      expect(find.text('claire@example.com'), findsNothing);
      expect(find.text('paul@example.com'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'zzz');
      await tester.pumpAndSettle();
      expect(find.text('Aucune réservation trouvée'), findsOneWidget);
    });
  });

  testWidgets('a balade nobody booked shows an empty state', (tester) async {
    final api = FakeApi(rambles: [balade(1, inDays: 3)]);
    await withFakeApi(api, () async {
      await pumpManagementApp(tester, api: api, location: '/admin/balade/1', user: admin, size: phone);

      expect(find.text('Aucune réservation'), findsOneWidget);
    });
  });

  testWidgets('the Balade tab shows the details, Modifier and Dupliquer', (tester) async {
    final api = FakeApi(rambles: [balade(1, inDays: 3)], reservations: [_claire]);
    await withFakeApi(api, () async {
      await pumpManagementApp(tester, api: api, location: '/admin/balade/1', user: admin, size: tablet);

      await tester.tap(find.text('Balade'));
      await tester.pumpAndSettle();

      expect(find.text('Tarifs'), findsOneWidget);
      expect(find.text('Modifier'), findsOneWidget);
      expect(find.text('Dupliquer'), findsOneWidget);
      expect(find.text('claire@example.com'), findsNothing);
      expect(find.text('Annuler la balade'), findsNothing, reason: 'destructive actions sit in the « ⋯ » menu');
    });
  });

  testWidgets('« Annuler la balade » sits in the « ⋯ » menu and asks for confirmation before cancelling', (tester) async {
    final api = FakeApi(rambles: [balade(1, inDays: 3)], reservations: [_claire]);
    await withFakeApi(api, () async {
      await pumpManagementApp(tester, api: api, location: '/admin/balade/1', user: admin, size: phone);

      await tester.tap(find.byTooltip('Plus d\'actions'));
      await tester.pumpAndSettle();
      expect(find.text('Exporter les participants'), findsOneWidget);
      await tester.tap(find.text('Annuler la balade'));
      await tester.pumpAndSettle();

      expect(find.textContaining('seront prévenues par email'), findsOneWidget);
      expect(find.textContaining('aucun remboursement automatique'), findsOneWidget);
      expect(api.requests.where((r) => r.method == 'PUT'), isEmpty);

      await tester.enterText(find.widgetWithText(TextField, 'Motif d\'annulation *'), 'Alerte orage');
      await tester.tap(find.widgetWithText(FilledButton, 'Annuler la balade'));
      await tester.pumpAndSettle();

      final cancel = api.requests.singleWhere((r) => r.method == 'PUT');
      expect(cancel.url.path, endsWith('/rambles/1/cancel'));
      expect(jsonDecode(cancel.body), {'reason': 'Alerte orage'});
    });
  });

  testWidgets('on desktop, reservations and the balade sit side by side, without tabs', (tester) async {
    final api = FakeApi(rambles: [balade(1, inDays: 3)], reservations: [_claire]);
    await withFakeApi(api, () async {
      await pumpManagementApp(tester, api: api, location: '/admin/balade/1', user: admin, size: desktop);

      expect(find.byType(SegmentedButton<Object>), findsNothing);
      expect(find.text('PERSONNE QUI RÉSERVE'), findsOneWidget);
      expect(tester.getTopLeft(find.text('La balade')).dx, greaterThan(tester.getTopRight(find.text('claire@example.com')).dx));
      expect(tester.getTopLeft(find.text('La balade')).dy, lessThan(tester.getTopLeft(find.text('claire@example.com')).dy));
      expect(find.text('Tarifs'), findsOneWidget);
    });
  });

  group('status change', () {
    testWidgets('the admin taps the badge, picks Annulée, confirms, and the API gets the new status', (tester) async {
      final api = FakeApi(rambles: [balade(1, inDays: 3)], reservations: [_claire]);
      await withFakeApi(api, () async {
        await pumpManagementApp(tester, api: api, location: '/admin/balade/1', user: admin, size: phone);

        await tester.tap(find.text('Confirmée'));
        await tester.pumpAndSettle();
        for (final status in ['Confirmée', 'À confirmer', 'Liste d\'attente', 'Annulée']) {
          expect(find.descendant(of: find.byType(ListTile), matching: find.text(status)), findsOneWidget);
        }
        expect(find.text('Les places sont libérées'), findsOneWidget);

        await tester.tap(find.text('Annulée'));
        await tester.pumpAndSettle();
        expect(find.textContaining('Les places de ses 2 participants seront libérées'), findsOneWidget);
        expect(find.textContaining('prévenue par email'), findsOneWidget);
        expect(find.textContaining('aucun remboursement automatique'), findsOneWidget, reason: 'the reservation is already paid');

        await tester.tap(find.widgetWithText(FilledButton, 'Annuler la réservation'));
        await tester.pumpAndSettle();

        final change = api.requests.singleWhere((r) => r.method == 'PUT');
        expect(change.url.path, endsWith('/reservations/admin/1/status'));
        expect(jsonDecode(change.body), {'status': 'cancelled', 'send_email': true});
        expect(find.text('ANNULÉES · 1'), findsOneWidget, reason: 'the sheet reloads');
      });
    });

    testWidgets('forcing Confirmée says it skips the booker\'s confirmation and online payment', (tester) async {
      final pending = reservation(2, status: 'pending', email: 'paul@example.com', participants: [participant(3, 'Paul', 'Durand', isBooker: true)]);
      final api = FakeApi(rambles: [balade(1, inDays: 3)], reservations: [pending]);
      await withFakeApi(api, () async {
        await pumpManagementApp(tester, api: api, location: '/admin/balade/1', user: admin, size: phone);

        await tester.tap(find.text('À confirmer'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Confirmée'));
        await tester.pumpAndSettle();

        expect(find.textContaining('sans la confirmation de la personne qui réserve ni son paiement en ligne'), findsOneWidget);
        await tester.tap(find.widgetWithText(FilledButton, 'Confirmer la réservation'));
        await tester.pumpAndSettle();

        expect(jsonDecode(api.requests.singleWhere((r) => r.method == 'PUT').body), {'status': 'confirmed', 'send_email': true});
      });
    });

    testWidgets('moving to the waiting list says the places are freed, and going back sends nothing', (tester) async {
      final api = FakeApi(rambles: [balade(1, inDays: 3)], reservations: [_claire]);
      await withFakeApi(api, () async {
        await pumpManagementApp(tester, api: api, location: '/admin/balade/1', user: admin, size: phone);

        await tester.tap(find.text('Confirmée'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Liste d\'attente'));
        await tester.pumpAndSettle();

        expect(find.textContaining('seront libérées'), findsOneWidget);
        await tester.tap(find.text('Retour'));
        await tester.pumpAndSettle();
        expect(api.requests.where((r) => r.method == 'PUT'), isEmpty);
      });
    });

    testWidgets('the reservation detail has a « Changer le statut » button', (tester) async {
      final api = FakeApi(rambles: [balade(1, inDays: 3)], reservations: [_claire]);
      await withFakeApi(api, () async {
        await pumpManagementApp(tester, api: api, location: '/admin/balade/1', user: admin, size: phone);

        await tester.tap(find.text('claire@example.com'));
        await tester.pumpAndSettle();
        await tester.tap(find.widgetWithText(OutlinedButton, 'Changer le statut'));
        await tester.pumpAndSettle();

        expect(find.text('Les places sont libérées'), findsOneWidget);
      });
    });

    testWidgets('a guide without the permission cannot change a status', (tester) async {
      final api = FakeApi(rambles: [balade(1, inDays: 3)], reservations: [_claire], myGuide: vera);
      await withFakeApi(api, () async {
        await pumpManagementApp(tester, api: api, location: '/admin/balade/1', user: guide, size: phone);

        expect(find.text('Confirmée'), findsOneWidget);
        // The badge is not a button for them: the tap falls through to the row, which opens the reservation detail
        await tester.tap(find.text('Confirmée'));
        await tester.pumpAndSettle();
        expect(find.text('Les places sont libérées'), findsNothing);
        expect(find.text('DATES'), findsOneWidget);
        expect(find.text('Changer le statut'), findsNothing);
      });
    });
  });
}
