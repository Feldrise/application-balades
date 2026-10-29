import 'dart:convert';

import 'package:balade/features/admin/reservations_management/providers/admin_reservations_provider.dart';
import 'package:balade/features/admin/reservations_management/widgets/reservation_edit_dialog.dart';
import 'package:balade/features/authentication/authentication_provider.dart';
import 'package:balade/features/authentication/data/models/authed_user/authed_user.dart';
import 'package:balade/features/ramble/models/ramble/ramble.dart';
import 'package:balade/features/reservations/models/reservation/reservation.dart';
import 'package:balade/features/reservations/providers/reservation_providers.dart';
import 'package:balade/features/reservations/reservations_service.dart';
import 'package:balade/features/users/models/user/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

const _json = {
  'id': 12,
  'created_at': '2026-11-02T10:00:00Z',
  'updated_at': '2026-11-02T10:00:00Z',
  'ramble_id': 3,
  'user_id': 7,
  'contact_email': 'claire@example.com',
  'status': 'pending',
  'participants': [
    {'id': 1, 'first_name': 'Claire', 'last_name': 'Martin', 'price_label': 'Adulte', 'price_amount': 12.5, 'is_booker': true},
    {'id': 2, 'first_name': 'Leo', 'last_name': 'Martin', 'price_label': 'Enfant', 'price_amount': 6.0, 'is_booker': false},
  ],
  'estimated_amount': 1850,
  'payments': [],
};

Ramble _ramble() => Ramble(
  3,
  title: 'Sortie champignons',
  type: 'champignons',
  difficulty: 'facile',
  date: DateTime.now().add(const Duration(days: 30)),
  prices: const [RamblePrice(label: 'Adulte', amount: 12.5), RamblePrice(label: 'Enfant', amount: 6)],
);

class _SignedIn extends AuthenticationNotifier {
  _SignedIn() {
    state = const AuthedUser(user: User(1, email: 'admin@example.com'), token: 'abc');
  }
}

/// Opens the dialog for the reservation; the API answers with [handler] and the requests are recorded.
Future<List<http.Request>> _pump(WidgetTester tester, Future<http.Response> Function(http.Request) handler) async {
  tester.view.physicalSize = const Size(900, 2400);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final requests = <http.Request>[];
  final service = ReservationsService(
    client: MockClient((request) {
      requests.add(request);
      return handler(request);
    }),
    baseUrl: 'http://api.test',
  );

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        reservationsServiceProvider.overrideWithValue(service),
        authenticationProvider.overrideWith((ref) => _SignedIn()),
        reservationRambleProvider.overrideWith((ref, id) async => _ramble()),
        adminReservationsProvider.overrideWith((ref) => AdminReservationsNotifier(service)),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => showDialog<void>(context: context, builder: (_) => ReservationEditDialog(reservation: Reservation.fromJson(_json))),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
  return requests;
}

void main() {
  testWidgets('shows the participants of the reservation with their names and tariffs', (tester) async {
    await _pump(tester, (_) async => http.Response('{}', 500));

    expect(find.text('Réservation de Claire Martin'), findsOneWidget);
    expect(find.text('claire@example.com'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Prénom'), findsNWidgets(2));
    expect(find.widgetWithText(TextField, 'Nom'), findsNWidgets(2));
    expect(find.text('Adulte'), findsOneWidget);
    expect(find.text('Enfant'), findsOneWidget);
  });

  testWidgets('corrects a participant by sending only what changed', (tester) async {
    final requests = await _pump(tester, (_) async => http.Response(jsonEncode(_json), 200));

    await tester.enterText(find.widgetWithText(TextField, 'Prénom').last, 'Léo');
    await tester.tap(find.widgetWithText(FilledButton, 'Enregistrer'));
    await tester.pumpAndSettle();

    final request = requests.single;
    expect(request.method, 'PUT');
    expect(request.url.toString(), 'http://api.test/reservations/admin/12/participants/2');
    expect(request.headers['Authorization'], 'Bearer abc');
    expect(jsonDecode(request.body), {'first_name': 'Léo'});
    expect(find.byType(ReservationEditDialog), findsNothing);
  });

  testWidgets('changes the tariff of a participant', (tester) async {
    final requests = await _pump(tester, (_) async => http.Response(jsonEncode(_json), 200));

    await tester.tap(find.text('Enfant'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Adulte').last);
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Enregistrer'));
    await tester.pumpAndSettle();

    expect(jsonDecode(requests.single.body), {'price_label': 'Adulte'});
  });

  testWidgets('cancels the reservation with a reason and tells the booker', (tester) async {
    final requests = await _pump(tester, (_) async => http.Response(jsonEncode({..._json, 'status': 'cancelled'}), 200));

    await tester.tap(find.text('En attente de confirmation'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Annulée').last);
    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(TextField, 'Motif (optionnel)'), 'Doublon');
    await tester.tap(find.text('Prévenir la personne qui réserve par email'));
    await tester.pump();
    await tester.tap(find.widgetWithText(FilledButton, 'Enregistrer'));
    await tester.pumpAndSettle();

    final request = requests.single;
    expect(request.url.toString(), 'http://api.test/reservations/admin/12/status');
    expect(jsonDecode(request.body), {'status': 'cancelled', 'reason': 'Doublon', 'send_email': true});
    expect(find.byType(ReservationEditDialog), findsNothing);
  });

  testWidgets('keeps the dialog open and tells why when the API refuses', (tester) async {
    await _pump(tester, (_) async => http.Response(jsonEncode({'status': 'conflict', 'reason': 'not_enough_places', 'error': 'the participants do not fit in the 1 places left'}), 409));

    await tester.tap(find.text('En attente de confirmation'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Confirmée').last);
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Enregistrer'));
    await tester.pumpAndSettle();

    expect(find.byType(ReservationEditDialog), findsOneWidget);
    expect(find.textContaining('Pas assez de places restantes'), findsOneWidget);
  });
}
