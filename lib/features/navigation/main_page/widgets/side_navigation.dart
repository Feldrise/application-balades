import 'package:balade/features/authentication/authentication_provider.dart';
import 'package:balade/features/authentication/data/models/authed_user/authed_user.dart';
import 'package:balade/features/navigation/main_page/widgets/navigation_items.dart';
import 'package:balade/features/users/models/user/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SideNavigation extends ConsumerWidget {
  final bool isDesktop;
  const SideNavigation({super.key, required this.isDesktop});

  bool _isCurrentRoute(BuildContext context, String route) {
    final currentRoute = GoRouterState.of(context).uri.path;
    return currentRoute == route;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final authState = ref.watch(authenticationProvider);

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
          // Footer section with authentication
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Divider(color: theme.colorScheme.outline.withAlpha(50)),
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

  Widget _buildUserProfile(BuildContext context, WidgetRef ref, AuthedUser? authState, ThemeData theme) {
    final User? user = authState?.user;
    final String displayName = user?.profile?.firstName != null && user?.profile?.lastName != null
        ? '${user!.profile!.firstName} ${user.profile!.lastName}'
        : user?.email as String;

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
                      user?.email ?? '',
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
      onPressed: () => context.go('/connexion'),
      icon: const Icon(Icons.login, size: 18),
      label: const Text('Se connecter'),
      style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12), backgroundColor: theme.colorScheme.primary),
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
