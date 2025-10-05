import 'dart:async';

import 'package:balade/features/registrations/models/registration/registration.dart';
import 'package:balade/features/registrations/registrations_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Filter state for admin registrations
class AdminRegistrationsFilterState {
  const AdminRegistrationsFilterState({this.search, this.rambleId, this.userId, this.email, this.status, this.statuses, this.dateFrom, this.dateTo, this.rambleTitle});

  final String? search;
  final int? rambleId;
  final int? userId;
  final String? email;
  final String? status;
  final List<String>? statuses;
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final String? rambleTitle;

  AdminRegistrationsFilterState copyWith({
    String? search,
    int? rambleId,
    int? userId,
    String? email,
    String? status,
    List<String>? statuses,
    DateTime? dateFrom,
    DateTime? dateTo,
    String? rambleTitle,
  }) {
    return AdminRegistrationsFilterState(
      search: search ?? this.search,
      rambleId: rambleId ?? this.rambleId,
      userId: userId ?? this.userId,
      email: email ?? this.email,
      status: status ?? this.status,
      statuses: statuses ?? this.statuses,
      dateFrom: dateFrom ?? this.dateFrom,
      dateTo: dateTo ?? this.dateTo,
      rambleTitle: rambleTitle ?? this.rambleTitle,
    );
  }

  AdminRegistrationsFilterState clearFilters() {
    return const AdminRegistrationsFilterState();
  }

  bool get hasActiveFilters {
    return (search?.isNotEmpty ?? false) ||
        rambleId != null ||
        userId != null ||
        (email?.isNotEmpty ?? false) ||
        (status?.isNotEmpty ?? false) ||
        (statuses?.isNotEmpty ?? false) ||
        dateFrom != null ||
        dateTo != null ||
        (rambleTitle?.isNotEmpty ?? false);
  }
}

// Sort state for admin registrations
class AdminRegistrationsSortState {
  const AdminRegistrationsSortState({this.sortBy = 'created_at', this.sortAscending = false});

  final String sortBy;
  final bool sortAscending;

  AdminRegistrationsSortState copyWith({String? sortBy, bool? sortAscending}) {
    return AdminRegistrationsSortState(sortBy: sortBy ?? this.sortBy, sortAscending: sortAscending ?? this.sortAscending);
  }

  String get sortOrder => sortAscending ? 'asc' : 'desc';
}

// Pagination state
class AdminRegistrationsPaginationState {
  const AdminRegistrationsPaginationState({this.page = 1, this.perPage = 50, this.total = 0, this.totalPages = 0});

  final int page;
  final int perPage;
  final int total;
  final int totalPages;

  AdminRegistrationsPaginationState copyWith({int? page, int? perPage, int? total, int? totalPages}) {
    return AdminRegistrationsPaginationState(page: page ?? this.page, perPage: perPage ?? this.perPage, total: total ?? this.total, totalPages: totalPages ?? this.totalPages);
  }

  bool get hasNextPage => page < totalPages;
  bool get hasPreviousPage => page > 1;
}

// Main state for admin registrations
class AdminRegistrationsState {
  const AdminRegistrationsState({
    this.registrations = const [],
    this.isLoading = false,
    this.error,
    this.filters = const AdminRegistrationsFilterState(),
    this.sort = const AdminRegistrationsSortState(),
    this.pagination = const AdminRegistrationsPaginationState(),
  });

  final List<Registration> registrations;
  final bool isLoading;
  final String? error;
  final AdminRegistrationsFilterState filters;
  final AdminRegistrationsSortState sort;
  final AdminRegistrationsPaginationState pagination;

  AdminRegistrationsState copyWith({
    List<Registration>? registrations,
    bool? isLoading,
    String? error,
    AdminRegistrationsFilterState? filters,
    AdminRegistrationsSortState? sort,
    AdminRegistrationsPaginationState? pagination,
  }) {
    return AdminRegistrationsState(
      registrations: registrations ?? this.registrations,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      filters: filters ?? this.filters,
      sort: sort ?? this.sort,
      pagination: pagination ?? this.pagination,
    );
  }
}

// StateNotifier for admin registrations
class AdminRegistrationsNotifier extends StateNotifier<AdminRegistrationsState> {
  AdminRegistrationsNotifier(this._registrationsService) : super(const AdminRegistrationsState());

  final RegistrationsService _registrationsService;
  Timer? _debounceTimer;

  Future<void> loadRegistrations({String? authorization}) async {
    if (authorization == null) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _registrationsService.fetchAllRegistrations(
        authorization: authorization,
        rambleId: state.filters.rambleId,
        userId: state.filters.userId,
        email: state.filters.email,
        status: state.filters.status,
        statuses: state.filters.statuses,
        dateFrom: state.filters.dateFrom,
        dateTo: state.filters.dateTo,
        search: state.filters.search?.isNotEmpty == true ? state.filters.search : null,
        rambleTitle: state.filters.rambleTitle?.isNotEmpty == true ? state.filters.rambleTitle : null,
        page: state.pagination.page,
        perPage: state.pagination.perPage,
        sortBy: state.sort.sortBy,
        sortOrder: state.sort.sortOrder,
      );

      final newPagination = state.pagination.copyWith(total: response.total, totalPages: response.totalPages);

      state = state.copyWith(registrations: response.registrations, isLoading: false, pagination: newPagination);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void updateFilters(AdminRegistrationsFilterState filters, {String? authorization}) {
    // Reset pagination when filters change
    final newPagination = state.pagination.copyWith(page: 1);
    state = state.copyWith(filters: filters, pagination: newPagination);

    // Debounce the search to avoid too many API calls
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      loadRegistrations(authorization: authorization);
    });
  }

  void updateSort(AdminRegistrationsSortState sort, {String? authorization}) {
    state = state.copyWith(sort: sort);
    loadRegistrations(authorization: authorization);
  }

  void updatePagination(AdminRegistrationsPaginationState pagination, {String? authorization}) {
    state = state.copyWith(pagination: pagination);
    loadRegistrations(authorization: authorization);
  }

  void nextPage({String? authorization}) {
    if (state.pagination.hasNextPage) {
      final newPagination = state.pagination.copyWith(page: state.pagination.page + 1);
      updatePagination(newPagination, authorization: authorization);
    }
  }

  void previousPage({String? authorization}) {
    if (state.pagination.hasPreviousPage) {
      final newPagination = state.pagination.copyWith(page: state.pagination.page - 1);
      updatePagination(newPagination, authorization: authorization);
    }
  }

  void goToPage(int page, {String? authorization}) {
    if (page >= 1 && page <= state.pagination.totalPages) {
      final newPagination = state.pagination.copyWith(page: page);
      updatePagination(newPagination, authorization: authorization);
    }
  }

  void clearFilters({String? authorization}) {
    final newPagination = state.pagination.copyWith(page: 1);
    state = state.copyWith(filters: const AdminRegistrationsFilterState(), pagination: newPagination);
    loadRegistrations(authorization: authorization);
  }

  void refreshRegistration(Registration updatedRegistration) {
    final updatedList = state.registrations.map((reg) {
      return reg.id == updatedRegistration.id ? updatedRegistration : reg;
    }).toList();

    state = state.copyWith(registrations: updatedList);
  }

  void removeRegistration(int registrationId) {
    final updatedList = state.registrations.where((reg) => reg.id != registrationId).toList();
    state = state.copyWith(registrations: updatedList);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}

// Provider for admin registrations
final adminRegistrationsProvider = StateNotifierProvider<AdminRegistrationsNotifier, AdminRegistrationsState>((ref) {
  return AdminRegistrationsNotifier(RegistrationsService.instance);
});
