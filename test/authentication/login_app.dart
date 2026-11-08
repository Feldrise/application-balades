import 'dart:convert';

import 'package:balade/features/authentication/authentication_provider.dart';
import 'package:balade/features/navigation/routes.dart';
import 'package:balade/features/reservations/providers/reservation_providers.dart';
import 'package:balade/features/reservations/reservations_service.dart';
import 'package:balade/features/users/models/user/user.dart';
import 'package:balade/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../management/management_app.dart';

export '../management/management_app.dart' show withFakeApi, currentLocation, ignoringCatalogueOverflows, phone, desktop;

/// The code the fake API accepts.
const goodCode = '123456';

const booker = User(3, email: 'claire@example.com', roles: ['user']);
final adminUser = admin.user;
final guideUser = guide.user;

/// The fake API behind the login: the accounts it knows, and the management area and catalogue behind it.
class LoginApi extends FakeApi {
  LoginApi({List<User> accounts = const [], super.rambles}) : accounts = {for (final a in accounts) a.email: a};

  final Map<String, User> accounts;

  /// When set, the code is refused with this reason (e.g. `authentication code expired`).
  String? codeRefusal;

  /// Bodies of the code requests received.
  final List<Map<String, Object?>> codeRequests = [];

  @override
  Future<http.Response> handle(http.Request request) async {
    final path = request.url.path;
    if (path.endsWith('/authentication/check-email')) {
      requests.add(request);
      final known = accounts.containsKey(request.url.queryParameters['email']);
      return known ? http.Response('{"error":"email already exists"}', 401) : http.Response('"not exists"', 200);
    }
    if (path.endsWith('/authentication/authenticate')) {
      requests.add(request);
      final body = jsonDecode(request.body) as Map<String, Object?>;
      codeRequests.add(body);
      final email = body['email'] as String;
      if (!accounts.containsKey(email)) {
        final firstName = body['first_name'] as String?;
        if (firstName == null || firstName.isEmpty) return http.Response('{"error":"bad request"}', 400);
        accounts[email] = User(99, email: email, roles: const ['user']);
      }
      return http.Response('"success"', 200);
    }
    if (path.endsWith('/authentication/verify-authentication')) {
      requests.add(request);
      final body = jsonDecode(request.body) as Map<String, Object?>;
      if (codeRefusal != null) return http.Response(jsonEncode({'error': codeRefusal}), 401);
      if (body['code'] != goodCode) return http.Response('{"error":"invalid authentication code"}', 401);
      final user = accounts[body['email']]!;
      return http.Response(jsonEncode({'user': user.toJson(), 'token': 'token-${user.id}'}), 200);
    }
    if (request.method == 'GET' && path.endsWith('/reservations')) {
      requests.add(request);
      return http.Response('[]', 200, headers: {'content-type': 'application/json'});
    }
    return super.handle(request);
  }
}

/// Pumps the routed app on [location], signed out, on a screen of [size].
/// Must run inside [withFakeApi] with the same [api].
Future<void> pumpSignedOutApp(WidgetTester tester, {required LoginApi api, required String location, Size size = phone}) async {
  await initializeDateFormatting('fr');
  SharedPreferences.setMockInitialValues({});
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        authenticationProvider.overrideWith((ref) => AuthenticationNotifier()),
        reservationsServiceProvider.overrideWithValue(ReservationsService(client: MockClient(api.handle))),
      ],
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

/// Types [email] on the login screen and asks for the code.
Future<void> enterEmail(WidgetTester tester, String email) async {
  await tester.enterText(find.widgetWithText(TextFormField, 'Adresse email'), email);
  await tester.tap(find.widgetWithText(FilledButton, 'Recevoir le code'));
  await tester.pumpAndSettle();
}

/// Types [code] on the code step and logs in.
Future<void> enterCode(WidgetTester tester, String code) async {
  await tester.enterText(find.widgetWithText(TextFormField, 'Code à 6 chiffres'), code);
  await tester.tap(find.descendant(of: find.byType(Form), matching: find.widgetWithText(FilledButton, 'Se connecter')));
  await tester.pumpAndSettle();
}
