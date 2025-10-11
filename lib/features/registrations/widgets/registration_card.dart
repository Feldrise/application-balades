import 'package:balade/core/constants.dart';
import 'package:balade/features/guides/models/guide/guide.dart';
import 'package:balade/features/payments/models/payment.dart';
import 'package:balade/features/payments/providers/payment_providers.dart';
import 'package:balade/features/payments/widgets/payment_status_chip.dart';
import 'package:balade/features/ramble/models/ramble/ramble.dart';
import 'package:balade/features/registrations/models/registration/registration.dart';
import 'package:balade/features/registrations/providers/registration_providers.dart';
import 'package:balade/features/registrations/widgets/registration_status_chip.dart';
import 'package:balade/features/registrations/widgets/registration_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

class RegistrationCard extends ConsumerWidget {
  const RegistrationCard({super.key, required this.registration, required this.onConfirm, required this.onCancel});

  final Registration registration;
  final VoidCallback onConfirm;
  final Function(String?) onCancel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final rambleAsync = ref.watch(rambleDetailsProvider(registration.rambleId));

    return Card(
      child: InkWell(
        onTap: () => _showRegistrationDetails(context, rambleAsync.value),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with ramble image and status
            _buildHeader(context, theme, rambleAsync),

            // Content with ramble info
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitle(theme, rambleAsync),
                  const SizedBox(height: 8),
                  _buildRambleInfo(theme, rambleAsync),
                  const SizedBox(height: 12),
                  _buildRegistrationInfo(theme),
                  if (_shouldShowConfirmation()) ...[const SizedBox(height: 12), _buildConfirmationNeeded(theme)],
                  if (_hasAvailableActions() && !_shouldShowConfirmation()) ...[
                    const SizedBox(height: 12),
                    RegistrationActions(registration: registration, onConfirm: onConfirm, onCancel: onCancel),
                  ],
                  // Payment section - show if registration is confirmed and ramble has payment enabled
                  if (registration.status == 'confirmed') ...[
                    Consumer(
                      builder: (context, ref, child) {
                        final rambleAsync = ref.watch(rambleDetailsProvider(registration.rambleId));
                        return rambleAsync.when(
                          loading: () => const SizedBox.shrink(),
                          error: (_, __) => const SizedBox.shrink(),
                          data: (ramble) {
                            if (!ramble.paymentEnabled || ramble.paymentGuide == null) {
                              return const SizedBox.shrink();
                            }
                            return _buildPaymentSection(context, ramble);
                          },
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme, AsyncValue<Ramble> rambleAsync) {
    return SizedBox(
      height: 180,
      width: double.infinity,
      child: Stack(
        children: [
          // Background image or placeholder
          rambleAsync.when(
            data: (ramble) => ramble.coverImage != null
                ? Image.network(
                    "$kBaseUrl/uploads/ramble/${ramble.id}/${ramble.coverImage}",
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => _buildImagePlaceholder(theme, ramble),
                  )
                : _buildImagePlaceholder(theme, ramble),
            loading: () => _buildImagePlaceholder(theme, null),
            error: (_, __) => _buildImagePlaceholder(theme, null),
          ),

          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black.withOpacity(0.7)]),
            ),
          ),

          // Status chip and ramble type in top corners
          Positioned(
            top: 12,
            left: 12,
            child: rambleAsync.when(data: (ramble) => _buildRambleTypeChip(ramble), loading: () => const SizedBox.shrink(), error: (_, __) => const SizedBox.shrink()),
          ),

          Positioned(top: 12, right: 12, child: RegistrationStatusChip(status: registration.status)),

          // Bottom info
          Positioned(bottom: 12, left: 12, right: 12, child: _buildHeaderBottomInfo(rambleAsync)),
        ],
      ),
    );
  }

  Widget _buildImagePlaceholder(ThemeData theme, Ramble? ramble) {
    final icon = ramble != null ? (rambleTypeIcons[ramble.type] ?? Icons.explore) : Icons.explore;
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [theme.colorScheme.primary.withOpacity(0.8), theme.colorScheme.secondary.withOpacity(0.8)],
        ),
      ),
      child: Icon(icon, size: 64, color: Colors.white.withOpacity(0.8)),
    );
  }

  Widget _buildRambleTypeChip(Ramble ramble) {
    final label = rambleTypeLabels[ramble.type] ?? ramble.type;
    final icon = rambleTypeIcons[ramble.type] ?? Icons.explore;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey.shade700),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderBottomInfo(AsyncValue<Ramble> rambleAsync) {
    return rambleAsync.when(
      data: (ramble) => Row(
        children: [
          // Date and time
          if (ramble.date != null) ...[
            Icon(Icons.schedule, size: 16, color: Colors.white),
            const SizedBox(width: 4),
            Text(
              DateFormat('dd MMM, HH:mm', 'fr').format(ramble.date!.toLocal()),
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 13),
            ),
          ],
          const Spacer(),
          // Difficulty badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(color: (rambleDifficultyColors[ramble.difficulty] ?? Colors.grey).withOpacity(0.9), borderRadius: BorderRadius.circular(8)),
            child: Text(
              rambleDifficultyLabels[ramble.difficulty] ?? ramble.difficulty,
              style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildTitle(ThemeData theme, AsyncValue<Ramble> rambleAsync) {
    return rambleAsync.when(
      data: (ramble) => Text(
        ramble.title,
        style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      loading: () => Text(registration.ramble?.title ?? 'Balade #${registration.rambleId}', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
      error: (_, __) => Text(registration.ramble?.title ?? 'Balade #${registration.rambleId}', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildRambleInfo(ThemeData theme, AsyncValue<Ramble> rambleAsync) {
    return rambleAsync.when(
      data: (ramble) => Column(
        children: [
          // Location
          if (ramble.location != null) _buildInfoRow(Icons.location_on, ramble.location!, theme),

          // Guides
          if (ramble.guides.isNotEmpty) ...[const SizedBox(height: 4), _buildGuideInfo(ramble.guides, theme)],

          // Duration
          if (ramble.estimatedDuration != null) ...[
            const SizedBox(height: 4),
            _buildInfoRow(Icons.timer, '${ramble.estimatedDuration!.inHours}h${ramble.estimatedDuration!.inMinutes.remainder(60).toString().padLeft(2, '0')}', theme),
          ],
        ],
      ),
      loading: () => _buildBasicInfo(theme),
      error: (_, __) => _buildBasicInfo(theme),
    );
  }

  Widget _buildBasicInfo(ThemeData theme) {
    final parts = <String>[];
    if (registration.ramble?.date != null) {
      parts.add(DateFormat('EEEE dd MMM, HH:mm', 'fr').format(registration.ramble!.date!.toLocal()));
    }
    if (registration.ramble?.location != null) {
      parts.add(registration.ramble!.location!);
    }

    if (parts.isEmpty) return const SizedBox.shrink();

    return Text(parts.join(' • '), style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant));
  }

  Widget _buildInfoRow(IconData icon, String text, ThemeData theme) {
    return Row(
      children: [
        Icon(icon, size: 14, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 6),
        Expanded(
          child: Text(text, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        ),
      ],
    );
  }

  Widget _buildGuideInfo(List<Guide> guides, ThemeData theme) {
    final guideName = '${guides.first.firstName} ${guides.first.lastName}';
    final additionalCount = guides.length - 1;

    return Row(
      children: [
        Icon(Icons.person, size: 14, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            additionalCount > 0 ? '$guideName et ${additionalCount} autre${additionalCount > 1 ? 's' : ''}' : guideName,
            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
        ),
      ],
    );
  }

  Widget _buildRegistrationInfo(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: theme.colorScheme.surfaceVariant.withOpacity(0.3), borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          Icon(Icons.person_outline, size: 16, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 8),
          Expanded(
            child: Text('${registration.firstName} ${registration.lastName}', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
          ),
          Text(
            'Inscrit le ${DateFormat('dd/MM/yy').format(registration.registrationDate.toLocal())}',
            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmationNeeded(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.orange.shade50, Colors.orange.shade100], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: Colors.orange.shade100, borderRadius: BorderRadius.circular(20)),
                child: Icon(Icons.schedule, size: 16, color: Colors.orange.shade700),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Confirmation requise',
                      style: theme.textTheme.titleSmall?.copyWith(color: Colors.orange.shade800, fontWeight: FontWeight.w600),
                    ),
                    Text('Avant le ${_formatDeadline()}', style: theme.textTheme.bodySmall?.copyWith(color: Colors.orange.shade700)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: onConfirm,
                  icon: const Icon(Icons.check_circle, size: 18),
                  label: const Text('Confirmer ma présence'),
                  style: FilledButton.styleFrom(backgroundColor: Colors.green.shade600, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: () => onCancel(null),
                icon: const Icon(Icons.close, size: 16),
                label: const Text('Annuler'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.orange.shade700,
                  side: BorderSide(color: Colors.orange.shade300),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showRegistrationDetails(BuildContext context, Ramble? ramble) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _RegistrationDetailsSheet(registration: registration, ramble: ramble),
    );
  }

  bool _shouldShowConfirmation() {
    // Show the confirmation section when:
    // 1. Status is pending
    // 2. We're within 3 days of the ramble (when confirmation is possible)
    // 3. There's a confirmation deadline set
    return registration.status == 'pending' && _canConfirm() && registration.confirmationDeadline != null && registration.confirmationDeadline!.isAfter(DateTime.now());
  }

  String _formatDeadline() {
    if (registration.confirmationDeadline == null) return '';
    return DateFormat('dd/MM/yyyy à HH:mm', 'fr').format(registration.confirmationDeadline!.toLocal());
  }

  bool _hasAvailableActions() {
    return _canConfirm() || _canCancel();
  }

  bool _canConfirm() {
    if (registration.status != 'pending') return false;
    if (registration.ramble?.date == null) return false;

    final rambleDate = registration.ramble!.date!;
    final now = DateTime.now();
    final daysDifference = rambleDate.difference(now).inDays;

    return daysDifference <= 3;
  }

  bool _canCancel() {
    return registration.status != 'cancelled';
  }

  Widget _buildPaymentSection(BuildContext context, Ramble ramble) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Consumer(
      builder: (context, ref, child) {
        // Use the appropriate provider based on whether this is a group registration
        final paymentsAsync = registration.groupId != null ? ref.watch(groupPaymentsProvider(registration.groupId!)) : ref.watch(registrationPaymentsProvider(registration.id));

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Divider(color: colorScheme.outline.withOpacity(0.3)),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: colorScheme.primaryContainer.withOpacity(0.3), borderRadius: BorderRadius.circular(8)),
              child: Row(
                children: [
                  Icon(Icons.payment, color: colorScheme.primary, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          registration.groupId != null ? 'Paiement de groupe' : 'Paiement en ligne',
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.primary),
                        ),
                        Text(
                          ramble.paymentRequired ? 'Paiement requis pour finaliser votre inscription' : 'Paiement en ligne optionnel disponible',
                          style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onPrimaryContainer),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            paymentsAsync.when(
              loading: () => const Row(
                children: [
                  SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
                  SizedBox(width: 8),
                  Text('Vérification du statut...'),
                ],
              ),
              error: (error, _) => _buildPaymentError(context, ramble),
              data: (payments) {
                if (payments.isEmpty) {
                  return _buildNoPayment(context, ramble);
                } else {
                  final payment = payments.first;
                  return _buildPaymentStatus(context, payment, ramble);
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildNoPayment(BuildContext context, Ramble ramble) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Determine the correct payment route based on whether this is a group registration
    final paymentRoute = registration.groupId != null ? '/paiement/groupe/${registration.groupId}' : '/paiement/${registration.id}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (ramble.paymentRequired) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.errorContainer.withOpacity(0.5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: colorScheme.error.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.warning, color: colorScheme.error, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Paiement requis pour finaliser votre inscription',
                    style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onErrorContainer, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        ] else ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer.withOpacity(0.5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: colorScheme.primary.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.info, color: colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Le paiement en ligne est optionnel pour cette balade',
                    style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onPrimaryContainer, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => context.go(paymentRoute),
            icon: const Icon(Icons.payment),
            label: Text(ramble.paymentRequired ? 'Payer maintenant' : 'Procéder au paiement'),
            style: ElevatedButton.styleFrom(
              backgroundColor: ramble.paymentRequired ? theme.colorScheme.primary : theme.colorScheme.secondary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentStatus(BuildContext context, Payment payment, Ramble ramble) {
    final theme = Theme.of(context);

    // Determine the correct payment route based on whether this is a group registration
    final paymentRoute = registration.groupId != null ? '/paiement/groupe/${registration.groupId}' : '/paiement/${registration.id}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Statut: ', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
            PaymentStatusChip(status: payment.status),
          ],
        ),
        const SizedBox(height: 8),
        Text('Montant: ${(payment.amount / 100).toStringAsFixed(2)} €', style: theme.textTheme.bodyMedium),
        if (payment.paidAt != null) ...[
          const SizedBox(height: 4),
          Text(
            'Payé le: ${DateFormat('dd/MM/yyyy à HH:mm', 'fr').format(payment.paidAt!.toLocal())}',
            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
        ],
        if (payment.status.isPending) ...[
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => context.go(paymentRoute),
              icon: const Icon(Icons.payment),
              label: const Text('Finaliser le paiement'),
              style: ElevatedButton.styleFrom(backgroundColor: theme.colorScheme.primary, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPaymentError(BuildContext context, Ramble ramble) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Determine the correct payment route based on whether this is a group registration
    final paymentRoute = registration.groupId != null ? '/paiement/groupe/${registration.groupId}' : '/paiement/${registration.id}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: colorScheme.errorContainer.withOpacity(0.5), borderRadius: BorderRadius.circular(8)),
          child: Row(
            children: [
              Icon(Icons.error, color: colorScheme.error, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text('Impossible de charger les informations de paiement', style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onErrorContainer)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => context.go(paymentRoute),
            icon: const Icon(Icons.payment),
            label: const Text('Réessayer le paiement'),
            style: ElevatedButton.styleFrom(backgroundColor: theme.colorScheme.error, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
          ),
        ),
      ],
    );
  }
}

class _RegistrationDetailsSheet extends StatelessWidget {
  const _RegistrationDetailsSheet({required this.registration, this.ramble});

  final Registration registration;
  final Ramble? ramble;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(color: theme.colorScheme.onSurfaceVariant.withOpacity(0.3), borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(child: Text(ramble?.title ?? registration.ramble?.title ?? 'Balade #${registration.rambleId}', style: theme.textTheme.headlineSmall)),
                    RegistrationStatusChip(status: registration.status),
                  ],
                ),
                const SizedBox(height: 24),
                _buildInfoSection(context),
                if (ramble != null) ...[const SizedBox(height: 24), _buildRambleSection(context, ramble!)],
                const SizedBox(height: 24),
                _buildParticipantSection(context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Informations de l\'inscription', style: theme.textTheme.titleMedium),
        const SizedBox(height: 12),
        _buildInfoTile(icon: Icons.calendar_today, label: 'Inscrit le', value: DateFormat('dd/MM/yyyy à HH:mm', 'fr').format(registration.registrationDate.toLocal())),
        if (registration.confirmationDate != null)
          _buildInfoTile(icon: Icons.check_circle, label: 'Confirmé le', value: DateFormat('dd/MM/yyyy à HH:mm', 'fr').format(registration.confirmationDate!.toLocal())),
        if (registration.confirmationDeadline != null)
          _buildInfoTile(
            icon: Icons.access_time,
            label: 'Confirmation requise avant',
            value: DateFormat('dd/MM/yyyy à HH:mm', 'fr').format(registration.confirmationDeadline!.toLocal()),
          ),
        if (registration.cancellationDate != null) ...[
          _buildInfoTile(icon: Icons.cancel, label: 'Annulé le', value: DateFormat('dd/MM/yyyy à HH:mm', 'fr').format(registration.cancellationDate!.toLocal())),
          if (registration.cancellationReason != null) _buildInfoTile(icon: Icons.info, label: 'Raison', value: registration.cancellationReason!),
        ],
      ],
    );
  }

  Widget _buildRambleSection(BuildContext context, Ramble ramble) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Détails de la balade', style: theme.textTheme.titleMedium),
            const Spacer(),
            TextButton.icon(
              onPressed: () {
                context.pop();
                context.go('/balades/${registration.rambleId}');
              },
              icon: const Icon(Icons.open_in_new, size: 16),
              label: const Text('Voir plus'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (ramble.date != null) _buildInfoTile(icon: Icons.event, label: 'Date et heure', value: DateFormat('EEEE dd MMMM yyyy à HH:mm', 'fr').format(ramble.date!.toLocal())),
        if (ramble.location != null) _buildInfoTile(icon: Icons.location_on, label: 'Lieu', value: ramble.location!),
        if (ramble.guides.isNotEmpty)
          _buildInfoTile(icon: Icons.person, label: 'Guide${ramble.guides.length > 1 ? 's' : ''}', value: ramble.guides.map((g) => '${g.firstName} ${g.lastName}').join(', ')),
        if (ramble.estimatedDuration != null)
          _buildInfoTile(
            icon: Icons.timer,
            label: 'Durée estimée',
            value: '${ramble.estimatedDuration!.inHours}h${ramble.estimatedDuration!.inMinutes.remainder(60).toString().padLeft(2, '0')}',
          ),
        _buildInfoTile(icon: Icons.fitness_center, label: 'Difficulté', value: rambleDifficultyLabels[ramble.difficulty] ?? ramble.difficulty),
        if (ramble.description != null) _buildInfoTile(icon: Icons.description, label: 'Description', value: ramble.description!),
      ],
    );
  }

  Widget _buildParticipantSection(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Participant', style: theme.textTheme.titleMedium),
        const SizedBox(height: 12),
        _buildInfoTile(icon: Icons.person, label: 'Nom', value: '${registration.firstName} ${registration.lastName}'),
        _buildInfoTile(icon: Icons.email, label: 'Email', value: registration.email),
        if (registration.phone != null) _buildInfoTile(icon: Icons.phone, label: 'Téléphone', value: registration.phone!),
      ],
    );
  }

  Widget _buildInfoTile({required IconData icon, required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade600),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
