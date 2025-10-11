import 'package:balade/features/payments/models/payment.dart';
import 'package:balade/features/payments/providers/payment_providers.dart';
import 'package:balade/features/payments/widgets/payment_summary_card.dart';
import 'package:balade/features/payments/widgets/price_selection_widget.dart';
import 'package:balade/features/ramble/models/ramble/ramble.dart';
import 'package:balade/features/registrations/models/registration/registration.dart';
import 'package:balade/features/registrations/providers/registration_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart' hide Card;
import 'package:go_router/go_router.dart';

class PaymentPage extends ConsumerStatefulWidget {
  const PaymentPage({super.key, this.registrationId, this.groupId});

  final int? registrationId;
  final int? groupId;

  @override
  ConsumerState<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends ConsumerState<PaymentPage> {
  Map<String, int> selectedPrices = {};
  bool _isProcessingPayment = false;
  String? _payerName;
  String? _payerEmail;
  late TextEditingController _nameController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Paiement'), backgroundColor: Colors.transparent),
      body: widget.registrationId != null ? _buildForRegistration() : _buildForGroup(),
    );
  }

  Widget _buildForRegistration() {
    final registrationAsync = ref.watch(registrationProvider(widget.registrationId!));

    return registrationAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => _buildErrorWidget(error.toString()),
      data: (registration) {
        final rambleAsync = ref.watch(rambleDetailsProvider(registration.rambleId));

        return rambleAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => _buildErrorWidget(error.toString()),
          data: (ramble) => _buildPaymentContent(ramble: ramble, participantCount: 1, isGroupPayment: false, registration: registration),
        );
      },
    );
  }

  Widget _buildForGroup() {
    final groupAsync = ref.watch(registrationGroupProvider(widget.groupId!));

    return groupAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => _buildErrorWidget(error.toString()),
      data: (group) {
        if (group == null) {
          return _buildErrorWidget('Groupe non trouvé');
        }

        final rambleAsync = ref.watch(rambleDetailsProvider(group.rambleId));

        return rambleAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => _buildErrorWidget(error.toString()),
          data: (ramble) => _buildPaymentContent(ramble: ramble, participantCount: group.participantCount, isGroupPayment: true, group: group),
        );
      },
    );
  }

  Widget _buildPaymentContent({required Ramble ramble, required int participantCount, required bool isGroupPayment, Registration? registration, RegistrationGroup? group}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final paymentState = ref.watch(paymentActionsProvider);

    // Initialize default values for controllers and private variables
    final defaultName = registration != null ? '${registration.firstName} ${registration.lastName}' : null;
    final defaultEmail = registration?.email ?? group?.primaryEmail;

    // Set controller values and private variables if not already set
    if (_nameController.text.isEmpty && defaultName != null) {
      _nameController.text = defaultName;
      _payerName = defaultName;
    }
    if (_emailController.text.isEmpty && defaultEmail != null) {
      _emailController.text = defaultEmail;
      _payerEmail = defaultEmail;
    }

    // Check if payment is enabled for this ramble
    if (!ramble.paymentEnabled || ramble.paymentGuide == null) {
      return _buildErrorWidget('Le paiement n\'est pas disponible pour cette balade.');
    }

    // Initialize Stripe with the guide's public key if available
    if (ramble.paymentGuide?.stripePublicKey != null) {
      final stripeService = ref.read(stripeServiceProvider);
      stripeService.initialize(ramble.paymentGuide!.stripePublicKey!);
    }

    final hasSelectedPrices =
        selectedPrices.isNotEmpty && (isGroupPayment ? selectedPrices.values.fold(0, (sum, count) => sum + count) == participantCount : selectedPrices.values.first == 1);

    // Calculate total from ramble prices
    double total = 0.0;
    for (final entry in selectedPrices.entries) {
      final priceLabel = entry.key;
      final quantity = entry.value;
      final price = ramble.prices.firstWhere((p) => p.label == priceLabel, orElse: () => const RamblePrice(label: '', amount: 0.0));
      total += price.amount * quantity;
    }

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Text(isGroupPayment ? 'Paiement de groupe' : 'Paiement de votre inscription', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('Finalisez votre inscription en procédant au paiement sécurisé.', style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
                const SizedBox(height: 24),

                // Price selection
                PriceSelectionWidget(
                  prices: ramble.prices,
                  selectedPrices: selectedPrices,
                  onPriceChanged: (prices) {
                    setState(() {
                      selectedPrices = prices;
                    });
                  },
                  participantCount: participantCount,
                  isGroupPayment: isGroupPayment,
                ),
                const SizedBox(height: 16),

                // Payment summary
                if (hasSelectedPrices) ...[PaymentSummaryCard(ramble: ramble, selectedPrices: selectedPrices, participantCount: participantCount), const SizedBox(height: 16)],

                // Payer information form
                if (hasSelectedPrices) ...[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.person, color: colorScheme.primary),
                              const SizedBox(width: 8),
                              Text('Informations du payeur', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _nameController,
                            decoration: const InputDecoration(labelText: 'Nom complet', border: OutlineInputBorder()),
                            onChanged: (value) => setState(() {
                              _payerName = value;
                            }),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (value) => _payerEmail = value,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Stripe card form
                if (hasSelectedPrices && _payerName?.isNotEmpty == true && _payerEmail?.isNotEmpty == true && ramble.paymentGuide?.stripePublicKey != null) ...[
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
                              Text('Informations de paiement', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 200,
                            child: CardField(
                              onCardChanged: (card) {
                                // Card details will be handled by Stripe
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // Error for missing Stripe configuration
                if (hasSelectedPrices && _payerName?.isNotEmpty == true && _payerEmail?.isNotEmpty == true && ramble.paymentGuide?.stripePublicKey == null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: colorScheme.errorContainer, borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      children: [
                        Icon(Icons.error, color: colorScheme.onErrorContainer),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Configuration de paiement manquante. Veuillez contacter l\'organisateur.',
                            style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onErrorContainer),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Error display
                if (paymentState.error != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: colorScheme.errorContainer, borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      children: [
                        Icon(Icons.error, color: colorScheme.onErrorContainer),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(paymentState.error!, style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onErrorContainer)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ],
            ),
          ),
        ),

        // Bottom action buttons
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            border: Border(top: BorderSide(color: colorScheme.outline.withOpacity(0.3))),
          ),
          child: SafeArea(
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(onPressed: _isProcessingPayment ? null : () => context.pop(), child: const Text('Annuler')),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: FilledButton(
                    onPressed:
                        hasSelectedPrices &&
                            _payerName?.isNotEmpty == true &&
                            _payerEmail?.isNotEmpty == true &&
                            ramble.paymentGuide?.stripePublicKey != null &&
                            !_isProcessingPayment
                        ? _processPayment
                        : null,
                    child: _isProcessingPayment || paymentState.isLoading
                        ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2))
                        : Text('Payer ${total.toStringAsFixed(2)} €'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorWidget(String error) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error, size: 64, color: colorScheme.error),
            const SizedBox(height: 16),
            Text('Erreur', style: theme.textTheme.headlineSmall?.copyWith(color: colorScheme.error)),
            const SizedBox(height: 8),
            Text(error, textAlign: TextAlign.center, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 24),
            FilledButton(onPressed: () => context.pop(), child: const Text('Retour')),
          ],
        ),
      ),
    );
  }

  Future<void> _processPayment() async {
    if (_payerName == null || _payerEmail == null) return;

    setState(() {
      _isProcessingPayment = true;
    });

    try {
      final paymentNotifier = ref.read(paymentActionsProvider.notifier);

      // Create payment request
      PaymentCreationRequest request;

      if (widget.groupId != null) {
        // For group payments, use price_selections
        final priceSelections = selectedPrices.entries.map((entry) => PriceSelection(priceLabel: entry.key, quantity: entry.value)).toList();

        request = PaymentCreationRequest(
          registrationId: widget.registrationId,
          groupId: widget.groupId,
          priceSelections: priceSelections,
          payerEmail: _payerEmail!,
          payerName: _payerName!,
          returnUrl: 'myapp://payment/success',
        );
      } else {
        // For individual payments, use the deprecated price_label field for backward compatibility
        final selectedPriceLabel = selectedPrices.keys.first;

        request = PaymentCreationRequest(
          registrationId: widget.registrationId,
          groupId: widget.groupId,
          priceLabel: selectedPriceLabel,
          payerEmail: _payerEmail!,
          payerName: _payerName!,
          returnUrl: 'myapp://payment/success',
        );
      }

      // Initialize payment
      final success = await paymentNotifier.initializePayment(request);
      if (!success) {
        setState(() {
          _isProcessingPayment = false;
        });
        return;
      }

      // Confirm payment with Stripe
      final paymentSuccess = await paymentNotifier.confirmPayment();
      if (paymentSuccess) {
        // Payment successful - navigate to success page
        if (context.mounted) {
          _showSuccessDialog();
        }
      }
    } catch (e) {
      // Error will be handled by the provider
    } finally {
      setState(() {
        _isProcessingPayment = false;
      });
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.check_circle, color: Colors.green, size: 48),
        title: const Text('Paiement réussi !'),
        content: const Text('Votre paiement a été traité avec succès. Vous recevrez une confirmation par email.'),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              context.go('/mes-reservations'); // Navigate to reservations
            },
            child: const Text('Voir mes réservations'),
          ),
        ],
      ),
    );
  }
}
