import 'package:balade/features/reservations/reservations_service.dart';

/// The message shown to an admin or a guide when the API refuses a change on a reservation.
String adminReservationErrorMessage(Object error) {
  if (error is! ReservationException) return error.toString().replaceFirst('Exception: ', '');

  switch (error.reason) {
    case 'not_enough_places':
      return 'Pas assez de places restantes : la réservation doit tenir en entier dans les places libres de la balade.';
    case 'reservation_already_exists':
      return 'Cette personne a déjà une autre réservation active sur cette balade.';
    case 'reservation_paid':
      return 'La réservation est déjà payée : le tarif de ses participants ne peut plus être modifié.';
    case 'reservation_cancelled':
      return 'Cette réservation est annulée : remettez-la d\'abord en attente ou confirmée.';
    case 'invalid_price':
      return 'Ce tarif n\'existe pas pour cette balade.';
    default:
      return error.message;
  }
}
