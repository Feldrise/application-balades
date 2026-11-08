import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_test/flutter_test.dart';

import 'login_app.dart';

void main() {
  testWidgets('a known email goes straight to the code, without asking for a name', (tester) async {
    final api = LoginApi(accounts: [booker]);
    await withFakeApi(api, () async {
      await pumpSignedOutApp(tester, api: api, location: '/connexion');

      expect(find.text('Vérifier l\'email'), findsNothing);
      await enterEmail(tester, 'claire@example.com');

      expect(api.codeRequests, [
        {'email': 'claire@example.com'},
      ]);
      expect(find.widgetWithText(TextFormField, 'Code à 6 chiffres'), findsOneWidget);
      expect(find.textContaining('claire@example.com'), findsWidgets);
      expect(find.text('Nouveau compte'), findsNothing);
      expect(find.widgetWithText(TextFormField, 'Prénom'), findsNothing);
    });
  });

  testWidgets('an unknown email asks for the new account, first name required, before sending the code', (tester) async {
    final api = LoginApi();
    await withFakeApi(api, () async {
      await pumpSignedOutApp(tester, api: api, location: '/connexion');

      await enterEmail(tester, 'leo@example.com');

      expect(find.text('Nouveau compte'), findsOneWidget);
      expect(api.codeRequests, isEmpty);
      expect(find.widgetWithText(TextFormField, 'Code à 6 chiffres'), findsNothing);

      await tester.tap(find.widgetWithText(FilledButton, 'Créer le compte et recevoir le code'));
      await tester.pumpAndSettle();
      expect(find.text('Le prénom est requis'), findsOneWidget);
      expect(api.codeRequests, isEmpty);

      await tester.enterText(find.widgetWithText(TextFormField, 'Prénom'), 'Léo');
      await tester.enterText(find.widgetWithText(TextFormField, 'Téléphone (facultatif)'), '0612345678');
      await tester.tap(find.widgetWithText(FilledButton, 'Créer le compte et recevoir le code'));
      await tester.pumpAndSettle();

      expect(api.codeRequests, [
        {'email': 'leo@example.com', 'first_name': 'Léo', 'phone': '0612345678'},
      ]);
      expect(find.widgetWithText(TextFormField, 'Code à 6 chiffres'), findsOneWidget);

      await enterCode(tester, goodCode);
      expect(currentLocation(tester), '/mes-reservations');
    });
  });

  testWidgets('shows when the code expires and sends a new one on demand', (tester) async {
    final api = LoginApi(accounts: [booker]);
    await withFakeApi(api, () async {
      await pumpSignedOutApp(tester, api: api, location: '/connexion');
      await enterEmail(tester, 'claire@example.com');

      expect(find.textContaining('Le code expire à'), findsOneWidget);

      await tester.tap(find.widgetWithText(TextButton, 'Renvoyer le code'));
      await tester.pumpAndSettle();
      expect(api.codeRequests, hasLength(2));
      expect(find.widgetWithText(TextFormField, 'Code à 6 chiffres'), findsOneWidget);
    });
  });

  testWidgets('a wrong code says so and lets the visitor try again', (tester) async {
    final api = LoginApi(accounts: [booker]);
    await withFakeApi(api, () async {
      await pumpSignedOutApp(tester, api: api, location: '/connexion');
      await enterEmail(tester, 'claire@example.com');

      await enterCode(tester, '000000');

      expect(find.textContaining('Ce code est incorrect'), findsOneWidget);
      expect(currentLocation(tester), '/connexion');

      await enterCode(tester, goodCode);
      expect(currentLocation(tester), '/mes-reservations');
    });
  });

  testWidgets('an expired code says so and points to a new code', (tester) async {
    final api = LoginApi(accounts: [booker])..codeRefusal = 'authentication code expired';
    await withFakeApi(api, () async {
      await pumpSignedOutApp(tester, api: api, location: '/connexion');
      await enterEmail(tester, 'claire@example.com');

      await enterCode(tester, goodCode);

      expect(find.textContaining('Ce code a expiré'), findsOneWidget);
      expect(currentLocation(tester), '/connexion');
    });
  });

  group('leaving the login while a request is pending does not break the app', () {
    /// Holds the login requests, taps [button], leaves for the catalogue, then lets the API answer.
    Future<void> leaveThenAnswer(WidgetTester tester, LoginApi api, Finder button) async {
      final hold = api.hold = Completer<void>();
      await tester.tap(button);
      await tester.pump();
      GoRouter.of(tester.element(find.byType(Form))).go('/balades');
      await tester.pumpAndSettle();
      hold.complete();
      await tester.pumpAndSettle();
      expect(currentLocation(tester), '/balades');
    }

    testWidgets('on the email check of a new account', (tester) async {
      final api = LoginApi();
      await withFakeApi(api, () async {
        await pumpSignedOutApp(tester, api: api, location: '/connexion');
        await tester.enterText(find.widgetWithText(TextFormField, 'Adresse email'), 'leo@example.com');
        await leaveThenAnswer(tester, api, find.widgetWithText(FilledButton, 'Recevoir le code'));
      });
    });

    testWidgets('on the code sending', (tester) async {
      final api = LoginApi(accounts: [booker]);
      await withFakeApi(api, () async {
        await pumpSignedOutApp(tester, api: api, location: '/connexion');
        await tester.enterText(find.widgetWithText(TextFormField, 'Adresse email'), 'claire@example.com');
        await leaveThenAnswer(tester, api, find.widgetWithText(FilledButton, 'Recevoir le code'));
      });
    });

    testWidgets('on a refused code', (tester) async {
      final api = LoginApi(accounts: [booker]);
      await withFakeApi(api, () async {
        await pumpSignedOutApp(tester, api: api, location: '/connexion');
        await enterEmail(tester, 'claire@example.com');
        await tester.enterText(find.widgetWithText(TextFormField, 'Code à 6 chiffres'), '000000');
        await leaveThenAnswer(tester, api, find.descendant(of: find.byType(Form), matching: find.widgetWithText(FilledButton, 'Se connecter')));
      });
    });

    testWidgets('on a failed code resending', (tester) async {
      final api = LoginApi(accounts: [booker]);
      await withFakeApi(api, () async {
        await pumpSignedOutApp(tester, api: api, location: '/connexion');
        await enterEmail(tester, 'claire@example.com');
        api.accounts.clear();
        await leaveThenAnswer(tester, api, find.widgetWithText(TextButton, 'Renvoyer le code'));
      });
    });
  });
}
