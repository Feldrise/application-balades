import 'package:balade/features/ramble/models/ramble/ramble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../management/management_app.dart';
import 'public_app.dart';

Ramble _champignons({bool cancelled = false}) => balade(7, inDays: 20, title: 'Sortie champignons', cancelled: cancelled).copyWith(
  description: 'Une matinée en forêt.',
  prices: const [
    RamblePrice(label: 'Adulte', amount: 12),
    RamblePrice(label: 'Enfant', amount: 6),
  ],
);

void main() {
  for (final (name, size) in [('on a 390 px phone', phone), ('on desktop', desktop)]) {
    group('the catalogue $name', () {
      testWidgets('shows each balade card with its title, type, guide, date, place and prices', (tester) async {
        final api = FakeApi(rambles: [_champignons()]);
        await withFakeApi(api, () async {
          await pumpPublicApp(tester, api: api, location: '/balades', size: size);

          final card = find.ancestor(of: find.text('Sortie champignons'), matching: find.byType(Card));
          for (final text in ['Sortie champignons', 'Champignons', 'Avec Vera Lemoine', 'Paimpont', '6€ - 12€']) {
            expect(
              find.descendant(of: card, matching: find.textContaining(text)),
              findsOneWidget,
              reason: text,
            );
          }
          expect(find.descendant(of: card, matching: find.textContaining('10:00')), findsOneWidget);
          expectNoOverflow(tester);
        });
      });

      testWidgets('the card carries the calendar date block of the management area', (tester) async {
        final api = FakeApi(rambles: [_champignons()]);
        await withFakeApi(api, () async {
          await pumpPublicApp(tester, api: api, location: '/balades', size: size);

          final card = find.ancestor(of: find.text('Sortie champignons'), matching: find.byType(Card));
          final date = _champignons().date!;
          expect(find.descendant(of: card, matching: find.byWidgetPredicate((w) => w is Semantics && w.properties.label?.startsWith(_weekday(date)) == true)), findsOneWidget);
          expectNoOverflow(tester);
        });
      });

      testWidgets('touching anywhere on a card opens the balade page', (tester) async {
        final api = FakeApi(rambles: [_champignons()]);
        for (final spot in [Alignment.topLeft, Alignment.center, Alignment.bottomRight, Alignment.centerLeft]) {
          await withFakeApi(api, () async {
            await pumpPublicApp(tester, api: api, location: '/balades', size: size);
            final card = find.ancestor(of: find.text('Sortie champignons'), matching: find.byType(Card));
            final rect = tester.getRect(card);
            await tester.tapAt(spot.withinRect(rect).translate(spot.x * -4, spot.y * -4));
            await tester.pumpAndSettle();

            expect(currentLocation(tester), '/balades/7', reason: '$spot');
            expectNoOverflow(tester);
          });
        }
      });
    });
  }
}

String _weekday(DateTime d) => const ['lundi', 'mardi', 'mercredi', 'jeudi', 'vendredi', 'samedi', 'dimanche'][d.weekday - 1];
