import 'package:flutter/material.dart';

class RamblesEmptyStateShared extends StatelessWidget {
  const RamblesEmptyStateShared({super.key, required this.hasFilters, this.onClearFilters, this.title, this.subtitle, this.actionLabel});

  final bool hasFilters;
  final VoidCallback? onClearFilters;
  final String? title;
  final String? subtitle;
  final String? actionLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final displayTitle = title ?? (hasFilters ? 'Aucune balade ne correspond à vos critères' : 'Aucune balade disponible pour le moment');

    final displaySubtitle = subtitle ?? (hasFilters ? 'Essayez de modifier vos filtres' : 'De nouvelles balades seront bientôt disponibles');

    final displayActionLabel = actionLabel ?? 'Effacer les filtres';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(hasFilters ? Icons.search_off : Icons.explore_off, size: 64, color: colorScheme.onSurfaceVariant),
            const SizedBox(height: 16),
            Text(
              displayTitle,
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              displaySubtitle,
              style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            if (hasFilters && onClearFilters != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(onPressed: onClearFilters, icon: const Icon(Icons.clear), label: Text(displayActionLabel)),
            ],
          ],
        ),
      ),
    );
  }
}
