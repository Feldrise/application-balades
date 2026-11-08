import 'package:balade/features/authentication/authentication_provider.dart';
import 'package:balade/features/navigation/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// The routed application, once the authentication is restored: the same in the app and in the tests.
///
/// It keeps a single router for its whole life: logging in or out only re-runs the redirections, so the
/// page on screen (e.g. the login finishing its landing) is never thrown away by a new router.
class RoutedApp extends ConsumerStatefulWidget {
  const RoutedApp({super.key, required this.theme, this.locale, this.initialLocation = '/'});

  final ThemeData theme;
  final Locale? locale;

  /// Where the app opens.
  final String initialLocation;

  @override
  ConsumerState<RoutedApp> createState() => _RoutedAppState();
}

class _RoutedAppState extends ConsumerState<RoutedApp> {
  /// The signed-in user, followed for the router to re-run its redirections on each login and logout.
  late final _authenticationChanges = ValueNotifier(ref.read(authenticationProvider));
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = router(ref.read(authenticationProvider), initialLocation: widget.initialLocation, refreshListenable: _authenticationChanges);
  }

  @override
  void dispose() {
    _router.dispose();
    _authenticationChanges.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authenticationProvider, (previous, next) => _authenticationChanges.value = next);
    return MaterialApp.router(
      title: 'Balade',
      theme: widget.theme,
      locale: widget.locale,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [Locale('fr', '')],
      routerConfig: _router,
    );
  }
}
