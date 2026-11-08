import 'package:balade/core/permission.dart';
import 'package:balade/features/admin/design/design.dart';
import 'package:balade/features/admin/reservations_management/admin_reservation_messages.dart';
import 'package:balade/features/authentication/authentication_provider.dart';
import 'package:balade/features/authentication/permission_provider.dart';
import 'package:balade/features/reservations/models/reservation/reservation.dart';
import 'package:balade/features/reservations/providers/reservation_providers.dart';
import 'package:balade/features/reservations/reservation_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Changing the status of a reservation by hand: the admin, and the accounts allowed to change a status
/// (unchanged by the redesign).
bool canChangeReservationStatus(Permission? permission) => permission?.isAdmin() == true || permission?.canUpdateRegistrationStatus() == true;

/// What choosing a status means, in one line.
String reservationStatusExplanation(ReservationStatus status) => switch (status) {
  ReservationStatus.confirmed => 'Places réservées : la personne qui réserve est attendue',
  ReservationStatus.pending => 'Places réservées, en attente de la confirmation de la personne qui réserve',
  ReservationStatus.waitingList => 'Aucune place réservée : passe dès que la place le permet',
  ReservationStatus.cancelled => 'Les places sont libérées',
};

/// Lets the user pick a new status for [reservation], confirms the consequential ones, then asks the API.
/// The booker is told by email. Returns the updated reservation, or null when nothing changed.
Future<Reservation?> changeReservationStatus(BuildContext context, WidgetRef ref, Reservation reservation) async {
  final current = ReservationStatus.tryParse(reservation.status);
  final picked = await showManagementBottomSheet<ReservationStatus>(
    context: context,
    title: 'Changer le statut',
    subtitle: '${bookerName(reservation)} · ${_participants(reservation.participants.length)}',
    builder: (context) => _StatusPicker(current: current),
  );
  if (picked == null || picked == current || !context.mounted) return null;

  String? reason;
  if (picked != ReservationStatus.pending) {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => _StatusConfirmation(reservation: reservation, status: picked, onReason: (value) => reason = value),
    );
    if (confirmed != true || !context.mounted) return null;
  }

  final token = ref.read(authenticationProvider)?.token;
  if (token == null) return null;
  final messenger = ScaffoldMessenger.of(context);
  try {
    final updated = await ref.read(reservationsServiceProvider).updateReservationStatus(reservation.id, status: picked.apiValue, reason: reason, sendEmail: true, token: token);
    messenger.showSnackBar(SnackBar(content: Text('Réservation passée en « ${reservationStatusLabel(picked)} »')));
    return updated;
  } catch (e) {
    messenger.showSnackBar(SnackBar(content: Text('Erreur : ${adminReservationErrorMessage(e)}')));
    return null;
  }
}

String _participants(int count) => '$count participant${count > 1 ? 's' : ''}';

class _StatusPicker extends StatelessWidget {
  const _StatusPicker({required this.current});

  final ReservationStatus? current;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final status in [ReservationStatus.confirmed, ReservationStatus.pending, ReservationStatus.waitingList, ReservationStatus.cancelled])
          ListTile(
            contentPadding: EdgeInsets.zero,
            enabled: status != current,
            leading: Icon(status == current ? Icons.radio_button_checked : Icons.radio_button_off, color: reservationStatusColor(status)),
            title: Text(reservationStatusLabel(status)),
            subtitle: Text(status == current ? 'Statut actuel' : reservationStatusExplanation(status)),
            onTap: () => Navigator.of(context).pop(status),
          ),
      ],
    );
  }
}

class _StatusConfirmation extends StatelessWidget {
  const _StatusConfirmation({required this.reservation, required this.status, required this.onReason});

  final Reservation reservation;
  final ReservationStatus status;
  final ValueChanged<String?> onReason;

  @override
  Widget build(BuildContext context) {
    final cancelling = status == ReservationStatus.cancelled;
    final (title, message, action) = switch (status) {
      ReservationStatus.cancelled => (
        'Annuler la réservation ?',
        'Les places de ses ${_participants(reservation.participants.length)} seront libérées et la personne qui réserve sera prévenue par email.'
            '${reservation.hasSuccessfulPayment ? ' Elle a déjà payé : la plateforme ne fait aucun remboursement automatique, elle sera invitée à contacter le guide.' : ''}',
        'Annuler la réservation',
      ),
      ReservationStatus.confirmed => (
        'Forcer la confirmation ?',
        'La réservation sera confirmée sans la confirmation de la personne qui réserve ni son paiement en ligne.',
        'Confirmer la réservation',
      ),
      _ => (
        'Mettre en liste d\'attente ?',
        'Les places de la réservation seront libérées. Elle passera dès que la place le permet.',
        'Mettre en liste d\'attente',
      ),
    };

    return AlertDialog(
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(message),
          if (cancelling) ...[
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(labelText: 'Motif (optionnel)', border: OutlineInputBorder()),
              maxLines: 2,
              onChanged: (value) => onReason(value.trim().isEmpty ? null : value.trim()),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Retour')),
        FilledButton(
          style: cancelling ? FilledButton.styleFrom(backgroundColor: ManagementColors.cancelled) : null,
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(action),
        ),
      ],
    );
  }
}

/// The status badge of a reservation, clickable to change the status for those allowed to.
/// [onChanged] gets the updated reservation.
class ChangeableStatusBadge extends ConsumerWidget {
  const ChangeableStatusBadge({super.key, required this.reservation, required this.onChanged});

  final Reservation reservation;
  final ValueChanged<Reservation> onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allowed = canChangeReservationStatus(ref.watch(permissionProvider));
    return ReservationStatusBadge(
      status: reservation.status,
      onTap: allowed
          ? () async {
              final updated = await changeReservationStatus(context, ref, reservation);
              if (updated != null) onChanged(updated);
            }
          : null,
    );
  }
}

/// The « Changer le statut » button of a reservation detail, shown to those allowed to change a status.
class ChangeStatusButton extends ConsumerWidget {
  const ChangeStatusButton({super.key, required this.reservation, required this.onChanged});

  final Reservation reservation;
  final ValueChanged<Reservation> onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!canChangeReservationStatus(ref.watch(permissionProvider))) return const SizedBox.shrink();
    return OutlinedButton.icon(
      onPressed: () async {
        final updated = await changeReservationStatus(context, ref, reservation);
        if (updated != null) onChanged(updated);
      },
      icon: const Icon(Icons.swap_horiz, size: 18),
      label: const Text('Changer le statut'),
    );
  }
}
