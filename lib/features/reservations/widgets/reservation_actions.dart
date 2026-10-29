import 'dart:math';

import 'package:balade/features/authentication/authentication_provider.dart';
import 'package:balade/features/reservations/models/reservation/reservation.dart';
import 'package:balade/features/reservations/providers/reservation_providers.dart';
import 'package:balade/features/reservations/reservations_service.dart';
import 'package:balade/features/reservations/widgets/add_participants_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Participants can be modified until the reservation is paid.
bool canModifyParticipants(Reservation reservation) => reservation.status != 'cancelled' && !reservation.hasSuccessfulPayment;

/// Participants can be added to a reservation that is not cancelled; added to a confirmed reservation,
/// they are confirmed with it and their tariffs are paid right away.
bool canAddParticipants(Reservation reservation) => reservation.status != 'cancelled';

/// How long before the ramble the booker is asked to confirm and pay.
const kConfirmationPeriod = Duration(days: 3);

/// A pending reservation is to be confirmed once the confirmation is requested, 3 days before the ramble.
bool canConfirm(Reservation reservation, {DateTime? now}) {
  if (reservation.status != 'pending') return false;
  if (reservation.confirmationDeadline != null) return true;
  final date = reservation.ramble?.date;
  return date != null && date.difference(now ?? DateTime.now()) <= kConfirmationPeriod;
}

/// The amount in cents left to pay: the estimated amount minus the succeeded payments.
int amountDue(Reservation reservation) {
  final paid = reservation.payments.where((p) => p.status == 'succeeded').fold(0, (sum, p) => sum + p.amount);
  return max(reservation.estimatedAmount - paid, 0);
}

/// Where the booker pays what their reservation still owes.
String reservationPaymentLocation(int reservationId) => '/mes-reservations/$reservationId/paiement';

/// The message shown to the booker when the API refuses a change on their reservation.
String reservationErrorMessage(ReservationException error) {
  switch (error.reason) {
    case 'not_enough_places':
      return 'Il ne reste pas assez de places sur cette balade pour ajouter tous ces participants : aucun n\'a été ajouté.';
    case 'too_many_participants':
      return 'Votre réservation compterait trop de participants pour cette balade.';
    case 'invalid_price':
      return 'Chaque participant doit avoir un tarif de cette balade.';
    case 'reservation_paid':
      return 'La réservation est déjà payée : ses participants ne peuvent plus être modifiés.';
    case 'reservation_cancelled':
      return 'Cette réservation est annulée.';
    case 'missing_prices':
      return 'Précisez d\'abord le tarif de chaque participant : le montant à payer doit être complet.';
    case 'reservation_waiting_list':
      return 'Votre réservation est en liste d\'attente : elle ne peut pas encore être confirmée.';
    case 'second_booker':
      return 'Un seul participant peut être la personne qui réserve.';
    default:
      return error.message;
  }
}

/// Opens the sheet to add participants to [reservation].
Future<void> showAddParticipantsSheet(BuildContext context, Reservation reservation) {
  return showModalBottomSheet<void>(context: context, isScrollControlled: true, useSafeArea: true, builder: (_) => AddParticipantsSheet(reservation: reservation));
}

/// Runs [change] with the booker's token, refreshes "Mes réservations" and tells the refusal of the API.
/// Returns the reservation as saved, or null when the change failed.
Future<Reservation?> _runChange(BuildContext context, WidgetRef ref, Future<Reservation> Function(ReservationsService service, String token) change) async {
  final messenger = ScaffoldMessenger.of(context);
  final token = ref.read(authenticationProvider)?.token;
  if (token == null) {
    messenger.showSnackBar(const SnackBar(content: Text('Veuillez vous reconnecter.')));
    return null;
  }

  try {
    final reservation = await change(ref.read(reservationsServiceProvider), token);
    ref.invalidate(userReservationsProvider);
    ref.invalidate(reservationProvider);
    return reservation;
  } on ReservationException catch (e) {
    messenger.showSnackBar(SnackBar(content: Text(reservationErrorMessage(e))));
  } catch (_) {
    messenger.showSnackBar(const SnackBar(content: Text('Impossible de joindre le serveur. Réessayez dans un instant.')));
  }
  return null;
}

Future<bool> _confirm(BuildContext context, {required String title, required String message, required String action}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Retour')),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
          child: Text(action),
        ),
      ],
    ),
  );
  return confirmed ?? false;
}

/// Removes [participant] after confirmation; removing the last one cancels the reservation.
Future<void> removeParticipant(BuildContext context, WidgetRef ref, Reservation reservation, Participant participant) async {
  final isLast = reservation.participants.length == 1;
  final confirmed = await _confirm(
    context,
    title: 'Retirer ${participant.firstName} ${participant.lastName} ?',
    message: isLast ? 'C\'est le dernier participant : toute la réservation sera annulée et ses places libérées.' : 'Sa place sera libérée.',
    action: 'Retirer',
  );
  if (!confirmed || !context.mounted) return;

  final saved = await _runChange(context, ref, (service, token) => service.removeParticipant(reservation.id, participant.id, token: token));
  if (saved != null && context.mounted) await _afterRelease(context, saved, isLast ? 'Réservation annulée' : 'Participant retiré');
}

