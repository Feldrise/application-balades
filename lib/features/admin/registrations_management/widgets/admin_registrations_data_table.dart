import 'package:balade/features/admin/registrations_management/providers/admin_registrations_provider.dart';
import 'package:balade/features/admin/registrations_management/providers/bulk_actions_provider.dart';
import 'package:balade/features/admin/registrations_management/widgets/registration_edit_dialog.dart';
import 'package:balade/features/authentication/authentication_provider.dart';
import 'package:balade/features/registrations/models/registration/registration.dart';
import 'package:balade/features/registrations/registrations_service.dart';
import 'package:balade/features/registrations/widgets/registration_status_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class AdminRegistrationsDataTable extends ConsumerWidget {
  const AdminRegistrationsDataTable({super.key, required this.registrations, required this.onSort, required this.sortBy, required this.sortAscending});

  final List<Registration> registrations;
  final Function(String) onSort;
  final String sortBy;
  final bool sortAscending;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bulkActionsState = ref.watch(bulkActionsProvider);

    return Card(
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with bulk selection controls
          if (bulkActionsState.hasSelection) _buildBulkActionsHeader(context, ref, theme),

          // Data table
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width - 32),
                child: DataTable(
                  sortColumnIndex: _getSortColumnIndex(),
                  sortAscending: sortAscending,
                  showCheckboxColumn: true,
                  columnSpacing: 24,
                  headingRowColor: WidgetStateProperty.all(colorScheme.surfaceVariant.withOpacity(0.3)),
                  columns: [
                    DataColumn(label: const Text('Participant'), onSort: (_, __) => onSort('first_name')),
                    DataColumn(label: const Text('Email'), onSort: (_, __) => onSort('email')),
                    const DataColumn(label: Text('Téléphone')),
                    DataColumn(label: const Text('Statut'), onSort: (_, __) => onSort('status')),
                    const DataColumn(label: Text('Balade')),
                    DataColumn(label: const Text('Date d\'inscription'), onSort: (_, __) => onSort('registration_date')),
                    DataColumn(label: const Text('Confirmation'), onSort: (_, __) => onSort('confirmation_date')),
                    const DataColumn(label: Text('Actions')),
                  ],
                  rows: registrations.map((registration) => _buildDataRow(context, ref, registration, theme)).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulkActionsHeader(BuildContext context, WidgetRef ref, ThemeData theme) {
    final bulkActionsState = ref.watch(bulkActionsProvider);
    final bulkActionsNotifier = ref.read(bulkActionsProvider.notifier);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withOpacity(0.3),
        border: Border(bottom: BorderSide(color: theme.dividerColor)),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle_outline, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Text(
            '${bulkActionsState.selectionCount} inscription(s) sélectionnée(s)',
            style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500, color: theme.colorScheme.primary),
          ),
          const Spacer(),
          TextButton(onPressed: bulkActionsNotifier.clearSelection, child: const Text('Désélectionner tout')),
          const SizedBox(width: 8),
          FilledButton.icon(onPressed: () => _showBulkActionsDialog(context, ref), icon: const Icon(Icons.playlist_add_check), label: const Text('Actions groupées')),
        ],
      ),
    );
  }

  DataRow _buildDataRow(BuildContext context, WidgetRef ref, Registration registration, ThemeData theme) {
    final bulkActionsNotifier = ref.read(bulkActionsProvider.notifier);
    final isSelected = bulkActionsNotifier.isSelected(registration.id);
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return DataRow(
      selected: isSelected,
      onSelectChanged: (_) => bulkActionsNotifier.toggleSelection(registration.id),
      cells: [
        DataCell(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${registration.firstName} ${registration.lastName}', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
              if (registration.ramble?.title != null) Text(registration.ramble!.title, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            ],
          ),
        ),
        DataCell(SelectableText(registration.email, style: theme.textTheme.bodyMedium)),
        DataCell(Text(registration.phone ?? '-', style: theme.textTheme.bodyMedium)),
        DataCell(RegistrationStatusChip(status: registration.status)),
        DataCell(
          registration.ramble != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(registration.ramble!.title, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
                    if (registration.ramble!.date != null)
                      Text(dateFormat.format(registration.ramble!.date!), style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                  ],
                )
              : Text('Balade #${registration.rambleId}', style: theme.textTheme.bodyMedium),
        ),
        DataCell(Text(dateFormat.format(registration.registrationDate), style: theme.textTheme.bodyMedium)),
        DataCell(
          registration.confirmationDate != null
              ? Text(dateFormat.format(registration.confirmationDate!), style: theme.textTheme.bodyMedium)
              : Text('-', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        ),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(onPressed: () => _showEditDialog(context, ref, registration), icon: const Icon(Icons.edit_outlined), tooltip: 'Modifier', iconSize: 20),
              IconButton(onPressed: () => _showDeleteConfirmation(context, ref, registration), icon: const Icon(Icons.delete_outline), tooltip: 'Supprimer', iconSize: 20),
            ],
          ),
        ),
      ],
    );
  }

  int? _getSortColumnIndex() {
    switch (sortBy) {
      case 'first_name':
        return 0;
      case 'email':
        return 1;
      case 'status':
        return 3;
      case 'registration_date':
        return 5;
      case 'confirmation_date':
        return 6;
      default:
        return null;
    }
  }

  void _showEditDialog(BuildContext context, WidgetRef ref, Registration registration) {
    showDialog(
      context: context,
      builder: (context) => RegistrationEditDialog(registration: registration),
    );
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref, Registration registration) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: Text('Êtes-vous sûr de vouloir supprimer l\'inscription de ${registration.firstName} ${registration.lastName} ?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Annuler')),
          FilledButton(onPressed: () => _deleteRegistration(context, ref, registration), child: const Text('Supprimer')),
        ],
      ),
    );
  }

  void _deleteRegistration(BuildContext context, WidgetRef ref, Registration registration) async {
    final auth = ref.read(authenticationProvider);
    if (auth == null) return;

    Navigator.of(context).pop(); // Close dialog

    try {
      await RegistrationsService.instance.deleteRegistration(registration.id, authorization: 'Bearer ${auth.token}');

      ref.read(adminRegistrationsProvider.notifier).removeRegistration(registration.id);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Inscription supprimée avec succès')));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur lors de la suppression: $e')));
      }
    }
  }

  void _showBulkActionsDialog(BuildContext context, WidgetRef ref) {
    showDialog(context: context, builder: (context) => const BulkActionsDialog());
  }
}

