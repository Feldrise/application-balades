import 'package:flutter/material.dart';

class RamblesDesktopHeader extends StatelessWidget {
  const RamblesDesktopHeader({
    super.key,
    required this.searchController,
    required this.onSearchChanged,
    required this.onRefresh,
    required this.onExport,
    required this.onCreateNew,
  });

  final TextEditingController searchController;
  final VoidCallback onSearchChanged;
  final VoidCallback onRefresh;
  final VoidCallback onExport;
  final VoidCallback onCreateNew;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(bottom: BorderSide(color: theme.dividerColor)),
      ),
      child: Row(
        children: [
          // Search field (more prominent on desktop)
          Expanded(
            flex: 3,
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher par titre, lieu, description...',
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
                contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              ),
            ),
          ),

          const SizedBox(width: 24),

          // Quick action buttons
          _buildQuickActions(theme),
        ],
      ),
    );
  }

  Widget _buildQuickActions(ThemeData theme) {
    return Row(
      children: [
        // Export button
        OutlinedButton.icon(onPressed: onExport, icon: const Icon(Icons.download), label: const Text('Exporter')),

        const SizedBox(width: 12),

        // Add new ramble button
        FilledButton.icon(onPressed: onCreateNew, icon: const Icon(Icons.add), label: const Text('Nouvelle balade')),

        const SizedBox(width: 12),

        // Refresh button
        IconButton.outlined(onPressed: onRefresh, icon: const Icon(Icons.refresh), tooltip: 'Actualiser'),
      ],
    );
  }
}
