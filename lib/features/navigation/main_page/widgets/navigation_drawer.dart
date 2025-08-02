import 'package:balade/features/navigation/main_page/widgets/navigation_items.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainNavigationDrawer extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const MainNavigationDrawer({super.key, required this.scaffoldKey});

  bool _isCurrentRoute(BuildContext context, String route) {
    final currentRoute = GoRouterState.of(context).uri.path;
    return currentRoute == route;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Drawer(
      backgroundColor: theme.colorScheme.surface,
      child: Column(
        children: [
          // Header
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [theme.colorScheme.primary, theme.colorScheme.primary.withAlpha(201)]),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: theme.colorScheme.onPrimary.withAlpha(50),
                  child: Icon(Icons.eco, size: 32, color: theme.colorScheme.onPrimary),
                ),
                const SizedBox(height: 16),
                Text(
                  'Balade Écologique',
                  style: theme.textTheme.titleLarge?.copyWith(color: theme.colorScheme.onPrimary, fontWeight: FontWeight.bold),
                ),
                Text('Découvrez la nature', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onPrimary.withAlpha(201))),
              ],
            ),
          ),
          // Navigation items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ...mainNavigationItems.map(
                  (item) => _DrawerNavItem(
                    item: item,
                    isSelected: _isCurrentRoute(context, item.route),
                    onTap: () {
                      Navigator.pop(context);
                      context.go(item.route);
                    },
                  ),
                ),
                const Divider(),
                ...adminNavigationItems.map(
                  (item) => _DrawerNavItem(
                    item: item,
                    isSelected: _isCurrentRoute(context, item.route),
                    onTap: () {
                      Navigator.pop(context);
                      context.go(item.route);
                    },
                  ),
                ),
              ],
            ),
          ),
          // Footer
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Divider(),
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

class _DrawerNavItem extends StatelessWidget {
  final NavigationItem item;
  final bool isSelected;
  final VoidCallback onTap;
  const _DrawerNavItem({required this.item, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
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
      onTap: onTap,
    );
  }
}
