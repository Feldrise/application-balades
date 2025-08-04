import 'dart:async';

import 'package:balade/features/ramble/models/ramble/ramble.dart';
import 'package:balade/features/ramble/rambles_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Filter state
class RamblesFilterState {
  const RamblesFilterState({this.search, this.status, this.type, this.difficulty, this.location, this.dateFrom, this.dateTo, this.guideId, this.isActive});

  final String? search;
  final String? status;
  final String? type;
  final String? difficulty;
  final String? location;
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final int? guideId;
  final bool? isActive;

  RamblesFilterState copyWith({
    String? search,
    String? status,
    String? type,
    String? difficulty,
    String? location,
    DateTime? dateFrom,
    DateTime? dateTo,
    int? guideId,
    bool? isActive,
  }) {
    return RamblesFilterState(
      search: search ?? this.search,
      status: status ?? this.status,
      type: type ?? this.type,
      difficulty: difficulty ?? this.difficulty,
      location: location ?? this.location,
      dateFrom: dateFrom ?? this.dateFrom,
      dateTo: dateTo ?? this.dateTo,
      guideId: guideId ?? this.guideId,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'search': search,
      'status': status,
      'type': type,
      'difficulty': difficulty,
      'location': location,
      'dateFrom': dateFrom,
      'dateTo': dateTo,
      'guideId': guideId,
      'isActive': isActive,
    };
  }
}

// Sort state
class RamblesSortState {
  const RamblesSortState({this.sortBy = 'date', this.sortAscending = true});

  final String sortBy;
  final bool sortAscending;

  RamblesSortState copyWith({String? sortBy, bool? sortAscending}) {
    return RamblesSortState(sortBy: sortBy ?? this.sortBy, sortAscending: sortAscending ?? this.sortAscending);
  }
}

// Main state
class RamblesState {
  const RamblesState({this.rambles = const [], this.isLoading = false, this.error, this.filters = const RamblesFilterState(), this.sort = const RamblesSortState()});

  final List<Ramble> rambles;
  final bool isLoading;
  final String? error;
  final RamblesFilterState filters;
  final RamblesSortState sort;

  RamblesState copyWith({List<Ramble>? rambles, bool? isLoading, String? error, RamblesFilterState? filters, RamblesSortState? sort}) {
    return RamblesState(
      rambles: rambles ?? this.rambles,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      filters: filters ?? this.filters,
      sort: sort ?? this.sort,
    );
  }
}

// StateNotifier
class RamblesNotifier extends StateNotifier<RamblesState> {
  RamblesNotifier(this._ramblesService) : super(const RamblesState());

  final RamblesService _ramblesService;
  Timer? _debounceTimer;

  Future<void> loadRambles({String? authorization}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final rambles = await _ramblesService.fetchRambles(
        search: state.filters.search?.isNotEmpty == true ? state.filters.search : null,
        status: state.filters.status,
        type: state.filters.type,
        difficulty: state.filters.difficulty,
        location: state.filters.location,
        dateFrom: state.filters.dateFrom,
        dateTo: state.filters.dateTo,
        guideId: state.filters.guideId,
        isActive: state.filters.isActive,
        authorization: authorization,
      );

      final sortedRambles = _sortRambles(rambles);
      state = state.copyWith(rambles: sortedRambles, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void updateFilters(RamblesFilterState filters, {String? authorization}) {
    state = state.copyWith(filters: filters);

    // Debounce the search to avoid too many API calls
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      loadRambles(authorization: authorization);
    });
  }

  void updateSort(RamblesSortState sort) {
    state = state.copyWith(sort: sort);
    final sortedRambles = _sortRambles(state.rambles);
    state = state.copyWith(rambles: sortedRambles);
  }

  void clearFilters({String? authorization}) {
    state = state.copyWith(filters: const RamblesFilterState());
    loadRambles(authorization: authorization);
  }

  List<Ramble> _sortRambles(List<Ramble> rambles) {
    final ramblesCopy = List<Ramble>.from(rambles);

    ramblesCopy.sort((a, b) {
      int comparison = 0;

      switch (state.sort.sortBy) {
        case 'date':
          if (a.date != null && b.date != null) {
            comparison = a.date!.compareTo(b.date!);
          } else if (a.date != null) {
            comparison = -1;
          } else if (b.date != null) {
            comparison = 1;
          }
          break;
        case 'title':
          comparison = a.title.compareTo(b.title);
          break;
        case 'status':
          comparison = a.status.compareTo(b.status);
          break;
      }

      return state.sort.sortAscending ? comparison : -comparison;
    });

    return ramblesCopy;
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}

// Provider
final ramblesProvider = StateNotifierProvider<RamblesNotifier, RamblesState>((ref) {
  return RamblesNotifier(RamblesService.instance);
});
