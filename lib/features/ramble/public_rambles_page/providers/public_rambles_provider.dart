import 'dart:async';

import 'package:balade/features/ramble/models/ramble/ramble.dart';
import 'package:balade/features/ramble/rambles_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Filter state for public rambles (simplified)
class PublicRamblesFilterState {
  const PublicRamblesFilterState({this.search, this.type, this.difficulty, this.location, this.dateFrom, this.dateTo});

  final String? search;
  final String? type;
  final String? difficulty;
  final String? location;
  final DateTime? dateFrom;
  final DateTime? dateTo;

  PublicRamblesFilterState copyWith({String? search, String? type, String? difficulty, String? location, DateTime? dateFrom, DateTime? dateTo}) {
    return PublicRamblesFilterState(
      search: search ?? this.search,
      type: type ?? this.type,
      difficulty: difficulty ?? this.difficulty,
      location: location ?? this.location,
      dateFrom: dateFrom ?? this.dateFrom,
      dateTo: dateTo ?? this.dateTo,
    );
  }

  PublicRamblesFilterState clearFilters() {
    return const PublicRamblesFilterState();
  }

  bool get hasActiveFilters {
    return search?.isNotEmpty == true || type?.isNotEmpty == true || difficulty?.isNotEmpty == true || location?.isNotEmpty == true || dateFrom != null || dateTo != null;
  }
}

// Sort state
class PublicRamblesSortState {
  const PublicRamblesSortState({this.sortBy = 'date', this.sortOrder = 'asc'});

  final String sortBy; // 'date', 'title', 'difficulty'
  final String sortOrder; // 'asc', 'desc'

  PublicRamblesSortState copyWith({String? sortBy, String? sortOrder}) {
    return PublicRamblesSortState(sortBy: sortBy ?? this.sortBy, sortOrder: sortOrder ?? this.sortOrder);
  }
}

// Main state
class PublicRamblesState {
  const PublicRamblesState({
    this.rambles = const [],
    this.isLoading = false,
    this.error,
    this.filterState = const PublicRamblesFilterState(),
    this.sortState = const PublicRamblesSortState(),
  });

  final List<Ramble> rambles;
  final bool isLoading;
  final String? error;
  final PublicRamblesFilterState filterState;
  final PublicRamblesSortState sortState;

  PublicRamblesState copyWith({List<Ramble>? rambles, bool? isLoading, String? error, PublicRamblesFilterState? filterState, PublicRamblesSortState? sortState}) {
    return PublicRamblesState(
      rambles: rambles ?? this.rambles,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      filterState: filterState ?? this.filterState,
      sortState: sortState ?? this.sortState,
    );
  }
}

// Provider
class PublicRamblesNotifier extends StateNotifier<PublicRamblesState> {
  PublicRamblesNotifier(this._ramblesService) : super(const PublicRamblesState()) {
    _init();
  }

  final RamblesService _ramblesService;
  Timer? _debounceTimer;

  void _init() {
    fetchRambles();
  }

  Future<void> fetchRambles() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final rambles = await _ramblesService.fetchRambles(
        search: state.filterState.search,
        type: state.filterState.type,
        difficulty: state.filterState.difficulty,
        location: state.filterState.location,
        dateFrom: state.filterState.dateFrom,
        dateTo: state.filterState.dateTo,
        isActive: true, // Only fetch active rambles
      );

      // Sort the rambles locally since the service doesn't support sorting
      final sortedRambles = _sortRambles(rambles);

      state = state.copyWith(rambles: sortedRambles, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void updateSearch(String? search) {
    state = state.copyWith(filterState: state.filterState.copyWith(search: search));

    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), fetchRambles);
  }

  void updateType(String? type) {
    state = state.copyWith(filterState: state.filterState.copyWith(type: type));
    fetchRambles();
  }

  void updateDifficulty(String? difficulty) {
    state = state.copyWith(filterState: state.filterState.copyWith(difficulty: difficulty));
    fetchRambles();
  }

  void updateLocation(String? location) {
    state = state.copyWith(filterState: state.filterState.copyWith(location: location));
    fetchRambles();
  }

  void updateDateRange(DateTime? dateFrom, DateTime? dateTo) {
    state = state.copyWith(
      filterState: state.filterState.copyWith(dateFrom: dateFrom, dateTo: dateTo),
    );
    fetchRambles();
  }

  void updateSort(String sortBy, [String? sortOrder]) {
    final newSortOrder = sortOrder ?? (state.sortState.sortBy == sortBy && state.sortState.sortOrder == 'asc' ? 'desc' : 'asc');

    state = state.copyWith(
      sortState: state.sortState.copyWith(sortBy: sortBy, sortOrder: newSortOrder),
    );
    fetchRambles();
  }

  void clearFilters() {
    state = state.copyWith(filterState: state.filterState.clearFilters());
    fetchRambles();
  }

  void refresh() {
    fetchRambles();
  }

  List<Ramble> _sortRambles(List<Ramble> rambles) {
    final sorted = List<Ramble>.from(rambles);

    switch (state.sortState.sortBy) {
      case 'date':
        sorted.sort((a, b) {
          if (a.date == null && b.date == null) return 0;
          if (a.date == null) return 1;
          if (b.date == null) return -1;
          return state.sortState.sortOrder == 'asc' ? a.date!.compareTo(b.date!) : b.date!.compareTo(a.date!);
        });
        break;
      case 'title':
        sorted.sort((a, b) {
          return state.sortState.sortOrder == 'asc' ? a.title.compareTo(b.title) : b.title.compareTo(a.title);
        });
        break;
      case 'difficulty':
        const difficultyOrder = ['facile', 'modere', 'difficile'];
        sorted.sort((a, b) {
          final aIndex = difficultyOrder.indexOf(a.difficulty);
          final bIndex = difficultyOrder.indexOf(b.difficulty);
          return state.sortState.sortOrder == 'asc' ? aIndex.compareTo(bIndex) : bIndex.compareTo(aIndex);
        });
        break;
    }

    return sorted;
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}

// Provider instances
final publicRamblesProvider = StateNotifierProvider<PublicRamblesNotifier, PublicRamblesState>((ref) {
  final ramblesService = ref.read(ramblesServiceProvider);
  return PublicRamblesNotifier(ramblesService);
});

// Service provider (using singleton instance)
final ramblesServiceProvider = Provider<RamblesService>((ref) {
  return RamblesService.instance;
});
