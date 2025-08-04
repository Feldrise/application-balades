import 'package:flutter/material.dart';

class RamblesHeader extends StatelessWidget {
  const RamblesHeader({
    super.key,
    required this.searchController,
    required this.onSearchChanged,
    required this.showFilters,
    required this.onToggleFilters,
    required this.onRefresh,
    this.showFilterToggle = true,
    this.actions = const [],
  });

  final TextEditingController searchController;
  final VoidCallback onSearchChanged;
  final bool showFilters;
  final VoidCallback onToggleFilters;
  final VoidCallback onRefresh;
  final bool showFilterToggle;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(bottom: BorderSide(color: theme.dividerColor)),
      ),
      child: Row(
        children: [
          // Search field
          Expanded(
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher une balade...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          searchController.clear();
                          onSearchChanged();
                        },
                      )
                    : null,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Filter toggle button (mobile/tablet only)
          if (showFilterToggle) ...[
            IconButton.filled(
              onPressed: onToggleFilters,
              icon: Icon(showFilters ? Icons.filter_list_off : Icons.filter_list),
              style: IconButton.styleFrom(backgroundColor: showFilters ? theme.colorScheme.primary : theme.colorScheme.primaryContainer),
            ),
            const SizedBox(width: 8),
          ],

          // Custom actions
          ...actions,

          // Refresh button
          IconButton.outlined(onPressed: onRefresh, icon: const Icon(Icons.refresh)),
        ],
      ),
    );
  }
}
