import 'package:balade/features/authentication/authentication_provider.dart';
import 'package:balade/features/navigation/main_page/widgets/navigation_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MainNavigationDrawer extends ConsumerWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const MainNavigationDrawer({super.key, required this.scaffoldKey});

  bool _isCurrentRoute(BuildContext context, String route) {
    final currentRoute = GoRouterState.of(context).uri.path;
    return currentRoute == route;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final authState = ref.watch(authenticationProvider);

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
                  'Balade EcoLogique',
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
          // Footer with authentication
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Divider(),
                const SizedBox(height: 12),
                if (authState != null) _buildUserProfile(context, ref, authState, theme) else _buildLoginButton(context, theme),
                const SizedBox(height: 12),
                Text(
                  '© 2025 Balade EcoLogique',
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

  Widget _buildUserProfile(BuildContext context, WidgetRef ref, authState, ThemeData theme) {
    final user = authState.user;
    final String displayName = user.profile?.firstName != null && user.profile?.lastName != null ? '${user.profile!.firstName} ${user.profile!.lastName}' : user.email as String;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: theme.colorScheme.primaryContainer.withAlpha(100), borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: theme.colorScheme.primary,
                child: Text(
                  displayName[0].toUpperCase(),
                  style: TextStyle(color: theme.colorScheme.onPrimary, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      user.email as String,
                      style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withAlpha(178)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () async {
              await ref.read(authenticationProvider.notifier).logout();
              if (context.mounted) {
                Navigator.pop(context);
                context.go('/');
              }
            },
            icon: const Icon(Icons.logout, size: 16),
            label: const Text('Déconnexion'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 8),
              foregroundColor: theme.colorScheme.error,
              side: BorderSide(color: theme.colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context, ThemeData theme) {
    return FilledButton.icon(
      onPressed: () {
        Navigator.pop(context);
        context.go('/connexion');
      },
      icon: const Icon(Icons.login, size: 18),
      label: const Text('Se connecter'),
      style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12), backgroundColor: theme.colorScheme.primary),
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
