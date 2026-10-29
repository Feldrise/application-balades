/// Formats an amount in cents, "Gratuit" when it is zero.
String formatCents(int cents) {
  if (cents == 0) return 'Gratuit';
  final euros = cents ~/ 100;
  final rest = cents % 100;
  return rest == 0 ? '$euros €' : '$euros,${rest.toString().padLeft(2, '0')} €';
}

/// Formats an amount in euros, as given by the API for a tariff.
String formatEuros(double euros) {
  final cents = (euros * 100).round();
  return cents == 0 ? '0 €' : formatCents(cents);
}
