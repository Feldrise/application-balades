import 'dart:convert';

import 'package:balade/features/admin/reservations_management/models/admin_reservation_filter.dart';
import 'package:balade/features/admin/reservations_management/providers/admin_reservations_provider.dart';
import 'package:balade/features/admin/reservations_management/providers/bulk_actions_provider.dart';
import 'package:balade/features/reservations/reservations_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

Map<String, Object?> _reservation(int id, String status) => {
  'id': id,
  'created_at': '2026-11-02T10:00:00Z',
  'updated_at': '2026-11-02T10:00:00Z',
  'ramble_id': 3,
  'user_id': 7,
  'contact_email': 'booker$id@example.com',
  'status': status,
  'participants': [
    {'id': id * 10, 'first_name': 'Claire', 'last_name': 'Martin', 'price_label': 'Adulte', 'price_amount': 12.5, 'is_booker': true},
  ],
  'estimated_amount': 1250,
};

/// A fake admin API: lists [reservations] and records the requests.
class _FakeApi {
  _FakeApi(this.reservations);

  List<Map<String, Object?>> reservations;
  final requests = <http.Request>[];

  Future<http.Response> handle(http.Request request) async {
    requests.add(request);
    if (request.url.path.endsWith('/bulk-action')) {
      return http.Response(jsonEncode({'success_count': 2, 'failure_count': 0}), 200);
    }
    return http.Response(jsonEncode({'reservations': reservations, 'total': 31, 'page': 1, 'per_page': 2, 'total_pages': 16}), 200);
  }
}

AdminReservationsNotifier _notifier(_FakeApi api) => AdminReservationsNotifier(ReservationsService(client: MockClient(api.handle), baseUrl: 'http://api.test/api/v1'));

void main() {
  group('AdminReservationsNotifier', () {
    test('loads a page of reservations with the filters, the sort and the pagination of its state', () async {
      final api = _FakeApi([_reservation(1, 'pending'), _reservation(2, 'waiting_list')]);
      final notifier = _notifier(api);
      notifier.state = notifier.state.copyWith(filters: const AdminReservationFilter(rambleId: 3, statuses: ['pending']));

      await notifier.loadReservations(token: 'abc');

      expect(notifier.state.reservations.map((r) => r.id), [1, 2]);
      expect(notifier.state.isLoading, isFalse);
      expect(notifier.state.pagination.total, 31);
      expect(notifier.state.pagination.totalPages, 16);
      final request = api.requests.single;
      expect(request.headers['Authorization'], 'Bearer abc');
      expect(request.url.queryParametersAll['ramble_id'], ['3']);
      expect(request.url.queryParametersAll['statuses'], ['pending']);
      expect(request.url.queryParameters['sort_by'], 'created_at');
      expect(request.url.queryParameters['sort_order'], 'desc');
    });

    test('shows the message of the API when loading fails', () async {
      final notifier = AdminReservationsNotifier(
        ReservationsService(client: MockClient((_) async => http.Response(jsonEncode({'status': 'forbidden', 'error': 'insufficient permissions'}), 403)), baseUrl: 'http://api.test/api/v1'),
      );

      await notifier.loadReservations(token: 'abc');

      expect(notifier.state.error, contains('insufficient permissions'));
      expect(notifier.state.isLoading, isFalse);
    });

    test('loads again from the new sort, then from the next page', () async {
      final api = _FakeApi([_reservation(1, 'pending')]);
      final notifier = _notifier(api);
      await notifier.loadReservations(token: 'abc');

      notifier.updateSort(const AdminReservationsSortState(sortBy: 'contact_email', sortAscending: true), token: 'abc');
      await Future<void>.delayed(Duration.zero);
      notifier.nextPage(token: 'abc');
      await Future<void>.delayed(Duration.zero);

      expect(api.requests, hasLength(3));
      expect(api.requests[1].url.queryParameters['sort_by'], 'contact_email');
      expect(api.requests[1].url.queryParameters['sort_order'], 'asc');
      expect(api.requests[2].url.queryParameters['page'], '2');
    });

    test('replaces a reservation changed elsewhere and drops a deleted one', () async {
      final notifier = _notifier(_FakeApi([_reservation(1, 'pending'), _reservation(2, 'pending')]));
      await notifier.loadReservations(token: 'abc');

      notifier.refreshReservation(notifier.state.reservations.first.copyWith(status: 'confirmed'));
      expect(notifier.state.reservations.map((r) => r.status), ['confirmed', 'pending']);

      notifier.removeReservation(1);
      expect(notifier.state.reservations.map((r) => r.id), [2]);
    });
  });

  group('BulkActionsNotifier', () {
    test('applies the action to the selection, clears it and loads the list again', () async {
      final api = _FakeApi([_reservation(1, 'pending'), _reservation(2, 'pending')]);
      final container = ProviderContainer(overrides: [adminReservationsProvider.overrideWith((ref) => _notifier(api))]);
      addTearDown(container.dispose);
      final bulk = BulkActionsNotifier(
        ReservationsService(client: MockClient(api.handle), baseUrl: 'http://api.test/api/v1'),
        container.read(adminReservationsProvider.notifier),
      );
      bulk.toggleSelection(1);
      bulk.toggleSelection(2);

      final success = await bulk.performBulkAction(action: 'cancel', token: 'abc', reason: 'Orage', sendEmail: true);

      expect(success, isTrue);
      expect(bulk.state.selectedReservationIds, isEmpty);
      expect(bulk.state.lastResult?.successCount, 2);
      final post = api.requests.firstWhere((r) => r.method == 'POST');
      expect(jsonDecode(post.body), {
        'reservation_ids': [1, 2],
        'action': 'cancel',
        'reason': 'Orage',
        'send_email': true,
      });
      await Future<void>.delayed(Duration.zero);
      expect(api.requests.last.method, 'GET');
    });

    test('does nothing without a selection', () async {
      final api = _FakeApi([]);
      final bulk = BulkActionsNotifier(ReservationsService(client: MockClient(api.handle), baseUrl: 'http://api.test/api/v1'), _notifier(api));

      final success = await bulk.performBulkAction(action: 'confirm', token: 'abc');

      expect(success, isFalse);
      expect(bulk.state.error, isNotNull);
      expect(api.requests, isEmpty);
    });
  });
}
