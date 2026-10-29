import 'package:balade/features/reservations/reservation_format.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('formatCents', () {
    test('drops the decimals of whole euros', () => expect(formatCents(3100), '31 €'));
    test('uses a decimal comma for cents', () => expect(formatCents(1850), '18,50 €'));
    test('keeps the leading zero of small amounts', () => expect(formatCents(5), '0,05 €'));
    test('shows a free reservation as Gratuit', () => expect(formatCents(0), 'Gratuit'));
  });

  group('formatEuros', () {
    test('formats a tariff amount in euros', () => expect(formatEuros(12.5), '12,50 €'));
    test('formats a round tariff without decimals', () => expect(formatEuros(6), '6 €'));
  });
}
