import 'package:balade/features/ramble/public_rambles_page/providers/public_rambles_provider.dart';
import 'package:balade/features/ramble/public_rambles_page/widgets/public_rambles_filters.dart';
import 'package:balade/features/ramble/public_rambles_page/widgets/ramble_public_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PublicRamblesPage extends ConsumerStatefulWidget {
  const PublicRamblesPage({super.key});

  @override
  ConsumerState<PublicRamblesPage> createState() => _PublicRamblesPageState();
}

class _PublicRamblesPageState extends ConsumerState<PublicRamblesPage> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    ref.read(publicRamblesProvider.notifier).updateSearch(_searchController.text);
  }

  void _onRambleRegister(int rambleId) {
    // TODO: Navigate to registration page
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Inscription à la balade $rambleId (à implémenter)'),
        action: SnackBarAction(label: 'OK', onPressed: () {}),
      ),
    );
  }

  void _onRambleDetails(int rambleId) {
    context.go('/balades/$rambleId');
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(publicRamblesProvider);
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive breakpoints
    final isMobile = screenWidth < 768;
    final isTablet = screenWidth >= 768 && screenWidth < 1200;
    final isDesktop = screenWidth >= 1200;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Balades Écologiques'),
        centerTitle: false,
        actions: [
          if (isMobile) IconButton(onPressed: _showFiltersBottomSheet, icon: const Icon(Icons.filter_list)),
          IconButton(onPressed: () => ref.read(publicRamblesProvider.notifier).refresh(), icon: const Icon(Icons.refresh)),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (isDesktop) {
            return _buildDesktopLayout(state);
          } else if (isTablet) {
            return _buildTabletLayout(state);
          } else {
            return _buildMobileLayout(state);
          }
        },
      ),
    );
  }

  Widget _buildDesktopLayout(PublicRamblesState state) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Sidebar with filters
        SizedBox(
          width: 320,
          child: Column(
            children: [
              _buildSearchBar(),
              const SizedBox(height: 16),
              const Expanded(
                child: SingleChildScrollView(padding: EdgeInsets.all(16), child: PublicRamblesFilters()),
              ),
            ],
          ),
        ),

        // Main content
        Expanded(
          child: Column(
            children: [
              _buildResultsHeader(state),
              Expanded(child: _buildRamblesGrid(state, crossAxisCount: 3)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabletLayout(PublicRamblesState state) {
    return Column(
      children: [
        _buildSearchBar(),
        const SizedBox(height: 8),
        const PublicRamblesFilters(),
        const SizedBox(height: 8),
        _buildResultsHeader(state),
        Expanded(child: _buildRamblesGrid(state, crossAxisCount: 2)),
      ],
    );
  }

  Widget _buildMobileLayout(PublicRamblesState state) {
    return Column(
      children: [
        _buildSearchBar(),
        const SizedBox(height: 8),
        _buildResultsHeader(state),
        Expanded(child: _buildRamblesList(state)),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SearchBar(
        controller: _searchController,
        hintText: 'Rechercher une balade...',
        leading: const Icon(Icons.search),
        trailing: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              onPressed: () {
                _searchController.clear();
              },
              icon: const Icon(Icons.clear),
            ),
        ],
      ),
    );
  }

  Widget _buildResultsHeader(PublicRamblesState state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          if (state.isLoading)
            const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
          else
            Text(
              '${state.rambles.length} balade${state.rambles.length != 1 ? 's' : ''} trouvée${state.rambles.length != 1 ? 's' : ''}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          const Spacer(),
          if (state.filterState.hasActiveFilters)
            TextButton.icon(
              onPressed: () => ref.read(publicRamblesProvider.notifier).clearFilters(),
              icon: const Icon(Icons.clear, size: 16),
              label: const Text('Effacer filtres'),
            ),
        ],
      ),
    );
  }

  Widget _buildRamblesGrid(PublicRamblesState state, {required int crossAxisCount}) {
    if (state.isLoading && state.rambles.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64),
            const SizedBox(height: 16),
            Text('Erreur: ${state.error}'),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: () => ref.read(publicRamblesProvider.notifier).refresh(), child: const Text('Réessayer')),
          ],
        ),
      );
    }

    if (state.rambles.isEmpty) {
      return _buildEmptyState();
    }

    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 12 / 10,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        mainAxisExtent: 330,
      ),
      itemCount: state.rambles.length,
      itemBuilder: (context, index) {
        final ramble = state.rambles[index];
        return RamblePublicCard(ramble: ramble, onTap: () => _onRambleDetails(ramble.id), onRegister: () => _onRambleRegister(ramble.id));
      },
    );
  }

  Widget _buildRamblesList(PublicRamblesState state) {
    if (state.isLoading && state.rambles.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64),
            const SizedBox(height: 16),
            Text('Erreur: ${state.error}'),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: () => ref.read(publicRamblesProvider.notifier).refresh(), child: const Text('Réessayer')),
          ],
        ),
      );
    }

    if (state.rambles.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: state.rambles.length,
      itemBuilder: (context, index) {
        final ramble = state.rambles[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: SizedBox(
            height: 280,
            child: RamblePublicCard(ramble: ramble, onTap: () => _onRambleDetails(ramble.id), onRegister: () => _onRambleRegister(ramble.id)),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    final hasFilters = ref.read(publicRamblesProvider).filterState.hasActiveFilters;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(hasFilters ? Icons.search_off : Icons.explore_off, size: 64, color: Theme.of(context).colorScheme.onSurfaceVariant),
          const SizedBox(height: 16),
          Text(
            hasFilters ? 'Aucune balade ne correspond à vos critères' : 'Aucune balade disponible pour le moment',
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            hasFilters ? 'Essayez de modifier vos filtres' : 'De nouvelles balades seront bientôt disponibles',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
          if (hasFilters) ...[
            const SizedBox(height: 16),
            ElevatedButton(onPressed: () => ref.read(publicRamblesProvider.notifier).clearFilters(), child: const Text('Effacer les filtres')),
          ],
        ],
      ),
    );
  }

  void _showFiltersBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Text('Filtres', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.close)),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(controller: scrollController, padding: const EdgeInsets.all(16), child: const PublicRamblesFilters()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
