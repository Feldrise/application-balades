import 'package:balade/core/form_validator.dart';
import 'package:balade/features/registrations/models/registration/registration.dart';
import 'package:flutter/material.dart';

class ParticipantFormField extends StatefulWidget {
  const ParticipantFormField({super.key, required this.participant, required this.onChanged, this.onRemove, this.isFirst = false, this.participantNumber = 1});

  final RegistrationParticipant participant;
  final Function(RegistrationParticipant) onChanged;
  final VoidCallback? onRemove;
  final bool isFirst;
  final int participantNumber;

  @override
  State<ParticipantFormField> createState() => _ParticipantFormFieldState();
}

class _ParticipantFormFieldState extends State<ParticipantFormField> {
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.participant.firstName);
    _lastNameController = TextEditingController(text: widget.participant.lastName);
    _emailController = TextEditingController(text: widget.participant.email);
    _phoneController = TextEditingController(text: widget.participant.phone ?? '');

    // Add listeners to update the participant data
    _firstNameController.addListener(_updateParticipant);
    _lastNameController.addListener(_updateParticipant);
    _emailController.addListener(_updateParticipant);
    _phoneController.addListener(_updateParticipant);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _updateParticipant() {
    final updatedParticipant = RegistrationParticipant(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      email: _emailController.text,
      phone: _phoneController.text.isEmpty ? null : _phoneController.text,
    );
    widget.onChanged(updatedParticipant);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with participant number and remove button
            Row(
              children: [
                Icon(widget.isFirst ? Icons.person : Icons.person_outline, color: colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.isFirst ? 'Contact principal' : 'Participant ${widget.participantNumber}',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                if (widget.onRemove != null)
                  IconButton(
                    onPressed: widget.onRemove,
                    icon: Icon(Icons.remove_circle_outline, color: colorScheme.error),
                    tooltip: 'Supprimer ce participant',
                  ),
              ],
            ),

            if (widget.isFirst) ...[
              const SizedBox(height: 4),
              Text('Cette personne recevra tous les emails de confirmation', style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
            ],

            const SizedBox(height: 20),

            // Name fields row
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _firstNameController,
                    decoration: const InputDecoration(labelText: 'Prénom *', hintText: 'Ex: Marie', prefixIcon: Icon(Icons.person_outline)),
                    textInputAction: TextInputAction.next,
                    validator: (value) => FormValidator.validateRequired(value, 'Le prénom est requis'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _lastNameController,
                    decoration: const InputDecoration(labelText: 'Nom *', hintText: 'Ex: Dupont'),
                    textInputAction: TextInputAction.next,
                    validator: (value) => FormValidator.validateRequired(value, 'Le nom est requis'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Email field
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email *', hintText: 'marie.dupont@example.com', prefixIcon: Icon(Icons.email_outlined)),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: FormValidator.validateEmail,
            ),

            const SizedBox(height: 16),

            // Phone field
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Téléphone (optionnel)',
                hintText: '06 12 34 56 78',
                prefixIcon: Icon(Icons.phone_outlined),
                helperText: 'Utile en cas d\'urgence ou de changements de dernière minute',
              ),
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  return FormValidator.validatePhone(value);
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}
