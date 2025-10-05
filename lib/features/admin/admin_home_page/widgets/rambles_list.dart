import 'package:balade/features/admin/admin_home_page/providers/rambles_provider.dart';
import 'package:balade/features/admin/admin_home_page/widgets/filters/rambles_filters_panel.dart';
import 'package:balade/features/admin/admin_home_page/widgets/filters/rambles_filters_sidebar.dart';
import 'package:balade/features/admin/admin_home_page/widgets/grids/rambles_content.dart';
import 'package:balade/features/admin/admin_home_page/widgets/headers/rambles_desktop_header.dart';
import 'package:balade/features/admin/admin_home_page/widgets/headers/rambles_header.dart';
import 'package:balade/features/admin/admin_home_page/widgets/headers/rambles_results_header.dart';
import 'package:balade/features/admin/admin_home_page/widgets/states/rambles_empty_state.dart';
import 'package:balade/features/authentication/authentication_provider.dart';
import 'package:balade/features/ramble/models/ramble/ramble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RamblesList extends ConsumerStatefulWidget {
  const RamblesList({super.key});

  @override
  ConsumerState<RamblesList> createState() => _RamblesListState();
}

class _RamblesListState extends ConsumerState<RamblesList> {
  final _searchController = TextEditingController();
  bool _showFilters = false;
  RamblesViewMode _viewMode = RamblesViewMode.compact; // Default to compact view

