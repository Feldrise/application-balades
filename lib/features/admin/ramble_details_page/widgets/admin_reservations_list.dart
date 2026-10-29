import 'package:balade/features/admin/reservations_management/admin_reservation_messages.dart';
import 'package:balade/features/admin/reservations_management/widgets/reservation_edit_dialog.dart';
import 'package:balade/features/authentication/authentication_provider.dart';
import 'package:balade/features/authentication/permission_provider.dart';
import 'package:balade/features/payments/widgets/payment_status_chip.dart';
import 'package:balade/features/reservations/models/reservation/reservation.dart';
import 'package:balade/features/reservations/providers/reservation_providers.dart';
import 'package:balade/features/reservations/reservation_format.dart';
import 'package:balade/features/reservations/widgets/reservation_status_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

/// The reservations of a ramble, with their participants, for its admins and guides.
class AdminReservationsList extends ConsumerStatefulWidget {
  const AdminReservationsList({super.key, required this.reservations, this.maxParticipants, this.onRefresh});

  final List<Reservation> reservations;
  final int? maxParticipants;
  final VoidCallback? onRefresh;

  @override
  ConsumerState<AdminReservationsList> createState() => _AdminReservationsListState();
}

class _AdminReservationsListState extends ConsumerState<AdminReservationsList> {
  // Filter state
  String? _filterStatus;
  String _searchQuery = '';

  // Sort state
  String _sortBy = 'created_at';
  bool _sortAscending = false;

  // Selection and expansion state
  final Set<int> _selectedIds = {};
  final Set<int> _expandedIds = {};

  List<Reservation> get _filteredAndSorted {
    var result = widget.reservations.toList();

    if (_filterStatus != null) {
      result = result.where((r) => r.status == _filterStatus).toList();
    }

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      result = result.where((r) {
        return r.contactEmail.toLowerCase().contains(query) || r.participants.any((p) => '${p.firstName} ${p.lastName}'.toLowerCase().contains(query));
      }).toList();
    }

    result.sort((a, b) {
      final int comparison;
      switch (_sortBy) {
        case 'name':
          comparison = bookerName(a).toLowerCase().compareTo(bookerName(b).toLowerCase());
        case 'email':
          comparison = a.contactEmail.compareTo(b.contactEmail);
        case 'status':
          comparison = a.status.compareTo(b.status);
        case 'confirmation_date':
          comparison = (a.confirmationDate ?? DateTime(2000)).compareTo(b.confirmationDate ?? DateTime(2000));
        case 'created_at':
        default:
          comparison = a.createdAt.compareTo(b.createdAt);
      }
      return _sortAscending ? comparison : -comparison;
    });

