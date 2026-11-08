import 'package:balade/features/admin/design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'management_app.dart';

Finder _inNavigation(String label) => find.descendant(of: find.byWidgetPredicate((w) => w is NavigationBar || w is NavigationRail), matching: find.text(label));

void main() {
  testWidgets('on a phone, an admin gets a bottom navigation bar and a single header', (tester) async {
    final api = FakeApi(rambles: [balade(1, inDays: 2)]);
    await withFakeApi(api, () async {
      await pumpManagementApp(tester, api: api, location: '/admin', user: admin, size: phone);

      final bottomBar = find.byType(NavigationBar);
      expect(bottomBar, findsOneWidget);
      for (final label in ['Balades', 'Réservations', 'Guides']) {
        expect(find.descendant(of: bottomBar, matching: find.text(label)), findsOneWidget);
      }
      expect(find.descendant(of: bottomBar, matching: find.text('Mon profil')), findsNothing);
      expect(find.text('Paramètres'), findsNothing);

      expect(find.byType(AppBar), findsNothing);
      expect(find.text('Balade EcoLogique'), findsNothing);
      expect(find.byTooltip('Voir le site public'), findsOneWidget);
    });
  });

  testWidgets('on a phone, a guide gets Mon profil instead of Guides', (tester) async {
    final api = FakeApi(rambles: [balade(1, inDays: 2)], myGuide: vera);
    await withFakeApi(api, () async {
      await pumpManagementApp(tester, api: api, location: '/admin', user: guide, size: phone);

      expect(_inNavigation('Mon profil'), findsOneWidget);
      expect(_inNavigation('Guides'), findsNothing);
      expect(find.byType(AppBar), findsNothing);
    });
  });

  testWidgets('on a phone, the bottom bar opens Réservations', (tester) async {
    final api = FakeApi(rambles: [balade(1, inDays: 2)]);
    await withFakeApi(api, () async {
      await pumpManagementApp(tester, api: api, location: '/admin', user: admin, size: phone);

      await tester.tap(_inNavigation('Réservations'));
      await tester.pumpAndSettle();

      expect(tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex, 1);
      expect(find.text('Sortie champignons'), findsNothing);
    });
  });

  testWidgets('on a tablet, the sidebar is reduced to icons', (tester) async {
    final api = FakeApi(rambles: [balade(1, inDays: 2)]);
    await withFakeApi(api, () async {
      await pumpManagementApp(tester, api: api, location: '/admin', user: admin, size: tablet);

      expect(find.byType(NavigationBar), findsNothing);
      final rail = tester.widget<NavigationRail>(find.byType(NavigationRail));
      expect(rail.extended, isFalse);
      expect(rail.destinations, hasLength(3));
      expect(find.byTooltip('Voir le site public'), findsOneWidget);
      expect(find.byType(AppBar), findsNothing);
    });
  });

  testWidgets('on desktop, a guide gets the full green sidebar with Balades, Réservations and Mon profil', (tester) async {
    final api = FakeApi(rambles: [balade(1, inDays: 2)], myGuide: vera);
    await withFakeApi(api, () async {
      await pumpManagementApp(tester, api: api, location: '/admin', user: guide, size: desktop);

      expect(find.byType(NavigationBar), findsNothing);
      expect(tester.widget<NavigationRail>(find.byType(NavigationRail)).extended, isTrue);
      for (final label in ['Balades', 'Réservations', 'Mon profil']) {
        expect(_inNavigation(label), findsOneWidget);
      }
      expect(_inNavigation('Guides'), findsNothing);
      expect(find.text('Voir le site public'), findsOneWidget);
      expect(find.byType(AppBar), findsNothing);
    });
  });

  testWidgets('the link to the public site leaves the management area', (tester) async {
    final api = FakeApi(rambles: [balade(1, inDays: 2)]);
    await withFakeApi(api, () async {
      await pumpManagementApp(tester, api: api, location: '/admin', user: admin, size: phone);

      await tester.tap(find.byTooltip('Voir le site public'));
      await tester.pumpAndSettle();

      expect(find.byType(NavigationBar), findsNothing);
      expect(find.text('Bienvenue sur Balade EcoLogique'), findsOneWidget);
    });
  });

  testWidgets('a guide whose account is not linked keeps seeing the warning banner', (tester) async {
    final api = FakeApi();
    await withFakeApi(api, () async {
      await pumpManagementApp(tester, api: api, location: '/admin', user: guide, size: phone);

      expect(find.textContaining('pas encore lié à un profil guide'), findsOneWidget);
    });
  });

  for (final (who, user, myGuide, entries) in [
    ('an admin', admin, null, ['Balades', 'Réservations', 'Guides']),
    ('a guide', guide, vera, ['Balades', 'Réservations', 'Mon profil']),
  ]) {
    for (final (screen, size) in [('a phone', phone), ('a tablet', tablet), ('desktop', desktop)]) {
      testWidgets('for $who on $screen, the balades page has a single header and the right entries', (tester) async {
        final api = FakeApi(rambles: [balade(1, inDays: 1)], myGuide: myGuide);
        await withFakeApi(api, () async {
          await pumpManagementApp(tester, api: api, location: '/admin', user: user, size: size);

          expect(find.byType(AppBar), findsNothing);
          expect(find.byType(ManagementPageHeader), findsOneWidget);
          final navigation = size == phone
              ? tester.widget<NavigationBar>(find.byType(NavigationBar)).destinations.map((d) => (d as NavigationDestination).label)
              : tester.widget<NavigationRail>(find.byType(NavigationRail)).destinations.map((d) => (d.label as Text).data);
          expect(navigation, entries);
          expect(find.text('Sortie champignons'), findsOneWidget);
        });
      });
    }
  }
}
