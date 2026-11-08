import 'package:balade/features/guides/models/guide/guide.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'management_app.dart';

const _anonymous = Guide(9, firstName: '', lastName: '', email: 'inconnu@example.com', isActive: false);
const _naturalist = Guide(7, firstName: 'Vera', lastName: 'Lemoine', email: 'vera@example.com', isActive: true, specialties: 'Mycologie, Ornithologie');

void main() {
  testWidgets('on a phone, Guides lists each guide as a row without overflowing', (tester) async {
    final api = FakeApi(guides: [_naturalist, _anonymous]);
    await withFakeApi(api, () async {
      await pumpManagementApp(tester, api: api, location: '/admin/guides', user: admin, size: phone);

      expect(tester.takeException(), isNull);
      expect(find.text('Guides'), findsWidgets);
      expect(find.text('Vera Lemoine'), findsOneWidget);
      expect(find.text('vera@example.com'), findsOneWidget);
      expect(find.textContaining('Mycologie, Ornithologie'), findsOneWidget);
      expect(find.text('Actif'), findsOneWidget);
      expect(find.text('Inactif'), findsOneWidget);
      expect(find.byType(AppBar), findsNothing);
    });
  });

  testWidgets('a guide without a name is shown with a readable placeholder instead of a question mark', (tester) async {
    final api = FakeApi(guides: [_anonymous]);
    await withFakeApi(api, () async {
      await pumpManagementApp(tester, api: api, location: '/admin/guides', user: admin, size: phone);

      expect(find.text('Guide sans nom'), findsOneWidget);
      expect(find.text('?'), findsNothing);
      expect(find.text('inconnu@example.com'), findsOneWidget);
    });
  });

  testWidgets('Guides does not overflow on a tablet or on desktop', (tester) async {
    final api = FakeApi(guides: [_naturalist, _anonymous]);
    await withFakeApi(api, () async {
      await pumpManagementApp(tester, api: api, location: '/admin/guides', user: admin, size: tablet);
      expect(tester.takeException(), isNull);
      await pumpManagementApp(tester, api: api, location: '/admin/guides', user: admin, size: desktop);
      expect(tester.takeException(), isNull);
      expect(find.text('Nouveau guide'), findsOneWidget);
    });
  });

  testWidgets('Guides without any guide shows an empty state', (tester) async {
    final api = FakeApi();
    await withFakeApi(api, () async {
      await pumpManagementApp(tester, api: api, location: '/admin/guides', user: admin, size: phone);
      expect(find.text('Aucun guide trouvé'), findsOneWidget);
    });
  });
}
