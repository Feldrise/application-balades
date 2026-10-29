import 'package:balade/features/authentication/authentication_provider.dart';
import 'package:balade/features/reservations/models/reservation/reservation.dart';
import 'package:balade/features/reservations/providers/reservation_providers.dart';
import 'package:balade/features/reservations/reservation_format.dart';
import 'package:balade/features/reservations/reservations_service.dart';
import 'package:balade/features/reservations/widgets/reservation_actions.dart';
import 'package:balade/features/reservations/widgets/reservation_notices.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/// Opens the confirmation of [reservation], where the booker can still remove participants
/// or specify their tariffs before confirming and paying.
Future<void> showConfirmReservationSheet(BuildContext context, Reservation reservation) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => ConfirmReservationSheet(reservation: reservation),
  );
}

class ConfirmReservationSheet extends ConsumerStatefulWidget {
  const ConfirmReservationSheet({super.key, required this.reservation});

  final Reservation reservation;

  @override
  ConsumerState<ConfirmReservationSheet> createState() => _ConfirmReservationSheetState();
}

class _ConfirmReservationSheetState extends ConsumerState<ConfirmReservationSheet> {
  bool _isSubmitting = false;
  String? _error;

  Future<void> _confirm(Reservation reservation) async {
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
      final confirmed = await ref.read(reservationsServiceProvider).confirmReservation(reservation.id, token: token);
      ref.invalidate(userReservationsProvider);
      ref.invalidate(reservationProvider);
      if (!mounted) return;

      final router = GoRouter.of(context);
      final messenger = ScaffoldMessenger.of(context);
      Navigator.of(context).pop();
      if (confirmed.payment != null) {
        router.push(reservationPaymentLocation(reservation.id), extra: confirmed.payment);
      } else {
        messenger.showSnackBar(SnackBar(content: Text(confirmed.paymentUnavailable ? 'Réservation confirmée. $kPaymentUnavailableMessage' : 'Réservation confirmée')));
      }
    } on ReservationException catch (e) {
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
    // The reservation as saved, refreshed after each removal or change of tariff.
    final reservation = ref.watch(reservationProvider(widget.reservation.id)).value ?? widget.reservation;
    final paymentEnabled = ref.watch(reservationRambleProvider(reservation.rambleId)).value?.paymentEnabled ?? false;
    final deadline = reservation.confirmationDeadline;
    final pays = paymentEnabled && amountDue(reservation) > 0;

    if (reservation.status == 'cancelled') {
      return const SizedBox(height: 200, child: Center(child: Text('Cette réservation est annulée.')));
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.9,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 8, 8),
            child: Row(
              children: [
                Icon(Icons.event_available, color: colorScheme.primary, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Confirmer ma réservation', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                      if (reservation.ramble != null) Text(reservation.ramble!.title, style: theme.textTheme.titleMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
                    ],
                  ),
                ),
                IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.close)),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              children: [
                Text('Vérifiez qui vient : retirez les participants qui ne viennent plus avant de confirmer${pays ? ', pour ne payer que pour les présents' : ''}.', style: theme.textTheme.bodyMedium),
                if (deadline != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Sans confirmation avant le ${DateFormat('dd/MM/yyyy à HH:mm', 'fr').format(deadline.toLocal())}, la réservation sera annulée.',
                    style: theme.textTheme.bodySmall?.copyWith(color: Colors.orange.shade800),
                  ),
                ],
                const SizedBox(height: 16),
                for (final participant in reservation.participants)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(participant.isBooker ? Icons.person : Icons.person_outline, color: colorScheme.primary),
                    title: Text('${participant.firstName} ${participant.lastName}${participant.isBooker ? ' (vous)' : ''}'),
                    subtitle: participant.priceMissing
                        ? Text(
                            'Tarif à préciser',
                            style: TextStyle(color: Colors.orange.shade800, fontWeight: FontWeight.w600),
                          )
                        : participant.priceLabel.isNotEmpty
                        ? Text('${participant.priceLabel} · ${formatEuros(participant.priceAmount)}')
                        : null,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (canModifyParticipants(reservation))
                          IconButton(
                            onPressed: () => editParticipant(context, ref, reservation, participant),
                            icon: const Icon(Icons.edit_outlined),
                            tooltip: participant.priceMissing ? 'Préciser le tarif' : 'Modifier',
                          ),
                        IconButton(
                          onPressed: () => removeParticipant(context, ref, reservation, participant),
                          icon: Icon(Icons.person_remove_outlined, color: colorScheme.error),
                          tooltip: 'Retirer',
                        ),
                      ],
                    ),
                  ),
                if (reservation.hasMissingPrices) ...[
                  const SizedBox(height: 12),
                  ReservationNotice(
                    icon: Icons.sell_outlined,
                    color: Colors.orange.shade800,
                    message: 'Le tarif de certains participants est inconnu : précisez-le avant de confirmer, pour que le montant à payer soit complet.',
                  ),
                ],
                if (_error != null) ...[const SizedBox(height: 12), ReservationNotice(icon: Icons.error_outline, color: colorScheme.error, message: _error!)],
                const SizedBox(height: 24),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: colorScheme.outline.withValues(alpha: 0.2))),
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text('Montant', style: theme.textTheme.titleMedium)),
                      Text(
                        formatReservationAmount(reservation),
                        style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.primary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _isSubmitting || reservation.hasMissingPrices ? null : () => _confirm(reservation),
                      icon: _isSubmitting ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.check),
                      label: Text(pays ? 'Confirmer et payer ${formatCents(amountDue(reservation))}' : 'Confirmer'),
                      style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
