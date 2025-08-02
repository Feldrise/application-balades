import 'package:balade/features/navigation/main_page/widgets/appbar.dart';
import 'package:balade/features/navigation/main_page/widgets/navigation_drawer.dart';
import 'package:balade/features/navigation/main_page/widgets/side_navigation.dart';
import 'package:balade/themes/screen_helper.dart';
import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

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
    final theme = Theme.of(context);
    final isDesktop = MediaQuery.of(context).size.width >= ScreenHelper.breakpointPC;
    final isTablet = MediaQuery.of(context).size.width >= ScreenHelper.breakpointTablet && MediaQuery.of(context).size.width < ScreenHelper.breakpointPC;

    return Scaffold(
      key: _scaffoldKey,
      appBar: BeAppbar(title: 'Balade Écologique', subtitle: 'Découvrez la nature'),
      drawer: isDesktop ? null : MainNavigationDrawer(scaffoldKey: _scaffoldKey),
      body: Row(
        children: [
          if (isDesktop || isTablet) SideNavigation(isDesktop: isDesktop),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [theme.colorScheme.surface, theme.colorScheme.surface.withAlpha(25)]),
              ),
              child: widget.child,
            ),
          ),
        ],
      ),
    );
  }
}
