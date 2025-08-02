import 'package:flutter/material.dart';

class NavigationItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final String route;
  final bool adminOnly;

  const NavigationItem({required this.icon, required this.selectedIcon, required this.label, required this.route, this.adminOnly = false});
}

const List<NavigationItem> mainNavigationItems = [
  NavigationItem(icon: Icons.home_outlined, selectedIcon: Icons.home, label: 'Accueil', route: '/'),
  NavigationItem(icon: Icons.nature_people_outlined, selectedIcon: Icons.nature_people, label: 'Balades', route: '/balades'),
  NavigationItem(icon: Icons.calendar_today_outlined, selectedIcon: Icons.calendar_today, label: 'Mes réservations', route: '/mes-reservations'),
  NavigationItem(icon: Icons.person_outline, selectedIcon: Icons.person, label: 'Mon compte', route: '/mon-compte'),
];

const List<NavigationItem> adminNavigationItems = [
  NavigationItem(icon: Icons.admin_panel_settings_outlined, selectedIcon: Icons.admin_panel_settings, label: 'Admin', route: '/admin', adminOnly: true),
  NavigationItem(icon: Icons.help_outline, selectedIcon: Icons.help, label: 'Aide', route: '/aide'),
];
