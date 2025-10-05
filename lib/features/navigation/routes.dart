import 'package:balade/core/widgets/loading_overlay.dart';
import 'package:balade/features/admin/guides_management/admin_guides_page.dart';
import 'package:balade/features/admin/layout/admin_layout.dart';
import 'package:balade/features/admin/rambles_management/admin_rambles_page.dart';
import 'package:balade/features/admin/registrations_management/admin_registrations_page.dart';
import 'package:balade/features/admin/settings/admin_settings_page.dart';
import 'package:balade/features/authentication/admin_login_page.dart';
import 'package:balade/features/authentication/data/models/authed_user/authed_user.dart';
import 'package:balade/features/navigation/main_page/main_page.dart';
import 'package:balade/features/ramble/add_ramble_page/add_ramble_page.dart';
import 'package:balade/features/authentication/login_page.dart';
import 'package:balade/features/ramble/edit_ramble_page/edit_ramble_page.dart';
import 'package:balade/features/registrations/user_registrations_page.dart';
import 'package:balade/features/ramble/public_ramble_details_page/public_ramble_details_page.dart';
import 'package:balade/features/ramble/public_rambles_page/public_rambles_page.dart';
import 'package:balade/features/admin/ramble_details_page/admin_ramble_details_page.dart';
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
          pageBuilder: (context, state) => _buildPageWithDefaultTransition(context: context, state: state, child: const PublicRamblesPage()),
          routes: [
            GoRoute(
              path: "/:id",
              pageBuilder: (context, state) {
                final id = int.tryParse(state.pathParameters['id'] ?? '');
                if (id == null) {
                  return _buildPageWithDefaultTransition(
                    context: context,
                    state: state,
                    child: const Scaffold(body: Center(child: Text('ID de balade invalide'))),
                  );
                }
                return _buildPageWithDefaultTransition(
                  context: context,
                  state: state,
                  child: PublicRambleDetailsPage(rambleId: id),
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: "/mes-reservations",
          pageBuilder: (context, state) => _buildPageWithDefaultTransition(context: context, state: state, child: const UserRegistrationsPage()),
        ),
        GoRoute(
          path: "/connexion",
          pageBuilder: (context, state) => _buildPageWithDefaultTransition(context: context, state: state, child: const LoginPage()),
        ),
        GoRoute(
          path: "/mon-compte",
          pageBuilder: (context, state) => _buildPageWithDefaultTransition(context: context, state: state, child: const _AccountPage()),
        ),
        // Admin routes with nested layout
        ShellRoute(
          builder: (context, state, child) => loggedUser == null ? AdminLoginPage() : AdminLayout(child: child),
          routes: [
            GoRoute(
              path: "/admin",
              pageBuilder: (context, state) => _buildPageWithDefaultTransition(context: context, state: state, child: const AdminRamblesPage()),
              routes: [
                GoRoute(
                  path: "nouvelle-balade",
                  pageBuilder: (context, state) => _buildPageWithDefaultTransition(context: context, state: state, child: const AddRamblePage()),
                ),
                GoRoute(
                  path: "modifier-balade/:id",
                  pageBuilder: (context, state) => _buildPageWithDefaultTransition(
                    context: context,
                    state: state,
                    child: EditRamblePage(id: state.pathParameters['id'] ?? ''),
                  ),
                ),
                GoRoute(
                  path: "balade/:id",
                  pageBuilder: (context, state) {
                    final id = int.tryParse(state.pathParameters['id'] ?? '');
                    final child = id == null ? const Scaffold(body: Center(child: Text('ID de balade invalide'))) : AdminRambleDetailsPage(rambleId: id);
                    return _buildPageWithDefaultTransition(context: context, state: state, child: child);
                  },
                ),
              ],
            ),
            GoRoute(
              path: "/admin/guides",
              pageBuilder: (context, state) => _buildPageWithDefaultTransition(context: context, state: state, child: const AdminGuidesPage()),
            ),
            GoRoute(
              path: "/admin/inscriptions",
              pageBuilder: (context, state) => _buildPageWithDefaultTransition(context: context, state: state, child: const AdminRegistrationsPage()),
            ),
            GoRoute(
              path: "/admin/parametres",
              pageBuilder: (context, state) => _buildPageWithDefaultTransition(context: context, state: state, child: const AdminSettingsPage()),
            ),
          ],
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
              'Bienvenue sur Balade EcoLogique',
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

// Removed temporary Reservations placeholder; now using UserRegistrationsPage

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
