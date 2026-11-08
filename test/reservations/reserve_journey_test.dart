import 'dart:convert';

import 'package:balade/features/ramble/models/ramble/ramble.dart';
import 'package:balade/features/ramble/public_ramble_details_page/widgets/ramble_registration_section.dart';
import 'package:balade/features/reservations/providers/reservation_providers.dart';
import 'package:balade/features/reservations/reservations_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:intl/date_symbol_data_local.dart';

Ramble _ramble({int? placesLeft = 10}) => Ramble(
  3,
  title: 'Sortie champignons',
  type: 'champignons',
  difficulty: 'facile',
  date: DateTime.now().add(const Duration(days: 30)),
  publishedAt: DateTime.now().subtract(const Duration(days: 1)),
  placesLeft: placesLeft,
  maxParticipantsPerReservation: 10,
  prices: const [RamblePrice(label: 'Adulte', amount: 12.5), RamblePrice(label: 'Enfant', amount: 6)],
);

Map<String, Object?> _created(List<Map<String, Object?>> participants, String status) => {
  'id': 12,
  'created_at': '2026-11-02T10:00:00Z',
  'updated_at': '2026-11-02T10:00:00Z',
  'ramble_id': 3,
  'user_id': 7,
  'contact_email': 'claire@example.com',
  'status': status,
  'participants': [
    for (var i = 0; i < participants.length; i++)
      {'id': i + 1, 'first_name': participants[i]['first_name'], 'last_name': participants[i]['last_name'], 'price_label': participants[i]['price_label'], 'price_amount': participants[i]['price_label'] == 'Adulte' ? 12.5 : 6.0, 'is_booker': false},
  ],
  'estimated_amount': 3100,
  'payments': [],
};

Future<void> _pump(WidgetTester tester, Ramble ramble, Future<http.Response> Function(http.Request) handler) async {
  await initializeDateFormatting('fr');
  tester.view.physicalSize = const Size(900, 2400);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [reservationsServiceProvider.overrideWithValue(ReservationsService(client: MockClient(handler), baseUrl: 'http://api.test'))],
      child: MaterialApp(
        home: Scaffold(body: SingleChildScrollView(child: RambleRegistrationSection(ramble: ramble))),
      ),
    ),
  );
}

void main() {
  testWidgets('a visitor reserves Adulte 2, Enfant 1 with only the contact email', (tester) async {
    Map<String, Object?>? sent;
    await _pump(tester, _ramble(), (request) async {
      sent = jsonDecode(request.body) as Map<String, Object?>;
      return http.Response(jsonEncode(_created((sent!['participants'] as List).cast<Map<String, Object?>>(), 'pending')), 201);
    });

    expect(find.text('10 places restantes'), findsOneWidget);
    expect(find.textContaining('3 jours avant la balade'), findsOneWidget);
    expect(find.text('Inscription de groupe'), findsNothing);

    await tester.tap(find.byTooltip('Ajouter une personne (Adulte)'));
    await tester.tap(find.byTooltip('Ajouter une personne (Enfant)'));
    await tester.pump();
    await tester.tap(find.widgetWithText(FilledButton, 'Réserver'));
    await tester.pumpAndSettle();

    expect(find.text('Participant 3'), findsOneWidget);
    expect(find.text('31 €'), findsOneWidget);

    final names = find.widgetWithText(TextFormField, 'Prénom *');
    final lasts = find.widgetWithText(TextFormField, 'Nom *');
    for (var i = 0; i < 3; i++) {
      await tester.enterText(names.at(i), 'Prénom$i');
      await tester.enterText(lasts.at(i), 'Martin');
    }
    await tester.enterText(find.widgetWithText(TextFormField, 'Email *'), 'claire@example.com');
    await tester.pump();
    await tester.ensureVisible(find.widgetWithText(FilledButton, 'Réserver pour 3 personnes'));
    await tester.tap(find.widgetWithText(FilledButton, 'Réserver pour 3 personnes'));
    await tester.pumpAndSettle();

    expect(sent!['contact_email'], 'claire@example.com');
    expect((sent!['participants'] as List).map((p) => (p as Map)['price_label']), ['Adulte', 'Adulte', 'Enfant']);
    expect(find.text('Réservation enregistrée !'), findsOneWidget);
    final dialog = find.byType(AlertDialog);
    expect(find.descendant(of: dialog, matching: find.text('Montant estimé')), findsOneWidget);
    expect(find.descendant(of: dialog, matching: find.text('31 €')), findsOneWidget);
    expect(find.descendant(of: dialog, matching: find.textContaining('3 jours avant la balade')), findsOneWidget);
    expect(find.descendant(of: dialog, matching: find.text('Prénom0 Martin')), findsOneWidget);
  });

  testWidgets('removing the first line leaves only the other participants', (tester) async {
    Map<String, Object?>? sent;
    await _pump(tester, _ramble(), (request) async {
      sent = jsonDecode(request.body) as Map<String, Object?>;
      return http.Response(jsonEncode(_created((sent!['participants'] as List).cast<Map<String, Object?>>(), 'pending')), 201);
    });

    await tester.tap(find.byTooltip('Ajouter une personne (Enfant)'));
    await tester.pump();
    await tester.tap(find.widgetWithText(FilledButton, 'Réserver'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Retirer ce participant').first);
    await tester.pumpAndSettle();
    expect(find.text('Participant 2'), findsNothing);

    await tester.enterText(find.widgetWithText(TextFormField, 'Prénom *'), 'Léo');
    await tester.enterText(find.widgetWithText(TextFormField, 'Nom *'), 'Martin');
    await tester.enterText(find.widgetWithText(TextFormField, 'Email *'), 'claire@example.com');
    await tester.pump();
    await tester.tap(find.widgetWithText(FilledButton, 'Réserver pour 1 personne'));
    await tester.pumpAndSettle();

    expect((sent!['participants'] as List).single, {'first_name': 'Léo', 'last_name': 'Martin', 'price_label': 'Enfant', 'is_booker': false});
  });

  testWidgets('warns that the whole reservation goes to the waiting list when it exceeds the places left', (tester) async {
    await _pump(tester, _ramble(placesLeft: 1), (_) async => http.Response('', 500));

    await tester.tap(find.byTooltip('Ajouter une personne (Adulte)'));
    await tester.pump();
    await tester.tap(find.widgetWithText(FilledButton, 'Réserver'));
    await tester.pumpAndSettle();

    expect(find.textContaining('liste d\'attente'), findsWidgets);
    expect(find.textContaining('toute la réservation sera placée en liste d\'attente'), findsOneWidget);
  });

  testWidgets('a full ramble can still be reserved, in the waiting list', (tester) async {
    await _pump(tester, _ramble(placesLeft: 0), (_) async => http.Response('', 500));

    expect(find.text('Complet — réservation en liste d\'attente'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Réserver en liste d\'attente'), findsOneWidget);
  });
}
