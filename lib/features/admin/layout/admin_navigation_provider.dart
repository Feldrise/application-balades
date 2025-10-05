import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

/// Navigation item for admin sidebar
class AdminNavigationItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final String route;
  final String? description;

  const AdminNavigationItem({required this.icon, required this.selectedIcon, required this.label, required this.route, this.description});
}

/// Admin navigation items configuration
const List<AdminNavigationItem> adminNavigationItems = [
  AdminNavigationItem(icon: Icons.nature_people_outlined, selectedIcon: Icons.nature_people, label: 'Balades', route: '/admin', description: 'Gestion des créneaux de balades'),
  AdminNavigationItem(icon: Icons.people_outline, selectedIcon: Icons.people, label: 'Guides', route: '/admin/guides', description: 'Gestion des guides naturalistes'),
  AdminNavigationItem(
    icon: Icons.how_to_reg_outlined,
    selectedIcon: Icons.how_to_reg,
    label: 'Inscriptions',
    route: '/admin/inscriptions',
    description: 'Gestion des réservations',
  ),
  AdminNavigationItem(icon: Icons.settings_outlined, selectedIcon: Icons.settings, label: 'Paramètres', route: '/admin/parametres', description: 'Configuration du système'),
];

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

  AdminNavigationItem? getCurrentNavigationItem() {
    return adminNavigationItems.where((item) => state.currentRoute.startsWith(item.route)).firstOrNull;
  }
}

/// Admin navigation provider
final adminNavigationProvider = StateNotifierProvider<AdminNavigationNotifier, AdminNavigationState>((ref) {
  return AdminNavigationNotifier();
});
