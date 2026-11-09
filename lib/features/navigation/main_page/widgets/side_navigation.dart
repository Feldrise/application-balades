import 'package:balade/features/navigation/main_page/widgets/navigation_panel.dart';
import 'package:flutter/material.dart';

/// The public navigation on a tablet or desktop.
class SideNavigation extends StatelessWidget {
  const SideNavigation({super.key, required this.isDesktop});

  final bool isDesktop;

  @override
  Widget build(BuildContext context) => SizedBox(width: isDesktop ? 260 : 232, child: const NavigationPanel());
}
