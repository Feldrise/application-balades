import 'package:balade/core/widgets/error_snackbar.dart';
import 'package:balade/core/widgets/loading_overlay.dart';
import 'package:balade/features/authentication/authentication_provider.dart';
import 'package:balade/features/authentication/permission_provider.dart';
import 'package:balade/features/guides/guides_service.dart';
import 'package:balade/features/guides/models/guide/guide.dart';
import 'package:balade/features/guides/providers/current_guide_provider.dart';
import 'package:balade/features/guides/widgets/guide_form.dart';
import 'package:balade/core/forms/form_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GuideProfilePage extends ConsumerStatefulWidget {
  const GuideProfilePage({super.key});

  @override
  ConsumerState<GuideProfilePage> createState() => _GuideProfilePageState();
}

class _GuideProfilePageState extends ConsumerState<GuideProfilePage> {
  final _formKey = GlobalKey<GuideFormState>();
  final _stripeAccountController = TextEditingController();
  final _stripePublicKeyController = TextEditingController();
  bool _paymentEnabled = false;
  bool _paymentSaving = false;
  int? _initializedGuideId;

  @override
  void dispose() {
    _stripeAccountController.dispose();
    _stripePublicKeyController.dispose();
    super.dispose();
  }

  void _syncPaymentFields(Guide guide) {
    if (_initializedGuideId == guide.id) return;
    _initializedGuideId = guide.id;
    _stripeAccountController.text = guide.stripeAccountId ?? '';
    _stripePublicKeyController.text = guide.stripePublicKey ?? '';
    _paymentEnabled = guide.paymentEnabled;
  }

  Future<void> _savePaymentConfig() async {
    final token = ref.read(authenticationProvider)?.token;
    if (token == null) return;

    setState(() => _paymentSaving = true);
    try {
      await GuidesService.instance.updateMyPaymentConfig(
        {
          'stripe_account_id': _stripeAccountController.text.trim(),
          'stripe_public_key': _stripePublicKeyController.text.trim(),
          'payment_enabled': _paymentEnabled,
        },
        authorization: token,
      );
      await ref.read(currentGuideProvider.notifier).load();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Configuration de paiement enregistrée')));
      }
    } catch (e) {
      if (mounted) ErrorSnackbar.show(context, 'Erreur : $e');
    } finally {
      if (mounted) setState(() => _paymentSaving = false);
    }
  }

  Future<void> _refreshRights() async {
    try {
      LoadingOverlay.of(context).show();
      await ref.read(authenticationProvider.notifier).refreshUser();
      await ref.read(currentGuideProvider.notifier).load();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Droits actualisés')));
      }
    } catch (e) {
      if (mounted) ErrorSnackbar.show(context, 'Erreur lors de l\'actualisation : $e');
    } finally {
      if (mounted) LoadingOverlay.of(context).hide();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final guideState = ref.watch(currentGuideProvider);
    final permission = ref.watch(permissionProvider);

    if (guideState.status == CurrentGuideStatus.loading) {
      return const Scaffold(backgroundColor: Colors.transparent, body: Center(child: CircularProgressIndicator()));
    }

    if (guideState.status == CurrentGuideStatus.unlinked) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(48),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.link_off, size: 64, color: theme.colorScheme.error),
                  const SizedBox(height: 16),
                  Text('Profil non lié', style: theme.textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  const Text('Votre compte n\'est pas encore associé à un profil guide.'),
                  const SizedBox(height: 24),
                  OutlinedButton.icon(onPressed: _refreshRights, icon: const Icon(Icons.refresh), label: const Text('Rafraîchir mes droits')),
                ],
              ),
            ),
          ),
        ),
      );
    }

    if (guideState.guide == null) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(child: Text('Impossible de charger votre profil guide.', style: theme.textTheme.bodyLarge)),
      );
    }

    final guide = guideState.guide!;
    _syncPaymentFields(guide);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Mon profil guide', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text('Gérez vos informations et votre configuration de paiement', style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                        ],
                      ),
                    ),
                    OutlinedButton.icon(onPressed: _refreshRights, icon: const Icon(Icons.refresh), label: const Text('Rafraîchir mes droits')),
                    const SizedBox(width: 12),
                    FilledButton.icon(
                      onPressed: () => _formKey.currentState?.save(),
                      icon: const Icon(Icons.save),
                      label: const Text('Enregistrer le profil'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: GuideForm(
                  key: _formKey,
                  initialGuide: guide,
                  selfEditMode: true,
                  onSaved: () => ref.read(currentGuideProvider.notifier).load(),
                ),
              ),
            ),
            if (permission?.canConfigureGuidePayments() == true) ...[
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: FormSection(
                    title: 'Configuration Stripe',
                    children: [
                      SwitchListTile(
                        title: const Text('Paiements activés'),
                        value: _paymentEnabled,
                        onChanged: (value) => setState(() => _paymentEnabled = value),
                      ),
                      TextField(
                        controller: _stripeAccountController,
                        decoration: const InputDecoration(labelText: 'Stripe Account ID', border: OutlineInputBorder()),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _stripePublicKeyController,
                        decoration: const InputDecoration(labelText: 'Stripe Public Key', border: OutlineInputBorder()),
                      ),
                      const SizedBox(height: 24),
                      Align(
                        alignment: Alignment.centerRight,
                        child: FilledButton.icon(
                          onPressed: _paymentSaving ? null : _savePaymentConfig,
                          icon: _paymentSaving ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.payment),
                          label: const Text('Enregistrer la configuration de paiement'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
