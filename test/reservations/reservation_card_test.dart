import 'package:balade/features/ramble/models/ramble/ramble.dart';
import 'package:balade/features/reservations/models/reservation/reservation.dart';
import 'package:balade/features/reservations/providers/reservation_providers.dart';
import 'package:balade/features/reservations/widgets/reservation_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

Reservation _reservation({
  String status = 'pending',
  bool paid = false,
  List<Map<String, Object?>>? participants,
  bool hasMissingPrices = false,
  int estimatedAmount = 1850,
  String? confirmationDeadline,
  List<Map<String, Object?>>? payments,
  int? amountPaid,
  int amountDue = 0,
}) => Reservation.fromJson({
  'id': 12,
  'created_at': '2026-11-02T10:00:00Z',
  'updated_at': '2026-11-02T10:00:00Z',
  'ramble_id': 3,
  'user_id': 7,
  'contact_email': 'claire@example.com',
  'status': status,
  'confirmation_deadline': confirmationDeadline,
  'participants':
      participants ??
      [
        {'id': 1, 'first_name': 'Claire', 'last_name': 'Martin', 'price_label': 'Adulte', 'price_amount': 12.5, 'is_booker': true},
        {'id': 2, 'first_name': 'Léo', 'last_name': 'Martin', 'price_label': 'Enfant', 'price_amount': 6.0, 'is_booker': false},
      ],
  'estimated_amount': estimatedAmount,
  'has_missing_prices': hasMissingPrices,
  'has_successful_payment': paid,
  'payments':
      payments ??
      [
        {'id': 5, 'created_at': '2026-11-02T10:00:00Z', 'amount': 1850, 'currency': 'eur', 'status': 'succeeded', 'paid_at': '2026-11-03T10:00:00Z'},
      ],
  'amount_paid': amountPaid ?? (paid ? estimatedAmount : 0),
  'amount_due': amountDue,
  'ramble': {'title': 'Sortie champignons', 'date': '2026-12-01T09:00:00Z', 'location': 'Forêt de Fontainebleau'},
});

/// The ramble of the reservations, taking online payment.
Ramble _payingRamble() => Ramble(3, title: 'Sortie champignons', type: 'champignons', difficulty: 'facile', paymentEnabled: true);

/// Before the confirmation period of the ramble of the reservations, on 1 December 2026 at 9:00.
final _beforeConfirmation = DateTime.utc(2026, 11, 20, 9);

Future<void> _pump(WidgetTester tester, Reservation reservation, {bool paymentEnabled = false, DateTime? now}) async {
  await initializeDateFormatting('fr');
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        if (paymentEnabled) reservationRambleProvider.overrideWith((ref, id) async => _payingRamble()),
        reservationClockProvider.overrideWithValue(() => now ?? _beforeConfirmation),
      ],
      child: MaterialApp(
        home: Scaffold(body: SingleChildScrollView(child: ReservationCard(reservation: reservation))),
      ),
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

  testWidgets('announces the missing tariff of a migrated participant instead of a free one', (tester) async {
    await _pump(
      tester,
      _reservation(
        hasMissingPrices: true,
        estimatedAmount: 1250,
        participants: [
          {'id': 1, 'first_name': 'Claire', 'last_name': 'Martin', 'price_label': 'Adulte', 'price_amount': 12.5, 'is_booker': true},
          {'id': 2, 'first_name': 'Paul', 'last_name': 'Martin', 'price_label': '', 'price_amount': 0, 'price_missing': true},
        ],
      ),
    );

    expect(find.text('Tarif à préciser'), findsOneWidget);
    expect(find.text('12,50 € + tarifs à préciser'), findsOneWidget);
    expect(find.textContaining(' · 0 €'), findsNothing);
    expect(find.text('Gratuit'), findsNothing);
  });

  testWidgets('offers to add participants, modify or remove them and cancel a pending reservation', (tester) async {
    await _pump(tester, _reservation());

    expect(find.text('Ajouter des participants'), findsOneWidget);
    expect(find.text('Annuler la réservation'), findsOneWidget);
    expect(find.byTooltip('Modifier'), findsNWidgets(2));
    expect(find.byTooltip('Retirer'), findsNWidgets(2));
  });

  testWidgets('no longer offers to modify participants once paid', (tester) async {
    await _pump(tester, _reservation(status: 'confirmed', paid: true));

    expect(find.byTooltip('Modifier'), findsNothing);
    expect(find.byTooltip('Retirer'), findsNWidgets(2));
    expect(find.text('Annuler la réservation'), findsOneWidget);
  });

  testWidgets('offers no action on a cancelled reservation', (tester) async {
    await _pump(tester, _reservation(status: 'cancelled'));

    expect(find.text('Ajouter des participants'), findsNothing);
    expect(find.text('Annuler la réservation'), findsNothing);
    expect(find.byTooltip('Retirer'), findsNothing);
  });

  testWidgets('asks to confirm a pending reservation within the confirmation period, until its deadline', (tester) async {
    await _pump(tester, _reservation(confirmationDeadline: '2026-11-30T21:00:00Z'), now: DateTime.utc(2026, 11, 29, 10));

    expect(find.text('Confirmer ma réservation'), findsOneWidget);
    expect(find.textContaining('Confirmez votre réservation avant le'), findsOneWidget);
  });

  testWidgets('tells when the confirmation opens before the confirmation period', (tester) async {
    await _pump(tester, _reservation(), now: _beforeConfirmation);

    expect(find.text('Confirmer ma réservation'), findsNothing);
    expect(find.textContaining('La confirmation ouvrira le 28/11/2026'), findsOneWidget);
  });

  testWidgets('tells that the confirmation deadline has passed', (tester) async {
    await _pump(tester, _reservation(confirmationDeadline: '2026-11-30T21:00:00Z'), now: DateTime.utc(2026, 11, 30, 22));

    expect(find.text('Confirmer ma réservation'), findsNothing);
    expect(find.textContaining('Le délai de confirmation est dépassé'), findsOneWidget);
  });

  testWidgets('offers to add participants to a confirmed reservation', (tester) async {
    await _pump(tester, _reservation(status: 'confirmed', paid: true));

    expect(find.text('Ajouter des participants'), findsOneWidget);
  });

  testWidgets('asks again for the part refunded of a payment, counting its net amount as paid', (tester) async {
    final reservation = _reservation(
      status: 'confirmed',
      paid: true,
      payments: [
        {'id': 5, 'created_at': '2026-11-02T10:00:00Z', 'amount': 1850, 'currency': 'eur', 'status': 'partially_refunded', 'paid_at': '2026-11-03T10:00:00Z', 'refund_amount': 1000},
      ],
      amountPaid: 850,
      amountDue: 1000,
    );
    await _pump(tester, reservation, paymentEnabled: true);
    await tester.pumpAndSettle();

    expect(find.text('03/11/2026 · Remboursé en partie (10 €)'), findsOneWidget);
    expect(find.text('Payer 10 €'), findsOneWidget);
    expect(find.byTooltip('Modifier'), findsNothing);
  });
}
