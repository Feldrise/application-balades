import 'package:balade/core/phone_utils.dart';
import 'package:balade/features/admin/design/design.dart';
import 'package:balade/features/admin/ramble_details_page/widgets/ramble_sheet_actions.dart';
import 'package:balade/features/guides/models/guide/guide.dart';
import 'package:balade/features/ramble/models/ramble/ramble.dart';
import 'package:balade/features/reservations/models/reservation/reservation.dart';
import 'package:balade/features/reservations/providers/reservation_providers.dart';
import 'package:balade/features/reservations/reservation_format.dart';
import 'package:balade/features/reservations/widgets/confirm_reservation_sheet.dart';
import 'package:balade/features/reservations/widgets/reservation_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

/// One reservation in full, for the booker: where it stands, what to confirm and when, where to meet,
/// who to contact, what to bring, then the participants, the amount and the actions on the reservation.
class ReservationDetail extends ConsumerWidget {
  const ReservationDetail({super.key, required this.reservation});

  final Reservation reservation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rambleAsync = ref.watch(reservationRambleProvider(reservation.rambleId));
    final ramble = rambleAsync.valueOrNull;
    final isCancelled = reservation.status == 'cancelled';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Summary(reservation: reservation, ramble: ramble),
        if (ramble != null) ...[..._rambleInformation(ramble)] else if (rambleAsync.hasError) _RambleInformationError(onRetry: () => ref.invalidate(reservationRambleProvider(reservation.rambleId))),
        const SizedBox(height: 12),
        _Participants(reservation: reservation),
        const SizedBox(height: 12),
        _Amount(reservation: reservation),
        if (!isCancelled) ...[const SizedBox(height: 16), _Actions(reservation: reservation)],
      ],
    );
  }

  List<Widget> _rambleInformation(Ramble ramble) {
    final meetingPoint = ramble.meetingPoint?.isNotEmpty == true ? ramble.meetingPoint : ramble.location;
    final hasPlace = meetingPoint?.isNotEmpty == true || (ramble.meetingLatitude != null && ramble.meetingLongitude != null);
    final equipment = ramble.equipmentNeeded?.trim() ?? '';
    final prerequisites = ramble.prerequisites?.trim() ?? '';

    return [
      if (hasPlace) ...[const SizedBox(height: 12), _MeetingPoint(ramble: ramble, label: meetingPoint)],
      if (ramble.guides.isNotEmpty) ...[const SizedBox(height: 12), _Guides(guides: ramble.guides)],
      if (equipment.isNotEmpty || prerequisites.isNotEmpty) ...[const SizedBox(height: 12), _ToBring(equipment: equipment, prerequisites: prerequisites)],
    ];
  }
}

/// A titled white panel of the detail.
class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ManagementColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: ManagementColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title.toUpperCase(), style: theme.textTheme.labelSmall?.copyWith(color: ManagementColors.green, letterSpacing: 0.8)),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }
}

class _Summary extends ConsumerWidget {
  const _Summary({required this.reservation, required this.ramble});

  final Reservation reservation;
  final Ramble? ramble;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final now = ref.watch(reservationClockProvider)();
    final summary = reservation.ramble;
    final date = summary?.date;
    final isPending = reservation.status == 'pending';
    final period = isPending ? confirmationPeriodText(reservation) : null;
    final pays = (ramble?.paymentEnabled ?? false) && amountDue(reservation) > 0;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ManagementColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: ManagementColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CalendarDateBlock(date: date?.toLocal()),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () => context.go('/balades/${reservation.rambleId}'),
                      child: Text(summary?.title ?? 'Balade', style: theme.textTheme.titleLarge),
                    ),
                    if (date != null) Text(_dateAndTime(date.toLocal()), style: theme.textTheme.bodyMedium),
                    const SizedBox(height: 6),
                    ReservationStatusBadge(status: reservation.status),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(reservationStatusExplanation(reservation, now: now), style: theme.textTheme.bodyMedium),
          if (period != null) ...[
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.event_available, size: 18, color: ManagementColors.pending),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    period,
                    style: theme.textTheme.bodyMedium?.copyWith(color: ManagementColors.pending, fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
          ],
          if (canConfirm(reservation, now: now)) ...[
            const SizedBox(height: 14),
            FilledButton.icon(
              style: FilledButton.styleFrom(backgroundColor: ManagementColors.green, padding: const EdgeInsets.symmetric(vertical: 16)),
              onPressed: () => showConfirmReservationSheet(context, reservation),
              icon: Icon(pays ? Icons.credit_card : Icons.event_available),
              label: Text(pays ? 'Confirmer et payer' : 'Confirmer ma réservation'),
            ),
          ],
        ],
      ),
    );
  }

  String _dateAndTime(DateTime date) => '${toBeginningOfSentenceCase(DateFormat('EEEE d MMMM yyyy', 'fr').format(date))} à ${DateFormat('HH:mm').format(date)}';
}

