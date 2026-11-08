import 'package:balade/core/widgets/app_logo.dart';
import 'package:balade/features/admin/design/management_theme.dart';
import 'package:balade/features/authentication/authentication_provider.dart';
import 'package:balade/features/authentication/permission_provider.dart';
import 'package:balade/features/navigation/main_page/widgets/navigation_items.dart';
import 'package:balade/features/users/user_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// The deep green public navigation, in the drawer on a phone and as a sidebar on larger screens:
/// the pages, then the connected account with the logout, or the login.
class NavigationPanel extends ConsumerWidget {
  const NavigationPanel({super.key, this.onNavigated});

  /// Called after each navigation, e.g. to close the drawer.
  final VoidCallback? onNavigated;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final authed = ref.watch(authenticationProvider);
    final items = publicNavigationItems(ref.watch(permissionProvider));
    final path = GoRouterState.of(context).uri.path;

    void go(String location) {
      onNavigated?.call();
      context.go(location);
    }

    return Material(
      color: ManagementColors.deepGreen,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                    child: const AppLogo(height: 30, width: 42),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text('Balade EcoLogique', style: theme.textTheme.titleMedium?.copyWith(color: Colors.white)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [for (final item in items) _NavigationEntry(item: item, selected: isInSection(item, path), onTap: () => go(item.route))],
              ),
            ),
            const Divider(color: Colors.white24),
            Padding(
              padding: const EdgeInsets.all(16),
              child: authed == null
                  ? FilledButton.icon(
                      style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: ManagementColors.deepGreen),
                      onPressed: () => go('/connexion'),
                      icon: const Icon(Icons.login, size: 18),
                      label: const Text('Se connecter'),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.account_circle_outlined, color: Colors.white70),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                userDisplayLabel(authed.user),
                                style: theme.textTheme.bodySmall?.copyWith(color: Colors.white),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white38),
                          ),
                          onPressed: () async {
                            await ref.read(authenticationProvider.notifier).logout();
                            if (context.mounted) go('/balades');
                          },
                          icon: const Icon(Icons.logout, size: 16),
                          label: const Text('Déconnexion'),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavigationEntry extends StatelessWidget {
  const _NavigationEntry({required this.item, required this.selected, required this.onTap});

  final NavigationItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: ListTile(
        selected: selected,
        selectedTileColor: Colors.white.withValues(alpha: 0.16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        leading: Icon(selected ? item.selectedIcon : item.icon, color: selected ? Colors.white : Colors.white70),
        title: Text(
          item.label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(color: selected ? Colors.white : Colors.white70, fontWeight: selected ? FontWeight.w700 : FontWeight.w400),
        ),
        onTap: onTap,
      ),
    );
  }
}
