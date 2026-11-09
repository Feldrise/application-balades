import 'package:balade/features/admin/design/design.dart';
import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';

import '../management/management_app.dart';
import 'booker_app.dart';

final _withinPeriod = Clock.fixed(DateTime.utc(2026, 11, 29, 10));

void main() {
  testWidgets('Mes réservations lists the reservations in the style of the management area and opens one', (tester) async {
    final api = BookerApi(
      ramble: publicBalade(),
      bookings: [
        bookerReservation(),
        bookerReservation(id: 13, status: 'confirmed', amountPaid: 1850),
        bookerReservation(id: 14, status: 'waiting_list'),
      ],
    );
    await withFakeApi(api, () async {
      await withClock(_withinPeriod, () async {
        await pumpManagementApp(tester, api: api, location: '/mes-reservations', user: booker, size: phone);

        expect(find.text('Mes réservations'), findsOneWidget);
        expect(find.byType(ManagementPageHeader), findsOneWidget);
        expect(find.byType(CalendarDateBlock), findsNWidgets(3));
        expect(find.byType(ReservationStatusBadge), findsNWidgets(3));
        expect(find.text('À confirmer'), findsOneWidget);
        expect(find.text('Confirmée'), findsOneWidget);
        expect(find.text('Liste d\'attente'), findsOneWidget);
        expect(find.text('Sortie champignons'), findsNWidgets(3));
        expect(find.textContaining('2 participants'), findsNWidgets(3));
        expect(tester.takeException(), isNull, reason: 'nothing overflows at 390 px');

        await tester.tap(find.text('Sortie champignons').at(1));
        await tester.pumpAndSettle();

        expect(currentLocation(tester), '/mes-reservations/13');
        expect(find.text('Ma réservation'), findsOneWidget);
        expect(find.textContaining('Votre place est confirmée'), findsOneWidget);
      });
    });
  });

  testWidgets('a booker without reservation is invited to discover the balades', (tester) async {
    final api = BookerApi(ramble: publicBalade(), bookings: []);
    await withFakeApi(api, () async {
      await pumpManagementApp(tester, api: api, location: '/mes-reservations', user: booker, size: phone);

      expect(find.text('Aucune réservation pour le moment'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
