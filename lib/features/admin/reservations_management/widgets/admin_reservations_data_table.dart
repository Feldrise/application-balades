import 'package:balade/features/admin/reservations_management/admin_reservation_messages.dart';
import 'package:balade/features/admin/reservations_management/providers/admin_reservations_provider.dart';
import 'package:balade/features/admin/reservations_management/providers/bulk_actions_provider.dart';
import 'package:balade/features/admin/reservations_management/widgets/reservation_edit_dialog.dart';
import 'package:balade/features/authentication/authentication_provider.dart';
import 'package:balade/features/authentication/permission_provider.dart';
import 'package:balade/features/payments/widgets/payment_status_chip.dart';
import 'package:balade/features/reservations/models/reservation/reservation.dart';
import 'package:balade/features/reservations/providers/reservation_providers.dart';
import 'package:balade/features/reservations/reservation_format.dart';
import 'package:balade/features/reservations/widgets/reservation_status_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class AdminReservationsDataTable extends ConsumerStatefulWidget {
  const AdminReservationsDataTable({super.key, required this.reservations, required this.onSort, required this.sortBy, required this.sortAscending});

  final List<Reservation> reservations;
  final Function(String) onSort;
  final String sortBy;
  final bool sortAscending;

  @override
  ConsumerState<AdminReservationsDataTable> createState() => _AdminReservationsDataTableState();
}

class _AdminReservationsDataTableState extends ConsumerState<AdminReservationsDataTable> {
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
                    rows: widget.reservations.map((reservation) => _buildDataRow(context, ref, reservation, theme, screenWidth)).toList(),
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

  /// The columns shown at this width: the key tells what the API sorts on, when it can.
  List<({String label, String? sortKey})> _columns(double screenWidth) {
    final isDesktop = screenWidth > 1200;
    final isTablet = screenWidth > 768;

    return [
      (label: 'Personne qui réserve', sortKey: 'contact_email'),
      (label: 'Participants', sortKey: null),
      (label: 'Statut', sortKey: 'status'),
      if (isTablet) (label: 'Paiement', sortKey: null),
      if (isDesktop) (label: 'Balade', sortKey: null),
      (label: 'Réservée le', sortKey: 'created_at'),
      if (isDesktop) (label: 'Confirmation', sortKey: null),
      (label: 'Actions', sortKey: null),
    ];
  }

