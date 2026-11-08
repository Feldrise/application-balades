import 'package:balade/features/admin/design/design.dart';
import 'package:balade/features/admin/reservations_management/admin_reservation_messages.dart';
import 'package:balade/features/admin/reservations_management/status_change/reservation_status_change.dart';
import 'package:balade/features/admin/reservations_management/widgets/booker_contact_buttons.dart';
import 'package:balade/features/admin/reservations_management/widgets/managed_participant_row.dart';
import 'package:balade/features/admin/reservations_management/widgets/reservation_edit_dialog.dart';
import 'package:balade/features/authentication/authentication_provider.dart';
import 'package:balade/features/authentication/permission_provider.dart';
import 'package:balade/features/reservations/models/reservation/reservation.dart';
import 'package:balade/features/reservations/providers/reservation_providers.dart';
import 'package:balade/features/reservations/reservation_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

/// Opens the detail of a reservation in a bottom sheet: participants, payment, dates, contact, « Changer le statut »,
/// and the edit and delete actions as before the redesign.
///
/// [onChanged] is called once the reservation changed (status, participants) or was deleted, so that the caller reloads.
/// [onOpenRamble], when given, adds « Ouvrir la feuille de balade ».
Future<void> showReservationDetailSheet(BuildContext context, {required Reservation reservation, required VoidCallback onChanged, VoidCallback? onOpenRamble}) {
  return showManagementBottomSheet<void>(
    context: context,
    title: bookerName(reservation),
    subtitle: reservation.contactEmail,
    builder: (context) => _ReservationDetail(reservation: reservation, onChanged: onChanged, onOpenRamble: onOpenRamble),
  );
}

class _ReservationDetail extends ConsumerWidget {
  const _ReservationDetail({required this.reservation, required this.onChanged, this.onOpenRamble});

  final Reservation reservation;
  final VoidCallback onChanged;
  final VoidCallback? onOpenRamble;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final df = DateFormat('dd/MM/yyyy HH:mm');
    final permission = ref.watch(permissionProvider);
    final isAdmin = permission?.isAdmin() == true;
    final canEdit = isAdmin || permission?.canUpdateRegistrationDetails() == true || canChangeReservationStatus(permission);
    final canDelete = isAdmin || permission?.canManageRegistration() == true;
    final paid = isReservationPaid(reservation);

    void changed() {
      Navigator.of(context).pop();
      onChanged();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            ReservationStatusBadge(status: reservation.status),
            const SizedBox(width: 10),
            Expanded(
              child: Text(formatReservationPayment(reservation), style: theme.textTheme.labelMedium?.copyWith(color: paid ? ManagementColors.green : ManagementColors.muted)),
            ),
            BookerContactButtons(reservation: reservation),
          ],
        ),
        if (reservation.contactPhone?.isNotEmpty ?? false) Text(reservation.contactPhone!, style: theme.textTheme.bodySmall),
        if (reservation.ramble != null) ...[
          const SizedBox(height: 12),
          Text('BALADE', style: theme.textTheme.labelSmall),
          const SizedBox(height: 4),
          Text(reservation.ramble!.title, style: theme.textTheme.bodyMedium),
          if (reservation.ramble!.date != null) Text(DateFormat("d MMMM yyyy · HH'h'mm", 'fr').format(reservation.ramble!.date!.toLocal()), style: theme.textTheme.bodySmall),
        ],
        const SizedBox(height: 12),
        Text('PARTICIPANTS · ${reservation.participants.length}', style: theme.textTheme.labelSmall),
        for (final participant in reservation.participants) ManagedParticipantRow(participant: participant),
        const SizedBox(height: 12),
        Text('DATES', style: theme.textTheme.labelSmall),
        const SizedBox(height: 4),
        Text('Réservée le ${df.format(reservation.createdAt)}', style: theme.textTheme.bodySmall),
        if (reservation.confirmationDeadline != null) Text('À confirmer avant le ${df.format(reservation.confirmationDeadline!)}', style: theme.textTheme.bodySmall),
        if (reservation.confirmationDate != null) Text('Confirmée le ${df.format(reservation.confirmationDate!)}', style: theme.textTheme.bodySmall),
        if (reservation.cancellationDate != null) Text('Annulée le ${df.format(reservation.cancellationDate!)}', style: theme.textTheme.bodySmall),
        if (reservation.cancellationReason?.isNotEmpty ?? false) Text('Motif : ${reservation.cancellationReason}', style: theme.textTheme.bodySmall),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ChangeStatusButton(reservation: reservation, onChanged: (_) => changed()),
            if (canEdit)
              OutlinedButton.icon(
                onPressed: () async {
                  final saved = await showDialog<Reservation>(
                    context: context,
                    builder: (context) => ReservationEditDialog(reservation: reservation),
                  );
                  if (saved != null && context.mounted) changed();
                },
                icon: const Icon(Icons.edit_outlined, size: 18),
                label: const Text('Modifier'),
              ),
            if (onOpenRamble != null)
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                  onOpenRamble!();
                },
                icon: const Icon(Icons.assignment_outlined, size: 18),
                label: const Text('Ouvrir la feuille de balade'),
              ),
            if (canDelete)
              TextButton.icon(
                style: TextButton.styleFrom(foregroundColor: ManagementColors.cancelled),
                onPressed: () => _delete(context, ref, changed),
                icon: const Icon(Icons.delete_outline, size: 18),
                label: const Text('Supprimer'),
              ),
          ],
        ),
      ],
    );
  }

  Future<void> _delete(BuildContext context, WidgetRef ref, VoidCallback changed) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer la réservation ?'),
        content: Text('Supprimer la réservation de ${bookerName(reservation)} ? Les places qu\'elle occupe iront à la liste d\'attente.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Retour')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: ManagementColors.cancelled),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
    final token = ref.read(authenticationProvider)?.token;
    if (confirmed != true || token == null || !context.mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(reservationsServiceProvider).deleteReservation(reservation.id, token: token);
      messenger.showSnackBar(const SnackBar(content: Text('Réservation supprimée')));
      if (context.mounted) changed();
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Erreur : ${adminReservationErrorMessage(e)}')));
    }
  }
}
