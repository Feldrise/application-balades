import 'package:balade/core/permission.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Navigation item for admin sidebar
class AdminNavigationItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final String route;
  final String? description;
  final bool adminOnly;
  final bool guideOnly;

  const AdminNavigationItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.route,
    this.description,
    this.adminOnly = false,
    this.guideOnly = false,
  });
}

/// Admin navigation items configuration
const List<AdminNavigationItem> adminNavigationItems = [
  AdminNavigationItem(
    icon: Icons.nature_people_outlined,
    selectedIcon: Icons.nature_people,
    label: 'Balades',
    route: '/admin',
    description: 'Gestion des créneaux de balades',
  ),
  AdminNavigationItem(
    icon: Icons.people_outline,
    selectedIcon: Icons.people,
    label: 'Guides',
    route: '/admin/guides',
    description: 'Gestion des guides naturalistes',
    adminOnly: true,
  ),
  AdminNavigationItem(
    icon: Icons.how_to_reg_outlined,
    selectedIcon: Icons.how_to_reg,
    label: 'Réservations',
    route: '/admin/reservations',
    description: 'Gestion des réservations',
  ),
  AdminNavigationItem(
    icon: Icons.person_outline,
    selectedIcon: Icons.person,
    label: 'Mon profil',
    route: '/admin/mon-profil',
    description: 'Votre profil guide',
    guideOnly: true,
  ),
  AdminNavigationItem(
    icon: Icons.settings_outlined,
    selectedIcon: Icons.settings,
    label: 'Paramètres',
    route: '/admin/parametres',
    description: 'Configuration du système',
    adminOnly: true,
  ),
];

List<AdminNavigationItem> visibleAdminNavigationItems(Permission? permission) {
  if (permission == null) return [];

  return adminNavigationItems.where((item) {
    if (item.adminOnly && !permission.isAdmin()) return false;
    if (item.guideOnly && !permission.isGuide()) return false;
    return true;
  }).toList();
}

bool isAdminOnlyRoute(String path) {
  return path.startsWith('/admin/guides') || path.startsWith('/admin/parametres');
}

/// Admin navigation state
class AdminNavigationState {
  final String currentRoute;
  final bool isSidebarExpanded;

  const AdminNavigationState({required this.currentRoute, this.isSidebarExpanded = true});

  AdminNavigationState copyWith({String? currentRoute, bool? isSidebarExpanded}) {
    return AdminNavigationState(currentRoute: currentRoute ?? this.currentRoute, isSidebarExpanded: isSidebarExpanded ?? this.isSidebarExpanded);
  }
}

/// Admin navigation state notifier
class AdminNavigationNotifier extends StateNotifier<AdminNavigationState> {
  AdminNavigationNotifier() : super(const AdminNavigationState(currentRoute: '/admin'));

  void updateCurrentRoute(String route) {
    state = state.copyWith(currentRoute: route);
  }

  void toggleSidebar() {
    state = state.copyWith(isSidebarExpanded: !state.isSidebarExpanded);
  }

  void setSidebarExpanded(bool expanded) {
    state = state.copyWith(isSidebarExpanded: expanded);
  }

  AdminNavigationItem? getCurrentNavigationItem(Permission? permission) {
    final items = visibleAdminNavigationItems(permission);
    for (final item in items.reversed) {
      if (state.currentRoute.startsWith(item.route)) {
        if (item.route == '/admin') {
          final isSubRoute = state.currentRoute.startsWith('/admin/nouvelle-balade') ||
              state.currentRoute.startsWith('/admin/modifier-balade') ||
              state.currentRoute.startsWith('/admin/balade/');
          if (state.currentRoute == '/admin' || isSubRoute) return item;
        } else {
          return item;
        }
      }
    }
    if (state.currentRoute == '/admin' || state.currentRoute.startsWith('/admin/nouvelle-balade') || state.currentRoute.startsWith('/admin/modifier-balade') || state.currentRoute.startsWith('/admin/balade/')) {
      return items.where((i) => i.route == '/admin').firstOrNull;
    }
    return null;
  }
}

/// Admin navigation provider
final adminNavigationProvider = StateNotifierProvider<AdminNavigationNotifier, AdminNavigationState>((ref) {
  return AdminNavigationNotifier();
});
