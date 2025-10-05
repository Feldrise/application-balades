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

class AdminRegistrationsDataTable extends ConsumerStatefulWidget {
  const AdminRegistrationsDataTable({super.key, required this.registrations, required this.onSort, required this.sortBy, required this.sortAscending});

  final List<Registration> registrations;
  final Function(String) onSort;
  final String sortBy;
  final bool sortAscending;

  @override
  ConsumerState<AdminRegistrationsDataTable> createState() => _AdminRegistrationsDataTableState();
}

class _AdminRegistrationsDataTableState extends ConsumerState<AdminRegistrationsDataTable> {
  late ScrollController _horizontalScrollController;

  @override
  void initState() {
    super.initState();
    _horizontalScrollController = ScrollController();
  }

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bulkActionsState = ref.watch(bulkActionsProvider);
    final screenWidth = MediaQuery.of(context).size.width;

    return Card(
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with bulk selection controls
          if (bulkActionsState.hasSelection) _buildBulkActionsHeader(context, ref, theme),

          // Data table with proper horizontal scrolling
          Expanded(
            child: Scrollbar(
              controller: _horizontalScrollController,
              thumbVisibility: true,
              trackVisibility: true,
              interactive: true,
              child: SingleChildScrollView(
                controller: _horizontalScrollController,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: screenWidth > 1200
                        ? screenWidth -
                              32 // Desktop: use available width
                        : 1200, // Mobile/Tablet: force minimum width for proper table display
                  ),
                  child: DataTable(
                    sortColumnIndex: _getSortColumnIndex(),
                    sortAscending: widget.sortAscending,
                    showCheckboxColumn: true,
                    columnSpacing: screenWidth > 1200 ? 24 : 16, // Responsive column spacing
                    headingRowColor: WidgetStateProperty.all(colorScheme.surfaceContainerHighest.withOpacity(0.3)),
                    headingTextStyle: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600, color: colorScheme.onSurface),
                    dataTextStyle: theme.textTheme.bodyMedium,
                    columns: _buildColumns(screenWidth),
                    rows: widget.registrations.map((registration) => _buildDataRow(context, ref, registration, theme, screenWidth)).toList(),
                  ),
                ),
              ),
            ),
          ),

          // Horizontal scroll indicator for mobile
          if (screenWidth < 1200) _buildHorizontalScrollIndicator(theme),
        ],
      ),
    );
  }

  List<DataColumn> _buildColumns(double screenWidth) {
    final isDesktop = screenWidth > 1200;
    final isTablet = screenWidth > 768;

    return [
      DataColumn(label: const Text('Participant'), onSort: (_, __) => widget.onSort('first_name')),
      DataColumn(label: const Text('Email'), onSort: (_, __) => widget.onSort('email')),
      if (isTablet) // Hide phone on mobile
        const DataColumn(label: Text('Téléphone')),
      DataColumn(label: const Text('Statut'), onSort: (_, __) => widget.onSort('status')),
      if (isDesktop) // Hide ramble on mobile/tablet
        const DataColumn(label: Text('Balade')),
      DataColumn(label: const Text('Date d\'inscription'), onSort: (_, __) => widget.onSort('registration_date')),
      if (isDesktop) // Hide confirmation date on mobile/tablet
        DataColumn(label: const Text('Confirmation'), onSort: (_, __) => widget.onSort('confirmation_date')),
      const DataColumn(label: Text('Actions')),
    ];
  }

  Widget _buildHorizontalScrollIndicator(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        border: Border(top: BorderSide(color: theme.dividerColor)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.swipe_left, size: 16, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 8),
          Text(
            'Faites défiler horizontalement pour voir plus de colonnes',
            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant, fontStyle: FontStyle.italic),
          ),
          const SizedBox(width: 8),
          Icon(Icons.swipe_right, size: 16, color: theme.colorScheme.onSurfaceVariant),
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

  DataRow _buildDataRow(BuildContext context, WidgetRef ref, Registration registration, ThemeData theme, double screenWidth) {
    final bulkActionsNotifier = ref.read(bulkActionsProvider.notifier);
    final isSelected = bulkActionsNotifier.isSelected(registration.id);
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
    final shortDateFormat = DateFormat('dd/MM/yy');
    final isDesktop = screenWidth > 1200;
    final isTablet = screenWidth > 768;

    List<DataCell> cells = [
      // Participant (always visible)
      DataCell(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${registration.firstName} ${registration.lastName}', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
            // Show ramble title here on mobile when ramble column is hidden
            if (!isDesktop && registration.ramble?.title != null)
              Text(
                registration.ramble!.title,
                style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
      ),

      // Email (always visible)
      DataCell(SelectableText(registration.email, style: theme.textTheme.bodyMedium)),

      // Phone (hidden on mobile)
      if (isTablet) DataCell(Text(registration.phone ?? '-', style: theme.textTheme.bodyMedium)),

      // Status (always visible)
      DataCell(RegistrationStatusChip(status: registration.status)),

      // Ramble (desktop only)
      if (isDesktop)
        DataCell(
          registration.ramble != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      registration.ramble!.title,
                      style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (registration.ramble!.date != null)
                      Text(dateFormat.format(registration.ramble!.date!), style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                  ],
                )
              : Text('Balade #${registration.rambleId}', style: theme.textTheme.bodyMedium),
        ),

      // Registration Date (always visible, but format varies)
      DataCell(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(isDesktop ? dateFormat.format(registration.registrationDate) : shortDateFormat.format(registration.registrationDate), style: theme.textTheme.bodyMedium),
            // Show phone number here on mobile when phone column is hidden
            if (!isTablet && registration.phone != null) Text(registration.phone!, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          ],
        ),
      ),

      // Confirmation Date (desktop only)
      if (isDesktop)
        DataCell(
          registration.confirmationDate != null
              ? Text(dateFormat.format(registration.confirmationDate!), style: theme.textTheme.bodyMedium)
              : Text('-', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        ),

      // Actions (always visible, but compact on mobile)
      DataCell(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(onPressed: () => _showEditDialog(context, ref, registration), icon: const Icon(Icons.edit_outlined), tooltip: 'Modifier', iconSize: isDesktop ? 20 : 18),
            IconButton(
              onPressed: () => _showDeleteConfirmation(context, ref, registration),
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Supprimer',
              iconSize: isDesktop ? 20 : 18,
            ),
          ],
        ),
      ),
    ];

    return DataRow(selected: isSelected, onSelectChanged: (_) => bulkActionsNotifier.toggleSelection(registration.id), cells: cells);
  }

  int? _getSortColumnIndex() {
    // Note: Column indices change based on responsive design
    // This is a simplified mapping - could be enhanced for exact responsive mapping
    switch (widget.sortBy) {
      case 'first_name':
        return 0; // Participant column
      case 'email':
        return 1; // Email column
      case 'status':
        return 2; // Status column (index varies based on screen size)
      case 'registration_date':
        return 4; // Registration date column (approximate)
      case 'confirmation_date':
        return 5; // Confirmation date column (desktop only)
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
