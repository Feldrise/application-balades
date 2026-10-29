import 'dart:math';

import 'package:balade/features/authentication/authentication_provider.dart';
import 'package:balade/features/ramble/models/ramble/ramble.dart';
import 'package:balade/features/reservations/models/reservation/create_reservation_request.dart';
import 'package:balade/features/reservations/models/reservation/reservation.dart';
import 'package:balade/features/reservations/providers/reservation_providers.dart';
import 'package:balade/features/reservations/reservation_draft.dart';
import 'package:balade/features/reservations/reservation_format.dart';
import 'package:balade/features/reservations/reservations_service.dart';
import 'package:balade/features/reservations/widgets/reservation_actions.dart';
import 'package:balade/features/reservations/widgets/reservation_counters.dart';
import 'package:balade/features/reservations/widgets/reservation_notices.dart';
import 'package:balade/features/reservations/widgets/reservation_participant_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Adds participants to an existing reservation, all of them or none.
class AddParticipantsSheet extends ConsumerWidget {
  const AddParticipantsSheet({super.key, required this.reservation});

  final Reservation reservation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rambleAsync = ref.watch(reservationRambleProvider(reservation.rambleId));

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.9,
      child: rambleAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Impossible de charger la balade.'),
              const SizedBox(height: 12),
              FilledButton.icon(onPressed: () => ref.invalidate(reservationRambleProvider(reservation.rambleId)), icon: const Icon(Icons.refresh), label: const Text('Réessayer')),
            ],
          ),
        ),
        data: (ramble) => _AddParticipantsForm(reservation: reservation, ramble: ramble),
      ),
    );
  }
}

class _AddParticipantsForm extends ConsumerStatefulWidget {
  const _AddParticipantsForm({required this.reservation, required this.ramble});

  final Reservation reservation;
  final Ramble ramble;

  @override
  ConsumerState<_AddParticipantsForm> createState() => _AddParticipantsFormState();
}

class _AddParticipantsFormState extends ConsumerState<_AddParticipantsForm> {
  final _formKey = GlobalKey<FormState>();
  late ReservationDraft _draft = ReservationDraft(prices: widget.ramble.prices, maxParticipants: max(_room, 1));
  bool _isSubmitting = false;
  String? _error;

  /// How many participants the reservation can still take under the per-reservation limit.
  int get _room => widget.ramble.maxParticipantsPerReservation - widget.reservation.participants.length;

  /// Places left for an addition to a pending reservation; a waiting reservation waits as a whole.
  int? get _placesLeft => widget.reservation.status == 'pending' ? widget.ramble.placesLeft : null;

  bool get _doesNotFit => _placesLeft != null && _draft.total > _placesLeft!;

  bool get _bookerIsParticipant => widget.reservation.participants.any((p) => p.isBooker);

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final token = ref.read(authenticationProvider)?.token;
    if (token == null) {
      setState(() => _error = 'Veuillez vous reconnecter.');
      return;
    }

    setState(() {
      _isSubmitting = true;
      _error = null;
    });

