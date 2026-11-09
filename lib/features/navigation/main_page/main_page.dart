import 'package:balade/features/admin/design/management_theme.dart';
import 'package:balade/features/navigation/main_page/widgets/appbar.dart';
import 'package:balade/features/navigation/main_page/widgets/navigation_drawer.dart';
import 'package:balade/features/navigation/main_page/widgets/side_navigation.dart';
import 'package:balade/themes/screen_helper.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.child});

  final Widget child;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= ScreenHelper.breakpointPC;
    final isTablet = MediaQuery.of(context).size.width >= ScreenHelper.breakpointTablet && MediaQuery.of(context).size.width < ScreenHelper.breakpointPC;

    return Scaffold(
      key: _scaffoldKey,
      appBar: BeAppbar(title: 'Balade EcoLogique', subtitle: 'Découvrez la nature'),
      drawer: isDesktop ? null : const MainNavigationDrawer(),
      body: Row(
        children: [
          if (isDesktop || isTablet) SideNavigation(isDesktop: isDesktop),
          Expanded(
            child: ColoredBox(color: ManagementColors.background, child: widget.child),
          ),
        ],
      ),
    );
  }
}
