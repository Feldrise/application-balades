import 'package:balade/core/permission.dart';
import 'package:flutter/material.dart';

/// An entry of the management area navigation (sidebar, icon rail or bottom bar).
class ManagementDestination {
  const ManagementDestination({required this.icon, required this.selectedIcon, required this.label, required this.route});

  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final String route;
}

const _balades = ManagementDestination(icon: Icons.landscape_outlined, selectedIcon: Icons.landscape, label: 'Balades', route: '/admin');
const _reservations = ManagementDestination(icon: Icons.receipt_long_outlined, selectedIcon: Icons.receipt_long, label: 'Réservations', route: '/admin/reservations');
const _guides = ManagementDestination(icon: Icons.groups_outlined, selectedIcon: Icons.groups, label: 'Guides', route: '/admin/guides');
const _myProfile = ManagementDestination(icon: Icons.account_circle_outlined, selectedIcon: Icons.account_circle, label: 'Mon profil', route: '/admin/mon-profil');

/// The entries the signed-in account sees: Guides for an admin, Mon profil for a guide.
List<ManagementDestination> managementDestinations(Permission? permission) {
  if (permission == null) return const [];
  return [_balades, _reservations, if (permission.isAdmin()) _guides, if (permission.isGuide()) _myProfile];
}

/// Index in [destinations] of the entry [path] belongs to; balade pages belong to Balades.
int selectedDestination(List<ManagementDestination> destinations, String path) {
  for (var i = 0; i < destinations.length; i++) {
    if (destinations[i].route != '/admin' && path.startsWith(destinations[i].route)) return i;
  }
  return destinations.indexWhere((d) => d.route == '/admin');
}

bool isAdminOnlyRoute(String path) {
  return path.startsWith('/admin/guides') || path.startsWith('/admin/parametres');
}
