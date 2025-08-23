import 'package:balade/features/ramble/models/ramble/ramble.dart';
import 'package:balade/features/registrations/models/registration/registration.dart';
import 'package:balade/features/registrations/providers/registration_providers.dart';
import 'package:balade/features/registrations/widgets/participant_form_field.dart';
import 'package:balade/features/registrations/widgets/registration_success_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegistrationFormSheet extends ConsumerStatefulWidget {
  const RegistrationFormSheet({super.key, required this.ramble});

  final Ramble ramble;

  @override
  ConsumerState<RegistrationFormSheet> createState() => _RegistrationFormSheetState();
}

class _RegistrationFormSheetState extends ConsumerState<RegistrationFormSheet> {
  final _formKey = GlobalKey<FormState>();
  bool _isGroupRegistration = false;

  @override
  void initState() {
    super.initState();
    // Start with one participant
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(registrationFormProvider.notifier).reset();
      _addInitialParticipant();
    });
  }

  void _addInitialParticipant() {
    ref.read(registrationFormProvider.notifier).addParticipant(const RegistrationParticipant(firstName: '', lastName: '', email: '', phone: ''));
  }

  void _addParticipant() {
    ref.read(registrationFormProvider.notifier).addParticipant(const RegistrationParticipant(firstName: '', lastName: '', email: '', phone: ''));
  }

  void _removeParticipant(int index) {
    ref.read(registrationFormProvider.notifier).removeParticipant(index);
  }

  void _updateParticipant(int index, RegistrationParticipant participant) {
    ref.read(registrationFormProvider.notifier).updateParticipant(index, participant);
  }

  Future<void> _submitRegistration() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    await ref.read(registrationFormProvider.notifier).submitRegistration(widget.ramble.id);

    final state = ref.read(registrationFormProvider);
    if (state.result != null && mounted) {
      // Show success dialog
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) => RegistrationSuccessDialog(registration: state.result!, ramble: widget.ramble),
      );

      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final state = ref.watch(registrationFormProvider);

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4), borderRadius: BorderRadius.circular(2)),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.person_add, color: colorScheme.primary, size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text('Inscription à la balade', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                    ),
                    IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.close)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(widget.ramble.title, style: theme.textTheme.titleMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
              ],
            ),
          ),

          // Form content
          Expanded(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Group registration toggle
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Icon(Icons.group, color: colorScheme.primary),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Inscription de groupe', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                                  Text('Inscrire plusieurs personnes ensemble', style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
                                ],
                              ),
                            ),
                            Switch(
                              value: _isGroupRegistration,
                              onChanged: (value) {
                                setState(() {
                                  _isGroupRegistration = value;
                                  if (!value && state.participants.length > 1) {
                                    // Keep only first participant
                                    ref.read(registrationFormProvider.notifier).clearParticipants();
                                    _addInitialParticipant();
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Participants section
                    Text(_isGroupRegistration ? 'Participants (max 10)' : 'Vos informations', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),

                    // Participant forms
                    ...state.participants.asMap().entries.map((entry) {
                      final index = entry.key;
                      final participant = entry.value;
                      final isFirst = index == 0;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: ParticipantFormField(
                          key: ValueKey('participant_$index'),
                          participant: participant,
                          onChanged: (updatedParticipant) => _updateParticipant(index, updatedParticipant),
                          onRemove: (!isFirst && _isGroupRegistration) ? () => _removeParticipant(index) : null,
                          isFirst: isFirst,
                          participantNumber: index + 1,
                        ),
                      );
                    }),

                    // Add participant button (only for group registration)
                    if (_isGroupRegistration && state.participants.length < 10) ...[
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: _addParticipant,
                          icon: const Icon(Icons.person_add),
                          label: Text('Ajouter un participant (${state.participants.length}/10)'),
                          style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                        ),
                      ),
                    ],

                    const SizedBox(height: 32),

                    // Error message
                    if (state.error != null) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: colorScheme.error.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: colorScheme.error.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.error_outline, color: colorScheme.error),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(state.error!, style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.error)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],

                    const SizedBox(height: 100), // Space for bottom bar
                  ],
                ),
              ),
            ),
          ),

          // Bottom action bar
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              border: Border(top: BorderSide(color: colorScheme.outline.withValues(alpha: 0.2))),
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: state.isLoading ? null : _submitRegistration,
                  icon: state.isLoading ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.check),
                  label: Text(
                    state.isLoading ? 'Inscription en cours...' : 'Confirmer l\'inscription${state.participants.length > 1 ? ' (${state.participants.length} personnes)' : ''}',
                  ),
                  style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
