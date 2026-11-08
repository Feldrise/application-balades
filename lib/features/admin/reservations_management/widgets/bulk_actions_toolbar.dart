import 'package:balade/features/admin/design/design.dart';
import 'package:balade/features/admin/reservations_management/providers/bulk_actions_provider.dart';
import 'package:balade/features/authentication/authentication_provider.dart';
import 'package:balade/features/authentication/permission_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Whether the account can act on several reservations at once: the admin, and those with the bulk permission.
bool canBulkReservations(WidgetRef ref) {
  final permission = ref.watch(permissionProvider);
  return permission?.isAdmin() == true || permission?.canBulkRegistrationActions() == true;
}

String _selection(int count) => '$count réservation${count > 1 ? 's' : ''} sélectionnée${count > 1 ? 's' : ''}';

/// The bar fixed at the bottom of the desktop list once reservations are selected: the three status changes and « Plus d'options ».
/// Hidden without a selection, and for accounts that cannot act on several reservations.
class BulkActionsToolbar extends ConsumerWidget {
  const BulkActionsToolbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bulk = ref.watch(bulkActionsProvider);
    if (!bulk.hasSelection || !canBulkReservations(ref)) return const SizedBox.shrink();

    final theme = Theme.of(context);
    return Material(
      color: ManagementColors.deepGreen,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: ManagementBreakpoints.gutter(context), vertical: 10),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(_selection(bulk.selectionCount), style: theme.textTheme.titleSmall?.copyWith(color: Colors.white)),
              TextButton(
                onPressed: ref.read(bulkActionsProvider.notifier).clearSelection,
                style: TextButton.styleFrom(foregroundColor: Colors.white70),
                child: const Text('Désélectionner'),
              ),
              const SizedBox(width: 12),
              for (final action in _BulkAction.quick) _QuickButton(action: action),
              TextButton(
                onPressed: () => showDialog<void>(context: context, builder: (context) => const _MoreOptionsDialog()),
                style: TextButton.styleFrom(foregroundColor: Colors.white),
                child: const Text('Plus d\'options'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum _BulkAction {
  confirm('confirm', 'Confirmer', 'confirmer', 'Elles seront confirmées sans la confirmation des personnes qui réservent ni leur paiement en ligne.'),
  cancel(
    'cancel',
    'Annuler',
    'annuler',
    'Les places seront libérées et les personnes qui réservent seront prévenues par email. La plateforme ne fait aucun remboursement automatique : celles qui ont déjà payé seront invitées à contacter le guide.',
  ),
  waiting('move_to_waiting', 'Liste d\'attente', 'mettre en liste d\'attente', 'Les places seront libérées. Elles passeront dès que la place le permet.');

  const _BulkAction(this.api, this.label, this.verb, this.consequence);

  final String api;
  final String label;
  final String verb;
  final String consequence;

  static const quick = [confirm, cancel, waiting];
}

class _QuickButton extends ConsumerWidget {
  const _QuickButton({required this.action});

  final _BulkAction action;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OutlinedButton(
      key: ValueKey('bulk-action-${action.api}'),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        side: const BorderSide(color: Colors.white54),
      ),
      onPressed: () async {
        final count = ref.read(bulkActionsProvider).selectionCount;
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('${action.label} ${count > 1 ? 'ces $count réservations' : 'cette réservation'} ?'),
            content: Text('Vous allez ${action.verb} ${_selection(count)}. ${action.consequence}'),
            actions: [
              TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Retour')),
              FilledButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Confirmer')),
            ],
          ),
        );
        if (confirmed == true && context.mounted) await _perform(context, ref, action.api, sendEmail: true);
      },
      child: Text(action.label),
    );
  }
}

/// Applies [action] to the selection and tells how it went.
Future<void> _perform(BuildContext context, WidgetRef ref, String action, {String? reason, required bool sendEmail}) async {
  final token = ref.read(authenticationProvider)?.token;
  if (token == null) return;
  final messenger = ScaffoldMessenger.of(context);
  final errorColor = Theme.of(context).colorScheme.error;

  final success = await ref.read(bulkActionsProvider.notifier).performBulkAction(action: action, token: token, reason: reason, sendEmail: sendEmail);

  final result = ref.read(bulkActionsProvider).lastResult;
  if (success && result != null) {
    messenger.showSnackBar(SnackBar(content: Text('${result.successCount} réservation(s) mise(s) à jour avec succès')));
  } else if (result != null && result.failureCount > 0) {
    messenger.showSnackBar(SnackBar(content: Text('${result.failureCount} erreur(s) lors de l\'opération'), backgroundColor: errorColor));
  } else if (ref.read(bulkActionsProvider).error != null) {
    messenger.showSnackBar(SnackBar(content: const Text('L\'opération a échoué'), backgroundColor: errorColor));
  }
}

/// The actions that need more than a tap: with a reason, whether to tell the bookers, and the deletion.
class _MoreOptionsDialog extends ConsumerStatefulWidget {
  const _MoreOptionsDialog();

  @override
  ConsumerState<_MoreOptionsDialog> createState() => _MoreOptionsDialogState();
}

class _MoreOptionsDialogState extends ConsumerState<_MoreOptionsDialog> {
  String _action = 'confirm';
  String? _reason;
  bool _sendEmail = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bulk = ref.watch(bulkActionsProvider);
    final deleting = _action == 'delete';

    return AlertDialog(
      title: Text('Actions groupées · ${_selection(bulk.selectionCount)}'),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              initialValue: _action,
              decoration: const InputDecoration(labelText: 'Action', border: OutlineInputBorder()),
              items: const [
                DropdownMenuItem(value: 'confirm', child: Text('Confirmer les réservations')),
                DropdownMenuItem(value: 'cancel', child: Text('Annuler les réservations')),
                DropdownMenuItem(value: 'move_to_waiting', child: Text('Mettre en liste d\'attente')),
                DropdownMenuItem(value: 'delete', child: Text('Supprimer les réservations')),
              ],
              onChanged: (value) => setState(() => _action = value!),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(labelText: 'Motif (optionnel)', border: OutlineInputBorder()),
              maxLines: 2,
              onChanged: (value) => _reason = value.trim().isEmpty ? null : value.trim(),
            ),
            CheckboxListTile(
              title: const Text('Prévenir les personnes qui réservent par email'),
              value: _sendEmail,
              onChanged: (value) => setState(() => _sendEmail = value ?? false),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
            if (deleting)
              Text(
                'Les réservations seront définitivement supprimées : les places qu\'elles occupent iront à la liste d\'attente.',
                style: theme.textTheme.bodySmall?.copyWith(color: ManagementColors.cancelled),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Retour')),
        FilledButton(
          style: deleting ? FilledButton.styleFrom(backgroundColor: ManagementColors.cancelled) : null,
          onPressed: bulk.isLoading
              ? null
              : () async {
                  final navigator = Navigator.of(context);
                  await _perform(context, ref, _action, reason: _reason, sendEmail: _sendEmail);
                  navigator.pop();
                },
          child: bulk.isLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : Text(deleting ? 'Supprimer' : 'Appliquer'),
        ),
      ],
    );
  }
}
