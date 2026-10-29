import 'package:balade/core/api_error_message.dart';
import 'package:balade/core/permission.dart';
import 'package:balade/features/admin/admin_home_page/providers/rambles_provider.dart';
import 'package:balade/features/admin/admin_home_page/widgets/filters/rambles_filters_panel.dart';
import 'package:balade/features/admin/admin_home_page/widgets/filters/rambles_filters_sidebar.dart';
import 'package:balade/features/admin/admin_home_page/widgets/grids/rambles_content.dart';
import 'package:balade/features/admin/admin_home_page/widgets/headers/rambles_desktop_header.dart';
import 'package:balade/features/admin/admin_home_page/widgets/headers/rambles_header.dart';
import 'package:balade/features/admin/admin_home_page/widgets/headers/rambles_results_header.dart';
import 'package:balade/features/admin/admin_home_page/widgets/states/rambles_empty_state.dart';
import 'package:balade/features/authentication/authentication_provider.dart';
import 'package:balade/features/authentication/permission_provider.dart';
import 'package:balade/features/guides/providers/current_guide_provider.dart';
import 'package:balade/features/ramble/models/ramble/ramble.dart';
import 'package:balade/features/ramble/ramble_permissions.dart';
import 'package:balade/features/ramble/rambles_service.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class RamblesList extends ConsumerStatefulWidget {
  const RamblesList({super.key});

  @override
  ConsumerState<RamblesList> createState() => _RamblesListState();
}

class _RamblesListState extends ConsumerState<RamblesList> {
  final _searchController = TextEditingController();
  bool _showFilters = false;
  RamblesViewMode _viewMode = RamblesViewMode.compact; // Default to compact view