class _MeetingPoint extends StatelessWidget {
  const _MeetingPoint({required this.ramble, required this.label});

  final Ramble ramble;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _Section(
      title: 'Rendez-vous',
      children: [
        if (label != null && label!.isNotEmpty) Text(label!, style: theme.textTheme.bodyLarge),
        const SizedBox(height: 4),
        TextButton.icon(
          style: TextButton.styleFrom(foregroundColor: ManagementColors.green, padding: EdgeInsets.zero, alignment: Alignment.centerLeft),
          onPressed: () => openMeetingPoint(context, ramble),
          icon: const Icon(Icons.map_outlined, size: 18),
          label: const Text('Ouvrir dans Maps'),
        ),
      ],
    );
  }
}

class _Guides extends StatelessWidget {
  const _Guides({required this.guides});

  final List<Guide> guides;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _Section(
      title: guides.length > 1 ? 'Vos guides' : 'Votre guide',
      children: [
        for (var i = 0; i < guides.length; i++) ...[
          if (i > 0) const SizedBox(height: 12),
          Text('${guides[i].firstName} ${guides[i].lastName}', style: theme.textTheme.titleSmall),
          if (phoneToTelUri(guides[i].phone) case final tel?)
            _ContactLine(
              icon: Icons.call_outlined,
              text: formatStoredPhone(guides[i].phone) ?? tel,
              uri: Uri(scheme: 'tel', path: tel),
              failure: 'Impossible de lancer l\'appel',
            ),
          if (guides[i].email.isNotEmpty)
            _ContactLine(
              icon: Icons.mail_outline,
              text: guides[i].email,
              uri: Uri(scheme: 'mailto', path: guides[i].email),
              failure: 'Impossible d\'ouvrir le client mail',
            ),
        ],
      ],
    );
  }
}

class _ContactLine extends StatelessWidget {
  const _ContactLine({required this.icon, required this.text, required this.uri, required this.failure});

  final IconData icon;
  final String text;
  final Uri uri;
  final String failure;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final messenger = ScaffoldMessenger.of(context);
        final opened = await launchUrl(uri, mode: LaunchMode.externalApplication).catchError((_) => false);
        if (!opened) messenger.showSnackBar(SnackBar(content: Text(failure)));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Icon(icon, size: 18, color: ManagementColors.green),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                text,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: ManagementColors.green, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ToBring extends StatelessWidget {
  const _ToBring({required this.equipment, required this.prerequisites});

  final String equipment;
  final String prerequisites;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _Section(
      title: 'À prévoir',
      children: [
        if (equipment.isNotEmpty) ...[Text('Équipement', style: theme.textTheme.titleSmall), const SizedBox(height: 2), Text(equipment, style: theme.textTheme.bodyMedium)],
        if (equipment.isNotEmpty && prerequisites.isNotEmpty) const SizedBox(height: 10),
        if (prerequisites.isNotEmpty) ...[Text('Prérequis', style: theme.textTheme.titleSmall), const SizedBox(height: 2), Text(prerequisites, style: theme.textTheme.bodyMedium)],
      ],
    );
  }
}

/// The ramble could not be loaded: the reservation stays readable, only the practical information is missing.
class _RambleInformationError extends StatelessWidget {
  const _RambleInformationError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: _Section(
        title: 'Informations pratiques',
        children: [
          Text('Le rendez-vous, le guide et l\'équipement n\'ont pas pu être chargés.', style: theme.textTheme.bodyMedium),
          TextButton.icon(onPressed: onRetry, icon: const Icon(Icons.refresh, size: 18), label: const Text('Réessayer')),
        ],
      ),
    );
  }
}

class _Participants extends ConsumerWidget {
  const _Participants({required this.reservation});

