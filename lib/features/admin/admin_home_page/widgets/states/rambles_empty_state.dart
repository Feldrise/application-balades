import 'package:flutter/material.dart';

class RamblesEmptyState extends StatelessWidget {
  const RamblesEmptyState({super.key, required this.onClearFilters});

  final VoidCallback onClearFilters;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.explore_off, size: 64, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(height: 16),
          Text('Aucune balade trouvée', style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          const SizedBox(height: 8),
          Text('Essayez de modifier vos critères de recherche', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          const SizedBox(height: 24),
          FilledButton.icon(onPressed: onClearFilters, icon: const Icon(Icons.clear_all), label: const Text('Effacer les filtres')),
        ],
      ),
    );
  }
}
