import 'package:balade/features/ramble/models/ramble/ramble.dart';
import 'package:balade/features/ramble/public_rambles_page/providers/public_rambles_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PublicRamblesFilters extends ConsumerWidget {
  const PublicRamblesFilters({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(publicRamblesProvider);
    final notifier = ref.read(publicRamblesProvider.notifier);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(Icons.filter_list, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text('Filtres', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const Spacer(),
                if (state.filterState.hasActiveFilters)
                  TextButton.icon(
                    onPressed: notifier.clearFilters,
                    icon: const Icon(Icons.clear, size: 16),
                    label: const Text('Effacer'),
                    style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 8)),
                  ),
              ],
            ),

            const SizedBox(height: 16),

            // Quick filters
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildQuickFilter(
                  'Aujourd\'hui',
                  () => notifier.updateDateRange(DateTime.now(), DateTime.now().add(const Duration(days: 1))),
                  state.filterState.dateFrom != null && _isSameDay(state.filterState.dateFrom!, DateTime.now()),
                ),
                _buildQuickFilter(
                  'Cette semaine',
                  () => notifier.updateDateRange(DateTime.now(), DateTime.now().add(const Duration(days: 7))),
                  state.filterState.dateFrom != null && state.filterState.dateTo != null,
                ),
                _buildQuickFilter('Facile', () => notifier.updateDifficulty(state.filterState.difficulty == 'facile' ? null : 'facile'), state.filterState.difficulty == 'facile'),
                _buildQuickFilter(
                  'Champignons',
                  () => notifier.updateType(state.filterState.type == 'champignons' ? null : 'champignons'),
                  state.filterState.type == 'champignons',
                ),
                _buildQuickFilter('Oiseaux', () => notifier.updateType(state.filterState.type == 'oiseaux' ? null : 'oiseaux'), state.filterState.type == 'oiseaux'),
              ],
            ),

            const SizedBox(height: 16),

            // Detailed filters in responsive layout
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 600;
                if (isWide) {
                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(child: _buildTypeFilter(state, notifier)),
                          const SizedBox(width: 16),
                          Expanded(child: _buildDifficultyFilter(state, notifier)),
                          const SizedBox(width: 16),
                          Expanded(child: _buildSortFilter(state, notifier)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildShowCancelledFilter(state, notifier),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      _buildTypeFilter(state, notifier),
                      const SizedBox(height: 12),
                      _buildDifficultyFilter(state, notifier),
                      const SizedBox(height: 12),
                      _buildSortFilter(state, notifier),
                      const SizedBox(height: 12),
                      _buildShowCancelledFilter(state, notifier),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickFilter(String label, VoidCallback onTap, bool isActive) {
    return FilterChip(label: Text(label), selected: isActive, onSelected: (_) => onTap(), showCheckmark: false);
  }

  Widget _buildTypeFilter(PublicRamblesState state, PublicRamblesNotifier notifier) {
    return DropdownButtonFormField<String>(
      value: state.filterState.type,
      decoration: const InputDecoration(labelText: 'Type de balade', border: OutlineInputBorder(), isDense: true),
      items: [
        const DropdownMenuItem(value: null, child: Text('Tous les types')),
        ...rambleTypeLabels.entries.map(
          (entry) => DropdownMenuItem(
            value: entry.key,
            child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(rambleTypeIcons[entry.key], size: 16), const SizedBox(width: 8), Text(entry.value)]),
          ),
        ),
      ],
      onChanged: notifier.updateType,
    );
  }

  Widget _buildDifficultyFilter(PublicRamblesState state, PublicRamblesNotifier notifier) {
    return DropdownButtonFormField<String>(
      value: state.filterState.difficulty,
      decoration: const InputDecoration(labelText: 'Difficulté', border: OutlineInputBorder(), isDense: true),
      items: [
        const DropdownMenuItem(value: null, child: Text('Toutes difficultés')),
        ...rambleDifficultyLabels.entries.map(
          (entry) => DropdownMenuItem(
            value: entry.key,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(color: rambleDifficultyColors[entry.key], shape: BoxShape.circle),
                ),
                const SizedBox(width: 8),
                Text(entry.value),
              ],
            ),
          ),
        ),
      ],
      onChanged: notifier.updateDifficulty,
    );
  }

  Widget _buildSortFilter(PublicRamblesState state, PublicRamblesNotifier notifier) {
    final sortOptions = {'date': 'Date', 'title': 'Titre', 'difficulty': 'Difficulté'};

    return DropdownButtonFormField<String>(
      value: state.sortState.sortBy,
      decoration: const InputDecoration(labelText: 'Trier par', border: OutlineInputBorder(), isDense: true),
      items: sortOptions.entries
          .map(
            (entry) => DropdownMenuItem(
              value: entry.key,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [Text(entry.value), const SizedBox(width: 4), Icon(state.sortState.sortOrder == 'asc' ? Icons.arrow_upward : Icons.arrow_downward, size: 14)],
              ),
            ),
          )
          .toList(),
      onChanged: (value) {
        if (value != null) {
          notifier.updateSort(value);
        }
      },
    );
  }

  Widget _buildShowCancelledFilter(PublicRamblesState state, PublicRamblesNotifier notifier) {
    return Row(
      children: [
        Checkbox(value: state.filterState.showCancelled, onChanged: (value) => notifier.updateShowCancelled(value ?? false)),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () => notifier.updateShowCancelled(!state.filterState.showCancelled),
          child: Row(
            children: [
              Icon(Icons.cancel, size: 16, color: Colors.red),
              const SizedBox(width: 4),
              const Text('Inclure les balades annulées'),
            ],
          ),
        ),
      ],
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }
}
