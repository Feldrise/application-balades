import 'dart:async';
import 'dart:convert';

import 'package:balade/features/authentication/authentication_provider.dart';
import 'package:balade/features/authentication/data/models/authed_user/authed_user.dart';
import 'package:balade/features/guides/models/guide/guide.dart';
import 'package:balade/features/navigation/routes.dart';
import 'package:balade/features/ramble/models/ramble/ramble.dart';
import 'package:balade/features/reservations/providers/reservation_providers.dart';
import 'package:balade/features/reservations/reservations_service.dart';
import 'package:balade/features/users/models/user/user.dart';
import 'package:balade/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:intl/date_symbol_data_local.dart';

/// Screen sizes of the management area tests.
const phone = Size(390, 844);
const tablet = Size(800, 1100);
const desktop = Size(1440, 900);

const vera = Guide(7, firstName: 'Vera', lastName: 'Lemoine', email: 'vera@example.com', isActive: true);
const val = Guide(8, firstName: 'Val', lastName: 'Morin', email: 'val@example.com', isActive: true);

final admin = AuthedUser(
  user: const User(1, email: 'admin@example.com', roles: ['admin'], permissions: ['create:ramble', 'update:ramble', 'delete:ramble', 'view:all-registrations']),
  token: 'admin-token',
);

final guide = AuthedUser(
  user: const User(2, email: 'vera@example.com', roles: ['guide'], permissions: ['create:ramble', 'update:ramble:self', 'view:registrations:self']),
  token: 'guide-token',
);

/// A balade [inDays] days from now, at 10h00.
Ramble balade(
  int id, {
  required int inDays,
  String title = 'Sortie champignons',
  List<Guide> guides = const [vera],
  int? max = 10,
  int? placesLeft = 10,
  bool published = true,
  bool cancelled = false,
  String location = 'Paimpont',
}) {
  final today = DateTime.now();
  return Ramble(
    id,
    title: title,
    type: 'champignons',
    difficulty: 'facile',
    date: DateTime(today.year, today.month, today.day + inDays, 10),
    location: location,
    guides: guides,
    maxParticipants: max,
    placesLeft: placesLeft,
    isCancelled: cancelled,
    publishedAt: published ? DateTime.now().subtract(const Duration(days: 3)) : null,
  );
}

/// The fake API behind the management area: what it serves and the requests it received.
class FakeApi {
  FakeApi({this.rambles = const [], this.guides = const [], this.myGuide, this.unanswered = const []});

  final List<Ramble> rambles;

  /// The guides of the platform, served by the guides list.
  final List<Guide> guides;

  /// The guide profile linked to the signed-in guide, or null when the account is not linked.
  final Guide? myGuide;

  /// Requests whose path matches one of these never get an answer, e.g. to stop on a page while it loads.
  final List<Pattern> unanswered;

  final List<http.Request> requests = [];

  Future<http.Response> handle(http.Request request) async {
    requests.add(request);
    final path = request.url.path;
    if (unanswered.any((p) => p.allMatches(path).isNotEmpty)) return Completer<http.Response>().future;
    if (request.method == 'GET' && path.endsWith('/guides/me')) {
      return myGuide == null ? http.Response('{"error":"not found"}', 404) : _json(myGuide!.toJson());
    }
    if (request.method == 'PUT' && path.endsWith('/guides/me')) return _json({});
    if (request.method == 'POST' && path.endsWith('/rambles')) return http.Response('{"id":99}', 201, headers: {'content-type': 'application/json'});
    if (path.endsWith('/guides')) return _json([for (final g in guides) g.toJson()]);
    if (path.endsWith('/rambles')) return _json([for (final r in rambles) r.toJson()]);
    final rambleId = RegExp(r'/rambles/(\d+)$').firstMatch(path)?.group(1);
    final ramble = rambles.where((r) => '${r.id}' == rambleId).firstOrNull;
    if (ramble != null) return _json(ramble.toJson());
    if (path.endsWith('/reservations/admin')) return _json({'reservations': [], 'total': 0, 'page': 1, 'per_page': 50, 'total_pages': 0});
    return http.Response('{"error":"not faked: $path"}', 404);
  }

  static http.Response _json(Object body) => http.Response.bytes(utf8.encode(jsonEncode(body)), 200, headers: {'content-type': 'application/json; charset=utf-8'});
}

class _SignedIn extends AuthenticationNotifier {
  _SignedIn(AuthedUser user) {
    state = user;
  }
}

/// Runs [body] with every HTTP call of the app answered by [api].
Future<void> withFakeApi(FakeApi api, Future<void> Function() body) => http.runWithClient(body, () => MockClient(api.handle));

/// The location the router is on.
String currentLocation(WidgetTester tester) => GoRouter.of(tester.element(find.byType(Navigator).first)).routerDelegate.currentConfiguration.uri.toString();

/// Pumps the routed app on [location], signed in as [user], on a screen of [size].
/// Must run inside [withFakeApi] with the same [api]: services calling `http` directly reach it through the zone,
/// [ReservationsService] through [reservationsServiceProvider].
Future<void> pumpManagementApp(WidgetTester tester, {required FakeApi api, required String location, required AuthedUser user, required Size size}) async {
  await initializeDateFormatting('fr');
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        authenticationProvider.overrideWith((ref) => _SignedIn(user)),
        // ReservationsService.instance keeps the client of the first test that touches it: pages get the fake one through the provider
        reservationsServiceProvider.overrideWithValue(ReservationsService(client: MockClient(api.handle))),
      ],
      child: MaterialApp.router(
        theme: MaterialTheme(Typography.material2021().black).light(),
        locale: const Locale('fr'),
        supportedLocales: const [Locale('fr')],
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        routerConfig: router(user, initialLocation: location),
      ),
    ),
  );
  await tester.pumpAndSettle();
}
