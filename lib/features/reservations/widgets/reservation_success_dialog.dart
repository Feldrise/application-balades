import 'package:balade/features/ramble/models/ramble/ramble.dart';
import 'package:balade/features/reservations/models/reservation/reservation.dart';
import 'package:balade/features/reservations/reservation_format.dart';
import 'package:balade/features/reservations/widgets/reservation_notices.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Shown once the API has accepted the reservation: summary and what comes next. No payment here.
class ReservationSuccessDialog extends StatelessWidget {
  const ReservationSuccessDialog({super.key, required this.reservation, required this.ramble});

  final Reservation reservation;
  final Ramble ramble;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final status = ReservationStatus.tryParse(reservation.status);

    return AlertDialog(
      icon: const Icon(Icons.check_circle, color: Colors.green, size: 48),
      title: Text(status == ReservationStatus.waitingList ? 'Réservation en liste d\'attente' : 'Réservation enregistrée !'),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(ramble.title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Text('Participants', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              for (final participant in reservation.participants)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Expanded(child: Text('${participant.firstName} ${participant.lastName}')),
                      if (participant.priceLabel.isNotEmpty) Text(participant.priceLabel, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                    ],
                  ),
                ),
              const Divider(height: 24),
              Row(
                children: [
                  Expanded(child: Text('Montant estimé', style: theme.textTheme.titleSmall)),
                  Text(formatCents(reservation.estimatedAmount), style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.primary)),
                ],
              ),
              const SizedBox(height: 16),
              ..._nextSteps(status),
              const SizedBox(height: 12),
              Text('Un récapitulatif a été envoyé à ${reservation.contactEmail}.', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Fermer')),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop();
            context.go('/mes-reservations');
          },
          child: const Text('Voir mes réservations'),
        ),
      ],
    );
  }

  List<Widget> _nextSteps(ReservationStatus? status) {
    switch (status) {
      case ReservationStatus.waitingList:
        return const [ReservationNotice(icon: Icons.hourglass_top, color: Colors.orange, message: 'Toute votre réservation est en liste d\'attente : elle passera en entier dès que la place le permettra.')];
      case ReservationStatus.confirmed:
        return const [ReservationNotice(icon: Icons.event_available, message: 'La balade a lieu dans moins de 3 jours : votre réservation est déjà confirmée.')];
      default:
        return const [ReservationNotice(icon: Icons.info_outline, message: kConfirmationNotice)];
    }
  }
}
