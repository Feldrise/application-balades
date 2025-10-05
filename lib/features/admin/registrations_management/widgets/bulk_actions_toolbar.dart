import 'package:balade/features/admin/registrations_management/providers/bulk_actions_provider.dart';
import 'package:balade/features/authentication/authentication_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BulkActionsToolbar extends ConsumerWidget {
  const BulkActionsToolbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bulkActionsState = ref.watch(bulkActionsProvider);
    final bulkActionsNotifier = ref.read(bulkActionsProvider.notifier);

    if (!bulkActionsState.hasSelection) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.all(16),
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(12),
        color: theme.colorScheme.primaryContainer,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle_outline, color: theme.colorScheme.onPrimaryContainer),
              const SizedBox(width: 12),
              Text(
                '${bulkActionsState.selectionCount} inscription(s) sélectionnée(s)',
                style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500, color: theme.colorScheme.onPrimaryContainer),
              ),
              const SizedBox(width: 24),
              TextButton(
                onPressed: bulkActionsNotifier.clearSelection,
                style: TextButton.styleFrom(foregroundColor: theme.colorScheme.onPrimaryContainer),
                child: const Text('Désélectionner'),
              ),
              const SizedBox(width: 8),
              _buildQuickActionButton(context, 'Confirmer', Icons.check_circle, Colors.green, () => _showQuickActionConfirmation(context, ref, 'confirm', 'confirmer')),
              const SizedBox(width: 8),
              _buildQuickActionButton(context, 'Annuler', Icons.cancel, Colors.red, () => _showQuickActionConfirmation(context, ref, 'cancel', 'annuler')),
              const SizedBox(width: 8),
              _buildQuickActionButton(
                context,
                'Liste d\'attente',
                Icons.queue,
                Colors.blue,
                () => _showQuickActionConfirmation(context, ref, 'move_to_waiting', 'mettre en liste d\'attente'),
              ),
              const SizedBox(width: 8),
              FilledButton.icon(
                onPressed: () => _showBulkActionsDialog(context, ref),
                icon: const Icon(Icons.more_horiz),
                label: const Text('Plus d\'options'),
                style: FilledButton.styleFrom(backgroundColor: theme.colorScheme.primary, foregroundColor: theme.colorScheme.onPrimary),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionButton(BuildContext context, String label, IconData icon, Color color, VoidCallback onPressed) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        side: BorderSide(color: color),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }

  void _showQuickActionConfirmation(BuildContext context, WidgetRef ref, String action, String actionLabel) {
    final bulkActionsState = ref.read(bulkActionsProvider);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmer l\'action'),
        content: Text('Êtes-vous sûr de vouloir $actionLabel les ${bulkActionsState.selectionCount} inscription(s) sélectionnée(s) ?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Annuler')),
          FilledButton(onPressed: () => _performQuickAction(context, ref, action), child: const Text('Confirmer')),
        ],
      ),
    );
  }

  void _performQuickAction(BuildContext context, WidgetRef ref, String action) async {
    Navigator.of(context).pop(); // Close confirmation dialog

    final auth = ref.read(authenticationProvider);
    if (auth == null) return;

    final success = await ref.read(bulkActionsProvider.notifier).performBulkAction(action: action, authorization: 'Bearer ${auth.token}', sendEmail: true);

    if (context.mounted) {
      final result = ref.read(bulkActionsProvider).lastResult;
      if (success && result != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${result.successCount} inscription(s) mise(s) à jour avec succès'), backgroundColor: Colors.green));
      } else if (result != null && result.failureCount > 0) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('${result.failureCount} erreur(s) lors de l\'opération'), backgroundColor: Theme.of(context).colorScheme.error));
      }
    }
  }

  void _showBulkActionsDialog(BuildContext context, WidgetRef ref) {
    showDialog(context: context, builder: (context) => const BulkActionsAdvancedDialog());
  }
}

class BulkActionsAdvancedDialog extends ConsumerStatefulWidget {
  const BulkActionsAdvancedDialog({super.key});

  @override
  ConsumerState<BulkActionsAdvancedDialog> createState() => _BulkActionsAdvancedDialogState();
}

class _BulkActionsAdvancedDialogState extends ConsumerState<BulkActionsAdvancedDialog> {
  String selectedAction = 'confirm';
  String? reason;
  bool sendEmail = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bulkActionsState = ref.watch(bulkActionsProvider);

    return AlertDialog(
      title: Text('Actions groupées avancées (${bulkActionsState.selectionCount} inscriptions)'),
      content: SizedBox(
        width: 450,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sélectionnez l\'action à effectuer:', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: selectedAction,
              decoration: const InputDecoration(border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
              items: const [
                DropdownMenuItem(value: 'confirm', child: Text('✅ Confirmer les inscriptions')),
                DropdownMenuItem(value: 'cancel', child: Text('❌ Annuler les inscriptions')),
                DropdownMenuItem(value: 'move_to_waiting', child: Text('📋 Mettre en liste d\'attente')),
                DropdownMenuItem(value: 'delete', child: Text('🗑️ Supprimer les inscriptions')),
              ],
              onChanged: (value) => setState(() => selectedAction = value!),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Raison de l\'action (optionnel)',
                border: OutlineInputBorder(),
                helperText: 'Cette raison sera enregistrée dans l\'historique',
              ),
              maxLines: 3,
              onChanged: (value) => reason = value.isEmpty ? null : value,
            ),
            const SizedBox(height: 16),
            Card(
              color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    CheckboxListTile(
                      title: const Text('Envoyer un email de notification'),
                      subtitle: const Text('Les participants recevront un email les informant du changement'),
                      value: sendEmail,
                      onChanged: (value) => setState(() => sendEmail = value ?? false),
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
            ),
            if (selectedAction == 'delete') ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: theme.colorScheme.error.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: theme.colorScheme.error),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Attention: Cette action est irréversible. Les inscriptions seront définitivement supprimées.',
                        style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.error),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Annuler')),
        FilledButton(
          onPressed: bulkActionsState.isLoading ? null : _performAdvancedAction,
          style: selectedAction == 'delete' ? FilledButton.styleFrom(backgroundColor: theme.colorScheme.error) : null,
          child: bulkActionsState.isLoading
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
              : Text(selectedAction == 'delete' ? 'Supprimer' : 'Appliquer'),
        ),
      ],
    );
  }

  void _performAdvancedAction() async {
    final auth = ref.read(authenticationProvider);
    if (auth == null) return;

    final success = await ref
        .read(bulkActionsProvider.notifier)
        .performBulkAction(action: selectedAction, authorization: 'Bearer ${auth.token}', reason: reason, sendEmail: sendEmail);

    if (mounted) {
      Navigator.of(context).pop();

      final result = ref.read(bulkActionsProvider).lastResult;
      if (success && result != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${result.successCount} inscription(s) mise(s) à jour avec succès'), backgroundColor: Colors.green));
      } else if (result != null && result.failureCount > 0) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('${result.failureCount} erreur(s) lors de l\'opération'), backgroundColor: Theme.of(context).colorScheme.error));
      }
    }
  }
}