class BulkActionsDialog extends ConsumerStatefulWidget {
  const BulkActionsDialog({super.key});

  @override
  ConsumerState<BulkActionsDialog> createState() => _BulkActionsDialogState();
}

class _BulkActionsDialogState extends ConsumerState<BulkActionsDialog> {
  String selectedAction = 'confirm';
  String? reason;
  bool sendEmail = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bulkActionsState = ref.watch(bulkActionsProvider);

    return AlertDialog(
      title: Text('Actions groupées (${bulkActionsState.selectionCount} inscriptions)'),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Action à effectuer:', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedAction,
              decoration: const InputDecoration(border: OutlineInputBorder()),
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
              decoration: const InputDecoration(labelText: 'Raison (optionnel)', border: OutlineInputBorder()),
              maxLines: 2,
              onChanged: (value) => reason = value.isEmpty ? null : value,
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              title: const Text('Envoyer un email de notification'),
              value: sendEmail,
              onChanged: (value) => setState(() => sendEmail = value ?? false),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Annuler')),
        FilledButton(
          onPressed: bulkActionsState.isLoading ? null : _performBulkAction,
          child: bulkActionsState.isLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Appliquer'),
        ),
      ],
    );
  }

  void _performBulkAction() async {
    final auth = ref.read(authenticationProvider);
    if (auth == null) return;

    final success = await ref
        .read(bulkActionsProvider.notifier)
        .performBulkAction(action: selectedAction, authorization: 'Bearer ${auth.token}', reason: reason, sendEmail: sendEmail);

    if (mounted) {
      Navigator.of(context).pop();

      final result = ref.read(bulkActionsProvider).lastResult;
      if (success && result != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${result.successCount} inscription(s) mise(s) à jour avec succès')));
      } else if (result != null && result.failureCount > 0) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('${result.failureCount} erreur(s) lors de l\'opération'), backgroundColor: Theme.of(context).colorScheme.error));
      }
    }
  }
}