    return result;
  }

  int _count(String status) => widget.reservations.where((r) => r.status == status).length;

  /// The places taken: the participants of the pending and confirmed reservations.
  int get _occupiedPlaces => widget.reservations.where((r) => r.status == 'pending' || r.status == 'confirmed').fold(0, (sum, r) => sum + r.participants.length);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final filtered = _filteredAndSorted;
    final waitingList = _count('waiting_list');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.people_alt, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text('Réservations', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const Spacer(),
                if (widget.maxParticipants != null) _buildCapacityIndicator(theme, _occupiedPlaces, widget.maxParticipants!),
                const SizedBox(width: 8),
                IconButton(icon: const Icon(Icons.refresh), tooltip: 'Actualiser', onPressed: widget.onRefresh),
                _buildExportMenu(),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildFilterableStatusChip(context, 'Confirmées', _count('confirmed'), Colors.green, 'confirmed'),
                _buildFilterableStatusChip(context, 'En attente', _count('pending'), Colors.orange, 'pending'),
                if (waitingList > 0) _buildFilterableStatusChip(context, 'Liste d\'attente', waitingList, Colors.blueGrey, 'waiting_list'),
                _buildFilterableStatusChip(context, 'Annulées', _count('cancelled'), Colors.red, 'cancelled'),
                _buildFilterableStatusChip(context, 'Total', widget.reservations.length, colorScheme.primary, null),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Rechercher par participant ou email...',
                      prefixIcon: const Icon(Icons.search, size: 20),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    onChanged: (value) => setState(() => _searchQuery = value),
                  ),
                ),
                const SizedBox(width: 8),
                _buildSortMenu(theme),
              ],
            ),
            const SizedBox(height: 12),
            if (_selectedIds.isNotEmpty) _buildBulkActionsBar(theme),
            if (filtered.length != widget.reservations.length)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text('${filtered.length} résultat(s) sur ${widget.reservations.length}', style: theme.textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic)),
              ),
            if (widget.reservations.isEmpty)
              _buildEmptyState(theme, 'Aucune réservation pour le moment.')
            else if (filtered.isEmpty)
              _buildEmptyState(theme, 'Aucune réservation ne correspond à vos critères.')
            else
              for (final reservation in filtered)
                _ReservationTile(
                  reservation: reservation,
                  isExpanded: _expandedIds.contains(reservation.id),
                  isSelected: _selectedIds.contains(reservation.id),
                  onToggleExpansion: () => setState(() => _toggle(_expandedIds, reservation.id)),
                  onToggleSelection: () => setState(() => _toggle(_selectedIds, reservation.id)),
                  onRefresh: widget.onRefresh,
                ),
          ],
        ),
      ),
    );
  }

  void _toggle(Set<int> ids, int id) {
    if (!ids.remove(id)) ids.add(id);
  }

  Widget _buildCapacityIndicator(ThemeData theme, int occupied, int maxParticipants) {
    final percentage = (occupied / maxParticipants * 100).round();
    final color = percentage >= 100
        ? Colors.red
        : percentage >= 80
        ? Colors.orange
        : Colors.green;

    return Tooltip(
      message: 'Places prises : participants des réservations en attente de confirmation ou confirmées',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          border: Border.all(color: color, width: 2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.people, size: 16, color: color),
            const SizedBox(width: 6),
            Text('$occupied/$maxParticipants ($percentage%)', style: theme.textTheme.labelLarge?.copyWith(color: color, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterableStatusChip(BuildContext context, String label, int count, Color color, String? status) {
    final theme = Theme.of(context);
    final isActive = _filterStatus == status;

    return InkWell(
      onTap: () => setState(() => _filterStatus = isActive ? null : status),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? color : color.withValues(alpha: 0.1),
          border: Border.all(color: color, width: isActive ? 2 : 1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('$label: $count', style: theme.textTheme.bodySmall?.copyWith(color: isActive ? Colors.white : color, fontWeight: FontWeight.w600)),
            if (isActive) ...[const SizedBox(width: 4), const Icon(Icons.close, size: 14, color: Colors.white)],
          ],
        ),
      ),
    );
  }

  Widget _buildSortMenu(ThemeData theme) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.sort, color: theme.colorScheme.onSurface),
      tooltip: 'Trier',
      onSelected: (value) {
        setState(() {
          if (_sortBy == value) {
            _sortAscending = !_sortAscending;
          } else {
            _sortBy = value;
            _sortAscending = false;
          }
        });
      },
      itemBuilder: (context) => [
        _buildSortMenuItem('created_at', 'Date de réservation', Icons.calendar_today),
        _buildSortMenuItem('confirmation_date', 'Date de confirmation', Icons.check_circle),
        _buildSortMenuItem('name', 'Nom', Icons.person),
        _buildSortMenuItem('email', 'Email', Icons.email),
        _buildSortMenuItem('status', 'Statut', Icons.flag),
      ],
    );
  }

  PopupMenuItem<String> _buildSortMenuItem(String value, String label, IconData icon) {
    final isActive = _sortBy == value;

    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 20, color: isActive ? Theme.of(context).colorScheme.primary : null),
          const SizedBox(width: 12),
          Expanded(child: Text(label)),
          if (isActive) Icon(_sortAscending ? Icons.arrow_upward : Icons.arrow_downward, size: 16, color: Theme.of(context).colorScheme.primary),
        ],
      ),
    );
  }

  Widget _buildExportMenu() {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.download),
      tooltip: 'Exporter',
      onSelected: (value) => value == 'csv' ? _exportToCSV(_filteredAndSorted) : _copyEmails(_filteredAndSorted),
      itemBuilder: (context) => const [
        PopupMenuItem(
          value: 'csv',
          child: Row(children: [Icon(Icons.table_chart), SizedBox(width: 8), Text('Export CSV')]),
        ),
        PopupMenuItem(
          value: 'emails',
          child: Row(children: [Icon(Icons.email), SizedBox(width: 8), Text('Copier emails')]),
        ),
      ],
    );
  }

  /// One line per participant, with the contact and the status of its reservation.
  void _exportToCSV(List<Reservation> reservations) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
    final csv = StringBuffer('Prénom,Nom,Tarif,Email de contact,Statut,Date de réservation,Date de confirmation\n');

    for (final reservation in reservations) {
      for (final participant in reservation.participants) {
        csv.writeln(
          [
            participant.firstName,
            participant.lastName,
            participant.priceLabel,
            reservation.contactEmail,
            reservation.status,
            dateFormat.format(reservation.createdAt),
            reservation.confirmationDate != null ? dateFormat.format(reservation.confirmationDate!) : '',
          ].map(_csvField).join(','),
        );
      }
    }

    Clipboard.setData(ClipboardData(text: csv.toString()));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('CSV copié dans le presse-papiers')));
  }

  String _csvField(String value) => value.contains(RegExp('[",\n]')) ? '"${value.replaceAll('"', '""')}"' : value;

  void _copyEmails(List<Reservation> reservations) {
    final emails = reservations.map((r) => r.contactEmail).toSet();
    Clipboard.setData(ClipboardData(text: emails.join(', ')));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${emails.length} email(s) copié(s)')));
  }

  Widget _buildBulkActionsBar(ThemeData theme) {
    return Card(
      color: theme.colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(Icons.check_circle_outline, color: theme.colorScheme.onPrimaryContainer),
            const SizedBox(width: 8),
            Text('${_selectedIds.length} sélectionnée(s)', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onPrimaryContainer, fontWeight: FontWeight.w600)),
            const Spacer(),
            TextButton(onPressed: () => setState(_selectedIds.clear), child: const Text('Désélectionner')),
            const SizedBox(width: 8),
            if (_canBulk) FilledButton.icon(onPressed: _showBulkActionsDialog, icon: const Icon(Icons.playlist_add_check), label: const Text('Actions groupées')),
          ],
        ),
      ),
    );
  }

  bool get _canBulk {
    final permission = ref.read(permissionProvider);
    return permission?.isAdmin() == true || permission?.canBulkRegistrationActions() == true;
  }

  void _showBulkActionsDialog() {
    showDialog<void>(
      context: context,
      builder: (context) => _BulkActionsDialog(
        selectedIds: _selectedIds.toList(),
        onComplete: () {
          setState(_selectedIds.clear);
          widget.onRefresh?.call();
        },
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme, String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.inbox_outlined, size: 64, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5)),
            const SizedBox(height: 16),
            Text(message, style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }
}

