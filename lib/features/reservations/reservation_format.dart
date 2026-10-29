import 'package:balade/features/reservations/models/reservation/reservation.dart';

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

/// Formats the estimated amount of a reservation, without presenting unknown tariffs as free.
String formatReservationAmount(Reservation reservation) {
  if (!reservation.hasMissingPrices) return formatCents(reservation.estimatedAmount);
  if (reservation.estimatedAmount == 0) return 'Tarif à préciser';
  return '${formatCents(reservation.estimatedAmount)} + tarifs à préciser';
}

/// The name of the booker: their participant line, or else the contact email.
String bookerName(Reservation reservation) {
  for (final participant in reservation.participants) {
    if (participant.isBooker) return '${participant.firstName} ${participant.lastName}';
  }
  return reservation.contactEmail;
}
