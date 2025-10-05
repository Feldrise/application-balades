import 'package:balade/features/admin/registrations_management/models/admin_registration_response.dart';
import 'package:balade/features/admin/registrations_management/providers/admin_registrations_provider.dart';
import 'package:balade/features/authentication/authentication_provider.dart';
import 'package:balade/features/registrations/models/registration/registration.dart';
import 'package:balade/features/registrations/registrations_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegistrationEditDialog extends ConsumerStatefulWidget {
  const RegistrationEditDialog({super.key, required this.registration});

  final Registration registration;

  @override
  ConsumerState<RegistrationEditDialog> createState() => _RegistrationEditDialogState();
}

class _RegistrationEditDialogState extends ConsumerState<RegistrationEditDialog> {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController notesController;
  late String selectedStatus;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController(text: widget.registration.firstName);
    lastNameController = TextEditingController(text: widget.registration.lastName);
    emailController = TextEditingController(text: widget.registration.email);
    phoneController = TextEditingController(text: widget.registration.phone ?? '');
    notesController = TextEditingController();
    selectedStatus = widget.registration.status;
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Modifier l\'inscription de ${widget.registration.firstName} ${widget.registration.lastName}'),
      content: SizedBox(
        width: 500,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: firstNameController,
                      decoration: const InputDecoration(labelText: 'Prénom', border: OutlineInputBorder()),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: lastNameController,
                      decoration: const InputDecoration(labelText: 'Nom', border: OutlineInputBorder()),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Téléphone', border: OutlineInputBorder()),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedStatus,
                decoration: const InputDecoration(labelText: 'Statut', border: OutlineInputBorder()),
                items: const [
                  DropdownMenuItem(value: 'pending', child: Text('⏳ En attente')),
                  DropdownMenuItem(value: 'confirmed', child: Text('✅ Confirmé')),
                  DropdownMenuItem(value: 'waiting_list', child: Text('📋 Liste d\'attente')),
                  DropdownMenuItem(value: 'cancelled', child: Text('❌ Annulé')),
                ],
                onChanged: (value) => setState(() => selectedStatus = value!),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: notesController,
                decoration: const InputDecoration(labelText: 'Notes de modification (optionnel)', border: OutlineInputBorder()),
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Annuler')),
        FilledButton(
          onPressed: isLoading ? null : _saveChanges,
          child: isLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Enregistrer'),
        ),
      ],
    );
  }

  void _saveChanges() async {
    final auth = ref.read(authenticationProvider);
    if (auth == null) return;

    setState(() => isLoading = true);

    try {
      final payload = AdminRegistrationUpdatePayload(
        firstName: firstNameController.text.trim().isEmpty ? null : firstNameController.text.trim(),
        lastName: lastNameController.text.trim().isEmpty ? null : lastNameController.text.trim(),
        email: emailController.text.trim().isEmpty ? null : emailController.text.trim(),
        phone: phoneController.text.trim().isEmpty ? null : phoneController.text.trim(),
        status: selectedStatus != widget.registration.status ? selectedStatus : null,
        notes: notesController.text.trim().isEmpty ? null : notesController.text.trim(),
      );

      final updatedRegistration = await RegistrationsService.instance.updateRegistrationDetails(widget.registration.id, payload, authorization: 'Bearer ${auth.token}');

      ref.read(adminRegistrationsProvider.notifier).refreshRegistration(updatedRegistration);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Inscription mise à jour avec succès')));
      }
    } catch (e) {
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur lors de la mise à jour: $e')));
      }
    }
  }
}
