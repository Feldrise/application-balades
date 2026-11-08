import 'dart:convert';

import 'package:balade/features/admin/design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'management_app.dart';

const _mapsLabel = 'Coller un lien Google Maps ou des coordonnées';

Finder _field(String label) => find.widgetWithText(TextFormField, label);

Future<void> _fill(WidgetTester tester, String label, String text) async {
  await tester.ensureVisible(_field(label));
  await tester.enterText(_field(label), text);
  await tester.pump();
}

String _valueOf(WidgetTester tester, String label) => tester.widget<TextFormField>(_field(label)).controller!.text;

Future<void> _openCreationForm(WidgetTester tester, FakeApi api, Size size) => pumpManagementApp(tester, api: api, location: '/admin/nouvelle-balade', user: admin, size: size);

void main() {
  testWidgets('on a phone, the creation form fits 390 px with its title, cards and fixed action bar', (tester) async {
    final api = FakeApi();
    await withFakeApi(api, () async {
      await _openCreationForm(tester, api, phone);

      expect(tester.takeException(), isNull);
      expect(find.byType(AppBar), findsNothing);
      expect(find.descendant(of: find.byType(ManagementPageHeader), matching: find.text('Nouvelle balade')), findsOneWidget);
      expect(find.text('Informations générales'), findsOneWidget);

      // The action bar is at the bottom of the screen, before and after scrolling the form
      final create = find.widgetWithText(FilledButton, 'Créer la balade');
      expect(create, findsOneWidget);
      expect(find.widgetWithText(OutlinedButton, 'Annuler'), findsOneWidget);
      expect(tester.getBottomLeft(create).dy, greaterThan(700));
      expect(tester.getBottomLeft(create).dy, lessThanOrEqualTo(844));
      await tester.drag(find.byType(Scrollable).first, const Offset(0, -3000));
      await tester.pumpAndSettle();
      expect(tester.getBottomLeft(create).dy, greaterThan(700));
      expect(tester.takeException(), isNull);
    });
  });

  testWidgets('the labels of the form are readable on one line, and the duration fields do not overlap', (tester) async {
    final api = FakeApi();
    await withFakeApi(api, () async {
      await _openCreationForm(tester, api, phone);

      final publish = find.text('Publier maintenant');
      await tester.ensureVisible(publish);
      await tester.pumpAndSettle();
      expect(tester.getSize(publish).height, lessThan(24), reason: 'a single line of text');

      final hours = find.widgetWithText(DropdownButtonFormField<int>, 'Durée estimée');
      final minutes = find.widgetWithText(DropdownButtonFormField<int>, 'Minutes');
      await tester.ensureVisible(hours);
      await tester.pumpAndSettle();
      expect(tester.getRect(hours).overlaps(tester.getRect(minutes)), isFalse);
      expect(tester.takeException(), isNull);
    });
  });

  testWidgets('on desktop, the form is limited to about 800 px wide', (tester) async {
    final api = FakeApi();
    await withFakeApi(api, () async {
      await _openCreationForm(tester, api, desktop);

      expect(tester.takeException(), isNull);
      final card = find.ancestor(of: find.text('Informations générales'), matching: find.byType(Card)).first;
      expect(tester.getSize(card).width, lessThanOrEqualTo(800));
      expect(tester.getSize(card).width, greaterThan(600));
    });
  });

  testWidgets('pasting a Google Maps link fills the latitude and the longitude', (tester) async {
    final api = FakeApi();
    await withFakeApi(api, () async {
      await _openCreationForm(tester, api, phone);

      await _fill(tester, _mapsLabel, 'https://www.google.com/maps/place/Paimpont/@48.1,-2.2,15z/data=!3d48.0123!4d-2.1456');

      expect(_valueOf(tester, 'Latitude'), '48.0123');
      expect(_valueOf(tester, 'Longitude'), '-2.1456');
    });
  });

  testWidgets('pasting plain coordinates fills the latitude and the longitude', (tester) async {
    final api = FakeApi();
    await withFakeApi(api, () async {
      await _openCreationForm(tester, api, phone);

      await _fill(tester, _mapsLabel, '48.8566, 2.3522');

      expect(_valueOf(tester, 'Latitude'), '48.8566');
      expect(_valueOf(tester, 'Longitude'), '2.3522');
    });
  });

  testWidgets('an input that is neither a link nor coordinates is reported, and leaves the coordinates alone', (tester) async {
    final api = FakeApi();
    await withFakeApi(api, () async {
      await _openCreationForm(tester, api, phone);

      await _fill(tester, 'Latitude', '10');
      await _fill(tester, 'Longitude', '20');
      await _fill(tester, _mapsLabel, 'devant la boulangerie');

      expect(find.text('Lien ou coordonnées non reconnus'), findsOneWidget);
      expect(_valueOf(tester, 'Latitude'), '10');
      expect(_valueOf(tester, 'Longitude'), '20');
    });
  });

  testWidgets('coordinates out of range are reported', (tester) async {
    final api = FakeApi();
    await withFakeApi(api, () async {
      await _openCreationForm(tester, api, phone);

      await _fill(tester, _mapsLabel, '148.8566, 2.3522');

      expect(find.text('Lien ou coordonnées non reconnus'), findsOneWidget);
    });
  });

  testWidgets('creating a balade sends the coordinates taken from the pasted link', (tester) async {
    final api = FakeApi();
    await withFakeApi(api, () async {
      await _openCreationForm(tester, api, phone);

      await _fill(tester, 'Titre de la balade', 'Sortie brame');
      await _fill(tester, 'Description', 'Écouter les cerfs');
      await _fill(tester, 'Lieu général', 'Paimpont');
      await _fill(tester, 'Point de rendez-vous', 'Parking de l\'étang');
      await _fill(tester, _mapsLabel, '48.0123, -2.1456');
      await _fill(tester, 'Nombre maximum de participants', '12');
      await _fill(tester, 'Prix (€)', '10');

      await tester.tap(find.widgetWithText(FilledButton, 'Créer la balade'));
      await tester.pumpAndSettle();

      final post = api.requests.where((r) => r.method == 'POST' && r.url.path.endsWith('/rambles'));
      expect(post, hasLength(1));
      final body = jsonDecode(post.single.body) as Map<String, dynamic>;
      expect(body['title'], 'Sortie brame');
      expect(body['meeting_latitude'], 48.0123);
      expect(body['meeting_longitude'], -2.1456);
    });
  });

  testWidgets('the edition form fits 390 px, shows the balade and has an Enregistrer action', (tester) async {
    final api = FakeApi(rambles: [balade(5, inDays: 4, title: 'Sortie champignons')]);
    await withFakeApi(api, () async {
      await pumpManagementApp(tester, api: api, location: '/admin/modifier-balade/5', user: admin, size: phone);

      expect(tester.takeException(), isNull);
      expect(find.byType(AppBar), findsNothing);
      expect(find.descendant(of: find.byType(ManagementPageHeader), matching: find.text('Modifier la balade')), findsOneWidget);
      expect(_valueOf(tester, 'Titre de la balade'), 'Sortie champignons');
      expect(find.widgetWithText(FilledButton, 'Enregistrer'), findsOneWidget);
      expect(find.widgetWithText(OutlinedButton, 'Annuler'), findsOneWidget);
    });
  });

  testWidgets('Annuler leaves the form for the balades list', (tester) async {
    final api = FakeApi(rambles: [balade(1, inDays: 2)]);
    await withFakeApi(api, () async {
      await pumpManagementApp(tester, api: api, location: '/admin/nouvelle-balade', user: admin, size: phone);

      await tester.tap(find.widgetWithText(OutlinedButton, 'Annuler'));
      await tester.pumpAndSettle();

      expect(currentLocation(tester), '/admin');
    });
  });
}