    try {
      final participants = [
        for (final p in _draft.participants) ParticipantRequest(firstName: p.firstName.trim(), lastName: p.lastName.trim(), priceLabel: p.priceLabel, isBooker: p.isBooker),
      ];
      await ref.read(reservationsServiceProvider).addParticipants(widget.reservation.id, participants, token: token);
      ref.invalidate(userReservationsProvider);
      ref.invalidate(reservationRambleProvider(widget.reservation.rambleId));
      if (!mounted) return;

      final messenger = ScaffoldMessenger.of(context);
      Navigator.of(context).pop();
      messenger.showSnackBar(SnackBar(content: Text(participants.length > 1 ? 'Participants ajoutés' : 'Participant ajouté')));
    } on ReservationException catch (e) {
      if (e.reason == 'not_enough_places') ref.invalidate(reservationRambleProvider(widget.reservation.rambleId));
      setState(() => _error = reservationErrorMessage(e));
    } catch (_) {
      setState(() => _error = 'Impossible de joindre le serveur. Réessayez dans un instant.');
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final tariffLabels = _draft.hasTariffChoice ? [for (final price in _draft.prices) price.label] : const <String>[];
    final placesLeft = _placesLeft;
    final full = _room <= 0 || (placesLeft != null && placesLeft <= 0);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 8, 8),
          child: Row(
            children: [
              Icon(Icons.group_add, color: colorScheme.primary, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Ajouter des participants', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                    Text(widget.ramble.title, style: theme.textTheme.titleMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
                  ],
                ),
              ),
              IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.close)),
            ],
          ),
        ),
        Expanded(
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              children: [
                Text(
                  'Votre réservation compte ${widget.reservation.participants.length} participant${widget.reservation.participants.length > 1 ? 's' : ''}.'
                  '${placesLeft != null ? ' Il reste $placesLeft place${placesLeft > 1 ? 's' : ''} sur la balade.' : ''}',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                if (full)
                  ReservationNotice(
                    icon: Icons.block,
                    color: colorScheme.error,
                    message: _room <= 0
                        ? 'Votre réservation compte déjà le nombre maximum de participants pour cette balade.'
                        : 'Il ne reste plus de place sur cette balade : aucun participant ne peut être ajouté.',
                  )
                else ...[
                  DraftCounters(
                    draft: _draft,
                    onIncrement: (label) => setState(() => _draft = _draft.increment(label)),
                    onDecrement: (label) => setState(() => _draft = _draft.decrement(label)),
                  ),
                  const SizedBox(height: 16),
                  for (var i = 0; i < _draft.participants.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: ReservationParticipantLine(
                        key: ValueKey(_draft.participants[i].key),
                        participant: _draft.participants[i],
                        number: widget.reservation.participants.length + i + 1,
                        tariffLabels: tariffLabels,
                        canBeBooker: !_bookerIsParticipant,
                        onChanged: ({firstName, lastName, priceLabel, isBooker}) => setState(
                          () => _draft = _draft.withParticipant(i, firstName: firstName, lastName: lastName, priceLabel: priceLabel, isBooker: isBooker),
                        ),
                        onRemove: _draft.total > 1 ? () => setState(() => _draft = _draft.removeParticipant(i)) : null,
                      ),
                    ),
                  if (_doesNotFit) ...[
                    ReservationNotice(
                      icon: Icons.block,
                      color: colorScheme.error,
                      message:
                          'Il ne reste que $placesLeft place${placesLeft! > 1 ? 's' : ''} sur cette balade : l\'ajout doit tenir entièrement dans les places restantes. Retirez des participants pour continuer.',
                    ),
                    const SizedBox(height: 12),
                  ],
                  if (widget.reservation.status == 'waiting_list') ...[
                    const ReservationNotice(
                      icon: Icons.hourglass_top,
                      color: Colors.orange,
                      message: 'Votre réservation est en liste d\'attente : les participants ajoutés y restent avec elle, et toute la réservation passera en entier dès que la place le permettra.',
                    ),
                    const SizedBox(height: 12),
                  ],
                  const ReservationNotice(icon: Icons.info_outline, message: kConfirmationNotice),
                ],
                if (_error != null) ...[const SizedBox(height: 12), ReservationNotice(icon: Icons.error_outline, color: colorScheme.error, message: _error!)],
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
        if (!full)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(border: Border(top: BorderSide(color: colorScheme.outline.withValues(alpha: 0.2)))),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_draft.prices.isNotEmpty)
                    Row(
                      children: [
                        Expanded(child: Text('Montant estimé de l\'ajout', style: theme.textTheme.titleMedium)),
                        Text(formatCents(_draft.estimatedAmountCents), style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.primary)),
                      ],
                    ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _isSubmitting || _doesNotFit ? null : _submit,
                      icon: _isSubmitting ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.check),
                      label: Text(_isSubmitting ? 'Ajout en cours...' : 'Ajouter ${_draft.total} ${_draft.total > 1 ? 'participants' : 'participant'}'),
                      style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
