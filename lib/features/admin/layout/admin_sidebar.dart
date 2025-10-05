import 'package:balade/features/admin/layout/admin_navigation_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AdminSidebar extends ConsumerWidget {
  final bool isDesktop;

  const AdminSidebar({super.key, required this.isDesktop});

  bool _isCurrentRoute(BuildContext context, String route) {
    final currentRoute = GoRouterState.of(context).uri.path;

    // Special handling for the main admin route
    if (route == '/admin') {
      return currentRoute == '/admin' ||
          currentRoute.startsWith('/admin/nouvelle-balade') ||
          currentRoute.startsWith('/admin/modifier-balade') ||
          currentRoute.startsWith('/admin/balade/');
    }

    return currentRoute.startsWith(route);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final navigationState = ref.watch(adminNavigationProvider);
    final isExpanded = isDesktop ? navigationState.isSidebarExpanded : true;

    return Container(
      width: isExpanded ? (isDesktop ? 280 : 240) : 72,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(right: BorderSide(color: theme.colorScheme.outline.withOpacity(0.2), width: 1)),
        boxShadow: [BoxShadow(color: theme.colorScheme.shadow.withOpacity(0.1), blurRadius: 4, offset: const Offset(2, 0))],
      ),
      child: Column(
        children: [
          _buildHeader(context, theme, isExpanded),
          Expanded(child: _buildNavigationItems(context, theme, isExpanded)),
          _buildFooter(context, theme, isExpanded),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme, bool isExpanded) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [theme.colorScheme.primaryContainer, theme.colorScheme.primaryContainer.withOpacity(0.8)],
        ),
      ),
      child: Column(
        crossAxisAlignment: isExpanded ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: theme.colorScheme.primary,
                child: Icon(Icons.admin_panel_settings, size: 24, color: theme.colorScheme.onPrimary),
              ),
              if (isExpanded) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Administration',
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onPrimaryContainer),
                      ),
                      Text('Balade EcoLogique', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onPrimaryContainer.withOpacity(0.8))),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationItems(BuildContext context, ThemeData theme, bool isExpanded) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      children: [
        ...adminNavigationItems.map(
          (item) => _AdminNavItem(item: item, isSelected: _isCurrentRoute(context, item.route), isExpanded: isExpanded, onTap: () => context.go(item.route)),
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context, ThemeData theme, bool isExpanded) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: theme.colorScheme.outline.withOpacity(0.2), width: 1)),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.go('/'),
            icon: Icon(Icons.logout, color: theme.colorScheme.onSurfaceVariant),
            tooltip: 'Retour au site public',
          ),
          if (isExpanded) ...[
            const SizedBox(width: 12),
            Expanded(
              child: Text('Retour au site public', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            ),
          ],
        ],
      ),
    );
  }
}

class _AdminNavItem extends StatelessWidget {
  final AdminNavigationItem item;
  final bool isSelected;
  final bool isExpanded;
  final VoidCallback onTap;

  const _AdminNavItem({required this.item, required this.isSelected, required this.isExpanded, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(color: isSelected ? theme.colorScheme.primaryContainer : Colors.transparent, borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                Icon(isSelected ? item.selectedIcon : item.icon, size: 24, color: isSelected ? theme.colorScheme.onPrimaryContainer : theme.colorScheme.onSurfaceVariant),
                if (isExpanded) ...[
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.label,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            color: isSelected ? theme.colorScheme.onPrimaryContainer : theme.colorScheme.onSurface,
                          ),
                        ),
                        if (item.description != null)
                          Text(
                            item.description!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: isSelected ? theme.colorScheme.onPrimaryContainer.withOpacity(0.8) : theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
