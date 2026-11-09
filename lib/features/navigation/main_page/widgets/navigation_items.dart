import 'package:balade/core/permission.dart';
import 'package:flutter/material.dart';

class NavigationItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final String route;

  const NavigationItem({required this.icon, required this.selectedIcon, required this.label, required this.route});
}

/// The pages of the public navigation: only pages that exist (no « À venir » page), plus the management area
/// for admins and guides.
List<NavigationItem> publicNavigationItems(Permission? permission) => [
  const NavigationItem(icon: Icons.nature_people_outlined, selectedIcon: Icons.nature_people, label: 'Balades', route: '/balades'),
  const NavigationItem(icon: Icons.calendar_today_outlined, selectedIcon: Icons.calendar_today, label: 'Mes réservations', route: '/mes-reservations'),
  if (permission != null && permission.canAccessAdminArea())
    permission.isAdmin()
        ? const NavigationItem(icon: Icons.admin_panel_settings_outlined, selectedIcon: Icons.admin_panel_settings, label: 'Administration', route: '/admin')
        : const NavigationItem(icon: Icons.hiking_outlined, selectedIcon: Icons.hiking, label: 'Espace guide', route: '/admin'),
];

/// Whether [item] is the section of [path], e.g. a balade page belongs to « Balades ».
bool isInSection(NavigationItem item, String path) => path == item.route || path.startsWith('${item.route}/');
