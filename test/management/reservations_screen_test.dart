import 'dart:convert';

import 'package:balade/features/admin/design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import 'management_app.dart';

Map<String, Object?> _ramble(String title, {String date = '2026-11-14T10:00:00Z'}) => {'title': title, 'date': date};

List<Map<String, Object?>> _reservations() => [
  reservation(
    1,
    email: 'claire@example.com',
    phone: '06 12 34 56 78',
    amountPaid: 2400,
    estimatedAmount: 2400,
    ramble: _ramble('Champignons de Paimpont'),
    participants: [
      participant(1, 'Claire', 'Martin', isBooker: true),
      participant(2, 'Léo', 'Martin', priceLabel: 'Enfant', priceAmount: 6),
    ],
  ),
  reservation(
    2,
    status: 'pending',
    email: 'paul@example.com',
    ramble: _ramble('Plantes sauvages', date: '2026-11-21T10:00:00Z'),
    rambleId: 2,
    participants: [participant(3, 'Paul', 'Durand', isBooker: true)],
  ),
  reservation(
    3,
    status: 'waiting_list',
    email: 'zoe@example.com',
    ramble: _ramble('Champignons de Paimpont'),
    participants: [participant(4, 'Zoé', 'Petit', isBooker: true, priceMissing: true)],
    estimatedAmount: 0,
    hasMissingPrices: true,
  ),
  reservation(4, status: 'cancelled', email: 'ines@example.com', ramble: _ramble('Champignons de Paimpont'), participants: [participant(5, 'Inès', 'Roux', isBooker: true)]),
  reservation(
    5,
    email: 'marc@example.com',
    ramble: _ramble('Plantes sauvages', date: '2026-11-21T10:00:00Z'),
    rambleId: 2,
    participants: [participant(6, 'Marc', 'Blanc', isBooker: true)],
  ),
];

FakeApi _api() => FakeApi(
  rambles: [
    balade(1, inDays: 6, title: 'Champignons de Paimpont'),
    balade(2, inDays: 13, title: 'Plantes sauvages'),
  ],
  reservations: _reservations(),
);

/// The reservations the screen asked the API for, the ones that only count (per_page=1) left out.
List<http.Request> _listings(FakeApi api) => [
  for (final r in api.requests)
    if (r.method == 'GET' && r.url.path.endsWith('/reservations/admin') && r.url.queryParameters['per_page'] != '1') r,
];

