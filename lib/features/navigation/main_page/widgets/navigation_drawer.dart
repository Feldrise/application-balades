import 'package:balade/features/admin/design/management_theme.dart';
import 'package:balade/features/navigation/main_page/widgets/navigation_panel.dart';
import 'package:flutter/material.dart';

/// The public navigation on a phone.
class MainNavigationDrawer extends StatelessWidget {
  const MainNavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: ManagementColors.deepGreen,
      child: NavigationPanel(onNavigated: () => Navigator.pop(context)),
    );
  }
}
