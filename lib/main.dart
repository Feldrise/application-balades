import 'package:balade/core/widgets/splash_screen.dart';
import 'package:balade/features/authentication/authentication_provider.dart';
import 'package:balade/features/authentication/data/models/authed_user/authed_user.dart';
import 'package:balade/features/navigation/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:intl/intl_standalone.dart';
import 'util.dart';
import 'themes/theme.dart';

Future<void> main() async {
  usePathUrlStrategy();

  WidgetsFlutterBinding.ensureInitialized();

  await findSystemLocale();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final brightness = View.of(context).platformDispatcher.platformBrightness;
    final brightness = Brightness.light;

    // Retrieves the default theme for the platform
    //TextTheme textTheme = Theme.of(context).textTheme;

    // Use with Google Fonts package to use downloadable fonts
    TextTheme textTheme = createTextTheme(context, "Lora", "Lato");

    MaterialTheme theme = MaterialTheme(textTheme);

    return FutureBuilder(
      future: ref.read(authenticationProvider.notifier).init(shouldFakeDelay: false),

      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        }

        return Builder(
          builder: (context) {
            final AuthedUser? authedUser = ref.watch(authenticationProvider);

            return MaterialApp.router(
              title: 'Balade',
              theme: brightness == Brightness.light ? theme.light() : theme.dark(),
              debugShowCheckedModeBanner: false,
              localizationsDelegates: GlobalMaterialLocalizations.delegates,
              supportedLocales: const [
                Locale('fr', ''), // French
              ],
              routerConfig: router(authedUser),
            );
          },
        );
      },
    );
  }
}
