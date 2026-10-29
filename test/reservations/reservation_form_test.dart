import 'dart:convert';

import 'package:balade/features/ramble/models/ramble/ramble.dart';
import 'package:balade/features/reservations/providers/reservation_providers.dart';
import 'package:balade/features/reservations/reservations_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

const _ramble = Ramble(
  3,
  title: 'Sortie champignons',
  type: 'champignons',
  difficulty: 'facile',
  placesLeft: 2,
  maxParticipantsPerReservation: 5,
  prices: [RamblePrice(label: 'Adulte', amount: 12.5), RamblePrice(label: 'Enfant', amount: 6)],
);

const _reservationJson = {
  'id': 12,
  'created_at': '2026-11-02T10:00:00Z',
  'updated_at': '2026-11-02T10:00:00Z',
  'ramble_id': 3,
  'user_id': 7,
  'contact_email': 'claire@example.com',
  'status': 'waiting_list',
  'participants': [
    {'id': 1, 'first_name': 'Paul', 'last_name': 'Durand', 'price_label': 'Adulte', 'price_amount': 12.5, 'is_booker': false},
  ],
  'estimated_amount': 1250,
  'payments': [],
};

ReservationFormNotifier _notifier(Future<http.Response> Function(http.Request) handler) =>
    ReservationFormNotifier(ReservationsService(client: MockClient(handler), baseUrl: 'http://api.test'), _ramble);

void main() {
  test('starts from the ramble: one participant, bounded by the API limit', () {
    final notifier = _notifier((_) async => http.Response('', 500));

    expect(notifier.state.draft.total, 1);
    expect(notifier.state.draft.maxParticipants, 5);
    expect(notifier.state.draft.placesLeft, 2);
  });

  test('a successful submission keeps the created reservation', () async {
    late http.Request received;
    final notifier = _notifier((r) async {
      received = r;
      return http.Response(jsonEncode(_reservationJson), 201);
    });
    notifier.updateParticipant(0, firstName: 'Paul', lastName: 'Durand');

    await notifier.submit(contactEmail: 'claire@example.com', contactPhone: '');

    expect(notifier.state.created?.id, 12);
    expect(notifier.state.error, isNull);
    expect(notifier.state.isSubmitting, isFalse);
    expect((jsonDecode(received.body) as Map)['contact_email'], 'claire@example.com');
  });

  test('a duplicate reservation is reported with the existing reservation', () async {
    final notifier = _notifier((_) async => http.Response(jsonEncode({'error': 'exists', 'reason': 'reservation_already_exists', 'reservation_id': 9}), 409));

    await notifier.submit(contactEmail: 'claire@example.com');

    expect(notifier.state.existingReservationId, 9);
    expect(notifier.state.created, isNull);
    expect(notifier.state.isSubmitting, isFalse);
  });

  test('another refusal is reported to the user in French', () async {
    final notifier = _notifier((_) async => http.Response(jsonEncode({'error': 'a reservation cannot have more than 5 participants for this ramble', 'reason': 'too_many_participants'}), 400));

    await notifier.submit(contactEmail: 'claire@example.com');

    expect(notifier.state.error, 'Une réservation ne peut pas compter plus de 5 participants pour cette balade.');
    expect(notifier.state.existingReservationId, isNull);
  });

  test('reset gives back a fresh draft', () async {
    final notifier = _notifier((_) async => http.Response(jsonEncode(_reservationJson), 201));
    notifier.increment('Enfant');
    await notifier.submit(contactEmail: 'claire@example.com');

    notifier.reset();

    expect(notifier.state.created, isNull);
    expect(notifier.state.draft.total, 1);
  });
}
