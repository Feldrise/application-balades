import 'dart:convert';

import 'package:balade/features/admin/reservations_management/models/admin_reservation_filter.dart';
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
  'status': 'waiting_list',
  'participants': [
    {'id': 1, 'first_name': 'Claire', 'last_name': 'Martin', 'price_label': 'Adulte', 'price_amount': 12.5, 'is_booker': true},
    {'id': 2, 'first_name': 'Léo', 'last_name': 'Martin', 'price_label': 'Enfant', 'price_amount': 6.0, 'is_booker': false},
  ],
  'estimated_amount': 1850,
  'payments': [],
  'ramble': {'title': 'Sortie champignons', 'date': '2026-12-01T09:00:00Z', 'location': 'Forêt de Fontainebleau'},
};

ReservationsService _service(http.Client client) => ReservationsService(client: client, baseUrl: 'http://api.test/api/v1');

void main() {
  group('fetchAdminReservations', () {
    test('lists the reservations with their participants, filtered, sorted and paginated by the API', () async {
      late http.Request received;
      final service = _service(
        MockClient((request) async {
          received = request;
          return http.Response(
            jsonEncode({
              'reservations': [_reservationJson],
              'total': 31,
              'page': 2,
              'per_page': 20,
              'total_pages': 2,
            }),
            200,
          );
        }),
      );

      final list = await service.fetchAdminReservations(
        token: 'abc',
        filter: AdminReservationFilter(
          rambleId: 3,
          userId: 7,
          email: 'claire@example.com',
          statuses: const ['waiting_list', 'cancelled'],
          dateFrom: DateTime(2026, 11, 1),
          dateTo: DateTime(2026, 11, 30),
          search: 'Martin',
          rambleTitle: 'champignons',
        ),
        page: 2,
        perPage: 20,
        sortBy: 'contact_email',
        sortAscending: true,
      );

      expect(received.method, 'GET');
      expect(received.url.path, '/api/v1/reservations/admin');
      expect(received.headers['Authorization'], 'Bearer abc');
      final query = received.url.queryParametersAll;
      expect(query['ramble_id'], ['3']);
      expect(query['user_id'], ['7']);
      expect(query['email'], ['claire@example.com']);
      expect(query['statuses'], ['waiting_list', 'cancelled']);
      expect(query['date_from'], ['2026-11-01']);
      expect(query['date_to'], ['2026-11-30']);
      expect(query['search'], ['Martin']);
      expect(query['ramble_title'], ['champignons']);
      expect(query['page'], ['2']);
      expect(query['per_page'], ['20']);
      expect(query['sort_by'], ['contact_email']);
      expect(query['sort_order'], ['asc']);

      expect(list.total, 31);
      expect(list.totalPages, 2);
      final reservation = list.reservations.single;
      expect(reservation.status, 'waiting_list');
      expect(reservation.participants.map((p) => p.firstName), ['Claire', 'Léo']);
    });

    test('sends only the filters that are set', () async {
      late http.Request received;
      final service = _service(
        MockClient((request) async {
          received = request;
          return http.Response(jsonEncode({'reservations': [], 'total': 0, 'page': 1, 'per_page': 50, 'total_pages': 0}), 200);
        }),
      );

      await service.fetchAdminReservations(token: 'abc');

      expect(received.url.queryParametersAll.keys, unorderedEquals(['page', 'per_page', 'sort_by', 'sort_order']));
      expect(received.url.queryParameters['sort_by'], 'created_at');
      expect(received.url.queryParameters['sort_order'], 'desc');
    });

    test('refuses with the message of the API', () async {
      final service = _service(MockClient((_) async => http.Response(jsonEncode({'status': 'forbidden', 'error': 'insufficient permissions'}), 403)));

      expect(
        () => service.fetchAdminReservations(token: 'abc'),
        throwsA(isA<ReservationException>().having((e) => e.message, 'message', 'insufficient permissions')),
      );
    });
  });

  group('updateReservationStatus', () {
    test('sets the status with its reason and tells the booker when asked', () async {
      late http.Request received;
      final service = _service(
        MockClient((request) async {
          received = request;
          return http.Response(jsonEncode({..._reservationJson, 'status': 'cancelled', 'cancellation_reason': 'Doublon'}), 200);
        }),
      );

      final reservation = await service.updateReservationStatus(12, status: 'cancelled', reason: 'Doublon', sendEmail: true, token: 'abc');

      expect(received.method, 'PUT');
      expect(received.url.toString(), 'http://api.test/api/v1/reservations/admin/12/status');
      expect(received.headers['Authorization'], 'Bearer abc');
      expect(jsonDecode(received.body), {'status': 'cancelled', 'reason': 'Doublon', 'send_email': true});
      expect(reservation.status, 'cancelled');
      expect(reservation.cancellationReason, 'Doublon');
    });

    test('does not tell the booker nor give a reason by default', () async {
      late http.Request received;
      final service = _service(
        MockClient((request) async {
          received = request;
          return http.Response(jsonEncode(_reservationJson), 200);
        }),
      );

      await service.updateReservationStatus(12, status: 'confirmed', token: 'abc');

      expect(jsonDecode(received.body), {'status': 'confirmed', 'send_email': false});
    });

    test('refuses a reservation that does not fit in the places left, with its reason', () async {
      final service = _service(
        MockClient((_) async => http.Response(jsonEncode({'status': 'the participants do not fit in the 1 places left', 'reason': 'not_enough_places', 'error': 'the participants do not fit in the 1 places left'}), 409)),
      );

      expect(
        () => service.updateReservationStatus(12, status: 'confirmed', token: 'abc'),
        throwsA(isA<ReservationException>().having((e) => e.reason, 'reason', 'not_enough_places')),
      );
    });
  });

  group('deleteReservation', () {
    test('deletes the reservation', () async {
      late http.Request received;
      final service = _service(
        MockClient((request) async {
          received = request;
          return http.Response('', 204);
        }),
      );

      await service.deleteReservation(12, token: 'abc');

      expect(received.method, 'DELETE');
      expect(received.url.toString(), 'http://api.test/api/v1/reservations/admin/12');
      expect(received.headers['Authorization'], 'Bearer abc');
    });

    test('refuses with the message of the API', () async {
      final service = _service(MockClient((_) async => http.Response(jsonEncode({'status': 'not found', 'error': 'resource not found'}), 404)));

      expect(() => service.deleteReservation(12, token: 'abc'), throwsA(isA<ReservationException>().having((e) => e.message, 'message', 'resource not found')));
    });
  });

  group('performBulkAction', () {
    test('applies the action to the reservations and reads what failed separately', () async {
      late http.Request received;
      final service = _service(
        MockClient((request) async {
          received = request;
          return http.Response(
            jsonEncode({
              'success_count': 1,
              'failure_count': 1,
              'errors': [
                {'reservation_id': 13, 'error': 'the participants do not fit in the 1 places left'},
              ],
              'updated': [_reservationJson],
            }),
            200,
          );
        }),
      );

      final result = await service.performBulkAction([12, 13], action: 'confirm', reason: 'Validé', sendEmail: true, token: 'abc');

      expect(received.method, 'POST');
      expect(received.url.toString(), 'http://api.test/api/v1/reservations/admin/bulk-action');
      expect(received.headers['Authorization'], 'Bearer abc');
      expect(jsonDecode(received.body), {
        'reservation_ids': [12, 13],
        'action': 'confirm',
        'reason': 'Validé',
        'send_email': true,
      });
      expect(result.successCount, 1);
      expect(result.failureCount, 1);
      expect(result.errors.single.reservationId, 13);
      expect(result.errors.single.error, contains('do not fit'));
      expect(result.updated.single.id, 12);
    });

    test('reads a result without errors nor reservations, as the API omits empty lists', () async {
      final service = _service(MockClient((_) async => http.Response(jsonEncode({'success_count': 2, 'failure_count': 0}), 200)));

      final result = await service.performBulkAction([12, 13], action: 'delete', token: 'abc');

      expect(result.successCount, 2);
      expect(result.errors, isEmpty);
      expect(result.updated, isEmpty);
    });

    test('refuses a user who may not apply bulk actions', () async {
      final service = _service(MockClient((_) async => http.Response(jsonEncode({'status': 'forbidden', 'error': 'insufficient permissions'}), 403)));

      expect(() => service.performBulkAction([12], action: 'cancel', token: 'abc'), throwsA(isA<ReservationException>()));
    });
  });

  group('updateParticipantAsAdmin', () {
    test('sends only the fields to correct', () async {
      late http.Request received;
      final service = _service(
        MockClient((request) async {
          received = request;
          return http.Response(jsonEncode(_reservationJson), 200);
        }),
      );

      final reservation = await service.updateParticipantAsAdmin(12, 2, firstName: 'Zoé', token: 'abc');

      expect(received.method, 'PUT');
      expect(received.url.toString(), 'http://api.test/api/v1/reservations/admin/12/participants/2');
      expect(received.headers['Authorization'], 'Bearer abc');
      expect(jsonDecode(received.body), {'first_name': 'Zoé'});
      expect(reservation.participants, hasLength(2));
    });

    test('can correct the name and the tariff together', () async {
      late http.Request received;
      final service = _service(
        MockClient((request) async {
          received = request;
          return http.Response(jsonEncode(_reservationJson), 200);
        }),
      );

      await service.updateParticipantAsAdmin(12, 2, firstName: 'Zoé', lastName: 'Durand', priceLabel: 'Enfant', token: 'abc');

      expect(jsonDecode(received.body), {'first_name': 'Zoé', 'last_name': 'Durand', 'price_label': 'Enfant'});
    });

    test('refuses to change the tariff of a paid reservation, with its reason', () async {
      final service = _service(
        MockClient((_) async => http.Response(jsonEncode({'status': 'paid', 'reason': 'reservation_paid', 'error': 'participants cannot be modified once the reservation is paid'}), 409)),
      );

      expect(
        () => service.updateParticipantAsAdmin(12, 2, priceLabel: 'Enfant', token: 'abc'),
        throwsA(isA<ReservationException>().having((e) => e.reason, 'reason', 'reservation_paid')),
      );
    });
  });
}
