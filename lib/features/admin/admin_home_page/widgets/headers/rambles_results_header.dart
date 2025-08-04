import 'package:flutter/material.dart';

class RamblesResultsHeader extends StatelessWidget {
  const RamblesResultsHeader({
    super.key,
    required this.resultsCount,
    required this.sortBy,
    required this.sortAscending,
    required this.onSortChanged,
    required this.onSortDirectionChanged,
  });

  final int resultsCount;
  final String sortBy;
  final bool sortAscending;
  final ValueChanged<String> onSortChanged;
  final VoidCallback onSortDirectionChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(bottom: BorderSide(color: theme.dividerColor.withOpacity(0.3))),
      ),
      child: Row(
        children: [
          Text(
            '$resultsCount balade${resultsCount > 1 ? 's' : ''} trouvée${resultsCount > 1 ? 's' : ''}',
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),

          const Spacer(),

          // Sort options
          Text('Trier par:', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          const SizedBox(width: 8),
          DropdownButton<String>(
            value: sortBy,
            underline: const SizedBox(),
            items: const [
              DropdownMenuItem(value: 'date', child: Text('Date')),
              DropdownMenuItem(value: 'title', child: Text('Titre')),
              DropdownMenuItem(value: 'status', child: Text('Statut')),
            ],
            onChanged: (value) {
              if (value != null) {
                onSortChanged(value);
              }
            },
          ),

          IconButton(onPressed: onSortDirectionChanged, icon: Icon(sortAscending ? Icons.arrow_upward : Icons.arrow_downward), iconSize: 18),
        ],
      ),
    );
  }
}