  List<DataColumn> _buildColumns(double screenWidth) {
    return [
      for (final column in _columns(screenWidth))
        DataColumn(label: Text(column.label), onSort: column.sortKey == null ? null : (_, _) => widget.onSort(column.sortKey!)),
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
            '${bulkActionsState.selectionCount} réservation(s) sélectionnée(s)',
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

  DataRow _buildDataRow(BuildContext context, WidgetRef ref, Reservation reservation, ThemeData theme, double screenWidth) {
    final bulkActionsNotifier = ref.read(bulkActionsProvider.notifier);
    final isSelected = bulkActionsNotifier.isSelected(reservation.id);
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
    final shortDateFormat = DateFormat('dd/MM/yy');
    final isDesktop = screenWidth > 1200;
    final isTablet = screenWidth > 768;
    final payment = reservation.payments.isEmpty ? null : reservation.payments.last;
    final muted = theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant);

    List<DataCell> cells = [
      // Booker (always visible)
      DataCell(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(bookerName(reservation), style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
            SelectableText(reservation.contactEmail, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            // Show ramble title + date here on mobile when ramble column is hidden
            if (!isDesktop && reservation.ramble?.title != null)
              Text(
                reservation.ramble!.date != null ? '${reservation.ramble!.title} · ${shortDateFormat.format(reservation.ramble!.date!)}' : reservation.ramble!.title,
                style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
      ),

      // Participants with their tariffs (always visible)
      DataCell(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (final participant in reservation.participants)
              Text(
                participant.priceLabel.isEmpty ? '${participant.firstName} ${participant.lastName}' : '${participant.firstName} ${participant.lastName} · ${participant.priceLabel}',
                style: theme.textTheme.bodySmall,
              ),
          ],
        ),
      ),

      // Status (always visible)
      DataCell(ReservationStatusChip(status: reservation.status)),

      // Payment (tablet and desktop only)
      if (isTablet)
        DataCell(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(formatReservationAmount(reservation), style: theme.textTheme.bodyMedium),
              if (payment != null) PaymentStatusChip(status: payment.status, showIcon: false),
            ],
          ),
        ),

      // Ramble (desktop only)
      if (isDesktop)
        DataCell(
          reservation.ramble != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(reservation.ramble!.title, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis),
                    if (reservation.ramble!.date != null) Text(dateFormat.format(reservation.ramble!.date!), style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                  ],
                )
              : Text('Balade #${reservation.rambleId}', style: theme.textTheme.bodyMedium),
        ),

      // Reservation date (always visible, but format varies)
      DataCell(Text(isDesktop ? dateFormat.format(reservation.createdAt) : shortDateFormat.format(reservation.createdAt), style: theme.textTheme.bodyMedium)),

      // Confirmation date (desktop only)
      if (isDesktop) DataCell(reservation.confirmationDate != null ? Text(dateFormat.format(reservation.confirmationDate!), style: theme.textTheme.bodyMedium) : Text('-', style: muted)),

      // Actions (always visible, but compact on mobile)
      DataCell(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_canEdit(ref))
              IconButton(onPressed: () => _showEditDialog(context, ref, reservation), icon: const Icon(Icons.edit_outlined), tooltip: 'Modifier', iconSize: isDesktop ? 20 : 18),
            if (_canDelete(ref))
              IconButton(onPressed: () => _showDeleteConfirmation(context, ref, reservation), icon: const Icon(Icons.delete_outline), tooltip: 'Supprimer', iconSize: isDesktop ? 20 : 18),
          ],
        ),
      ),
    ];

    return DataRow(selected: isSelected, onSelectChanged: (_) => bulkActionsNotifier.toggleSelection(reservation.id), cells: cells);
  }

  int? _getSortColumnIndex() {
    final index = _columns(MediaQuery.of(context).size.width).indexWhere((column) => column.sortKey == widget.sortBy);
    return index < 0 ? null : index;
  }

  void _showEditDialog(BuildContext context, WidgetRef ref, Reservation reservation) {
    showDialog<Reservation>(
      context: context,
      builder: (context) => ReservationEditDialog(reservation: reservation),
    );
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref, Reservation reservation) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: Text('Êtes-vous sûr de vouloir supprimer la réservation de ${bookerName(reservation)} (${reservation.participants.length} participant(s)) ? Les places qu\'elle occupe iront à la liste d\'attente.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Annuler')),
          FilledButton(onPressed: () => _deleteReservation(context, ref, reservation), child: const Text('Supprimer')),
        ],
      ),
    );
  }

  void _deleteReservation(BuildContext context, WidgetRef ref, Reservation reservation) async {
    final auth = ref.read(authenticationProvider);
    if (auth == null) return;

    Navigator.of(context).pop(); // Close dialog

    try {
      await ref.read(reservationsServiceProvider).deleteReservation(reservation.id, token: auth.token);

      ref.read(adminReservationsProvider.notifier).removeReservation(reservation.id);
      // The places released can admit reservations of the waiting list
      ref.read(adminReservationsProvider.notifier).loadReservations(token: auth.token);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Réservation supprimée avec succès')));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur lors de la suppression: ${adminReservationErrorMessage(e)}')));
      }
    }
  }

  void _showBulkActionsDialog(BuildContext context, WidgetRef ref) {
    showDialog(context: context, builder: (context) => const BulkActionsDialog());
  }

  bool _canEdit(WidgetRef ref) {
    final permission = ref.watch(permissionProvider);
    return permission?.isAdmin() == true || permission?.canUpdateRegistrationDetails() == true || permission?.canUpdateRegistrationStatus() == true;
  }

  bool _canDelete(WidgetRef ref) {
    final permission = ref.watch(permissionProvider);
    return permission?.isAdmin() == true || permission?.canManageRegistration() == true;
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
      title: Text('Actions groupées (${bulkActionsState.selectionCount} réservations)'),
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
                DropdownMenuItem(value: 'confirm', child: Text('✅ Confirmer les réservations')),
                DropdownMenuItem(value: 'cancel', child: Text('❌ Annuler les réservations')),
                DropdownMenuItem(value: 'move_to_waiting', child: Text('📋 Mettre en liste d\'attente')),
                DropdownMenuItem(value: 'delete', child: Text('🗑️ Supprimer les réservations')),
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
        .performBulkAction(action: selectedAction, token: auth.token, reason: reason, sendEmail: sendEmail);

    if (mounted) {
      Navigator.of(context).pop();

      final result = ref.read(bulkActionsProvider).lastResult;
      if (success && result != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${result.successCount} réservation(s) mise(s) à jour avec succès')));
      } else if (result != null && result.failureCount > 0) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('${result.failureCount} erreur(s) lors de l\'opération'), backgroundColor: Theme.of(context).colorScheme.error));
      }
    }
  }
}
