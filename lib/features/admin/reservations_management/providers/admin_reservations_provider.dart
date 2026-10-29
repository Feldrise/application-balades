import 'dart:async';

import 'package:balade/core/api_error_message.dart';
import 'package:balade/features/admin/reservations_management/models/admin_reservation_filter.dart';
import 'package:balade/features/reservations/models/reservation/reservation.dart';
import 'package:balade/features/reservations/reservations_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Sort state for admin reservations
class AdminReservationsSortState {
  const AdminReservationsSortState({this.sortBy = 'created_at', this.sortAscending = false});

  final String sortBy;
  final bool sortAscending;

  AdminReservationsSortState copyWith({String? sortBy, bool? sortAscending}) {
    return AdminReservationsSortState(sortBy: sortBy ?? this.sortBy, sortAscending: sortAscending ?? this.sortAscending);
  }

}

// Pagination state
class AdminReservationsPaginationState {
  const AdminReservationsPaginationState({this.page = 1, this.perPage = 50, this.total = 0, this.totalPages = 0});

  final int page;
  final int perPage;
  final int total;
  final int totalPages;

  AdminReservationsPaginationState copyWith({int? page, int? perPage, int? total, int? totalPages}) {
    return AdminReservationsPaginationState(page: page ?? this.page, perPage: perPage ?? this.perPage, total: total ?? this.total, totalPages: totalPages ?? this.totalPages);
  }

  bool get hasNextPage => page < totalPages;
  bool get hasPreviousPage => page > 1;
}

// Main state for admin reservations
class AdminReservationsState {
  const AdminReservationsState({
    this.reservations = const [],
    this.isLoading = false,
    this.error,
    this.filters = const AdminReservationFilter(),
    this.sort = const AdminReservationsSortState(),
    this.pagination = const AdminReservationsPaginationState(),
  });

  final List<Reservation> reservations;
  final bool isLoading;
  final String? error;
  final AdminReservationFilter filters;
  final AdminReservationsSortState sort;
  final AdminReservationsPaginationState pagination;

  AdminReservationsState copyWith({
    List<Reservation>? reservations,
    bool? isLoading,
    String? error,
    AdminReservationFilter? filters,
    AdminReservationsSortState? sort,
    AdminReservationsPaginationState? pagination,
  }) {
    return AdminReservationsState(
      reservations: reservations ?? this.reservations,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      filters: filters ?? this.filters,
      sort: sort ?? this.sort,
      pagination: pagination ?? this.pagination,
    );
  }
}

// StateNotifier for admin reservations
class AdminReservationsNotifier extends StateNotifier<AdminReservationsState> {
  AdminReservationsNotifier(this._reservationsService) : super(const AdminReservationsState());

  final ReservationsService _reservationsService;
  Timer? _debounceTimer;

  Future<void> loadReservations({String? token}) async {
    if (token == null) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _reservationsService.fetchAdminReservations(
        token: token,
        filter: state.filters,
        page: state.pagination.page,
        perPage: state.pagination.perPage,
        sortBy: state.sort.sortBy,
        sortAscending: state.sort.sortAscending,
      );

      final newPagination = state.pagination.copyWith(total: response.total, totalPages: response.totalPages);

      state = state.copyWith(reservations: response.reservations, isLoading: false, pagination: newPagination);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: parseApiErrorMessage(e));
    }
  }

  void updateFilters(AdminReservationFilter filters, {String? token}) {
    // Reset pagination when filters change
    final newPagination = state.pagination.copyWith(page: 1);
    state = state.copyWith(filters: filters, pagination: newPagination);

    // Debounce the search to avoid too many API calls
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      loadReservations(token: token);
    });
  }

  void updateSort(AdminReservationsSortState sort, {String? token}) {
    state = state.copyWith(sort: sort);
    loadReservations(token: token);
  }

  void updatePagination(AdminReservationsPaginationState pagination, {String? token}) {
    state = state.copyWith(pagination: pagination);
    loadReservations(token: token);
  }

  void nextPage({String? token}) {
    if (state.pagination.hasNextPage) {
      final newPagination = state.pagination.copyWith(page: state.pagination.page + 1);
      updatePagination(newPagination, token: token);
    }
  }

  void previousPage({String? token}) {
    if (state.pagination.hasPreviousPage) {
      final newPagination = state.pagination.copyWith(page: state.pagination.page - 1);
      updatePagination(newPagination, token: token);
    }
  }

  void goToPage(int page, {String? token}) {
    if (page >= 1 && page <= state.pagination.totalPages) {
      final newPagination = state.pagination.copyWith(page: page);
      updatePagination(newPagination, token: token);
    }
  }

  void clearFilters({String? token}) {
    final newPagination = state.pagination.copyWith(page: 1);
    state = state.copyWith(filters: const AdminReservationFilter(), pagination: newPagination);
    loadReservations(token: token);
  }

  void refreshReservation(Reservation updatedReservation) {
    final updatedList = state.reservations.map((reservation) {
      return reservation.id == updatedReservation.id ? updatedReservation : reservation;
    }).toList();

    state = state.copyWith(reservations: updatedList);
  }

  void removeReservation(int reservationId) {
    final updatedList = state.reservations.where((reservation) => reservation.id != reservationId).toList();
    state = state.copyWith(reservations: updatedList);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}

// Provider for admin reservations
final adminReservationsProvider = StateNotifierProvider<AdminReservationsNotifier, AdminReservationsState>((ref) {
  return AdminReservationsNotifier(ReservationsService.instance);
});