class _ReservationTile extends ConsumerWidget {
  const _ReservationTile({
    required this.reservation,
    required this.isExpanded,
    required this.isSelected,
    required this.onToggleExpansion,
    required this.onToggleSelection,
    this.onRefresh,
  });

  final Reservation reservation;
  final bool isExpanded;
  final bool isSelected;
  final VoidCallback onToggleExpansion;
  final VoidCallback onToggleSelection;
  final VoidCallback? onRefresh;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final df = DateFormat('dd/MM/yyyy HH:mm');
    final permission = ref.watch(permissionProvider);
    final isAdmin = permission?.isAdmin() == true;
    final canChangeStatus = isAdmin || permission?.canUpdateRegistrationStatus() == true;
    final canEdit = isAdmin || permission?.canUpdateRegistrationDetails() == true || canChangeStatus;
    final canDelete = isAdmin || permission?.canManageRegistration() == true;
    final payment = reservation.payments.isEmpty ? null : reservation.payments.last;

    return Card(
      color: isSelected ? colorScheme.primaryContainer.withValues(alpha: 0.3) : null,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Checkbox(value: isSelected, onChanged: (_) => onToggleSelection()),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(bookerName(reservation), style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 2),
                      _EmailRow(email: reservation.contactEmail),
                      const SizedBox(height: 2),
                      Text(
                        '${reservation.participants.length} participant(s) · ${formatReservationAmount(reservation)}',
                        style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ReservationStatusChip(status: reservation.status),
                    if (payment != null) ...[const SizedBox(height: 4), PaymentStatusChip(status: payment.status)],
                  ],
                ),
                const SizedBox(width: 8),
                if (canChangeStatus && (reservation.status == 'pending' || reservation.status == 'waiting_list'))
                  IconButton(icon: const Icon(Icons.check_circle_outline), tooltip: 'Confirmer', onPressed: () => _setStatus(context, ref, 'confirmed')),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert),
                  tooltip: 'Plus d\'actions',
                  onSelected: (value) => _handleAction(context, ref, value),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'expand',
                      child: Row(children: [Icon(Icons.info_outline), SizedBox(width: 8), Text('Voir détails')]),
                    ),
                    if (canEdit)
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(children: [Icon(Icons.edit_outlined), SizedBox(width: 8), Text('Modifier')]),
                      ),
                    if (canChangeStatus && reservation.status != 'waiting_list' && reservation.status != 'cancelled')
                      const PopupMenuItem(
                        value: 'waiting_list',
                        child: Row(children: [Icon(Icons.queue), SizedBox(width: 8), Text('Mettre en liste d\'attente')]),
                      ),
                    if (canChangeStatus && reservation.status != 'cancelled')
                      const PopupMenuItem(
                        value: 'cancel',
                        child: Row(children: [Icon(Icons.cancel), SizedBox(width: 8), Text('Annuler')]),
                      ),
                    const PopupMenuItem(
                      value: 'email',
                      child: Row(children: [Icon(Icons.email), SizedBox(width: 8), Text('Envoyer un email')]),
                    ),
                    if (canDelete)
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(children: [Icon(Icons.delete_outline), SizedBox(width: 8), Text('Supprimer')]),
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            for (final participant in reservation.participants)
              Padding(
                padding: const EdgeInsets.only(left: 48, bottom: 2),
                child: Row(
                  children: [
                    Icon(participant.isBooker ? Icons.star : Icons.person_outline, size: 14, color: colorScheme.onSurfaceVariant),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        participant.priceLabel.isEmpty ? '${participant.firstName} ${participant.lastName}' : '${participant.firstName} ${participant.lastName} · ${participant.priceLabel}',
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            if (isExpanded) ...[
              const SizedBox(height: 8),
              const Divider(),
              const SizedBox(height: 8),
              Text('Dates', style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: [
                  _dateChip(context, 'Réservée', df.format(reservation.createdAt)),
                  if (reservation.confirmationDate != null) _dateChip(context, 'Confirmée', df.format(reservation.confirmationDate!)),
                  if (reservation.confirmationDeadline != null) _dateChip(context, 'Échéance', df.format(reservation.confirmationDeadline!)),
                  if (reservation.cancellationDate != null) _dateChip(context, 'Annulée', df.format(reservation.cancellationDate!)),
                ],
              ),
              if (reservation.cancellationReason != null && reservation.cancellationReason!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text('Motif d\'annulation', style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(reservation.cancellationReason!, style: theme.textTheme.bodySmall),
              ],
              if (reservation.payments.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text('Paiements', style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                for (final p in reservation.payments)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        PaymentStatusChip(status: p.status),
                        const SizedBox(width: 12),
                        Text('${(p.amount / 100).toStringAsFixed(2)} ${p.currency.toUpperCase()}', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
                        if (p.paidAt != null) ...[const SizedBox(width: 12), Text('Payé le ${df.format(p.paidAt!)}', style: theme.textTheme.bodySmall)],
                      ],
                    ),
                  ),
              ],
              Center(
                child: TextButton.icon(onPressed: onToggleExpansion, icon: const Icon(Icons.expand_less, size: 16), label: const Text('Voir moins')),
              ),
            ] else
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: onToggleExpansion,
                  icon: const Icon(Icons.expand_more, size: 16),
                  label: Text('Réservée le ${df.format(reservation.createdAt)}'),
                  style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleAction(BuildContext context, WidgetRef ref, String action) async {
    switch (action) {
      case 'expand':
        onToggleExpansion();
      case 'edit':
        final saved = await showDialog<Reservation>(
          context: context,
          builder: (context) => ReservationEditDialog(reservation: reservation),
        );
        if (saved != null) onRefresh?.call();
      case 'waiting_list':
        await _setStatus(context, ref, 'waiting_list');
      case 'cancel':
        await _showCancelDialog(context, ref);
      case 'email':
        await _openEmailClient(context);
      case 'delete':
        await _showDeleteDialog(context, ref);
    }
  }

  Future<void> _showCancelDialog(BuildContext context, WidgetRef ref) async {
    String? reason;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Annuler la réservation'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Êtes-vous sûr de vouloir annuler la réservation de ${bookerName(reservation)} ? Tous ses participants sont annulés.'),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(labelText: 'Motif (optionnel)', border: OutlineInputBorder()),
              maxLines: 2,
              onChanged: (value) => reason = value.isEmpty ? null : value,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Retour')),
          FilledButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Annuler la réservation')),
        ],
      ),
    );

    if (confirmed == true && context.mounted) await _setStatus(context, ref, 'cancelled', reason: reason);
  }

  Future<void> _showDeleteDialog(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer la réservation'),
        content: Text('Supprimer la réservation de ${bookerName(reservation)} ? Les places qu\'elle occupe iront à la liste d\'attente.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Retour')),
          FilledButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Supprimer')),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    await _run(context, ref, 'Réservation supprimée', (token) => ref.read(reservationsServiceProvider).deleteReservation(reservation.id, token: token));
  }

  Future<void> _setStatus(BuildContext context, WidgetRef ref, String status, {String? reason}) {
    return _run(context, ref, 'Réservation mise à jour', (token) => ref.read(reservationsServiceProvider).updateReservationStatus(reservation.id, status: status, reason: reason, token: token));
  }

  Future<void> _run(BuildContext context, WidgetRef ref, String success, Future<void> Function(String token) action) async {
    final token = ref.read(authenticationProvider)?.token;
    if (token == null) return;
    final messenger = ScaffoldMessenger.of(context);

    try {
      await action(token);
      messenger.showSnackBar(SnackBar(content: Text(success)));
      onRefresh?.call();
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Erreur : ${adminReservationErrorMessage(e)}')));
    }
  }

  Future<void> _openEmailClient(BuildContext context) async {
    final uri = Uri(scheme: 'mailto', path: reservation.contactEmail);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication) && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Impossible d'ouvrir le client mail")));
    }
  }

  Widget _dateChip(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: theme.colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(8)),
      child: Text('$label: $value', style: theme.textTheme.bodySmall),
    );
  }
}

