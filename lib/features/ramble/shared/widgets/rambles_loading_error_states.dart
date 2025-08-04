import 'package:flutter/material.dart';

class RamblesLoadingState extends StatelessWidget {
  const RamblesLoadingState({super.key, this.message = 'Chargement des balades...'});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(message, style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}

class RamblesErrorState extends StatelessWidget {
  const RamblesErrorState({super.key, required this.error, this.onRetry, this.retryLabel = 'Réessayer'});

  final String error;
  final VoidCallback? onRetry;
  final String retryLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: colorScheme.error),
            const SizedBox(height: 16),
            Text(
              'Une erreur est survenue',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[const SizedBox(height: 24), ElevatedButton.icon(onPressed: onRetry, icon: const Icon(Icons.refresh), label: Text(retryLabel))],
          ],
        ),
      ),
    );
  }
}
