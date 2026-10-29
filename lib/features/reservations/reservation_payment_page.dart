import 'package:balade/features/authentication/authentication_provider.dart';
import 'package:balade/features/payments/providers/payment_providers.dart';
import 'package:balade/features/reservations/models/reservation/reservation.dart';
import 'package:balade/features/reservations/providers/reservation_providers.dart';
import 'package:balade/features/reservations/reservation_format.dart';
import 'package:balade/features/reservations/reservations_service.dart';
import 'package:balade/features/reservations/widgets/reservation_actions.dart';
import 'package:balade/features/reservations/widgets/reservation_notices.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart' hide Card;
import 'package:go_router/go_router.dart';

/// Pays what a confirmed reservation owes, on confirmation or after an addition of participants:
/// the participants and their tariffs are taken from the reservation, nothing is to be split by hand.
class ReservationPaymentPage extends ConsumerStatefulWidget {
  const ReservationPaymentPage({super.key, required this.reservationId, this.payment});

  final int reservationId;

  /// The payment created by the confirmation or the addition. Without it (page reloaded), the
  /// payment of what is still due is asked again to the API.
  final PaymentToMake? payment;

  @override
  ConsumerState<ReservationPaymentPage> createState() => _ReservationPaymentPageState();
}

class _ReservationPaymentPageState extends ConsumerState<ReservationPaymentPage> {
  late PaymentToMake? _payment = widget.payment;
  bool _isLoadingPayment = false;
  bool _isPaying = false;
  bool _cardComplete = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    if (_payment == null) WidgetsBinding.instance.addPostFrameCallback((_) => _loadPayment());
  }

  Future<void> _loadPayment() async {
    final token = ref.read(authenticationProvider)?.token;
    if (token == null) return;

    setState(() {
      _isLoadingPayment = true;
      _error = null;
    });
    try {
      final confirmed = await ref.read(reservationsServiceProvider).confirmReservation(widget.reservationId, token: token);
      if (!mounted) return;
      setState(() {
        _payment = confirmed.payment;
        if (confirmed.payment == null) _error = 'Il n\'y a rien à payer en ligne pour cette réservation.';
      });
    } on ReservationException catch (e) {
      if (mounted) setState(() => _error = reservationErrorMessage(e));
    } catch (_) {
      if (mounted) setState(() => _error = 'Impossible de joindre le serveur. Réessayez dans un instant.');
    } finally {
      if (mounted) setState(() => _isLoadingPayment = false);
    }
  }

  Future<void> _pay(PaymentToMake payment) async {
    setState(() {
      _isPaying = true;
      _error = null;
    });

    try {
      final stripe = ref.read(stripeServiceProvider);
      stripe.initialize(payment.publishableKey);
      final result = await stripe.confirmPayment(payment.clientSecret);
      if (!mounted) return;

      if (result.status == PaymentIntentsStatus.Succeeded) {
        ref.invalidate(userReservationsProvider);
        ref.invalidate(reservationProvider);
        await _showSuccess();
      } else {
        setState(() => _error = 'Le paiement n\'a pas abouti. Vous pouvez réessayer.');
      }
    } catch (e) {
      if (mounted) setState(() => _error = 'Le paiement a échoué : $e');
    } finally {
      if (mounted) setState(() => _isPaying = false);
    }
  }

  Future<void> _showSuccess() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(Icons.check_circle, color: Colors.green, size: 48),
        title: const Text('Paiement réussi !'),
        content: const Text('Votre réservation est confirmée et payée.'),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.go('/mes-reservations/${widget.reservationId}');
            },
            child: const Text('Voir ma réservation'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final reservationAsync = ref.watch(reservationProvider(widget.reservationId));

    return Scaffold(
      appBar: AppBar(title: const Text('Paiement'), backgroundColor: Colors.transparent),
      body: reservationAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString().contains('NOT_AUTHENTICATED') ? 'Veuillez vous reconnecter.' : 'Impossible de charger la réservation.')),
        data: _buildContent,
      ),
    );
  }

  Widget _buildContent(Reservation reservation) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final payment = _payment;
    final paid = reservation.amountPaid;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(reservation.ramble?.title ?? 'Votre réservation', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Participants (${reservation.participants.length})', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      for (final participant in reservation.participants)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Expanded(child: Text('${participant.firstName} ${participant.lastName}')),
                              Text(participant.priceLabel.isEmpty ? formatEuros(participant.priceAmount) : '${participant.priceLabel} · ${formatEuros(participant.priceAmount)}'),
                            ],
                          ),
                        ),
                      const Divider(height: 24),
                      _AmountRow(label: 'Total', amount: formatCents(reservation.estimatedAmount)),
                      if (paid > 0) _AmountRow(label: 'Déjà payé', amount: formatCents(paid)),
                      if (payment != null) _AmountRow(label: 'À payer maintenant', amount: formatCents(payment.amount), emphasized: true),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (payment != null)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.credit_card, color: colorScheme.primary),
                            const SizedBox(width: 8),
                            Text('Carte bancaire', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _GuideCardField(publishableKey: payment.publishableKey, onChanged: (complete) => setState(() => _cardComplete = complete)),
                      ],
                    ),
                  ),
                ),
              if (_isLoadingPayment)
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                ),
              if (_error != null) ...[const SizedBox(height: 12), ReservationNotice(icon: Icons.error_outline, color: colorScheme.error, message: _error!)],
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            border: Border(top: BorderSide(color: colorScheme.outline.withValues(alpha: 0.3))),
          ),
          child: SafeArea(
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(onPressed: _isPaying ? null : () => context.go('/mes-reservations/${widget.reservationId}'), child: const Text('Plus tard')),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: FilledButton(
                    onPressed: payment != null && _cardComplete && !_isPaying ? () => _pay(payment) : null,
                    child: _isPaying
                        ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2))
                        : Text(payment != null ? 'Payer ${formatCents(payment.amount)}' : 'Payer'),
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

class _AmountRow extends StatelessWidget {
  const _AmountRow({required this.label, required this.amount, this.emphasized = false});

  final String label;
  final String amount;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = emphasized ? theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.primary) : theme.textTheme.bodyMedium;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(child: Text(label, style: style)),
          Text(amount, style: style),
        ],
      ),
    );
  }
}

/// The Stripe card field, set up with the publishable key of the guide who receives the payment.
class _GuideCardField extends ConsumerStatefulWidget {
  const _GuideCardField({required this.publishableKey, required this.onChanged});

  final String publishableKey;
  final ValueChanged<bool> onChanged;

  @override
  ConsumerState<_GuideCardField> createState() => _GuideCardFieldState();
}

class _GuideCardFieldState extends ConsumerState<_GuideCardField> {
  @override
  void initState() {
    super.initState();
    ref.read(stripeServiceProvider).initialize(widget.publishableKey);
  }

  @override
  Widget build(BuildContext context) {
    return CardField(onCardChanged: (card) => widget.onChanged(card?.complete ?? false));
  }
}
