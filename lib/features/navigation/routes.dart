import 'package:balade/core/widgets/loading_overlay.dart';
import 'package:balade/features/admin/guide_profile/guide_profile_page.dart';
import 'package:balade/features/admin/guides_management/admin_guides_page.dart';
import 'package:balade/features/admin/layout/admin_shell.dart';
import 'package:balade/features/admin/ramble_details_page/admin_ramble_details_page.dart';
import 'package:balade/features/admin/rambles_management/admin_rambles_page.dart';
import 'package:balade/features/admin/reservations_management/admin_reservations_page.dart';
import 'package:balade/features/admin/settings/admin_settings_page.dart';
import 'package:balade/features/authentication/authentication_provider.dart';
import 'package:balade/features/authentication/data/models/authed_user/authed_user.dart';
import 'package:balade/features/authentication/login_page.dart';
import 'package:balade/features/navigation/main_page/main_page.dart';
import 'package:balade/features/ramble/add_ramble_page/add_ramble_page.dart';
import 'package:balade/features/ramble/edit_ramble_page/edit_ramble_page.dart';
import 'package:balade/features/ramble/public_ramble_details_page/public_ramble_details_page.dart';
import 'package:balade/features/ramble/public_rambles_page/public_rambles_page.dart';
import 'package:balade/features/reservations/reservation_details_page.dart';
import 'package:balade/features/reservations/reservation_payment_page.dart';
import 'package:balade/features/reservations/reservations_service.dart';
import 'package:balade/features/reservations/user_reservations_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

/// The management area, opened signed out, goes through the single login screen and comes back to the page asked.
String? _loginBeforeManagementArea(BuildContext context, GoRouterState state) {
  final path = state.uri.path;
  if (path != '/admin' && !path.startsWith('/admin/')) return null;
  if (ProviderScope.containerOf(context, listen: false).read(authenticationProvider) != null) return null;
  return Uri(path: '/connexion', queryParameters: {'redirection': state.uri.toString()}).toString();
}

GoRouter router(AuthedUser? loggedUser, {String initialLocation = '/'}) => GoRouter(
  initialLocation: initialLocation,
  redirect: _loginBeforeManagementArea,
  routes: [
    ShellRoute(
      builder: (context, state, child) => MainPage(child: LoadingOverlay(child: child)),
      routes: [
        GoRoute(path: "/", redirect: (context, state) => '/balades'),
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
          pageBuilder: (context, state) => _buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: UserReservationsPage(addToReservationId: int.tryParse(state.uri.queryParameters['ajouter'] ?? '')),
          ),
          routes: [
            GoRoute(
              path: ":id",
              pageBuilder: (context, state) {
                final id = int.tryParse(state.pathParameters['id'] ?? '');
                final child = id == null ? const Scaffold(body: Center(child: Text('ID de réservation invalide'))) : ReservationDetailsPage(reservationId: id);
                return _buildPageWithDefaultTransition(context: context, state: state, child: child);
              },
              routes: [
                GoRoute(
                  path: "paiement",
                  pageBuilder: (context, state) {
                    final id = int.tryParse(state.pathParameters['id'] ?? '');
                    final payment = state.extra is PaymentToMake ? state.extra as PaymentToMake : null;
                    final child = id == null ? const Scaffold(body: Center(child: Text('ID de réservation invalide'))) : ReservationPaymentPage(reservationId: id, payment: payment);
                    return _buildPageWithDefaultTransition(context: context, state: state, child: child);
                  },
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: "/connexion",
          pageBuilder: (context, state) => _buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: LoginPage(email: state.uri.queryParameters['email'], redirection: state.uri.queryParameters['redirection']),
          ),
        ),
        GoRoute(
          path: "/mon-compte",
          pageBuilder: (context, state) => _buildPageWithDefaultTransition(context: context, state: state, child: const _AccountPage()),
        ),
        GoRoute(
          path: "/aide",
          pageBuilder: (context, state) => _buildPageWithDefaultTransition(context: context, state: state, child: const _HelpPage()),
        ),
      ],
    ),
    // Management area: its own shell, separate from the public site
    ShellRoute(
      builder: (context, state, child) => LoadingOverlay(child: AdminShell(child: child)),
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
          path: "/admin/reservations",
          pageBuilder: (context, state) => _buildPageWithDefaultTransition(context: context, state: state, child: const AdminReservationsPage()),
        ),
        GoRoute(
          path: "/admin/mon-profil",
          pageBuilder: (context, state) => _buildPageWithDefaultTransition(context: context, state: state, child: const GuideProfilePage()),
        ),
        GoRoute(
          path: "/admin/parametres",
          pageBuilder: (context, state) => _buildPageWithDefaultTransition(context: context, state: state, child: const AdminSettingsPage()),
        ),
      ],
    ),
  ],
);

// Placeholder pages, out of the navigation until they are built
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
