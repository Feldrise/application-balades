import 'package:balade/features/admin/layout/admin_navigation_provider.dart';
import 'package:balade/features/admin/layout/admin_sidebar.dart';
import 'package:balade/themes/screen_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AdminLayout extends ConsumerStatefulWidget {
  final Widget child;

  const AdminLayout({super.key, required this.child});

  @override
  ConsumerState<AdminLayout> createState() => _AdminLayoutState();
}

class _AdminLayoutState extends ConsumerState<AdminLayout> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Update current route when the route changes
    final currentRoute = GoRouterState.of(context).uri.path;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(adminNavigationProvider.notifier).updateCurrentRoute(currentRoute);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= ScreenHelper.breakpointPC;
    final isTablet = screenWidth >= ScreenHelper.breakpointTablet && screenWidth < ScreenHelper.breakpointPC;
    final isMobile = screenWidth < ScreenHelper.breakpointTablet;

    final navigationState = ref.watch(adminNavigationProvider);
    final currentItem = ref.read(adminNavigationProvider.notifier).getCurrentNavigationItem();

    if (isMobile) {
      return _buildMobileLayout(theme, currentItem);
    } else if (isTablet) {
      return _buildTabletLayout(theme, currentItem);
    } else {
      return _buildDesktopLayout(theme, currentItem, navigationState, isDesktop);
    }
  }

  Widget _buildDesktopLayout(ThemeData theme, AdminNavigationItem? currentItem, AdminNavigationState navigationState, bool isDesktop) {
    return Scaffold(
      body: Row(
        children: [
          AdminSidebar(isDesktop: isDesktop),
          Expanded(
            child: Column(
              children: [
                _buildTopBar(theme, currentItem, showMenuButton: false),
                Expanded(child: widget.child),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(ThemeData theme, AdminNavigationItem? currentItem) {
    return Scaffold(
      appBar: _buildAppBar(theme, currentItem, showMenuButton: true),
      drawer: Drawer(child: AdminSidebar(isDesktop: false)),
      body: widget.child,
    );
  }

  Widget _buildMobileLayout(ThemeData theme, AdminNavigationItem? currentItem) {
    return Scaffold(
      appBar: _buildAppBar(theme, currentItem, showMenuButton: true),
      drawer: Drawer(child: AdminSidebar(isDesktop: false)),
      body: widget.child,
    );
  }

  PreferredSizeWidget _buildAppBar(ThemeData theme, AdminNavigationItem? currentItem, {required bool showMenuButton}) {
    return AppBar(
      elevation: 0,
      backgroundColor: theme.colorScheme.surface,
      foregroundColor: theme.colorScheme.onSurface,
      leading: showMenuButton ? null : const SizedBox.shrink(),
      title: Row(
        children: [
          if (currentItem != null) ...[
            Icon(currentItem.selectedIcon, size: 24, color: theme.colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentItem.label,
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
                  ),
                  if (currentItem.description != null) Text(currentItem.description!, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                ],
              ),
            ),
          ],
        ],
      ),
      actions: [
        IconButton(onPressed: () => context.go('/'), icon: const Icon(Icons.public), tooltip: 'Voir le site public'),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildTopBar(ThemeData theme, AdminNavigationItem? currentItem, {required bool showMenuButton}) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(bottom: BorderSide(color: theme.colorScheme.outline.withOpacity(0.2), width: 1)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          children: [
            if (showMenuButton) ...[
              IconButton(
                onPressed: () {
                  ref.read(adminNavigationProvider.notifier).toggleSidebar();
                },
                icon: const Icon(Icons.menu),
                tooltip: 'Toggle sidebar',
              ),
              const SizedBox(width: 16),
            ],
            if (currentItem != null) ...[
              Icon(currentItem.selectedIcon, size: 24, color: theme.colorScheme.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      currentItem.label,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
                    ),
                    if (currentItem.description != null) Text(currentItem.description!, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                  ],
                ),
              ),
            ],
            const Spacer(),
            IconButton(onPressed: () => context.go('/'), icon: const Icon(Icons.public), tooltip: 'Voir le site public'),
          ],
        ),
      ),
    );
  }
}
