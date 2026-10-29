import 'package:flutter/material.dart';

/// What happens at J-3, shown on the ramble page, in the form and on the success screen.
const String kConfirmationNotice = 'Vous ne payez pas maintenant : la confirmation et le paiement ont lieu 3 jours avant la balade.';

const String kWaitingListWarning = 'Il n\'y a pas assez de places pour tous les participants : toute la réservation sera placée en liste d\'attente et passera en entier dès que la place le permettra.';

class ReservationNotice extends StatelessWidget {
  const ReservationNotice({super.key, required this.icon, required this.message, this.color});

  final IconData icon;
  final String message;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tint = color ?? theme.colorScheme.primary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: tint.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: tint.withValues(alpha: 0.3))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: tint),
          const SizedBox(width: 8),
          Expanded(child: Text(message, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface))),
        ],
      ),
    );
  }
}
