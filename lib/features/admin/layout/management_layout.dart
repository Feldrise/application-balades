import 'package:balade/core/widgets/app_logo.dart';
import 'package:balade/features/admin/design/management_theme.dart';
import 'package:balade/features/admin/layout/management_navigation.dart';
import 'package:balade/features/authentication/permission_provider.dart';
import 'package:balade/features/guides/providers/current_guide_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// The shell of the management area, separate from the public site: a deep green bottom bar on a phone,
/// an icon rail on a tablet and a full sidebar on desktop. It has no header bar: each page brings its own
/// [ManagementPageHeader].
class ManagementLayout extends ConsumerWidget {
  const ManagementLayout({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final permission = ref.watch(permissionProvider);
    final destinations = managementDestinations(permission);
    final selected = selectedDestination(destinations, GoRouterState.of(context).uri.path);
    final guideStatus = ref.watch(currentGuideProvider.select((s) => s.status));
    final showUnlinkedBanner = permission?.isGuide() == true && guideStatus == CurrentGuideStatus.unlinked;
    void go(int index) => context.go(destinations[index].route);

    final content = Column(
      children: [
        if (showUnlinkedBanner) const _UnlinkedBanner(),
        Expanded(child: child),
      ],
    );

    return Theme(
      data: managementTheme(Theme.of(context)),
      child: Builder(
        builder: (context) {
          if (ManagementBreakpoints.isPhone(context)) {
            return Scaffold(
              body: content,
              bottomNavigationBar: _BottomBar(destinations: destinations, selected: selected, onSelected: go),
            );
          }
          return Scaffold(
            body: Row(
              children: [
                _Sidebar(destinations: destinations, selected: selected, onSelected: go, extended: ManagementBreakpoints.isDesktop(context)),
                Expanded(child: content),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _UnlinkedBanner extends StatelessWidget {
  const _UnlinkedBanner();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return MaterialBanner(
      content: const Text('Votre compte n\'est pas encore lié à un profil guide. Contactez un administrateur.'),
      leading: Icon(Icons.warning_amber, color: scheme.error),
      backgroundColor: scheme.errorContainer,
      actions: const [SizedBox.shrink()],
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.destinations, required this.selected, required this.onSelected});

  final List<ManagementDestination> destinations;
  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final label = Theme.of(context).textTheme.labelMedium;
    return NavigationBar(
      backgroundColor: ManagementColors.deepGreen,
      indicatorColor: Colors.white.withValues(alpha: 0.16),
      selectedIndex: selected,
      height: 64,
      onDestinationSelected: onSelected,
      labelTextStyle: WidgetStatePropertyAll(label?.copyWith(color: Colors.white)),
      destinations: [
        for (final d in destinations)
          NavigationDestination(
            icon: Icon(d.icon, color: Colors.white70),
            selectedIcon: Icon(d.selectedIcon, color: Colors.white),
            label: d.label,
          ),
      ],
    );
  }
}

/// The deep green sidebar: icons only on a tablet, icons and labels on desktop.
class _Sidebar extends StatelessWidget {
  const _Sidebar({required this.destinations, required this.selected, required this.onSelected, required this.extended});

  final List<ManagementDestination> destinations;
  final int selected;
  final ValueChanged<int> onSelected;
  final bool extended;

  @override
  Widget build(BuildContext context) {
    final label = Theme.of(context).textTheme.labelLarge;
    return NavigationRail(
      extended: extended,
      minWidth: 80,
      minExtendedWidth: 232,
      backgroundColor: ManagementColors.deepGreen,
      indicatorColor: Colors.white.withValues(alpha: 0.16),
      selectedIndex: selected,
      onDestinationSelected: onSelected,
      labelType: NavigationRailLabelType.none,
      selectedLabelTextStyle: label?.copyWith(color: Colors.white),
      unselectedLabelTextStyle: label?.copyWith(color: Colors.white70, fontWeight: FontWeight.w400),
      leading: Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 20),
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: const AppLogo(height: 30, width: 42),
        ),
      ),
      trailing: Expanded(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: extended
                ? TextButton.icon(
                    style: TextButton.styleFrom(foregroundColor: Colors.white70),
                    onPressed: () => context.go('/'),
                    icon: const Icon(Icons.public),
                    label: const Text('Voir le site public'),
                  )
                : IconButton(
                    tooltip: 'Voir le site public',
                    onPressed: () => context.go('/'),
                    icon: const Icon(Icons.public, color: Colors.white70),
                  ),
          ),
        ),
      ),
      destinations: [
        for (final d in destinations)
          NavigationRailDestination(
            icon: Icon(d.icon, color: Colors.white70),
            selectedIcon: Icon(d.selectedIcon, color: Colors.white),
            label: Text(d.label),
          ),
      ],
    );
  }
}