  @override
  void initState() {
    super.initState();

    // Load rambles on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadRambles();
    });

    // Add listener to search field for real-time search
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadRambles() {
    final auth = ref.read(authenticationProvider);
    ref.read(ramblesProvider.notifier).loadRambles(authorization: auth?.token);
  }

  void _onSearchChanged() {
    final currentFilters = ref.read(ramblesProvider).filters;
    final newFilters = currentFilters.copyWith(search: _searchController.text);
    final auth = ref.read(authenticationProvider);

    ref.read(ramblesProvider.notifier).updateFilters(newFilters, authorization: auth?.token);
  }

  void _onFilterChanged({String? status, String? type, String? difficulty, int? guideId, DateTime? dateFrom, DateTime? dateTo}) {
    final currentFilters = ref.read(ramblesProvider).filters;
    final newFilters = currentFilters.copyWith(status: status, type: type, difficulty: difficulty, guideId: guideId, dateFrom: dateFrom, dateTo: dateTo);
    final auth = ref.read(authenticationProvider);

    ref.read(ramblesProvider.notifier).updateFilters(newFilters, authorization: auth?.token);
  }

  void _onSortChanged(String sortBy) {
    final currentSort = ref.read(ramblesProvider).sort;
    final newSort = currentSort.copyWith(sortBy: sortBy);
    ref.read(ramblesProvider.notifier).updateSort(newSort);
  }

  void _onSortDirectionChanged() {
    final currentSort = ref.read(ramblesProvider).sort;
    final newSort = currentSort.copyWith(sortAscending: !currentSort.sortAscending);
    ref.read(ramblesProvider.notifier).updateSort(newSort);
  }

  void _onClearFilters() {
    _searchController.clear();
    final auth = ref.read(authenticationProvider);
    ref.read(ramblesProvider.notifier).clearFilters(authorization: auth?.token);
  }

  void _onViewModeChanged(RamblesViewMode mode) {
    setState(() {
      _viewMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1200;
    final isTablet = screenWidth > 768 && screenWidth <= 1200;

    if (isDesktop) {
      return _buildDesktopLayout();
    } else if (isTablet) {
      return _buildTabletLayout();
    } else {
      return _buildMobileLayout();
    }
  }

  Widget _buildDesktopLayout() {
    final state = ref.watch(ramblesProvider);

    return Row(
      children: [
        // Left sidebar with filters (always visible on desktop)
        RamblesFiltersSidebar(
          selectedStatus: state.filters.status,
          selectedType: state.filters.type,
          selectedDifficulty: state.filters.difficulty,
          selectedGuideId: state.filters.guideId,
          dateFrom: state.filters.dateFrom,
          dateTo: state.filters.dateTo,
          onStatusChanged: (value) => _onFilterChanged(status: value),
          onTypeChanged: (value) => _onFilterChanged(type: value),
          onDifficultyChanged: (value) => _onFilterChanged(difficulty: value),
          onGuideChanged: (value) => _onFilterChanged(guideId: value),
          onDateFromChanged: (value) => _onFilterChanged(dateFrom: value),
          onDateToChanged: (value) => _onFilterChanged(dateTo: value),
          onClearFilters: _onClearFilters,
        ),

        // Main content area
        Expanded(
          child: Column(
            children: [
              RamblesDesktopHeader(
                searchController: _searchController,
                onSearchChanged: _onSearchChanged,
                onRefresh: _loadRambles,
                onExport: _handleExport,
                onCreateNew: _handleCreateNew,
              ),
              RamblesResultsHeader(
                resultsCount: state.rambles.length,
                sortBy: state.sort.sortBy,
                sortAscending: state.sort.sortAscending,
                onSortChanged: _onSortChanged,
                onSortDirectionChanged: _onSortDirectionChanged,
                viewMode: _viewMode,
                onViewModeChanged: _onViewModeChanged,
                showViewToggle: true,
              ),
              Expanded(child: _buildContent(state, isDesktop: true)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabletLayout() {
    final state = ref.watch(ramblesProvider);

    return Column(
      children: [
        RamblesHeader(
          searchController: _searchController,
          onSearchChanged: _onSearchChanged,
          showFilters: _showFilters,
          onToggleFilters: () => setState(() => _showFilters = !_showFilters),
          onRefresh: _loadRambles,
        ),
        if (_showFilters)
          RamblesFiltersPanel(
            selectedStatus: state.filters.status,
            selectedType: state.filters.type,
            selectedDifficulty: state.filters.difficulty,
            selectedGuideId: state.filters.guideId,
            dateFrom: state.filters.dateFrom,
            dateTo: state.filters.dateTo,
            onStatusChanged: (value) => _onFilterChanged(status: value),
            onTypeChanged: (value) => _onFilterChanged(type: value),
            onDifficultyChanged: (value) => _onFilterChanged(difficulty: value),
            onGuideChanged: (value) => _onFilterChanged(guideId: value),
            onDateFromChanged: (value) => _onFilterChanged(dateFrom: value),
            onDateToChanged: (value) => _onFilterChanged(dateTo: value),
            onClearFilters: _onClearFilters,
          ),
        RamblesResultsHeader(
          resultsCount: state.rambles.length,
          sortBy: state.sort.sortBy,
          sortAscending: state.sort.sortAscending,
          onSortChanged: _onSortChanged,
          onSortDirectionChanged: _onSortDirectionChanged,
          showViewToggle: false, // No view toggle for tablet
        ),
        Expanded(child: _buildContent(state, isTablet: true)),
      ],
    );
  }

  Widget _buildMobileLayout() {
    final state = ref.watch(ramblesProvider);

    return Column(
      children: [
        RamblesHeader(
          searchController: _searchController,
          onSearchChanged: _onSearchChanged,
          showFilters: _showFilters,
          onToggleFilters: () => setState(() => _showFilters = !_showFilters),
          onRefresh: _loadRambles,
        ),
        if (_showFilters)
          RamblesFiltersPanel(
            selectedStatus: state.filters.status,
            selectedType: state.filters.type,
            selectedDifficulty: state.filters.difficulty,
            selectedGuideId: state.filters.guideId,
            dateFrom: state.filters.dateFrom,
            dateTo: state.filters.dateTo,
            onStatusChanged: (value) => _onFilterChanged(status: value),
            onTypeChanged: (value) => _onFilterChanged(type: value),
            onDifficultyChanged: (value) => _onFilterChanged(difficulty: value),
            onGuideChanged: (value) => _onFilterChanged(guideId: value),
            onDateFromChanged: (value) => _onFilterChanged(dateFrom: value),
            onDateToChanged: (value) => _onFilterChanged(dateTo: value),
            onClearFilters: _onClearFilters,
          ),
        RamblesResultsHeader(
          resultsCount: state.rambles.length,
          sortBy: state.sort.sortBy,
          sortAscending: state.sort.sortAscending,
          onSortChanged: _onSortChanged,
          onSortDirectionChanged: _onSortDirectionChanged,
          showViewToggle: false, // No view toggle for mobile
        ),
        Expanded(child: _buildContent(state, isMobile: true)),
      ],
    );
  }

  Widget _buildContent(RamblesState state, {bool isDesktop = false, bool isTablet = false, bool isMobile = false}) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Theme.of(context).colorScheme.error),
            const SizedBox(height: 16),
            Text('Erreur: ${state.error}'),
            const SizedBox(height: 16),
            FilledButton(onPressed: _loadRambles, child: const Text('Réessayer')),
          ],
        ),
      );
    }

    if (state.rambles.isEmpty) {
      return RamblesEmptyState(onClearFilters: _onClearFilters);
    }

    if (isMobile) {
      return RamblesGrid(
        rambles: state.rambles,
        onEdit: _handleEdit,
        onToggleStatus: _handleToggleStatus,
        viewMode: RamblesViewMode.list, // Mobile uses list view
      );
    } else if (isTablet) {
      return RamblesGrid(
        rambles: state.rambles,
        onEdit: _handleEdit,
        onToggleStatus: _handleToggleStatus,
        viewMode: RamblesViewMode.compact, // Tablet uses compact grid
        padding: const EdgeInsets.all(16),
        spacing: 16,
      );
    } else {
      // Desktop - use selected view mode
      return RamblesGrid(rambles: state.rambles, onEdit: _handleEdit, onToggleStatus: _handleToggleStatus, viewMode: _viewMode, padding: const EdgeInsets.all(24), spacing: 24);
    }
  }

  void _handleEdit(Ramble ramble) {
    context.go("/admin/modifier-balade/${ramble.id}");
  }

  void _handleToggleStatus(Ramble ramble) {
    // TODO: Implement status toggle
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Changement de statut pour "${ramble.title}"')));
  }

  void _handleExport() {
    // TODO: Implement export functionality
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Export en cours de développement')));
  }

  void _handleCreateNew() {
    context.go("/admin/nouvelle-balade");
  }
}
