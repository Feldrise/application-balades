import 'package:balade/features/authentication/authentication_provider.dart';
import 'package:balade/features/ramble/models/ramble/ramble.dart';
import 'package:balade/features/reservations/providers/reservation_providers.dart';
import 'package:balade/features/reservations/reservation_format.dart';
import 'package:balade/features/reservations/widgets/reservation_counters.dart';
import 'package:balade/features/reservations/widgets/reservation_notices.dart';
import 'package:balade/features/reservations/widgets/reservation_participant_line.dart';
import 'package:balade/features/reservations/widgets/reservation_success_dialog.dart';
import 'package:balade/features/reservations/user_reservations_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ReservationFormSheet extends ConsumerStatefulWidget {
  const ReservationFormSheet({super.key, required this.ramble});

  final Ramble ramble;

  @override
  ConsumerState<ReservationFormSheet> createState() => _ReservationFormSheetState();
}

class _ReservationFormSheetState extends ConsumerState<ReservationFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final user = ref.read(authenticationProvider)?.user;
    if (user != null) {
      _emailController.text = user.email;
      final firstName = user.profile?.firstName;
      final lastName = user.profile?.lastName;
      if (firstName != null && lastName != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) ref.read(reservationFormProvider(widget.ramble).notifier).prefill(firstName: firstName, lastName: lastName);
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    await ref.read(reservationFormProvider(widget.ramble).notifier).submit(contactEmail: _emailController.text, contactPhone: _phoneController.text);
    if (!mounted) return;

    final form = ref.read(reservationFormProvider(widget.ramble));
    if (form.existingReservationId != null) {
      _goToExistingReservation(form.existingReservationId!);
      return;
    }

    final created = form.created;
    if (created == null) return;

    final navigator = Navigator.of(context);
    final notifier = ref.read(reservationFormProvider(widget.ramble).notifier);
    navigator.pop();
    await showDialog<void>(
      context: navigator.context,
      barrierDismissible: false,
      builder: (context) => ReservationSuccessDialog(reservation: created, ramble: widget.ramble),
    );
    notifier.reset();
  }

  /// The booker already has a reservation for this ramble: they add participants to it, after logging in if needed.
  void _goToExistingReservation(int reservationId) {
    final authed = ref.read(authenticationProvider);
    final email = _emailController.text.trim();
    final location = addParticipantsLocation(reservationId);
    final messenger = ScaffoldMessenger.of(context);
    final router = GoRouter.of(context);

    ref.read(reservationFormProvider(widget.ramble).notifier).reset();
    Navigator.of(context).pop();

    if (authed != null && authed.user.email.toLowerCase() == email.toLowerCase()) {
      messenger.showSnackBar(const SnackBar(content: Text('Vous avez déjà une réservation pour cette balade : ajoutez-y vos participants.')));
      router.go(location);
    } else {
      messenger.showSnackBar(const SnackBar(content: Text('Vous avez déjà une réservation pour cette balade : connectez-vous pour y ajouter vos participants.')));
      router.go(Uri(path: '/connexion', queryParameters: {'email': email, 'redirection': location}).toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final form = ref.watch(reservationFormProvider(widget.ramble));
    final notifier = ref.read(reservationFormProvider(widget.ramble).notifier);
    final draft = form.draft;
    final tariffLabels = draft.hasTariffChoice ? [for (final price in draft.prices) price.label] : const <String>[];

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(color: colorScheme.surface, borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4), borderRadius: BorderRadius.circular(2)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
            child: Row(
              children: [
                Icon(Icons.event_available, color: colorScheme.primary, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Réserver', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Combien de personnes ?', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    ReservationCounters(ramble: widget.ramble),
                    const SizedBox(height: 24),
                    Text('Participants', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    for (var i = 0; i < draft.participants.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: ReservationParticipantLine(
                          key: ValueKey(draft.participants[i].key),
                          participant: draft.participants[i],
                          number: i + 1,
                          tariffLabels: tariffLabels,
                          onChanged: ({firstName, lastName, priceLabel, isBooker}) =>
                              notifier.updateParticipant(i, firstName: firstName, lastName: lastName, priceLabel: priceLabel, isBooker: isBooker),
                          onRemove: draft.total > 1 ? () => notifier.removeParticipant(i) : null,
                        ),
                      ),
                    const SizedBox(height: 12),
                    Text('Contact', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(
                      'La personne qui réserve est le contact : elle reçoit les emails et gère la réservation. Les autres participants n\'ont pas besoin d\'email.',
                      style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(labelText: 'Email *', prefixIcon: Icon(Icons.email_outlined), border: OutlineInputBorder()),
                      validator: (value) {
                        final email = value?.trim() ?? '';
                        if (email.isEmpty) return 'Email requis';
                        if (!RegExp(r'^[\w.+-]+@([\w-]+\.)+[a-zA-Z]{2,}$').hasMatch(email)) return 'Veuillez entrer une adresse e-mail valide.';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(labelText: 'Téléphone (facultatif)', prefixIcon: Icon(Icons.phone_outlined), border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 24),
                    if (draft.goesToWaitingList) ...[const ReservationNotice(icon: Icons.hourglass_top, color: Colors.orange, message: kWaitingListWarning), const SizedBox(height: 12)],
                    const ReservationNotice(icon: Icons.info_outline, message: kConfirmationNotice),
                    if (form.error != null) ...[const SizedBox(height: 12), ReservationNotice(icon: Icons.error_outline, color: colorScheme.error, message: form.error!)],
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: colorScheme.surface, border: Border(top: BorderSide(color: colorScheme.outline.withValues(alpha: 0.2)))),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text('Montant estimé', style: theme.textTheme.titleMedium)),
                      Text(formatCents(draft.estimatedAmountCents), style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.primary)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: form.isSubmitting ? null : _submit,
                      icon: form.isSubmitting ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.check),
                      label: Text(form.isSubmitting ? 'Réservation en cours...' : 'Réserver pour ${draft.total} ${draft.total > 1 ? 'personnes' : 'personne'}'),
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
