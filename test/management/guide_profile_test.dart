import 'package:balade/features/admin/design/design.dart';
import 'package:balade/features/authentication/data/models/authed_user/authed_user.dart';
import 'package:balade/features/users/models/user/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'management_app.dart';

/// A guide account that may also configure its own payments.
final _payingGuide = AuthedUser(
  user: const User(2, email: 'vera@example.com', roles: ['guide'], permissions: ['create:ramble', 'update:ramble:self', 'view:registrations:self', 'configure:guide-payments:self']),
  token: 'guide-token',
);

void main() {
  testWidgets('on a phone, Mon profil has a title, shows the form without overflowing and keeps Enregistrer reachable', (tester) async {
    final api = FakeApi(myGuide: vera);
    await withFakeApi(api, () async {
      await pumpManagementApp(tester, api: api, location: '/admin/mon-profil', user: guide, size: phone);

      expect(tester.takeException(), isNull);
      expect(find.descendant(of: find.byType(ManagementPageHeader), matching: find.text('Mon profil')), findsOneWidget);
      expect(find.byType(AppBar), findsNothing);
      expect(find.text('Informations personnelles'), findsOneWidget);

      // Reachable without scrolling, whatever the length of the form
      final save = find.widgetWithText(FilledButton, 'Enregistrer');
      expect(save, findsOneWidget);
      expect(tester.getBottomLeft(save).dy, lessThanOrEqualTo(844));
      await tester.drag(find.byType(Scrollable).first, const Offset(0, -2000));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(tester.getBottomLeft(save).dy, lessThanOrEqualTo(844));
    });
  });

  testWidgets('Enregistrer sends the profile', (tester) async {
    final api = FakeApi(myGuide: vera);
    await withFakeApi(api, () async {
      await pumpManagementApp(tester, api: api, location: '/admin/mon-profil', user: guide, size: phone);

      await tester.tap(find.widgetWithText(FilledButton, 'Enregistrer'));
      await tester.pumpAndSettle();

      final put = api.requests.where((r) => r.method == 'PUT' && r.url.path.endsWith('/guides/me'));
      expect(put, hasLength(1));
      expect(put.single.body, contains('"first_name":"Vera"'));
    });
  });

  testWidgets('Mon profil does not overflow on a tablet or on desktop', (tester) async {
    final api = FakeApi(myGuide: vera);
    await withFakeApi(api, () async {
      await pumpManagementApp(tester, api: api, location: '/admin/mon-profil', user: guide, size: tablet);
      expect(tester.takeException(), isNull);
      await pumpManagementApp(tester, api: api, location: '/admin/mon-profil', user: guide, size: desktop);
      expect(tester.takeException(), isNull);
    });
  });

  testWidgets('a guide with the right to configure payments gets the Stripe section, still without overflow on a phone', (tester) async {
    final api = FakeApi(myGuide: vera);
    await withFakeApi(api, () async {
      await pumpManagementApp(tester, api: api, location: '/admin/mon-profil', user: _payingGuide, size: phone);
      await tester.scrollUntilVisible(find.text('Configuration Stripe'), 400, scrollable: find.byType(Scrollable).first);
      expect(tester.takeException(), isNull);
    });
  });
}
