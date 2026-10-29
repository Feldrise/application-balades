import 'package:balade/features/admin/reservations_management/admin_reservation_messages.dart';
import 'package:balade/features/admin/reservations_management/providers/admin_reservations_provider.dart';
import 'package:balade/features/authentication/authentication_provider.dart';
import 'package:balade/features/ramble/models/ramble/ramble.dart';
import 'package:balade/features/reservations/models/reservation/reservation.dart';
import 'package:balade/features/reservations/providers/reservation_providers.dart';
import 'package:balade/features/reservations/reservation_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Lets an admin or a guide set the status of a reservation and correct its participants.
/// It pops the reservation as saved when something changed.
class ReservationEditDialog extends ConsumerStatefulWidget {
  const ReservationEditDialog({super.key, required this.reservation});

  final Reservation reservation;

  @override
  ConsumerState<ReservationEditDialog> createState() => _ReservationEditDialogState();
}

class _ParticipantEdit {
  _ParticipantEdit(this.participant)
    : firstName = TextEditingController(text: participant.firstName),
      lastName = TextEditingController(text: participant.lastName),
      priceLabel = participant.priceLabel;

  final Participant participant;
  final TextEditingController firstName;
  final TextEditingController lastName;
  String priceLabel;

  void dispose() {
    firstName.dispose();
    lastName.dispose();
  }
}

class _ReservationEditDialogState extends ConsumerState<ReservationEditDialog> {
  late final List<_ParticipantEdit> _participants = widget.reservation.participants.map(_ParticipantEdit.new).toList();
  final TextEditingController _reason = TextEditingController();
  late String _status = widget.reservation.status;
  bool _sendEmail = false;
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    for (final participant in _participants) {
      participant.dispose();
    }
    _reason.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final reservation = widget.reservation;
    final ramble = ref.watch(reservationRambleProvider(reservation.rambleId)).valueOrNull;
    final name = bookerName(reservation);

    return AlertDialog(
      title: Text('Réservation de $name'),
      content: SizedBox(
        width: 560,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(reservation.contactEmail, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              if (reservation.ramble != null) Text(reservation.ramble!.title, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              const SizedBox(height: 16),
              Text('Statut', style: theme.textTheme.titleSmall),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: _status,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                items: [for (final status in ReservationStatus.values) DropdownMenuItem(value: status.apiValue, child: Text(status.label))],
                onChanged: _isLoading ? null : (value) => setState(() => _status = value!),
              ),
              if (_status != reservation.status) ...[
                const SizedBox(height: 12),
                if (_status == 'cancelled') ...[
                  TextField(
                    controller: _reason,
                    decoration: const InputDecoration(labelText: 'Motif (optionnel)', border: OutlineInputBorder()),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 4),
                ],
                CheckboxListTile(
                  title: const Text('Prévenir la personne qui réserve par email'),
                  value: _sendEmail,
                  onChanged: _isLoading ? null : (value) => setState(() => _sendEmail = value ?? false),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                ),
                Text(
                  'La réservation n\'est jamais scindée : pour la remettre en attente ou confirmée, tous ses participants doivent tenir dans les places restantes.',
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
              ],
              const SizedBox(height: 20),
              Text('Participants', style: theme.textTheme.titleSmall),
              if (reservation.hasSuccessfulPayment) ...[
                const SizedBox(height: 4),
                Text('La réservation est payée : les tarifs sont figés, les noms peuvent être corrigés.', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              ],
              const SizedBox(height: 8),
              for (final participant in _participants) _buildParticipant(theme, participant, ramble),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(_error!, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.error)),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: _isLoading ? null : () => Navigator.of(context).pop(), child: const Text('Annuler')),
        FilledButton(
          onPressed: _isLoading ? null : _save,
          child: _isLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Enregistrer'),
        ),
      ],
    );
  }

  Widget _buildParticipant(ThemeData theme, _ParticipantEdit edit, Ramble? ramble) {
    final labels = ramble?.prices.map((price) => price.label).toList() ?? const <String>[];
    // A migrated participant can have a tariff the ramble does not propose: it has to be chosen again.
    final tariffs = {...labels, if (edit.priceLabel.isNotEmpty && !labels.contains(edit.priceLabel)) edit.priceLabel}.toList();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: TextField(
              controller: edit.firstName,
              decoration: const InputDecoration(labelText: 'Prénom', border: OutlineInputBorder(), isDense: true),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: edit.lastName,
              decoration: const InputDecoration(labelText: 'Nom', border: OutlineInputBorder(), isDense: true),
            ),
          ),
          if (tariffs.isNotEmpty) ...[
            const SizedBox(width: 8),
            Expanded(
              child: DropdownButtonFormField<String>(
                initialValue: tariffs.contains(edit.priceLabel) ? edit.priceLabel : null,
                isExpanded: true,
                decoration: InputDecoration(
                  labelText: 'Tarif',
                  helperText: edit.participant.priceMissing ? 'Tarif à préciser' : null,
                  border: const OutlineInputBorder(),
                  isDense: true,
                ),
                items: [
                  for (final label in tariffs)
                    DropdownMenuItem(
                      value: label,
                      child: Text(labels.contains(label) ? label : '$label (inconnu)', overflow: TextOverflow.ellipsis),
                    ),
                ],
                onChanged: _isLoading ? null : (value) => setState(() => edit.priceLabel = value ?? edit.priceLabel),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _save() async {
    final token = ref.read(authenticationProvider)?.token;
    if (token == null) return;

    final service = ref.read(reservationsServiceProvider);
    final reservation = widget.reservation;
    Reservation? saved;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      for (final edit in _participants) {
        final firstName = edit.firstName.text.trim();
        final lastName = edit.lastName.text.trim();
        final changesName = firstName != edit.participant.firstName || lastName != edit.participant.lastName;
        final changesPrice = edit.priceLabel != edit.participant.priceLabel;
        if (!changesName && !changesPrice) continue;

        saved = await service.updateParticipantAsAdmin(
          reservation.id,
          edit.participant.id,
          firstName: firstName != edit.participant.firstName ? firstName : null,
          lastName: lastName != edit.participant.lastName ? lastName : null,
          priceLabel: changesPrice ? edit.priceLabel : null,
          token: token,
        );
      }

      if (_status != reservation.status) {
        final reason = _reason.text.trim();
        saved = await service.updateReservationStatus(
          reservation.id,
          status: _status,
          reason: _status == 'cancelled' && reason.isNotEmpty ? reason : null,
          sendEmail: _sendEmail,
          token: token,
        );
      }
    } catch (e) {
      // What was saved before the refusal is shown by the list once it is loaded again.
      if (saved != null) ref.read(adminReservationsProvider.notifier).refreshReservation(saved);
      if (mounted) setState(() {
        _isLoading = false;
        _error = adminReservationErrorMessage(e);
      });
      return;
    }

    if (saved != null) ref.read(adminReservationsProvider.notifier).refreshReservation(saved);
    if (mounted) {
      Navigator.of(context).pop(saved);
      if (saved != null) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Réservation mise à jour')));
    }
  }
}
