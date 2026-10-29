import 'package:balade/features/reservations/models/reservation/reservation.dart';
import 'package:balade/features/reservations/widgets/reservation_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

Reservation _reservation({String status = 'pending'}) => Reservation.fromJson({
  'id': 12,
  'created_at': '2026-11-02T10:00:00Z',
  'updated_at': '2026-11-02T10:00:00Z',
  'ramble_id': 3,
  'user_id': 7,
  'contact_email': 'claire@example.com',
  'status': status,
  'participants': [
    {'id': 1, 'first_name': 'Claire', 'last_name': 'Martin', 'price_label': 'Adulte', 'price_amount': 12.5, 'is_booker': true},
    {'id': 2, 'first_name': 'Léo', 'last_name': 'Martin', 'price_label': 'Enfant', 'price_amount': 6.0, 'is_booker': false},
  ],
  'estimated_amount': 1850,
  'payments': [
    {'id': 5, 'created_at': '2026-11-02T10:00:00Z', 'amount': 1850, 'currency': 'eur', 'status': 'succeeded', 'paid_at': '2026-11-03T10:00:00Z'},
  ],
  'ramble': {'title': 'Sortie champignons', 'date': '2026-12-01T09:00:00Z', 'location': 'Forêt de Fontainebleau'},
});

Future<void> _pump(WidgetTester tester, Reservation reservation) async {
  await initializeDateFormatting('fr');
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(body: SingleChildScrollView(child: ReservationCard(reservation: reservation))),
    ),
  );
}

void main() {
  testWidgets('shows the ramble, status, participants with their tariffs, amount and payments', (tester) async {
    await _pump(tester, _reservation());

    expect(find.text('Sortie champignons'), findsOneWidget);
    expect(find.text('Forêt de Fontainebleau'), findsOneWidget);
    expect(find.text('En attente de confirmation'), findsOneWidget);
    expect(find.text('Participants (2)'), findsOneWidget);
    expect(find.text('Claire Martin (vous)'), findsOneWidget);
    expect(find.text('Adulte · 12,50 €'), findsOneWidget);
    expect(find.text('Léo Martin'), findsOneWidget);
    expect(find.text('Enfant · 6 €'), findsOneWidget);
    expect(find.text('18,50 €'), findsNWidgets(2)); // the amount and the payment
    expect(find.text('03/11/2026 · Payé'), findsOneWidget);
  });

  testWidgets('explains that a waiting list reservation passes as a whole', (tester) async {
    await _pump(tester, _reservation(status: 'waiting_list'));

    expect(find.text('Liste d\'attente'), findsOneWidget);
    expect(find.textContaining('passera en entier'), findsOneWidget);
  });
}
