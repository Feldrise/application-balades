import 'package:balade/features/admin/registrations_management/providers/admin_registrations_provider.dart';
import 'package:balade/features/admin/registrations_management/widgets/admin_registrations_data_table.dart';
import 'package:balade/features/admin/registrations_management/widgets/admin_registrations_filters.dart';
import 'package:balade/features/admin/registrations_management/widgets/bulk_actions_toolbar.dart';
import 'package:balade/features/admin/registrations_management/widgets/registrations_stats_cards.dart';
import 'package:balade/features/authentication/authentication_provider.dart';
import 'package:balade/themes/screen_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminRegistrationsPage extends ConsumerStatefulWidget {
  const AdminRegistrationsPage({super.key});

  @override
  ConsumerState<AdminRegistrationsPage> createState() => _AdminRegistrationsPageState();
}

class _AdminRegistrationsPageState extends ConsumerState<AdminRegistrationsPage> {
  late TextEditingController searchController;
  bool showFilters = false;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _loadInitialData() {
    final auth = ref.read(authenticationProvider);
    if (auth != null) {
      ref.read(adminRegistrationsProvider.notifier).loadRegistrations(authorization: 'Bearer ${auth.token}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= ScreenHelper.breakpointPC;
    final isTablet = screenWidth >= ScreenHelper.breakpointTablet && screenWidth < ScreenHelper.breakpointPC;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Main scrollable content
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? ScreenHelper.instance.horizontalPadding : 16.0, // Reduced padding on mobile/tablet for more table space
            ),
            child: CustomScrollView(
              slivers: [
                // Header with integrated controls
                SliverToBoxAdapter(child: _buildCompactHeader(theme, isDesktop)),

                // Stats section (only on desktop and tablet)
                if (isDesktop || isTablet) SliverToBoxAdapter(child: _buildStatsSection()),

                // Mobile search bar (only on mobile now)
                if (screenWidth < ScreenHelper.breakpointTablet) 
                  SliverToBoxAdapter(child: _buildMobileSearchBar()),

                // Filters (collapsible on mobile/tablet)
                if (showFilters || isDesktop) SliverToBoxAdapter(child: _buildFiltersSection()),

                // Results summary and actions
                SliverToBoxAdapter(child: _buildResultsToolbar()),

                // Main data content
                SliverFillRemaining(hasScrollBody: false, child: _buildDataContent(isDesktop, isTablet)),
              ],
            ),
          ),

          // Floating bulk actions toolbar
          Positioned(bottom: 16, left: 16, right: 16, child: const BulkActionsToolbar()),
        ],
      ),
    );
  }

  Widget _buildCompactHeader(ThemeData theme, bool isDesktop) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < ScreenHelper.breakpointTablet;
    final isTablet = screenWidth >= ScreenHelper.breakpointTablet && screenWidth < ScreenHelper.breakpointPC;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(isMobile ? 16 : 20),
          child: Column(
            children: [
              // First row: Title and main actions
              Row(
                children: [
                  // Title and subtitle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Inscriptions',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                            fontSize: isMobile ? 20 : null, // Smaller title on mobile
                          ),
                        ),
                        if (!isMobile) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Gérez toutes les réservations',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Action buttons - always on the right
                  _buildActionButtons(theme, isDesktop, isMobile),
                ],
              ),

              // Second row: Search bar (tablet/desktop) or spacing
              if (isTablet || isDesktop) ...[
                const SizedBox(height: 16),
                _buildSearchBar(theme, isDesktop),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(ThemeData theme, bool isDesktop, bool isMobile) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Filter toggle (mobile/tablet only)
        if (!isDesktop)
          IconButton.outlined(
            onPressed: () => setState(() => showFilters = !showFilters),
            icon: Icon(showFilters ? Icons.tune : Icons.tune),
            tooltip: showFilters ? 'Masquer les filtres' : 'Afficher les filtres',
            iconSize: isMobile ? 20 : 24,
          ),
        
        if (!isDesktop) SizedBox(width: isMobile ? 6 : 8),
        
        // Refresh button
        IconButton.outlined(
          onPressed: _refreshData,
          icon: const Icon(Icons.refresh),
          tooltip: 'Actualiser',
          iconSize: isMobile ? 20 : 24,
        ),
        
        SizedBox(width: isMobile ? 6 : 8),
        
        // Export button - responsive sizing
        if (isMobile)
          // Mobile: Icon only
          IconButton.outlined(
            onPressed: _exportRegistrations,
            icon: const Icon(Icons.download),
            tooltip: 'Exporter',
            iconSize: 20,
          )
        else
          // Tablet/Desktop: Icon + text
          OutlinedButton.icon(
            onPressed: _exportRegistrations,
            icon: const Icon(Icons.download),
            label: const Text('Exporter'),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 16 : 12,
                vertical: isDesktop ? 12 : 8,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSearchBar(ThemeData theme, bool isDesktop) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: isDesktop ? 'Rechercher par nom, email...' : 'Rechercher...',
              prefixIcon: const Icon(Icons.search, size: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: theme.colorScheme.outline),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              suffixIcon: searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 20),
                      onPressed: () {
                        searchController.clear();
                        _onSearchChanged();
                      },
                    )
                  : null,
            ),
            onChanged: (_) => _onSearchChanged(),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileSearchBar() {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Rechercher par nom, email...',
              prefixIcon: const Icon(Icons.search, size: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: theme.colorScheme.outline),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              suffixIcon: searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 20),
                      onPressed: () {
                        searchController.clear();
                        _onSearchChanged();
                      },
                    )
                  : null,
            ),
            onChanged: (_) => _onSearchChanged(),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsSection() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Consumer(
        builder: (context, ref, child) {
          final state = ref.watch(adminRegistrationsProvider);

          return RegistrationsStatsCards(registrations: state.registrations, totalCount: state.pagination.total);
        },
      ),
    );
  }

  Widget _buildFiltersSection() {
    return Container(margin: const EdgeInsets.only(bottom: 16), child: const AdminRegistrationsFilters());
  }

  Widget _buildResultsToolbar() {
    return Consumer(
      builder: (context, ref, child) {
        final state = ref.watch(adminRegistrationsProvider);
        final theme = Theme.of(context);

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  // Results count
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          '${state.pagination.total} résultat${state.pagination.total > 1 ? 's' : ''}',
                          style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500, color: theme.colorScheme.onSurface),
                        ),
                        if (state.filters.hasActiveFilters) ...[
                          const SizedBox(width: 12),
                          ActionChip(
                            label: const Text('Filtres actifs'),
                            onPressed: _clearFilters,
                            avatar: Icon(Icons.filter_list, size: 16, color: theme.colorScheme.primary),
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Loading indicator
                  if (state.isLoading)
                    Container(
                      margin: const EdgeInsets.only(left: 16),
                      child: const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDataContent(bool isDesktop, bool isTablet) {
    return Consumer(
      builder: (context, ref, child) {
        final state = ref.watch(adminRegistrationsProvider);
        final auth = ref.watch(authenticationProvider);

        if (auth == null) {
          return _buildStateCard(
            icon: Icons.lock_outline,
            title: 'Authentification requise',
            message: 'Vous devez être connecté en tant qu\'administrateur.',
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          );
        }

        if (state.isLoading && state.registrations.isEmpty) {
          return _buildStateCard(icon: Icons.hourglass_empty, title: 'Chargement...', message: 'Récupération des inscriptions en cours.', showLoading: true);
        }

        if (state.error != null) {
          return _buildStateCard(
            icon: Icons.error_outline,
            title: 'Erreur de chargement',
            message: state.error!,
            color: Theme.of(context).colorScheme.error,
            action: FilledButton.icon(onPressed: _refreshData, icon: const Icon(Icons.refresh), label: const Text('Réessayer')),
          );
        }

        if (state.registrations.isEmpty) {
          return _buildStateCard(
            icon: Icons.assignment_outlined,
            title: 'Aucune inscription',
            message: 'Aucune inscription ne correspond à vos critères de recherche.',
            action: OutlinedButton.icon(onPressed: _clearFilters, icon: const Icon(Icons.clear_all), label: const Text('Effacer les filtres')),
          );
        }

        // Main data table with pagination
        return Column(
          children: [
            // Data table
            Expanded(
              child: Card(
                margin: EdgeInsets.zero,
                child: AdminRegistrationsDataTable(registrations: state.registrations, onSort: _onSort, sortBy: state.sort.sortBy, sortAscending: state.sort.sortAscending),
              ),
            ),

            // Pagination (if needed)
            if (state.pagination.totalPages > 1) ...[const SizedBox(height: 16), _buildPaginationCard(state)],

            // Bottom padding for floating toolbar
            const SizedBox(height: 80),
          ],
        );
      },
    );
  }

  Widget _buildStateCard({required IconData icon, required String title, required String message, Color? color, Widget? action, bool showLoading = false}) {
    final theme = Theme.of(context);
    final effectiveColor = color ?? theme.colorScheme.onSurfaceVariant;

    return Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(48),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showLoading) ...[const CircularProgressIndicator(), const SizedBox(height: 24)] else ...[Icon(icon, size: 48, color: effectiveColor), const SizedBox(height: 16)],
              Text(
                title,
                style: theme.textTheme.headlineSmall?.copyWith(color: effectiveColor, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                message,
                style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                textAlign: TextAlign.center,
              ),
              if (action != null) ...[const SizedBox(height: 24), action],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaginationCard(AdminRegistrationsState state) {
    final theme = Theme.of(context);
    final pagination = state.pagination;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            Text('Page ${pagination.page} sur ${pagination.totalPages}', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            const Spacer(),

            // Pagination controls
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(onPressed: pagination.hasPreviousPage ? _previousPage : null, icon: const Icon(Icons.chevron_left), tooltip: 'Page précédente'),

                // Page numbers (simplified for mobile)
                _buildPageNumbers(pagination, theme),

                IconButton(onPressed: pagination.hasNextPage ? _nextPage : null, icon: const Icon(Icons.chevron_right), tooltip: 'Page suivante'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageNumbers(AdminRegistrationsPaginationState pagination, ThemeData theme) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < ScreenHelper.breakpointTablet;

    if (isMobile && pagination.totalPages > 5) {
      // Simplified pagination for mobile
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (pagination.page > 2) ...[_buildPageButton(1, pagination.page, theme), if (pagination.page > 3) const Text('...')],
          if (pagination.page > 1) _buildPageButton(pagination.page - 1, pagination.page, theme),
          _buildPageButton(pagination.page, pagination.page, theme),
          if (pagination.page < pagination.totalPages) _buildPageButton(pagination.page + 1, pagination.page, theme),
          if (pagination.page < pagination.totalPages - 1) ...[
            if (pagination.page < pagination.totalPages - 2) const Text('...'),
            _buildPageButton(pagination.totalPages, pagination.page, theme),
          ],
        ],
      );
    }

    // Full pagination for desktop/tablet
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 1; i <= pagination.totalPages; i++)
          if (i == 1 || i == pagination.totalPages || (i >= pagination.page - 2 && i <= pagination.page + 2)) ...[
            if (i > 1 && i == pagination.page - 3) const Padding(padding: EdgeInsets.symmetric(horizontal: 4), child: Text('...')),
            _buildPageButton(i, pagination.page, theme),
            if (i < pagination.totalPages && i == pagination.page + 3) const Padding(padding: EdgeInsets.symmetric(horizontal: 4), child: Text('...')),
          ],
      ],
    );
  }

  Widget _buildPageButton(int pageNumber, int currentPage, ThemeData theme) {
    final isCurrentPage = pageNumber == currentPage;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      child: TextButton(
        onPressed: isCurrentPage ? null : () => _goToPage(pageNumber),
        style: TextButton.styleFrom(
          backgroundColor: isCurrentPage ? theme.colorScheme.primaryContainer : null,
          foregroundColor: isCurrentPage ? theme.colorScheme.onPrimaryContainer : null,
          minimumSize: const Size(40, 40),
          padding: const EdgeInsets.symmetric(horizontal: 8),
        ),
        child: Text(pageNumber.toString(), style: TextStyle(fontWeight: isCurrentPage ? FontWeight.w600 : FontWeight.normal)),
      ),
    );
  }

  void _onSearchChanged() {
    final auth = ref.read(authenticationProvider);
    final currentFilters = ref.read(adminRegistrationsProvider).filters;
    final newFilters = currentFilters.copyWith(search: searchController.text.isEmpty ? null : searchController.text);
    ref.read(adminRegistrationsProvider.notifier).updateFilters(newFilters, authorization: auth?.token);
  }

  void _onSort(String sortBy) {
    final auth = ref.read(authenticationProvider);
    final currentSort = ref.read(adminRegistrationsProvider).sort;
    final newSort = currentSort.copyWith(sortBy: sortBy, sortAscending: currentSort.sortBy == sortBy ? !currentSort.sortAscending : false);
    ref.read(adminRegistrationsProvider.notifier).updateSort(newSort, authorization: auth?.token);
  }

  void _clearFilters() {
    searchController.clear();
    final auth = ref.read(authenticationProvider);
    ref.read(adminRegistrationsProvider.notifier).clearFilters(authorization: auth?.token);
  }

  void _refreshData() {
    final auth = ref.read(authenticationProvider);
    if (auth != null) {
      ref.read(adminRegistrationsProvider.notifier).loadRegistrations(authorization: 'Bearer ${auth.token}');
    }
  }

  void _exportRegistrations() {
    // TODO: Implement export functionality
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Export en cours de développement')));
  }

  void _nextPage() {
    final auth = ref.read(authenticationProvider);
    ref.read(adminRegistrationsProvider.notifier).nextPage(authorization: auth?.token);
  }

  void _previousPage() {
    final auth = ref.read(authenticationProvider);
    ref.read(adminRegistrationsProvider.notifier).previousPage(authorization: auth?.token);
  }

  void _goToPage(int page) {
    final auth = ref.read(authenticationProvider);
    ref.read(adminRegistrationsProvider.notifier).goToPage(page, authorization: auth?.token);
  }
}
