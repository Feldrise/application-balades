import 'dart:convert';

import 'package:balade/features/reservations/models/reservation/create_reservation_request.dart';
import 'package:balade/features/reservations/reservations_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

const _reservationJson = {
  'id': 12,
  'created_at': '2026-11-02T10:00:00Z',
  'updated_at': '2026-11-02T10:00:00Z',
  'ramble_id': 3,
  'user_id': 7,
  'contact_email': 'claire@example.com',
  'status': 'pending',
  'participants': [
    {'id': 1, 'first_name': 'Claire', 'last_name': 'Martin', 'price_label': 'Adulte', 'price_amount': 12.5, 'is_booker': true},
    {'id': 2, 'first_name': 'Léo', 'last_name': 'Martin', 'price_label': 'Enfant', 'price_amount': 6.0, 'is_booker': false},
  ],
  'estimated_amount': 1850,
  'payments': [
    {'id': 5, 'created_at': '2026-11-02T10:00:00Z', 'amount': 1850, 'currency': 'eur', 'status': 'succeeded'},
  ],
  'ramble': {'title': 'Sortie champignons', 'date': '2026-12-01T09:00:00Z', 'location': 'Forêt de Fontainebleau'},
};

ReservationsService _service(http.Client client) => ReservationsService(client: client, baseUrl: 'http://api.test/api/v1');

