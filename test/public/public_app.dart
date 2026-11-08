import 'package:balade/features/navigation/routes.dart';
import 'package:balade/features/reservations/providers/reservation_providers.dart';
import 'package:balade/features/reservations/reservations_service.dart';
import 'package:balade/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../management/management_app.dart';

/// Pumps the routed app on [location] as a visitor (not signed in), on a screen of [size].
/// Must run inside [withFakeApi] with the same [api].
Future<void> pumpPublicApp(WidgetTester tester, {required FakeApi api, required String location, required Size size}) async {
  await initializeDateFormatting('fr');
  SharedPreferences.setMockInitialValues({});
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [reservationsServiceProvider.overrideWithValue(ReservationsService(client: MockClient(api.handle)))],
      child: MaterialApp.router(
        theme: MaterialTheme(Typography.material2021().black).light(),
        locale: const Locale('fr'),
        supportedLocales: const [Locale('fr')],
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        routerConfig: router(null, initialLocation: location),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

/// Fails when a layout overflowed since the last call. Other framework complaints raised by the shell
/// (the navigation drawer's ListTile, outside the catalogue) are drained and ignored.
void expectNoOverflow(WidgetTester tester) {
  final overflows = <String>[];
  for (Object? error = tester.takeException(); error != null; error = tester.takeException()) {
    if ('$error'.contains('overflowed')) overflows.add('$error'.split('\n').take(6).join(' / '));
  }
  expect(overflows, isEmpty);
}
