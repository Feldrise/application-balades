import 'package:balade/core/form_validator.dart';
import 'package:flutter/material.dart';

class AdminLoginEmailStep extends StatelessWidget {
  const AdminLoginEmailStep({super.key, required this.emailController, required this.onSendCode, this.onFieldSubmitted});

  final TextEditingController emailController;
  final VoidCallback onSendCode;
  final void Function(String)? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('email-step'),
      children: [
        TextFormField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          validator: (value) => FormValidator.emailValidator(value, isRequired: true),
          onFieldSubmitted: onFieldSubmitted,
          decoration: const InputDecoration(labelText: 'Adresse email', hintText: 'votre.email@organisation.com', prefixIcon: Icon(Icons.email_outlined)),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(onPressed: onSendCode, icon: const Icon(Icons.send_outlined, size: 20), label: const Text('Recevoir le code')),
        ),
      ],
    );
  }
}
