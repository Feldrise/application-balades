import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../management/management_app.dart' show balade;
import 'login_app.dart';

Future<void> _logIn(WidgetTester tester, String email) async {
  await enterEmail(tester, email);
  await enterCode(tester, goodCode);
}

void main() {
  group('landing after login', () {
    testWidgets('an admin lands on the management area', (tester) async {
      final api = LoginApi(accounts: [adminUser]);
      await withFakeApi(api, () async {
        await pumpSignedOutApp(tester, api: api, location: '/connexion');
        await _logIn(tester, 'admin@example.com');
        expect(currentLocation(tester), '/admin');
      });
    });

    testWidgets('a guide lands on the management area', (tester) async {
      final api = LoginApi(accounts: [guideUser]);
      await withFakeApi(api, () async {
        await pumpSignedOutApp(tester, api: api, location: '/connexion');
        await _logIn(tester, 'vera@example.com');
        expect(currentLocation(tester), '/admin');
      });
    });

    testWidgets('a booker lands on Mes réservations', (tester) async {
      final api = LoginApi(accounts: [booker]);
      await withFakeApi(api, () async {
        await pumpSignedOutApp(tester, api: api, location: '/connexion');
        await _logIn(tester, 'claire@example.com');
        expect(currentLocation(tester), '/mes-reservations');
      });
    });

    testWidgets('an explicit redirection wins over the landing of the role', (tester) async {
      final api = LoginApi(accounts: [adminUser]);
      await withFakeApi(api, () async {
        await pumpSignedOutApp(tester, api: api, location: '/connexion?redirection=%2Fmes-reservations%3Fajouter%3D12');
        await _logIn(tester, 'admin@example.com');
        expect(currentLocation(tester), '/mes-reservations?ajouter=12');
      });
    });
  });

  testWidgets('opening the management area signed out goes through the single login and back to the page asked', (tester) async {
    final api = LoginApi(accounts: [adminUser]);
    await withFakeApi(api, () async {
      await pumpSignedOutApp(tester, api: api, location: '/admin/guides');

      expect(currentLocation(tester), '/connexion?redirection=%2Fadmin%2Fguides');
      expect(find.text('Administration'), findsNothing);
      expect(find.widgetWithText(TextFormField, 'Adresse email'), findsOneWidget);

      await _logIn(tester, 'admin@example.com');
      expect(currentLocation(tester), '/admin/guides');
    });
  });

  testWidgets('the root opens the balades catalogue', (tester) async {
    final api = LoginApi(rambles: [balade(1, inDays: 10)]);
    await withFakeApi(api, () async {
      await ignoringCatalogueOverflows(() => pumpSignedOutApp(tester, api: api, location: '/', size: desktop));
      expect(currentLocation(tester), '/balades');
    });
  });

  for (final size in [phone, desktop]) {
    testWidgets('the navigation only lists pages that exist, account and logout included (${size.width.toInt()} px)', (tester) async {
      final api = LoginApi(accounts: [booker]);
      await withFakeApi(api, () async {
        await pumpSignedOutApp(tester, api: api, location: '/connexion', size: size);
        await _logIn(tester, 'claire@example.com');

        if (size == phone) {
          await tester.tap(find.byIcon(Icons.menu));
          await tester.pumpAndSettle();
        }

        expect(find.text('Balades'), findsOneWidget);
        expect(find.text('Mes réservations'), findsWidgets);
        for (final empty in ['Accueil', 'Mon compte', 'Aide']) {
          expect(find.text(empty), findsNothing, reason: '$empty is an empty page');
        }
        expect(find.text('Administration'), findsNothing);
        expect(find.text('claire@example.com'), findsWidgets);

        await ignoringCatalogueOverflows(() async {
          await tester.tap(find.text('Déconnexion'));
          await tester.pumpAndSettle();
        });
        if (size == phone) {
          await tester.tap(find.byIcon(Icons.menu));
          await tester.pumpAndSettle();
        }
        expect(find.text('Se connecter'), findsOneWidget);
        expect(find.text('Déconnexion'), findsNothing);
      });
    });
  }

  testWidgets('a guide finds the management area in the navigation', (tester) async {
    final api = LoginApi(accounts: [guideUser], rambles: [balade(1, inDays: 10)]);
    await withFakeApi(api, () async {
      await pumpSignedOutApp(tester, api: api, location: '/connexion?redirection=%2Fbalades', size: desktop);
      await ignoringCatalogueOverflows(() => _logIn(tester, 'vera@example.com'));

      expect(currentLocation(tester), '/balades');
      expect(find.text('Espace guide'), findsOneWidget);
    });
  });
}
