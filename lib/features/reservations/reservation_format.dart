import 'package:balade/features/reservations/models/reservation/reservation.dart';
import 'package:balade/features/reservations/widgets/reservation_actions.dart';
import 'package:intl/intl.dart';

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

/// The reservation is paid in full: something was paid and nothing is left to pay.
bool isReservationPaid(Reservation reservation) => reservation.amountPaid > 0 && reservation.amountDue <= 0;

/// The payment of a reservation as the management area shows it: « Payé 24 € » once paid, else the amount.
String formatReservationPayment(Reservation reservation) => isReservationPaid(reservation) ? 'Payé ${formatCents(reservation.amountPaid)}' : formatReservationAmount(reservation);

/// The tariff of a participant, e.g. « Adulte · 12 € », or « tarif à préciser » when it is unknown (migrated data).
String formatParticipantTariff(Participant participant) {
  if (participant.priceMissing) return 'tarif à préciser';
  if (participant.priceLabel.isEmpty) return '';
  return '${participant.priceLabel} · ${formatEuros(participant.priceAmount)}';
}

/// « À confirmer entre le 28 novembre à 10:00 et le 30 novembre à 22:00 », null when the ramble has no date.
String? confirmationPeriodText(Reservation reservation) {
  final opening = confirmationOpening(reservation);
  final deadline = confirmationDeadline(reservation);
  if (opening == null || deadline == null) return null;
  final format = DateFormat('d MMMM \'à\' HH:mm', 'fr');
  return 'À confirmer entre le ${format.format(opening.toLocal())} et le ${format.format(deadline.toLocal())}';
}

/// Where a reservation stands, in plain words for the booker.
String reservationStatusExplanation(Reservation reservation, {required DateTime now}) {
  switch (ReservationStatus.tryParse(reservation.status)) {
    case ReservationStatus.pending:
      final reason = confirmationUnavailableReason(reservation, now: now);
      final open = canConfirm(reservation, now: now);
      final base = open
          ? 'Votre place est réservée. Confirmez et payez maintenant pour la garder : sans confirmation à temps, la réservation est annulée.'
          : 'Votre place est réservée, mais elle ne sera définitive qu\'une fois confirmée et payée pendant la période de confirmation. Sans confirmation à temps, la réservation est annulée.';
      // Before the opening the period says it all; the reason matters when there is no period or when it is over.
      final opening = confirmationOpening(reservation);
      final beforeOpening = opening != null && now.isBefore(opening);
      return reason != null && !beforeOpening ? '$base $reason' : base;
    case ReservationStatus.confirmed:
      return 'Votre place est confirmée. Retrouvez ci-dessous où et quand vous présenter, et qui contacter.';
    case ReservationStatus.waitingList:
      return 'Vous êtes en liste d\'attente : vous passerez dès que des places se libèrent. Toute la réservation passera en entier dès que la place le permettra.';
    case ReservationStatus.cancelled:
      return 'Cette réservation est annulée.';
    case null:
      return '';
  }
}