  bool _guideFilterApplied = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _applyGuideDefaultFilter();
      _loadRambles();
    });

    _searchController.addListener(_onSearchChanged);
  }

  void _applyGuideDefaultFilter() {
    if (_guideFilterApplied) return;

    final permission = ref.read(permissionProvider);
    final guideId = ref.read(currentGuideProvider).guide?.id;
    if (permission?.isGuide() == true && !permission!.isAdmin() && guideId != null) {
      _guideFilterApplied = true;
      _onFilterChanged(guideId: guideId);
    }
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

  void _onFilterChanged({String? type, String? difficulty, int? guideId, DateTime? dateFrom, DateTime? dateTo, bool? isCancelled, bool? hidePastRambles}) {
    final currentFilters = ref.read(ramblesProvider).filters;
    final newFilters = currentFilters.copyWith(
      type: type,
      difficulty: difficulty,
      guideId: guideId,
      dateFrom: dateFrom,
      dateTo: dateTo,
      isCancelled: isCancelled,
      hidePastRambles: hidePastRambles,
    );
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
    ref.listen(currentGuideProvider, (_, next) {
      if (!_guideFilterApplied && next.guide?.id != null) {
        _applyGuideDefaultFilter();
      }
    });

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
    final permission = ref.watch(permissionProvider);
    final guideId = ref.watch(currentGuideProvider).guide?.id;
    final isGuideOnly = permission?.isGuide() == true && permission?.isAdmin() != true;
    final showCreate = canCreateBalade(permission, ref.watch(isFunctionalGuideProvider));

    return Row(
      children: [
        RamblesFiltersSidebar(
          selectedCancellationStatus: state.filters.isCancelled,
          selectedType: state.filters.type,
          selectedDifficulty: state.filters.difficulty,
          selectedGuideId: state.filters.guideId,
          dateFrom: state.filters.dateFrom,
          dateTo: state.filters.dateTo,
          hidePastRambles: state.filters.hidePastRambles,
          hideGuideFilter: isGuideOnly,
          onCancellationStatusChanged: (value) => _onFilterChanged(isCancelled: value),
          onTypeChanged: (value) => _onFilterChanged(type: value),
          onDifficultyChanged: (value) => _onFilterChanged(difficulty: value),
          onGuideChanged: (value) => _onFilterChanged(guideId: value),
          onDateFromChanged: (value) => _onFilterChanged(dateFrom: value),
          onDateToChanged: (value) => _onFilterChanged(dateTo: value),
          onHidePastRamblesChanged: (value) => _onFilterChanged(hidePastRambles: value),
          onClearFilters: _onClearFilters,
        ),
        Expanded(
          child: Column(
            children: [
              RamblesDesktopHeader(
                searchController: _searchController,
                onSearchChanged: _onSearchChanged,
                onRefresh: _loadRambles,
                onExport: _handleExport,
                onCreateNew: _handleCreateNew,
                showCreateButton: showCreate,
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
              Expanded(child: _buildContent(state, isDesktop: true, permission: permission, guideId: guideId)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabletLayout() {
    final state = ref.watch(ramblesProvider);
    final permission = ref.watch(permissionProvider);
    final guideId = ref.watch(currentGuideProvider).guide?.id;
    final isGuideOnly = permission?.isGuide() == true && permission?.isAdmin() != true;

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
            selectedCancellationStatus: state.filters.isCancelled,
            selectedType: state.filters.type,
            selectedDifficulty: state.filters.difficulty,
            selectedGuideId: state.filters.guideId,
            dateFrom: state.filters.dateFrom,
            dateTo: state.filters.dateTo,
            hidePastRambles: state.filters.hidePastRambles,
            hideGuideFilter: isGuideOnly,
            onCancellationStatusChanged: (value) => _onFilterChanged(isCancelled: value),
            onTypeChanged: (value) => _onFilterChanged(type: value),
            onDifficultyChanged: (value) => _onFilterChanged(difficulty: value),
            onGuideChanged: (value) => _onFilterChanged(guideId: value),
            onDateFromChanged: (value) => _onFilterChanged(dateFrom: value),
            onDateToChanged: (value) => _onFilterChanged(dateTo: value),
            onHidePastRamblesChanged: (value) => _onFilterChanged(hidePastRambles: value),
            onClearFilters: _onClearFilters,
          ),
        RamblesResultsHeader(
          resultsCount: state.rambles.length,
          sortBy: state.sort.sortBy,
          sortAscending: state.sort.sortAscending,
          onSortChanged: _onSortChanged,
          onSortDirectionChanged: _onSortDirectionChanged,
          showViewToggle: false,
        ),
        Expanded(child: _buildContent(state, isTablet: true, permission: permission, guideId: guideId)),
      ],
    );
  }

  Widget _buildMobileLayout() {
    final state = ref.watch(ramblesProvider);
    final permission = ref.watch(permissionProvider);
    final guideId = ref.watch(currentGuideProvider).guide?.id;
    final isGuideOnly = permission?.isGuide() == true && permission?.isAdmin() != true;

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
            selectedCancellationStatus: state.filters.isCancelled,
            selectedType: state.filters.type,
            selectedDifficulty: state.filters.difficulty,
            selectedGuideId: state.filters.guideId,
            dateFrom: state.filters.dateFrom,
            dateTo: state.filters.dateTo,
            hidePastRambles: state.filters.hidePastRambles,
            hideGuideFilter: isGuideOnly,
            onCancellationStatusChanged: (value) => _onFilterChanged(isCancelled: value),
            onTypeChanged: (value) => _onFilterChanged(type: value),
            onDifficultyChanged: (value) => _onFilterChanged(difficulty: value),
            onGuideChanged: (value) => _onFilterChanged(guideId: value),
            onDateFromChanged: (value) => _onFilterChanged(dateFrom: value),
            onDateToChanged: (value) => _onFilterChanged(dateTo: value),
            onHidePastRamblesChanged: (value) => _onFilterChanged(hidePastRambles: value),
            onClearFilters: _onClearFilters,
          ),
        RamblesResultsHeader(
          resultsCount: state.rambles.length,
          sortBy: state.sort.sortBy,
          sortAscending: state.sort.sortAscending,
          onSortChanged: _onSortChanged,
          onSortDirectionChanged: _onSortDirectionChanged,
          showViewToggle: false,
        ),
        Expanded(child: _buildContent(state, isMobile: true, permission: permission, guideId: guideId)),
      ],
    );
  }

  Widget _buildContent(RamblesState state, {bool isDesktop = false, bool isTablet = false, bool isMobile = false, Permission? permission, int? guideId}) {
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

    bool canManage(Ramble ramble) => canManageRamble(permission, ramble, guideId);

    if (isMobile) {
      return RamblesGrid(
        rambles: state.rambles,
        onEdit: _handleEdit,
        onCancel: _handleCancel,
        onDuplicate: _handleDuplicate,
        canManage: canManage,
        viewMode: RamblesViewMode.list,
      );
    } else if (isTablet) {
      return RamblesGrid(
        rambles: state.rambles,
        onEdit: _handleEdit,
        onCancel: _handleCancel,
        onDuplicate: _handleDuplicate,
        canManage: canManage,
        viewMode: RamblesViewMode.compact,
        padding: const EdgeInsets.all(16),
        spacing: 16,
      );
    } else {
      return RamblesGrid(rambles: state.rambles, onEdit: _handleEdit, onCancel: _handleCancel, onDuplicate: _handleDuplicate, canManage: canManage, viewMode: _viewMode, padding: const EdgeInsets.all(24), spacing: 24);
    }
  }

  void _handleEdit(Ramble ramble) {
    context.go("/admin/modifier-balade/${ramble.id}");
  }

  void _handleCancel(Ramble ramble) {
    _showCancelDialog(ramble);
  }

  void _handleDuplicate(Ramble ramble) {
    _showDuplicateDialog(ramble);
  }

  void _showDuplicateDialog(Ramble ramble) {
    final titleController = TextEditingController(text: '${ramble.title} (copie)');
    DateTime? selectedDate = ramble.date;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Dupliquer « ${ramble.title} »'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Titre de la copie', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            DateTimeFormField(
              initialValue: selectedDate,
              dateFormat: DateFormat('EEEE d MMMM yyyy à HH:mm', 'fr_FR'),
              decoration: const InputDecoration(labelText: 'Date de la balade', suffixIcon: Icon(Icons.calendar_today)),
              mode: DateTimeFieldPickerMode.dateAndTime,
              onChanged: (date) => selectedDate = date,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Annuler')),
          FilledButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
              _performDuplicate(ramble, titleController.text.trim(), selectedDate);
            },
            icon: const Icon(Icons.copy),
            label: const Text('Dupliquer'),
          ),
        ],
      ),
    );
  }

  Future<void> _performDuplicate(Ramble ramble, String title, DateTime? date) async {
    try {
      final auth = ref.read(authenticationProvider);
      if (auth?.token == null) return;

      final copy = await RamblesService.instance.duplicateRamble(
        ramble.id,
        title: title.isNotEmpty ? title : null,
        date: date,
        authorization: auth!.token,
      );

      ref.read(ramblesProvider.notifier).loadRambles(authorization: auth.token);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Balade dupliquée : « ${copy.title} » (brouillon)')));
        context.go('/admin/modifier-balade/${copy.id}');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur lors de la duplication : ${parseApiErrorMessage(e)}')));
      }
    }
  }

  void _showCancelDialog(Ramble ramble) {
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Annuler la balade "${ramble.title}"'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Êtes-vous sûr de vouloir annuler cette balade ?'),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(labelText: 'Motif d\'annulation *', hintText: 'Indiquez la raison de l\'annulation', border: OutlineInputBorder()),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Annuler')),
          FilledButton(
            onPressed: () {
              if (reasonController.text.trim().isNotEmpty) {
                Navigator.of(context).pop();
                _performCancel(ramble, reasonController.text.trim());
              }
            },
            style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
            child: const Text('Confirmer l\'annulation'),
          ),
        ],
      ),
    );
  }

  void _performCancel(Ramble ramble, String reason) async {
    try {
      final auth = ref.read(authenticationProvider);
      if (auth?.token != null) {
        await RamblesService.instance.cancelRamble(ramble.id, reason, authorization: auth!.token);
        ref.read(ramblesProvider.notifier).loadRambles(authorization: auth.token);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Balade "${ramble.title}" annulée avec succès')));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur lors de l\'annulation: $e')));
      }
    }
  }

  void _handleExport() {
    // TODO: Implement export functionality
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Export en cours de développement')));
  }

  void _handleCreateNew() {
    if (!canCreateBalade(ref.read(permissionProvider), ref.read(isFunctionalGuideProvider))) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vous devez avoir un profil guide lié pour créer une balade.')));
      return;
    }
    context.go("/admin/nouvelle-balade");
  }
}