void main() {
  group('fetchUserReservations', () {
    test('reads the reservations of the booker with participants, amount and payments', () async {
      late http.Request received;
      final service = _service(
        MockClient((request) async {
          received = request;
          return http.Response(jsonEncode([_reservationJson]), 200);
        }),
      );

      final reservations = await service.fetchUserReservations(token: 'abc');

      expect(received.method, 'GET');
      expect(received.url.toString(), 'http://api.test/api/v1/reservations');
      expect(received.headers['Authorization'], 'Bearer abc');

      final reservation = reservations.single;
      expect(reservation.id, 12);
      expect(reservation.status, 'pending');
      expect(reservation.contactEmail, 'claire@example.com');
      expect(reservation.estimatedAmount, 1850);
      expect(reservation.ramble?.title, 'Sortie champignons');
      expect(reservation.participants.map((p) => p.priceLabel), ['Adulte', 'Enfant']);
      expect(reservation.participants.first.priceAmount, 12.5);
      expect(reservation.participants.first.isBooker, isTrue);
      expect(reservation.payments.single.amount, 1850);
      expect(reservation.payments.single.status, 'succeeded');
    });
  });

  group('fetchReservation', () {
    test('reads one reservation with the token of the booker', () async {
      late http.Request received;
      final service = _service(
        MockClient((r) async {
          received = r;
          return http.Response(jsonEncode(_reservationJson), 200);
        }),
      );

      final reservation = await service.fetchReservation(12, token: 'abc');

      expect(received.url.toString(), 'http://api.test/api/v1/reservations/12');
      expect(received.headers['Authorization'], 'Bearer abc');
      expect(reservation.participants, hasLength(2));
    });

    test('refuses a reservation the user cannot see', () async {
      final service = _service(MockClient((_) async => http.Response(jsonEncode({'status': 'forbidden', 'error': 'insufficient permissions'}), 403)));

      await expectLater(service.fetchReservation(12, token: 'abc'), throwsA(isA<ReservationException>()));
    });
  });

  group('createReservation', () {
    const request = CreateReservationRequest(
      rambleId: 3,
      contactEmail: 'claire@example.com',
      contactPhone: '0601020304',
      participants: [
        ParticipantRequest(firstName: 'Claire', lastName: 'Martin', priceLabel: 'Adulte', isBooker: true),
        ParticipantRequest(firstName: 'Léo', lastName: 'Martin', priceLabel: 'Enfant'),
      ],
    );

    test('posts the contact and the participants without authentication and returns the reservation', () async {
      late http.Request received;
      final service = _service(
        MockClient((r) async {
          received = r;
          return http.Response(jsonEncode(_reservationJson), 201);
        }),
      );

      final reservation = await service.createReservation(request);

      expect(received.method, 'POST');
      expect(received.url.toString(), 'http://api.test/api/v1/reservations');
      expect(received.headers.containsKey('Authorization'), isFalse);
      expect(jsonDecode(received.body), {
        'ramble_id': 3,
        'contact_email': 'claire@example.com',
        'contact_phone': '0601020304',
        'participants': [
          {'first_name': 'Claire', 'last_name': 'Martin', 'price_label': 'Adulte', 'is_booker': true},
          {'first_name': 'Léo', 'last_name': 'Martin', 'price_label': 'Enfant', 'is_booker': false},
        ],
      });
      expect(reservation.id, 12);
    });

    test('omits the phone when it is not given', () async {
      late http.Request received;
      final service = _service(
        MockClient((r) async {
          received = r;
          return http.Response(jsonEncode(_reservationJson), 201);
        }),
      );

      await service.createReservation(const CreateReservationRequest(rambleId: 3, contactEmail: 'a@b.fr', participants: [ParticipantRequest(firstName: 'A', lastName: 'B')]));

      expect((jsonDecode(received.body) as Map).containsKey('contact_phone'), isFalse);
    });

    test('reports the existing reservation when one already exists for this ramble and email', () async {
      final service = _service(
        MockClient(
          (_) async => http.Response(
            jsonEncode({'status': 'a reservation already exists', 'reason': 'reservation_already_exists', 'error': 'a reservation already exists for this ramble and email', 'reservation_id': 9}),
            409,
          ),
        ),
      );

      await expectLater(
        service.createReservation(request),
        throwsA(isA<ReservationAlreadyExistsException>().having((e) => e.reservationId, 'reservationId', 9)),
      );
    });

    test('keeps the API message for other refusals', () async {
      final service = _service(
        MockClient((_) async => http.Response(jsonEncode({'status': 'x', 'reason': 'too_many_participants', 'error': 'a reservation cannot have more than 2 participants for this ramble'}), 400)),
      );

      await expectLater(
        service.createReservation(request),
        throwsA(isA<ReservationException>().having((e) => e.message, 'message', 'a reservation cannot have more than 2 participants for this ramble').having((e) => e.reason, 'reason', 'too_many_participants')),
      );
    });
  });

  group('modifying a reservation', () {
    late http.Request received;
    late ReservationsService service;

    setUp(() {
      service = _service(
        MockClient((r) async {
          received = r;
          return http.Response(jsonEncode({..._reservationJson, 'has_successful_payment': true}), 200);
        }),
      );
    });

    test('adds participants with the token of the booker', () async {
      await service.addParticipants(12, const [ParticipantRequest(firstName: 'Zoé', lastName: 'Martin', priceLabel: 'Enfant')], token: 'abc');

      expect(received.method, 'POST');
      expect(received.url.toString(), 'http://api.test/api/v1/reservations/12/participants');
      expect(received.headers['Authorization'], 'Bearer abc');
      expect(jsonDecode(received.body), {
        'participants': [
          {'first_name': 'Zoé', 'last_name': 'Martin', 'price_label': 'Enfant', 'is_booker': false},
        ],
      });
    });

    test('updates the name and tariff of a participant', () async {
      await service.updateParticipant(12, 2, firstName: 'Léo', lastName: 'Durand', priceLabel: 'Adulte', token: 'abc');

      expect(received.method, 'PUT');
      expect(received.url.toString(), 'http://api.test/api/v1/reservations/12/participants/2');
      expect(jsonDecode(received.body), {'first_name': 'Léo', 'last_name': 'Durand', 'price_label': 'Adulte'});
    });

    test('removes a participant and tells whether a payment succeeded', () async {
      final reservation = await service.removeParticipant(12, 2, token: 'abc');

      expect(received.method, 'DELETE');
      expect(received.url.toString(), 'http://api.test/api/v1/reservations/12/participants/2');
      expect(reservation.hasSuccessfulPayment, isTrue);
    });

    test('cancels the reservation', () async {
      await service.cancelReservation(12, token: 'abc');

      expect(received.method, 'PUT');
      expect(received.url.toString(), 'http://api.test/api/v1/reservations/12/cancel');
      expect(received.headers['Authorization'], 'Bearer abc');
    });

    test('reports an addition refused for lack of places', () async {
      service = _service(
        MockClient((_) async => http.Response(jsonEncode({'status': 'x', 'reason': 'not_enough_places', 'error': 'the participants do not fit in the 1 places left'}), 409)),
      );

      await expectLater(
        service.addParticipants(12, const [ParticipantRequest(firstName: 'A', lastName: 'B')], token: 'abc'),
        throwsA(isA<ReservationException>().having((e) => e.reason, 'reason', 'not_enough_places')),
      );
    });
  });

  group('confirming and paying', () {
    const paymentJson = {
      'payment': {'id': 9, 'amount': 3100, 'status': 'pending', 'reservation_id': 12},
      'client_secret': 'pi_1_secret',
      'publishable_key': 'pk_test_guide',
    };

    test('confirms the reservation and reads the payment to make', () async {
      late http.Request received;
      final service = _service(
        MockClient((request) async {
          received = request;
          return http.Response(jsonEncode({..._reservationJson, 'status': 'confirmed', 'payment': paymentJson}), 200);
        }),
      );

      final confirmed = await service.confirmReservation(12, token: 'abc');

      expect(received.method, 'PUT');
      expect(received.url.toString(), 'http://api.test/api/v1/reservations/12/confirm');
      expect(received.headers['Authorization'], 'Bearer abc');
      expect(confirmed.reservation.status, 'confirmed');
      expect(confirmed.payment?.amount, 3100);
      expect(confirmed.payment?.clientSecret, 'pi_1_secret');
      expect(confirmed.payment?.publishableKey, 'pk_test_guide');
    });

    test('confirms without payment when there is nothing to pay online', () async {
      final service = _service(MockClient((_) async => http.Response(jsonEncode({..._reservationJson, 'status': 'confirmed', 'payment': null}), 200)));

      final confirmed = await service.confirmReservation(12, token: 'abc');

      expect(confirmed.payment, isNull);
    });

    test('reads the complementary payment of participants added to a confirmed reservation', () async {
      final service = _service(MockClient((_) async => http.Response(jsonEncode({..._reservationJson, 'status': 'confirmed', 'payment': paymentJson}), 200)));

      final added = await service.addParticipants(12, const [ParticipantRequest(firstName: 'Zoé', lastName: 'Martin', priceLabel: 'Enfant')], token: 'abc');

      expect(added.reservation.status, 'confirmed');
      expect(added.payment?.amount, 3100);
    });

    test('tells that participants were added but their payment is to make later', () async {
      final service = _service(
        MockClient((_) async => http.Response(jsonEncode({..._reservationJson, 'status': 'confirmed', 'payment': null, 'payment_unavailable': true}), 200)),
      );

      final added = await service.addParticipants(12, const [ParticipantRequest(firstName: 'Zoé', lastName: 'Martin', priceLabel: 'Enfant')], token: 'abc');

      expect(added.payment, isNull);
      expect(added.paymentUnavailable, isTrue);
    });

    test('reports a confirmation refused while a tariff is missing', () async {
      final service = _service(MockClient((_) async => http.Response(jsonEncode({'status': 'x', 'reason': 'missing_prices', 'error': 'x'}), 409)));

      await expectLater(service.confirmReservation(12, token: 'abc'), throwsA(isA<ReservationException>().having((e) => e.reason, 'reason', 'missing_prices')));
    });
  });

  test('reads the missing prices of migrated participants', () async {
    final service = _service(
      MockClient(
        (_) async => http.Response(
          jsonEncode({
            ..._reservationJson,
            'has_missing_prices': true,
            'participants': [
              {'id': 1, 'first_name': 'Paul', 'last_name': 'Martin', 'price_label': '', 'price_amount': 0, 'price_missing': true, 'is_booker': false},
            ],
          }),
          200,
        ),
      ),
    );

    final reservation = await service.fetchReservation(12, token: 'abc');

    expect(reservation.hasMissingPrices, isTrue);
    expect(reservation.participants.single.priceMissing, isTrue);
  });
}
