import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RegistrationsEmptyState extends StatelessWidget {
  const RegistrationsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.event_busy, size: 64, color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7)),
            const SizedBox(height: 16),
            Text('Aucune inscription pour le moment', style: theme.textTheme.titleLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            const SizedBox(height: 8),
            Text(
              'Explorez les balades et inscrivez-vous à celles qui vous intéressent.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant.withOpacity(0.8)),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(onPressed: () => context.go('/'), icon: const Icon(Icons.explore), label: const Text('Découvrir les balades')),
          ],
        ),
      ),
    );
  }
}
