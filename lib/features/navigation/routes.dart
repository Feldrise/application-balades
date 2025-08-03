import 'package:balade/core/widgets/loading_overlay.dart';
import 'package:balade/features/admin/admin_home_page/admin_home_page.dart';
import 'package:balade/features/authentication/admin_login_page.dart';
import 'package:balade/features/authentication/data/models/authed_user/authed_user.dart';
import 'package:balade/features/navigation/main_page/main_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

CustomTransitionPage<dynamic> _buildPageWithDefaultTransition<T>({required BuildContext context, required GoRouterState state, required Widget child}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // return ScaleTransition(
      //   scale: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
      //   child: child,
      // );

      return FadeTransition(
        opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
        child: child,
      );
    },
  );
}

GoRouter router(AuthedUser? loggedUser) => GoRouter(
  routes: [
    ShellRoute(
      builder: (context, state, child) => MainPage(child: LoadingOverlay(child: child)),
      routes: [
        GoRoute(
          path: "/",
          pageBuilder: (context, state) => _buildPageWithDefaultTransition(context: context, state: state, child: const _HomePage()),
        ),
        GoRoute(
          path: "/balades",
          pageBuilder: (context, state) => _buildPageWithDefaultTransition(context: context, state: state, child: const _BalladesPage()),
        ),
        GoRoute(
          path: "/mes-reservations",
          pageBuilder: (context, state) => _buildPageWithDefaultTransition(context: context, state: state, child: const _ReservationsPage()),
        ),
        GoRoute(
          path: "/mon-compte",
          pageBuilder: (context, state) => _buildPageWithDefaultTransition(context: context, state: state, child: const _AccountPage()),
        ),
        GoRoute(
          path: "/admin",
          pageBuilder: (context, state) => _buildPageWithDefaultTransition(context: context, state: state, child: loggedUser == null ? AdminLoginPage() : const AdminHomePage()),
        ),
        GoRoute(
          path: "/aide",
          pageBuilder: (context, state) => _buildPageWithDefaultTransition(context: context, state: state, child: const _HelpPage()),
        ),
      ],
    ),
  ],
);

// Temporary placeholder pages - these will be replaced with actual feature pages
class _HomePage extends StatelessWidget {
  const _HomePage();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.eco, size: 64, color: theme.colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              'Bienvenue sur Balade Écologique',
              style: theme.textTheme.headlineMedium?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Découvrez la nature à travers nos balades guidées',
              style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.7)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _BalladesPage extends StatelessWidget {
  const _BalladesPage();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(child: Text("Page des Balades - À venir")),
    );
  }
}

class _ReservationsPage extends StatelessWidget {
  const _ReservationsPage();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(child: Text("Mes Réservations - À venir")),
    );
  }
}

class _AccountPage extends StatelessWidget {
  const _AccountPage();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(child: Text("Mon Compte - À venir")),
    );
  }
}

class _HelpPage extends StatelessWidget {
  const _HelpPage();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(child: Text("Aide - À venir")),
    );
  }
}