void main() {
  group('on a phone', () {
    testWidgets('each reservation is a row with the booker, the balade and its date, the participants, the status and the payment', (tester) async {
      final api = _api();
      await withFakeApi(api, () async {
        await pumpManagementApp(tester, api: api, location: '/admin/reservations', user: admin, size: phone);

        for (final name in ['Claire Martin', 'Paul Durand', 'Zoé Petit', 'Inès Roux', 'Marc Blanc']) {
          expect(find.text(name), findsOneWidget);
        }
        expect(find.text('Champignons de Paimpont'), findsNWidgets(3));
        expect(find.text('Plantes sauvages'), findsNWidgets(2));
        expect(find.textContaining('14 nov.'), findsNWidgets(3));
        expect(find.text('Payé 24 €'), findsOneWidget, reason: 'paid in full');
        expect(find.text('Tarif à préciser'), findsOneWidget);
        expect(find.text('12 €'), findsNWidgets(3), reason: 'not paid: the amount');

        final badges = find.byType(ReservationStatusBadge);
        expect(badges, findsNWidgets(5), reason: 'the status is visible on every row');
        for (var i = 0; i < 5; i++) {
          final rect = tester.getRect(badges.at(i));
          expect(rect.right, lessThanOrEqualTo(phone.width));
          expect(rect.left, greaterThanOrEqualTo(0));
        }
      });
    });

    testWidgets('a green header carries the search and the stat chips, with their counts', (tester) async {
      final api = _api();
      await withFakeApi(api, () async {
        await pumpManagementApp(tester, api: api, location: '/admin/reservations', user: admin, size: phone);

        expect(find.text('Réservations'), findsWidgets);
        for (final (key, count) in [('all', '5'), ('confirmed', '2'), ('pending', '1'), ('waiting_list', '1'), ('cancelled', '1')]) {
          final chip = find.byKey(ValueKey('stat-chip-$key'));
          expect(chip, findsOneWidget, reason: key);
          expect(
            find.descendant(of: chip, matching: find.text(count)),
            findsOneWidget,
            reason: '$key count',
          );
          expect(tester.getRect(chip).right, lessThanOrEqualTo(phone.width), reason: '$key chip is not cut');
        }
        expect(find.descendant(of: find.byKey(const ValueKey('stat-chip-pending')), matching: find.text('À confirmer')), findsOneWidget);
        expect(find.descendant(of: find.byKey(const ValueKey('stat-chip-waiting_list')), matching: find.text('Liste d\'attente')), findsOneWidget);
      });
    });

    testWidgets('a stat chip filters the list, « Toutes » brings everything back', (tester) async {
      final api = _api();
      await withFakeApi(api, () async {
        await pumpManagementApp(tester, api: api, location: '/admin/reservations', user: admin, size: phone);

        await tester.tap(find.byKey(const ValueKey('stat-chip-confirmed')));
        await tester.pumpAndSettle(const Duration(seconds: 1));

        expect(find.text('Claire Martin'), findsOneWidget);
        expect(find.text('Marc Blanc'), findsOneWidget);
        expect(find.text('Paul Durand'), findsNothing);
        expect(find.text('Zoé Petit'), findsNothing);
        expect(_listings(api).last.url.queryParametersAll['statuses'], ['confirmed']);
        expect(
          find.descendant(of: find.byKey(const ValueKey('stat-chip-cancelled')), matching: find.text('1')),
          findsOneWidget,
          reason: 'the other counts stay',
        );

        await tester.tap(find.byKey(const ValueKey('stat-chip-all')));
        await tester.pumpAndSettle(const Duration(seconds: 1));

        expect(find.text('Paul Durand'), findsOneWidget);
        expect(_listings(api).last.url.queryParametersAll.containsKey('statuses'), isFalse);
      });
    });

    testWidgets('the search narrows the list by name or email', (tester) async {
      final api = _api();
      await withFakeApi(api, () async {
        await pumpManagementApp(tester, api: api, location: '/admin/reservations', user: admin, size: phone);

        await tester.enterText(find.byType(TextField), 'zoe');
        await tester.pumpAndSettle(const Duration(seconds: 1));

        expect(find.text('Zoé Petit'), findsOneWidget);
        expect(find.text('Claire Martin'), findsNothing);
        expect(_listings(api).last.url.queryParameters['search'], 'zoe');
      });
    });

    testWidgets('the other filters are in a bottom sheet: the balade narrows the list', (tester) async {
      final api = _api();
      await withFakeApi(api, () async {
        await pumpManagementApp(tester, api: api, location: '/admin/reservations', user: admin, size: phone);
        expect(find.text('Toutes les balades'), findsNothing, reason: 'not on the screen itself');

        await tester.tap(find.text('Filtres'));
        await tester.pumpAndSettle();
        expect(find.text('Toutes les balades'), findsOneWidget);

        await tester.tap(find.text('Toutes les balades'));
        await tester.pumpAndSettle();
        await tester.tap(find.textContaining('Plantes sauvages').last);
        await tester.pumpAndSettle();
        await tester.tap(find.text('Appliquer'));
        await tester.pumpAndSettle(const Duration(seconds: 1));

        expect(find.text('Paul Durand'), findsOneWidget);
        expect(find.text('Marc Blanc'), findsOneWidget);
        expect(find.text('Claire Martin'), findsNothing);
        expect(_listings(api).last.url.queryParameters['ramble_id'], '2');
      });
    });

    testWidgets('touching a row opens the detail, which leads to the feuille de balade', (tester) async {
      final api = _api();
      await withFakeApi(api, () async {
        await pumpManagementApp(tester, api: api, location: '/admin/reservations', user: admin, size: phone);

        await tester.tap(find.text('Claire Martin'));
        await tester.pumpAndSettle();

        expect(find.text('claire@example.com'), findsOneWidget);
        expect(find.text('Léo Martin'), findsOneWidget);
        expect(find.text('Enfant · 6 €'), findsOneWidget);
        expect(find.text('Payé 24 €'), findsNWidgets(2));
        expect(find.byTooltip('Appeler'), findsOneWidget);
        expect(find.byTooltip('Écrire'), findsOneWidget);
        expect(find.text('Changer le statut'), findsOneWidget);

        await tester.tap(find.text('Ouvrir la feuille de balade'));
        await tester.pumpAndSettle();

        expect(currentLocation(tester), '/admin/balade/1');
      });
    });

    testWidgets('the status of a row is changed from its badge, and the list is updated', (tester) async {
      final api = _api();
      await withFakeApi(api, () async {
        await pumpManagementApp(tester, api: api, location: '/admin/reservations', user: admin, size: phone);

        final paulsRow = find.ancestor(of: find.text('Paul Durand'), matching: find.byType(ManagementRow));
        await tester.tap(find.descendant(of: paulsRow, matching: find.byType(ReservationStatusBadge)));
        await tester.pumpAndSettle();
        await tester.tap(find.descendant(of: find.byType(ListTile), matching: find.text('Annulée')));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Annuler la réservation'));
        await tester.pumpAndSettle(const Duration(seconds: 1));

        final put = api.requests.singleWhere((r) => r.method == 'PUT');
        expect(put.url.path, endsWith('/reservations/admin/2/status'));
        expect(jsonDecode(put.body), containsPair('status', 'cancelled'));
        expect(find.descendant(of: find.byKey(const ValueKey('stat-chip-pending')), matching: find.text('0')), findsOneWidget);
      });
    });

    testWidgets('without any reservation, an empty state says so', (tester) async {
      final api = FakeApi();
      await withFakeApi(api, () async {
        await pumpManagementApp(tester, api: api, location: '/admin/reservations', user: admin, size: phone);

        expect(find.text('Aucune réservation'), findsOneWidget);
      });
    });
  });

  group('on a tablet', () {
    testWidgets('the reservations are rows too, with no bulk selection and no overflow', (tester) async {
      final api = _api();
      await withFakeApi(api, () async {
        await pumpManagementApp(tester, api: api, location: '/admin/reservations', user: admin, size: tablet);

        expect(find.text('Claire Martin'), findsOneWidget);
        expect(find.byType(ReservationStatusBadge), findsNWidgets(5));
        expect(find.byKey(const ValueKey('select-reservation-1')), findsNothing);
      });
    });
  });

  group('on desktop', () {
    testWidgets('the stats are on one row and the table shows every column, none cut', (tester) async {
      final api = _api();
      await withFakeApi(api, () async {
        await pumpManagementApp(tester, api: api, location: '/admin/reservations', user: admin, size: desktop);

        final tops = {
          for (final key in ['all', 'confirmed', 'pending', 'waiting_list', 'cancelled']) tester.getTopLeft(find.byKey(ValueKey('stat-chip-$key'))).dy,
        };
        expect(tops, hasLength(1), reason: 'the stat chips share a line');

        for (final column in ['PERSONNE QUI RÉSERVE', 'BALADE', 'PARTICIPANTS', 'STATUT', 'PAIEMENT']) {
          final heading = find.text(column);
          expect(heading, findsOneWidget, reason: column);
          expect(tester.getRect(heading).right, lessThanOrEqualTo(desktop.width));
        }
        expect(find.text('claire@example.com'), findsOneWidget);
        expect(find.text('Payé 24 €'), findsOneWidget);
        expect(find.textContaining('Scroll'), findsNothing);
      });
    });

    testWidgets('selecting reservations offers the bulk actions, and one sends the right request', (tester) async {
      final api = _api();
      await withFakeApi(api, () async {
        await pumpManagementApp(tester, api: api, location: '/admin/reservations', user: admin, size: desktop);
        expect(find.text('Désélectionner'), findsNothing);

        await tester.tap(find.byKey(const ValueKey('select-reservation-2')));
        await tester.tap(find.byKey(const ValueKey('select-reservation-3')));
        await tester.pumpAndSettle();
        expect(find.textContaining('2 réservations sélectionnées'), findsOneWidget);

        await tester.tap(find.byKey(const ValueKey('bulk-action-confirm')));
        await tester.pumpAndSettle();
        await tester.tap(find.widgetWithText(FilledButton, 'Confirmer'));
        await tester.pumpAndSettle(const Duration(seconds: 1));

        final post = api.requests.singleWhere((r) => r.method == 'POST' && r.url.path.endsWith('/bulk-action'));
        expect(jsonDecode(post.body), {
          'reservation_ids': [2, 3],
          'action': 'confirm',
          'send_email': true,
        });
        expect(find.text('Désélectionner'), findsNothing, reason: 'the selection is cleared');
      });
    });

    testWidgets('the header checkbox selects the whole list', (tester) async {
      final api = _api();
      await withFakeApi(api, () async {
        await pumpManagementApp(tester, api: api, location: '/admin/reservations', user: admin, size: desktop);

        await tester.tap(find.byKey(const ValueKey('select-all-reservations')));
        await tester.pumpAndSettle();

        expect(find.textContaining('5 réservations sélectionnées'), findsOneWidget);
      });
    });

    testWidgets('clicking a row opens its detail', (tester) async {
      final api = _api();
      await withFakeApi(api, () async {
        await pumpManagementApp(tester, api: api, location: '/admin/reservations', user: admin, size: desktop);

        await tester.tap(find.text('Paul Durand'));
        await tester.pumpAndSettle();

        expect(find.text('Changer le statut'), findsOneWidget);
        expect(find.byTooltip('Appeler'), findsNothing, reason: 'no phone given');
      });
    });
  });

  group('for a guide', () {
    testWidgets('the screen asks for the reservations with the guide\'s own token, and offers no bulk selection', (tester) async {
      final api = _api();
      await withFakeApi(api, () async {
        await pumpManagementApp(tester, api: api, location: '/admin/reservations', user: guide, size: desktop);

        expect(find.text('Claire Martin'), findsOneWidget);
        expect(_listings(api), isNotEmpty);
        expect({for (final r in api.requests.where((r) => r.url.path.contains('/reservations/admin'))) r.headers['Authorization']}, {'Bearer guide-token'});
        expect(find.byKey(const ValueKey('select-reservation-1')), findsNothing);
        expect(find.byKey(const ValueKey('select-all-reservations')), findsNothing);
      });
    });
  });
}