/// Cancels the whole reservation after confirmation.
Future<void> cancelReservation(BuildContext context, WidgetRef ref, Reservation reservation) async {
  final confirmed = await _confirm(
    context,
    title: 'Annuler la réservation ?',
    message: 'Toute la réservation (${reservation.participants.length} participant${reservation.participants.length > 1 ? 's' : ''}) sera annulée et ses places libérées.',
    action: 'Annuler la réservation',
  );
  if (!confirmed || !context.mounted) return;

  final saved = await _runChange(context, ref, (service, token) => service.cancelReservation(reservation.id, token: token));
  if (saved != null && context.mounted) await _afterRelease(context, saved, 'Réservation annulée');
}

/// After a removal or a cancellation, invites the booker of a paid reservation to contact the guide.
Future<void> _afterRelease(BuildContext context, Reservation saved, String done) async {
  if (!saved.hasSuccessfulPayment) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(done)));
    return;
  }
  await showDialog<void>(context: context, builder: (_) => ContactGuideDialog(rambleId: saved.rambleId, title: done));
}

/// Changes the name or tariff of a participant, before payment.
Future<void> editParticipant(BuildContext context, WidgetRef ref, Reservation reservation, Participant participant) async {
  final result = await showDialog<({String firstName, String lastName, String priceLabel})>(
    context: context,
    builder: (_) => _EditParticipantDialog(reservation: reservation, participant: participant),
  );
  if (result == null || !context.mounted) return;

  final saved = await _runChange(
    context,
    ref,
    (service, token) => service.updateParticipant(reservation.id, participant.id, firstName: result.firstName, lastName: result.lastName, priceLabel: result.priceLabel, token: token),
  );
  if (saved != null && context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Participant modifié')));
}

/// No automatic refund: the booker of a paid reservation is invited to contact the guide.
class ContactGuideDialog extends ConsumerWidget {
  const ContactGuideDialog({super.key, required this.rambleId, required this.title});

  final int rambleId;
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final guides = ref.watch(reservationRambleProvider(rambleId)).value?.guides ?? const [];

    return AlertDialog(
      icon: Icon(Icons.support_agent, color: theme.colorScheme.primary, size: 40),
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Vous aviez déjà payé cette réservation. Aucun remboursement n\'est automatique : contactez le guide de la balade pour en discuter.'),
          for (final guide in guides) ...[
            const SizedBox(height: 12),
            Text('${guide.firstName} ${guide.lastName}', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
            if (guide.email.isNotEmpty) SelectableText(guide.email),
            if (guide.phone != null && guide.phone!.isNotEmpty) SelectableText(guide.phone!),
          ],
        ],
      ),
      actions: [FilledButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Compris'))],
    );
  }
}

class _EditParticipantDialog extends ConsumerStatefulWidget {
  const _EditParticipantDialog({required this.reservation, required this.participant});

  final Reservation reservation;
  final Participant participant;

  @override
  ConsumerState<_EditParticipantDialog> createState() => _EditParticipantDialogState();
}

class _EditParticipantDialogState extends ConsumerState<_EditParticipantDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _firstName = TextEditingController(text: widget.participant.firstName);
  late final _lastName = TextEditingController(text: widget.participant.lastName);
  late String? _priceLabel = widget.participant.priceMissing ? null : widget.participant.priceLabel;

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rambleAsync = ref.watch(reservationRambleProvider(widget.reservation.rambleId));
    final prices = rambleAsync.value?.prices ?? const [];

    return AlertDialog(
      title: const Text('Modifier le participant'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _firstName,
              decoration: const InputDecoration(labelText: 'Prénom *', border: OutlineInputBorder()),
              textCapitalization: TextCapitalization.words,
              validator: (value) => (value?.trim().isEmpty ?? true) ? 'Prénom requis' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _lastName,
              decoration: const InputDecoration(labelText: 'Nom *', border: OutlineInputBorder()),
              textCapitalization: TextCapitalization.words,
              validator: (value) => (value?.trim().isEmpty ?? true) ? 'Nom requis' : null,
            ),
            if (rambleAsync.isLoading) const Padding(padding: EdgeInsets.only(top: 12), child: LinearProgressIndicator()),
            if (prices.length > 1) ...[
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: prices.any((p) => p.label == _priceLabel) ? _priceLabel : null,
                decoration: const InputDecoration(labelText: 'Tarif *', border: OutlineInputBorder()),
                items: [for (final price in prices) DropdownMenuItem(value: price.label, child: Text(price.label))],
                onChanged: (value) => setState(() => _priceLabel = value),
                validator: (value) => value == null ? 'Tarif requis' : null,
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Annuler')),
        FilledButton(
          onPressed: rambleAsync.isLoading
              ? null
              : () {
                  if (!_formKey.currentState!.validate()) return;
                  final priceLabel = prices.length > 1 ? _priceLabel! : (prices.isEmpty ? widget.participant.priceLabel : prices.first.label);
                  Navigator.of(context).pop((firstName: _firstName.text.trim(), lastName: _lastName.text.trim(), priceLabel: priceLabel));
                },
          child: const Text('Enregistrer'),
        ),
      ],
    );
  }
}
