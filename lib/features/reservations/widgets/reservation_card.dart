import 'package:balade/features/reservations/models/reservation/reservation.dart';
import 'package:balade/features/reservations/reservation_format.dart';
import 'package:balade/features/reservations/widgets/reservation_actions.dart';
import 'package:balade/features/reservations/widgets/reservation_status_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/// One reservation in full: ramble, status, participants with their tariffs, amount and payments,
/// with the booker's actions on it.
class ReservationCard extends StatelessWidget {
  const ReservationCard({super.key, required this.reservation});

  final Reservation reservation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ramble = reservation.ramble;
    final date = ramble?.date;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => context.go('/balades/${reservation.rambleId}'),
                    child: Text(ramble?.title ?? 'Balade', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 8),
                ReservationStatusChip(status: reservation.status),
              ],
            ),
            if (date != null) ...[
              const SizedBox(height: 8),
              _InfoRow(icon: Icons.event, text: '${DateFormat('EEEE dd MMMM yyyy', 'fr').format(date)} à ${DateFormat('HH:mm').format(date)}'),
            ],
            if (ramble?.location != null && ramble!.location!.isNotEmpty) ...[const SizedBox(height: 4), _InfoRow(icon: Icons.place_outlined, text: ramble.location!)],
            if (reservation.status == 'waiting_list') ...[
              const SizedBox(height: 8),
              Text('Toute la réservation est en liste d\'attente et passera en entier dès que la place le permettra.', style: theme.textTheme.bodySmall?.copyWith(color: Colors.blue.shade700)),
            ],
            const Divider(height: 24),
            Text(reservation.participants.length > 1 ? 'Participants (${reservation.participants.length})' : 'Participant', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            for (final participant in reservation.participants) _ParticipantRow(reservation: reservation, participant: participant),
            const Divider(height: 24),
            Row(
              children: [
                Expanded(child: Text('Montant', style: theme.textTheme.titleSmall)),
                Text(formatReservationAmount(reservation), style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.primary)),
              ],
            ),
            if (reservation.payments.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text('Paiements', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              for (final payment in reservation.payments) _PaymentRow(payment: payment),
            ],
            if (reservation.status != 'cancelled') ...[const SizedBox(height: 16), _ReservationActions(reservation: reservation)],
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 16, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 6),
        Expanded(child: Text(text, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant))),
      ],
    );
  }
}

class _ParticipantRow extends ConsumerWidget {
  const _ParticipantRow({required this.reservation, required this.participant});

  final Reservation reservation;
  final Participant participant;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final tariffStyle = theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Icon(participant.isBooker ? Icons.person : Icons.person_outline, size: 18, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(child: Text('${participant.firstName} ${participant.lastName}${participant.isBooker ? ' (vous)' : ''}')),
          if (participant.priceMissing)
            Text('Tarif à préciser', style: tariffStyle?.copyWith(color: Colors.orange.shade800, fontWeight: FontWeight.w600))
          else if (participant.priceLabel.isNotEmpty)
            Text('${participant.priceLabel} · ${formatEuros(participant.priceAmount)}', style: tariffStyle),
          if (canModifyParticipants(reservation))
            IconButton(
              onPressed: () => editParticipant(context, ref, reservation, participant),
              icon: const Icon(Icons.edit_outlined, size: 18),
              tooltip: 'Modifier',
              visualDensity: VisualDensity.compact,
            ),
          if (reservation.status != 'cancelled')
            IconButton(
              onPressed: () => removeParticipant(context, ref, reservation, participant),
              icon: Icon(Icons.person_remove_outlined, size: 18, color: theme.colorScheme.error),
              tooltip: 'Retirer',
              visualDensity: VisualDensity.compact,
            ),
        ],
      ),
    );
  }
}

class _ReservationActions extends ConsumerWidget {
  const _ReservationActions({required this.reservation});

  final Reservation reservation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.end,
      children: [
        if (canAddParticipants(reservation))
          FilledButton.tonalIcon(onPressed: () => showAddParticipantsSheet(context, reservation), icon: const Icon(Icons.group_add), label: const Text('Ajouter des participants')),
        OutlinedButton.icon(
          onPressed: () => cancelReservation(context, ref, reservation),
          icon: Icon(Icons.event_busy, color: theme.colorScheme.error),
          label: Text('Annuler la réservation', style: TextStyle(color: theme.colorScheme.error)),
        ),
      ],
    );
  }
}

class _PaymentRow extends StatelessWidget {
  const _PaymentRow({required this.payment});

  final ReservationPayment payment;

  static const _labels = {'pending': 'En attente', 'succeeded': 'Payé', 'failed': 'Échoué', 'cancelled': 'Annulé', 'refunded': 'Remboursé'};

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final date = payment.paidAt ?? payment.createdAt;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(child: Text('${DateFormat('dd/MM/yyyy').format(date)} · ${_labels[payment.status] ?? payment.status}')),
          Text(formatCents(payment.amount), style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
