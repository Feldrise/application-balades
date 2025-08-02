import 'package:balade/features/navigation/main_page/widgets/navigation_items.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SideNavigation extends StatelessWidget {
  final bool isDesktop;
  const SideNavigation({super.key, required this.isDesktop});

  bool _isCurrentRoute(BuildContext context, String route) {
    final currentRoute = GoRouterState.of(context).uri.path;
    return currentRoute == route;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: isDesktop ? 280 : 240,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(right: BorderSide(color: theme.colorScheme.outline.withAlpha(50), width: 1)),
      ),
      child: Column(
        children: [
          // Header section
          Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: theme.colorScheme.primary.withAlpha(25),
                  child: Icon(Icons.eco, size: 32, color: theme.colorScheme.primary),
                ),
                const SizedBox(height: 16),
                Text(
                  'Navigation',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
                ),
              ],
            ),
          ),
          // Navigation items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                ...mainNavigationItems.map((item) => _NavItem(item: item, isSelected: _isCurrentRoute(context, item.route), onTap: () => context.go(item.route))),
                const SizedBox(height: 24),
                Divider(color: theme.colorScheme.outline.withAlpha(50)),
                ...adminNavigationItems.map((item) => _NavItem(item: item, isSelected: _isCurrentRoute(context, item.route), onTap: () => context.go(item.route))),
                const SizedBox(height: 16),
              ],
            ),
          ),
          // Footer section
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Divider(color: theme.colorScheme.outline.withAlpha(50)),
                const SizedBox(height: 8),
                Text(
                  '© 2025 Balade Écologique',
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withAlpha(151)),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final NavigationItem item;
  final bool isSelected;
  final VoidCallback onTap;
  const _NavItem({required this.item, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: ListTile(
        leading: Icon(isSelected ? item.selectedIcon : item.icon, color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface.withAlpha(178)),
        title: Text(
          item.label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        selected: isSelected,
        selectedTileColor: theme.colorScheme.primary.withAlpha(25),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onTap: onTap,
      ),
    );
  }
}
