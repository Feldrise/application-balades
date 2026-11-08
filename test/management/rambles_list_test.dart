import 'package:balade/features/admin/design/design.dart';
import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'management_app.dart';

const _months = ['JANV', 'FÉVR', 'MARS', 'AVR', 'MAI', 'JUIN', 'JUIL', 'AOÛT', 'SEPT', 'OCT', 'NOV', 'DÉC'];

/// The feuille de balade is redone by another ticket: tests stop on it while it loads.
final _feuilleLoading = [RegExp(r'/rambles/\d+$')];

/// A Wednesday: tomorrow is in this week, and the 12th day from it in this month.
final _wednesday = DateTime(2026, 11, 4, 8);

double _top(WidgetTester tester, String text) => tester.getTopLeft(find.text(text)).dy;

void main() {
  testWidgets('« Cette semaine » ends on Sunday and « Ce mois-ci » with the calendar month', (tester) async {
    // Sunday 8 November 2026
    await withClock(Clock.fixed(DateTime(2026, 11, 8, 8)), () async {
      final api = FakeApi(
        rambles: [
          balade(1, inDays: 0, title: 'Ce dimanche'),
          balade(2, inDays: 1, title: 'Lundi prochain'),
          balade(3, inDays: 22, title: 'Fin novembre'),
          balade(4, inDays: 23, title: 'Début décembre'),
        ],
      );
      await withFakeApi(api, () async {
        await pumpManagementApp(tester, api: api, location: '/admin', user: admin, size: phone);

        final order = ['CETTE SEMAINE · 1', 'Ce dimanche', 'CE MOIS-CI · 2', 'Lundi prochain', 'Fin novembre', 'PLUS TARD · 1', 'Début décembre'];
        for (var i = 1; i < order.length; i++) {
          expect(_top(tester, order[i]), greaterThan(_top(tester, order[i - 1])), reason: '${order[i]} comes after ${order[i - 1]}');
        }
      });
    });
  });

  testWidgets('balades are grouped by period, soonest first, past ones hidden', (tester) async {
    await withClock(Clock.fixed(_wednesday), () async {
      final api = FakeApi(
        rambles: [
          balade(3, inDays: 60, title: 'Brame du cerf'),
          balade(1, inDays: 1, title: 'Champignons de Paimpont'),
          balade(2, inDays: 12, title: 'Petits fruits du bocage'),
          balade(4, inDays: -3, title: 'Balade passée'),
        ],
      );
      await withFakeApi(api, () async {
        await pumpManagementApp(tester, api: api, location: '/admin', user: admin, size: phone);

        expect(find.text('CETTE SEMAINE · 1'), findsOneWidget);
        expect(find.text('CE MOIS-CI · 1'), findsOneWidget);
        expect(find.text('PLUS TARD · 1'), findsOneWidget);
        expect(find.text('Balade passée'), findsNothing);

        final order = ['CETTE SEMAINE · 1', 'Champignons de Paimpont', 'CE MOIS-CI · 1', 'Petits fruits du bocage', 'PLUS TARD · 1', 'Brame du cerf'];
        for (var i = 1; i < order.length; i++) {
          expect(_top(tester, order[i]), greaterThan(_top(tester, order[i - 1])), reason: '${order[i]} comes after ${order[i - 1]}');
        }
      });
    });
  });

  testWidgets('on a phone, a row shows the essentials and opens the feuille de balade when tapped anywhere', (tester) async {
    final api = FakeApi(
      rambles: [balade(5, inDays: 2, title: 'Champignons de Paimpont', location: 'Forêt de Paimpont', max: 10, placesLeft: 7)],
      unanswered: _feuilleLoading,
    );
    final date = DateTime.now().add(const Duration(days: 2));
    await withFakeApi(api, () async {
      await pumpManagementApp(tester, api: api, location: '/admin', user: admin, size: phone);

      expect(find.textContaining('10h00 · Forêt de Paimpont · Vera'), findsOneWidget);
      expect(find.text('3/10'), findsOneWidget);
      expect(find.text('Publiée'), findsOneWidget);
      expect(find.text(_months[date.month - 1]), findsOneWidget);
      expect(find.text('${date.day}'), findsOneWidget);
      expect(find.text('Modifier'), findsNothing);
      expect(find.text('Dupliquer'), findsNothing);
      expect(find.text('Annuler'), findsNothing);

      await tester.tap(find.text('3/10'));
      await tester.pump();

      expect(currentLocation(tester), '/admin/balade/5');
      expect(api.requests.any((r) => r.url.path.endsWith('/rambles/5')), isTrue);
    });
  });

  testWidgets('on desktop, balades are a table with the same grouping', (tester) async {
    await withClock(Clock.fixed(_wednesday), () async {
      final api = FakeApi(
        rambles: [
          balade(1, inDays: 1, title: 'Champignons de Paimpont'),
          balade(2, inDays: 40, title: 'Brame du cerf', guides: [val]),
        ],
        unanswered: _feuilleLoading,
      );
      await withFakeApi(api, () async {
        await pumpManagementApp(tester, api: api, location: '/admin', user: admin, size: desktop);

        for (final column in ['DATE', 'BALADE', 'GUIDE', 'PLACES', 'STATUT']) {
          expect(find.text(column), findsOneWidget);
        }
        expect(find.text('CETTE SEMAINE · 1'), findsOneWidget);
        expect(find.text('PLUS TARD · 1'), findsOneWidget);
        expect(find.text('Val'), findsOneWidget);

        await tester.tap(find.text('Brame du cerf'));
        await tester.pump();
        expect(currentLocation(tester), '/admin/balade/2');
      });
    });
  });

  testWidgets('on a tablet, balades are rows, not a table', (tester) async {
    final api = FakeApi(rambles: [balade(1, inDays: 1)]);
    await withFakeApi(api, () async {
      await pumpManagementApp(tester, api: api, location: '/admin', user: admin, size: tablet);

      expect(find.text('Sortie champignons'), findsOneWidget);
      expect(find.text('GUIDE'), findsNothing);
    });
  });

  testWidgets('the chips filter drafts, cancelled and past balades', (tester) async {
    final api = FakeApi(
      rambles: [
        balade(1, inDays: 1, title: 'Balade publiée'),
        balade(2, inDays: 2, title: 'Balade en brouillon', published: false),
        balade(3, inDays: 3, title: 'Balade annulée', cancelled: true),
        balade(4, inDays: -2, title: 'Balade passée'),
      ],
    );
    await withFakeApi(api, () async {
      await pumpManagementApp(tester, api: api, location: '/admin', user: admin, size: phone);

      Future<List<String>> shownAfter(String chip) async {
        await tester.ensureVisible(find.widgetWithText(ChoiceChip, chip));
        await tester.tap(find.widgetWithText(ChoiceChip, chip));
        await tester.pumpAndSettle();
        return [
          for (final t in ['Balade publiée', 'Balade en brouillon', 'Balade annulée', 'Balade passée'])
            if (find.text(t).evaluate().isNotEmpty) t,
        ];
      }

      expect(await shownAfter('À venir'), ['Balade publiée', 'Balade en brouillon']);
      expect(await shownAfter('Publiées'), ['Balade publiée']);
      expect(await shownAfter('Brouillons'), ['Balade en brouillon']);
      expect(await shownAfter('Annulées'), ['Balade annulée']);
      expect(await shownAfter('Passées'), ['Balade passée']);
    });
  });

  testWidgets('the search finds balades by title, place or guide', (tester) async {
    final api = FakeApi(
      rambles: [
        balade(1, inDays: 1, title: 'Champignons'),
        balade(2, inDays: 2, title: 'Oiseaux du lac', guides: [val], location: 'Rennes'),
      ],
    );
    await withFakeApi(api, () async {
      await pumpManagementApp(tester, api: api, location: '/admin', user: admin, size: phone);

      await tester.enterText(find.byType(TextField), 'val');
      await tester.pumpAndSettle();
      expect(find.text('Oiseaux du lac'), findsOneWidget);
      expect(find.text('Champignons'), findsNothing);

      await tester.enterText(find.byType(TextField), 'zzz');
      await tester.pumpAndSettle();
      expect(find.text('Aucune balade'), findsOneWidget);
    });
  });

  testWidgets('a guide only gets their own balades, as before', (tester) async {
    final api = FakeApi(rambles: [balade(1, inDays: 1)], myGuide: vera);
    await withFakeApi(api, () async {
      await pumpManagementApp(tester, api: api, location: '/admin', user: guide, size: phone);

      final listRequests = api.requests.where((r) => r.url.path.endsWith('/rambles')).toList();
      expect(listRequests, isNotEmpty);
      expect(listRequests.every((r) => r.url.queryParameters['guide_id'] == '7'), isTrue);
      expect(find.text('Tous les guides'), findsNothing);
    });
  });

  testWidgets('« Nouvelle balade » is in the header', (tester) async {
    final api = FakeApi(rambles: [balade(1, inDays: 1)]);
    await withFakeApi(api, () async {
      await pumpManagementApp(tester, api: api, location: '/admin', user: admin, size: phone);

      // The form it opens overflows until it is redone in the D style: the test stops at the header
      expect(find.descendant(of: find.byType(ManagementPageHeader), matching: find.text('Nouvelle balade')), findsOneWidget);
    });
  });

  testWidgets('a guide whose account is not linked cannot create a balade', (tester) async {
    final api = FakeApi(rambles: [balade(1, inDays: 1)]);
    await withFakeApi(api, () async {
      await pumpManagementApp(tester, api: api, location: '/admin', user: guide, size: phone);

      expect(find.text('Nouvelle balade'), findsNothing);
    });
  });
}
