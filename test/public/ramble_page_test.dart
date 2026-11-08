import 'package:balade/features/admin/design/design.dart';
import 'package:balade/features/ramble/models/ramble/ramble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../management/management_app.dart';
import 'public_app.dart';

Ramble _champignons({bool cancelled = false}) => balade(7, inDays: 20, title: 'Sortie champignons', cancelled: cancelled).copyWith(
  description: 'Une matinée en forêt.',
  meetingPoint: 'Parking de l\'étang',
  equipmentNeeded: 'Bottes et panier',
  prices: const [
    RamblePrice(label: 'Adulte', amount: 12),
    RamblePrice(label: 'Enfant', amount: 6),
  ],
  cancellationReason: 'Orage',
);

/// Whether [text] sits in the deep green header of the style D.
Finder _inGreenHeader(String text) => find.descendant(of: find.byWidgetPredicate((w) => w is Material && w.color == ManagementColors.deepGreen), matching: find.text(text));

void main() {
  for (final (name, size) in [('on a 390 px phone', phone), ('on desktop', desktop)]) {
    group('the balade page $name', () {
      testWidgets('has the green header and the calendar date block, and keeps its content', (tester) async {
        final api = FakeApi(rambles: [_champignons()]);
        await withFakeApi(api, () async {
          await pumpPublicApp(tester, api: api, location: '/balades/7', size: size);

          expect(_inGreenHeader('Sortie champignons'), findsOneWidget);
          expect(find.byType(CalendarDateBlock), findsOneWidget);
          for (final text in ['Champignons', 'Facile', 'Paimpont', 'Une matinée en forêt.', 'Parking de l\'étang', 'Bottes et panier', 'Adulte', 'Enfant', 'Vera Lemoine']) {
            expect(find.textContaining(text), findsWidgets, reason: text);
          }
          expectNoOverflow(tester);
        });
      });

      testWidgets('still offers to book', (tester) async {
        final api = FakeApi(rambles: [_champignons()]);
        await withFakeApi(api, () async {
          await pumpPublicApp(tester, api: api, location: '/balades/7', size: size);

          await tester.scrollUntilVisible(find.widgetWithText(FilledButton, 'Réserver'), 200, scrollable: find.byType(Scrollable).first);
          expect(find.widgetWithText(FilledButton, 'Réserver'), findsOneWidget);
          expectNoOverflow(tester);
        });
      });

      testWidgets('the back button returns to the catalogue', (tester) async {
        final api = FakeApi(rambles: [_champignons()]);
        await withFakeApi(api, () async {
          await pumpPublicApp(tester, api: api, location: '/balades/7', size: size);

          await tester.tap(find.byTooltip('Retour'));
          await tester.pumpAndSettle();

          expect(currentLocation(tester), '/balades');
          expectNoOverflow(tester);
        });
      });

      testWidgets('a cancelled balade says so', (tester) async {
        final api = FakeApi(rambles: [_champignons(cancelled: true)]);
        await withFakeApi(api, () async {
          await pumpPublicApp(tester, api: api, location: '/balades/7', size: size);

          expect(find.text('Annulée'), findsWidgets);
          expect(find.textContaining('Orage'), findsOneWidget);
          expectNoOverflow(tester);
        });
      });
    });

    group('the catalogue $name, header and cancelled balade', () {
      testWidgets('has the green header, and a cancelled card keeps its notice', (tester) async {
        final api = FakeApi(
          rambles: [
            _champignons(cancelled: true),
            balade(8, inDays: 5, title: 'Observation des oiseaux'),
          ],
        );
        await withFakeApi(api, () async {
          await pumpPublicApp(tester, api: api, location: '/balades', size: size);

          expect(_inGreenHeader('Balades EcoLogiques'), findsOneWidget);
          expect(find.text('Observation des oiseaux'), findsOneWidget);
          expect(find.text('Balade annulée'), findsOneWidget);
          expect(find.text('Orage'), findsOneWidget);
          expectNoOverflow(tester);
        });
      });
    });
  }
}
