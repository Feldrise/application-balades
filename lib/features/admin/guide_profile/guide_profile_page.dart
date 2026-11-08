import 'package:balade/core/forms/form_layout.dart';
import 'package:balade/core/widgets/error_snackbar.dart';
import 'package:balade/features/admin/design/design.dart';
import 'package:balade/core/widgets/loading_overlay.dart';
import 'package:balade/features/authentication/authentication_provider.dart';
import 'package:balade/features/authentication/permission_provider.dart';
import 'package:balade/features/guides/guides_service.dart';
import 'package:balade/core/phone_utils.dart';
import 'package:balade/features/guides/models/guide/guide.dart';
import 'package:balade/features/guides/providers/current_guide_provider.dart';
import 'package:balade/features/guides/widgets/guide_form.dart';
import 'package:balade/core/forms/form_large_field.dart';
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

  Widget _page({required Widget body, List<Widget> actions = const [], String? subtitle}) {
    return Column(
      children: [
        ManagementPageHeader(title: 'Mon profil', subtitle: subtitle, actions: actions),
        Expanded(child: body),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final guideState = ref.watch(currentGuideProvider);
    final permission = ref.watch(permissionProvider);

    if (guideState.status == CurrentGuideStatus.loading) {
      return _page(body: const Center(child: CircularProgressIndicator()));
    }

    if (guideState.status == CurrentGuideStatus.unlinked) {
      return _page(
        body: Center(
          child: SingleChildScrollView(
            child: ManagementEmptyState(
              icon: Icons.link_off,
              title: 'Profil non lié',
              message: 'Votre compte n\'est pas encore associé à un profil guide.',
              action: OutlinedButton.icon(onPressed: _refreshRights, icon: const Icon(Icons.refresh), label: const Text('Rafraîchir mes droits')),
            ),
          ),
        ),
      );
    }

    if (guideState.status == CurrentGuideStatus.error || guideState.guide == null) {
      return _page(
        body: Center(child: ManagementEmptyState(icon: Icons.cloud_off, title: 'Impossible de charger votre profil guide', message: 'Vérifiez votre connexion puis réessayez.')),
      );
    }

    final guide = guideState.guide!;
    _syncPaymentFields(guide);

    return _page(
      subtitle: hasStoredPhone(guide.phone) ? formatStoredPhone(guide.phone) : null,
      actions: [
        IconButton(
          tooltip: 'Rafraîchir mes droits',
          onPressed: _refreshRights,
          icon: const Icon(Icons.refresh, color: Colors.white),
        ),
      ],
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  GuideForm(
                    key: _formKey,
                    initialGuide: guide,
                    selfEditMode: true,
                    onSaved: () => ref.read(currentGuideProvider.notifier).load(),
                  ),
                  if (permission?.canConfigureGuidePayments() == true)
                    FormLayout(
                      children: [
                        FormSection(
                          title: 'Configuration Stripe',
                          children: [
                            FormLargeField(
                              child: SwitchListTile(
                                contentPadding: EdgeInsets.zero,
                                title: const Text('Paiements activés'),
                                value: _paymentEnabled,
                                onChanged: (value) => setState(() => _paymentEnabled = value),
                              ),
                            ),
                            TextField(controller: _stripeAccountController, decoration: const InputDecoration(labelText: 'Stripe Account ID')),
                            TextField(controller: _stripePublicKeyController, decoration: const InputDecoration(labelText: 'Stripe Public Key')),
                            FormLargeField(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: FilledButton.icon(
                                  onPressed: _paymentSaving ? null : _savePaymentConfig,
                                  icon: _paymentSaving ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.payment),
                                  label: const Text('Enregistrer la configuration de paiement'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          ManagementActionBar(actions: [FilledButton(onPressed: () => _formKey.currentState?.save(), child: const Text('Enregistrer'))]),
        ],
      ),
    );
  }
}
