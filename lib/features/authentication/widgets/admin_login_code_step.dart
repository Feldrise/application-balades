import 'package:balade/core/form_validator.dart';
import 'package:flutter/material.dart';

class AdminLoginCodeStep extends StatelessWidget {
  final TextEditingController codeController;
  final String email;
  final bool obscureCode;
  final VoidCallback onVerifyCode;
  final VoidCallback onGoBack;
  final VoidCallback onToggleObscure;
  final void Function(String)? onFieldSubmitted;
  const AdminLoginCodeStep({
    super.key,
    required this.codeController,
    required this.email,
    required this.obscureCode,
    required this.onVerifyCode,
    required this.onGoBack,
    required this.onToggleObscure,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      key: const ValueKey('code-step'),
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer.withAlpha(76),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: theme.colorScheme.primary.withAlpha(76)),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: theme.colorScheme.primary, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text('Un code de vérification a été envoyé à $email', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onPrimaryContainer)),
              ),
            ],
          ),
        ),
        TextFormField(
          controller: codeController,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          obscureText: obscureCode,
          validator: (value) => FormValidator.requiredValidator(value),
          onFieldSubmitted: onFieldSubmitted,
          decoration: InputDecoration(
            labelText: 'Code de vérification',
            hintText: '123456',
            prefixIcon: const Icon(Icons.security_outlined),
            suffixIcon: IconButton(onPressed: onToggleObscure, icon: Icon(obscureCode ? Icons.visibility : Icons.visibility_off)),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(onPressed: onGoBack, icon: const Icon(Icons.arrow_back), label: const Text('Retour')),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton.icon(onPressed: onVerifyCode, icon: const Icon(Icons.login, size: 20), label: const Text('Se connecter')),
            ),
          ],
        ),
      ],
    );
  }
}
