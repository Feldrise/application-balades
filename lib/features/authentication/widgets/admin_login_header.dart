import 'package:flutter/material.dart';

class AdminLoginHeader extends StatelessWidget {
  final bool showCodeStep;
  const AdminLoginHeader({super.key, required this.showCodeStep});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: theme.colorScheme.primary.withAlpha(25), shape: BoxShape.circle),
          child: Icon(Icons.admin_panel_settings, size: 48, color: theme.colorScheme.primary),
        ),
        const SizedBox(height: 16),
        Text(
          'Administration',
          style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
        ),
        const SizedBox(height: 8),
        Text(
          showCodeStep ? 'Saisissez le code reçu par email' : 'Accès réservé aux organisateurs',
          style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