class _EmailRow extends StatelessWidget {
  const _EmailRow({required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () async {
        final opened = await launchUrl(Uri(scheme: 'mailto', path: email), mode: LaunchMode.externalApplication);
        if (!opened && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Impossible d'ouvrir le client mail")));
        }
      },
      child: Row(
        children: [
          Icon(Icons.mail, size: 14, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              email,
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.primary, decoration: TextDecoration.underline),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _BulkActionsDialog extends ConsumerStatefulWidget {
  const _BulkActionsDialog({required this.selectedIds, required this.onComplete});

  final List<int> selectedIds;
  final VoidCallback onComplete;

  @override
  ConsumerState<_BulkActionsDialog> createState() => _BulkActionsDialogState();
}

class _BulkActionsDialogState extends ConsumerState<_BulkActionsDialog> {
  String selectedAction = 'confirm';
  String? reason;
  bool sendEmail = true;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text('Actions groupées (${widget.selectedIds.length} réservations)'),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Action à effectuer:', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: selectedAction,
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
              decoration: const InputDecoration(labelText: 'Motif (optionnel)', border: OutlineInputBorder()),
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
          onPressed: isLoading ? null : _performBulkAction,
          child: isLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Appliquer'),
        ),
      ],
    );
  }

  Future<void> _performBulkAction() async {
    final token = ref.read(authenticationProvider)?.token;
    if (token == null) return;

    setState(() => isLoading = true);

    try {
      final result = await ref.read(reservationsServiceProvider).performBulkAction(widget.selectedIds, action: selectedAction, reason: reason, sendEmail: sendEmail, token: token);

      if (!mounted) return;
      Navigator.of(context).pop();
      final messenger = ScaffoldMessenger.of(context);

      if (result.successCount > 0) {
        messenger.showSnackBar(SnackBar(content: Text('${result.successCount} réservation(s) mise(s) à jour avec succès')));
        widget.onComplete();
      }

      if (result.failureCount > 0) {
        final first = result.errors.isEmpty ? '' : ' : ${result.errors.first.error}';
        messenger.showSnackBar(SnackBar(content: Text('${result.failureCount} erreur(s) lors de l\'opération$first'), backgroundColor: Theme.of(context).colorScheme.error));
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur: ${adminReservationErrorMessage(e)}'), backgroundColor: Theme.of(context).colorScheme.error));
      }
    }
  }
}