  final Reservation reservation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _Section(
      title: reservation.participants.length > 1 ? 'Participants (${reservation.participants.length})' : 'Participant',
      children: [for (final participant in reservation.participants) _ParticipantRow(reservation: reservation, participant: participant)],
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
    final tariff = participant.priceMissing ? 'Tarif à préciser' : formatParticipantTariff(participant);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${participant.firstName} ${participant.lastName}${participant.isBooker ? ' (vous)' : ''}', style: theme.textTheme.bodyMedium),
                if (tariff.isNotEmpty)
                  Text(
                    tariff,
                    style: theme.textTheme.bodySmall?.copyWith(color: participant.priceMissing ? ManagementColors.pending : null, fontWeight: participant.priceMissing ? FontWeight.w800 : null),
                  ),
              ],
            ),
          ),
          if (canModifyParticipants(reservation))
            IconButton(
              onPressed: () => editParticipant(context, ref, reservation, participant),
              icon: const Icon(Icons.edit_outlined, size: 18),
              tooltip: 'Modifier',
              visualDensity: VisualDensity.compact,
            )
          else if (canSpecifyMissingPrice(reservation, participant))
            IconButton(
              onPressed: () => editParticipant(context, ref, reservation, participant),
              icon: const Icon(Icons.edit_outlined, size: 18, color: ManagementColors.pending),
              tooltip: 'Préciser le tarif',
              visualDensity: VisualDensity.compact,
            ),
          if (reservation.status != 'cancelled')
            IconButton(
              onPressed: () => removeParticipant(context, ref, reservation, participant),
              icon: const Icon(Icons.person_remove_outlined, size: 18, color: ManagementColors.cancelled),
              tooltip: 'Retirer',
              visualDensity: VisualDensity.compact,
            ),
        ],
      ),
    );
  }
}

class _Amount extends StatelessWidget {
  const _Amount({required this.reservation});

  final Reservation reservation;

  static const _labels = {
    'pending': 'En attente',
    'requires_action': 'Action requise',
    'succeeded': 'Payé',
    'failed': 'Échoué',
    'cancelled': 'Annulé',
    'partially_refunded': 'Remboursé en partie',
    'refunded': 'Remboursé',
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _Section(
      title: 'Paiement',
      children: [
        Row(
          children: [
            Expanded(child: Text('Montant', style: theme.textTheme.bodyMedium)),
            Flexible(
              child: Text(
                formatReservationAmount(reservation),
                textAlign: TextAlign.end,
                style: theme.textTheme.titleMedium?.copyWith(color: ManagementColors.green),
              ),
            ),
          ],
        ),
        for (final payment in reservation.payments) _paymentRow(theme, payment),
      ],
    );
  }

  Widget _paymentRow(ThemeData theme, ReservationPayment payment) {
    final date = payment.paidAt ?? payment.createdAt;
    final refund = payment.status == 'partially_refunded' && payment.refundAmount != null ? ' (${formatCents(payment.refundAmount!)})' : '';
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        children: [
          Expanded(child: Text('${DateFormat('dd/MM/yyyy').format(date)} · ${_labels[payment.status] ?? payment.status}$refund', style: theme.textTheme.bodySmall)),
          Text(formatCents(payment.amount), style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _Actions extends ConsumerWidget {
  const _Actions({required this.reservation});

  final Reservation reservation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentEnabled = ref.watch(reservationRambleProvider(reservation.rambleId)).valueOrNull?.paymentEnabled ?? false;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        if (canPayBalance(reservation) && paymentEnabled)
          FilledButton.icon(
            onPressed: () => context.push(reservationPaymentLocation(reservation.id)),
            icon: const Icon(Icons.credit_card),
            label: Text('Payer ${formatCents(amountDue(reservation))}'),
          ),
        if (canAddParticipants(reservation))
          FilledButton.tonalIcon(onPressed: () => showAddParticipantsSheet(context, reservation), icon: const Icon(Icons.group_add), label: const Text('Ajouter des participants')),
        OutlinedButton.icon(
          onPressed: () => cancelReservation(context, ref, reservation),
          style: OutlinedButton.styleFrom(foregroundColor: ManagementColors.cancelled),
          icon: const Icon(Icons.event_busy),
          label: const Text('Annuler la réservation'),
        ),
      ],
    );
  }
}
