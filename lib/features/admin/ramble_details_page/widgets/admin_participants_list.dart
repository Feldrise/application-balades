import 'package:balade/features/admin/registrations_management/models/bulk_action_request.dart';
import 'package:balade/features/authentication/authentication_provider.dart';
import 'package:balade/features/payments/providers/payment_providers.dart';
import 'package:balade/features/payments/widgets/payment_status_chip.dart';
import 'package:balade/features/registrations/models/registration/registration.dart';
import 'package:balade/features/registrations/registrations_service.dart';
import 'package:balade/features/registrations/widgets/registration_status_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminParticipantsList extends ConsumerStatefulWidget {
  const AdminParticipantsList({super.key, required this.registrations, this.maxParticipants, this.onConfirmRegistration, this.onRefresh});

  final List<Registration> registrations;
  final int? maxParticipants;
  final Future<void> Function(Registration registration, bool confirmed)? onConfirmRegistration;
  final VoidCallback? onRefresh;

  @override
  ConsumerState<AdminParticipantsList> createState() => _AdminParticipantsListState();
}

class _AdminParticipantsListState extends ConsumerState<AdminParticipantsList> {
  // Filter state
  String? _filterStatus;
  String _searchQuery = '';

  // Sort state
  String _sortBy = 'registration_date';
  bool _sortAscending = false;

  // Selection state
  final Set<int> _selectedRegistrationIds = {};

  // Expansion state
  final Set<int> _expandedRegistrationIds = {};
  final Set<int?> _expandedGroupIds = {};

  // Computed properties for filtering and sorting
  List<Registration> get _filteredAndSortedRegistrations {
    var result = widget.registrations;

    // Apply status filter
    if (_filterStatus != null && _filterStatus!.isNotEmpty) {
      result = result.where((r) => r.status == _filterStatus).toList();
    }

    // Apply search query
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      result = result.where((r) {
        return r.firstName.toLowerCase().contains(query) ||
            r.lastName.toLowerCase().contains(query) ||
            r.email.toLowerCase().contains(query) ||
            (r.phone?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    // Apply sorting
    result.sort((a, b) {
      int comparison = 0;

      switch (_sortBy) {
        case 'name':
          comparison = a.firstName.compareTo(b.firstName);
          break;
        case 'email':
          comparison = a.email.compareTo(b.email);
          break;
        case 'status':
          comparison = a.status.compareTo(b.status);
          break;
        case 'confirmation_date':
          final aDate = a.confirmationDate ?? DateTime(2000);
          final bDate = b.confirmationDate ?? DateTime(2000);
          comparison = aDate.compareTo(bDate);
          break;
        case 'registration_date':
        default:
          comparison = a.registrationDate.compareTo(b.registrationDate);
      }

      return _sortAscending ? comparison : -comparison;
    });

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final filteredRegs = _filteredAndSortedRegistrations;

    final confirmed = widget.registrations.where((r) => r.status == 'confirmed').length;
    final pending = widget.registrations.where((r) => r.status == 'pending').length;
    final waitingList = widget.registrations.where((r) => r.status == 'waiting_list').length;
    final cancelled = widget.registrations.where((r) => r.status == 'cancelled').length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with title and actions
            Row(
              children: [
                Icon(Icons.people_alt, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text('Inscriptions', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const Spacer(),
                if (widget.maxParticipants != null) _buildCapacityIndicator(theme, colorScheme, confirmed, widget.maxParticipants!),
                const SizedBox(width: 8),
                IconButton(icon: const Icon(Icons.refresh), tooltip: 'Actualiser', onPressed: widget.onRefresh),
                _buildExportMenu(context),
              ],
            ),

            const SizedBox(height: 12),

            // Enhanced stats chips with click-to-filter
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildFilterableStatusChip(context, 'Confirmées', confirmed, Colors.green, 'confirmed'),
                _buildFilterableStatusChip(context, 'En attente', pending, Colors.orange, 'pending'),
                if (waitingList > 0) _buildFilterableStatusChip(context, 'Liste d\'attente', waitingList, Colors.blueGrey, 'waiting_list'),
                _buildFilterableStatusChip(context, 'Annulées', cancelled, Colors.red, 'cancelled'),
                _buildFilterableStatusChip(context, 'Total', widget.registrations.length, colorScheme.primary, null),
              ],
            ),

            const SizedBox(height: 12),

            // Search bar and sort controls
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Rechercher par nom, email, téléphone...',
                      prefixIcon: const Icon(Icons.search, size: 20),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      suffixIcon: _searchQuery.isNotEmpty ? IconButton(icon: const Icon(Icons.clear, size: 20), onPressed: () => setState(() => _searchQuery = '')) : null,
                    ),
                    onChanged: (value) => setState(() => _searchQuery = value),
                  ),
                ),
                const SizedBox(width: 8),
                _buildSortMenu(theme),
              ],
            ),

            const SizedBox(height: 12),

            // Bulk actions toolbar (if selections exist)
            if (_selectedRegistrationIds.isNotEmpty) _buildBulkActionsBar(context, theme),

            const SizedBox(height: 8),

            // Results count
            if (filteredRegs.length != widget.registrations.length)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text('${filteredRegs.length} résultat(s) sur ${widget.registrations.length}', style: theme.textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic)),
              ),

            // Main content
            if (widget.registrations.isEmpty)
              _buildEmptyState(context, 'Aucune inscription pour le moment.')
            else if (filteredRegs.isEmpty)
              _buildEmptyState(context, 'Aucune inscription ne correspond à vos critères.')
            else
              _GroupedRegistrationsList(
                registrations: filteredRegs,
                onConfirmRegistration: widget.onConfirmRegistration,
                expandedGroupIds: _expandedGroupIds,
                expandedRegistrationIds: _expandedRegistrationIds,
                selectedRegistrationIds: _selectedRegistrationIds,
                onToggleGroupExpansion: _toggleGroupExpansion,
                onToggleRegistrationExpansion: _toggleRegistrationExpansion,
                onToggleSelection: _toggleSelection,
                onRefresh: widget.onRefresh,
              ),
          ],
        ),
      ),
    );
  }

  // Helper methods for UI components
  Widget _buildCapacityIndicator(ThemeData theme, ColorScheme colorScheme, int confirmed, int maxParticipants) {
    final percentage = (confirmed / maxParticipants * 100).round();
    Color color;

    if (percentage >= 100) {
      color = Colors.red;
    } else if (percentage >= 80) {
      color = Colors.orange;
    } else {
      color = Colors.green;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color, width: 2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.people, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            '$confirmed/$maxParticipants ($percentage%)',
            style: theme.textTheme.labelLarge?.copyWith(color: color, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterableStatusChip(BuildContext context, String label, int count, Color color, String? status) {
    final theme = Theme.of(context);
    final isActive = _filterStatus == status;

    return InkWell(
      onTap: () {
        setState(() {
          _filterStatus = isActive ? null : status;
        });
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? color : color.withOpacity(0.1),
          border: Border.all(color: color, width: isActive ? 2 : 1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$label: $count',
              style: theme.textTheme.bodySmall?.copyWith(color: isActive ? Colors.white : color, fontWeight: FontWeight.w600),
            ),
            if (isActive) ...[const SizedBox(width: 4), Icon(Icons.close, size: 14, color: Colors.white)],
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
        _buildSortMenuItem('registration_date', 'Date d\'inscription', Icons.calendar_today),
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

  Widget _buildExportMenu(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.download),
      tooltip: 'Exporter',
      onSelected: (value) => _handleExport(context, value),
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'csv',
          child: Row(children: [Icon(Icons.table_chart), SizedBox(width: 8), Text('Export CSV')]),
        ),
        const PopupMenuItem(
          value: 'emails',
          child: Row(children: [Icon(Icons.email), SizedBox(width: 8), Text('Copier emails')]),
        ),
        const PopupMenuItem(
          value: 'phones',
          child: Row(children: [Icon(Icons.phone), SizedBox(width: 8), Text('Copier téléphones')]),
        ),
      ],
    );
  }

  void _handleExport(BuildContext context, String type) {
    final regsToExport = _filteredAndSortedRegistrations;

    switch (type) {
      case 'csv':
        _exportToCSV(context, regsToExport);
        break;
      case 'emails':
        _copyEmails(context, regsToExport);
        break;
      case 'phones':
        _copyPhones(context, regsToExport);
        break;
    }
  }

  void _exportToCSV(BuildContext context, List<Registration> registrations) {
    final csv = StringBuffer();
    csv.writeln('Prénom,Nom,Email,Téléphone,Statut,Date inscription,Date confirmation');

    for (final reg in registrations) {
      final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
      csv.writeln(
        [
          reg.firstName,
          reg.lastName,
          reg.email,
          reg.phone ?? '',
          reg.status,
          dateFormat.format(reg.registrationDate),
          reg.confirmationDate != null ? dateFormat.format(reg.confirmationDate!) : '',
        ].join(','),
      );
    }

    Clipboard.setData(ClipboardData(text: csv.toString()));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('CSV copié dans le presse-papiers')));
  }

  void _copyEmails(BuildContext context, List<Registration> registrations) {
    final emails = registrations.map((r) => r.email).join(', ');
    Clipboard.setData(ClipboardData(text: emails));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${registrations.length} email(s) copié(s)')));
  }

  void _copyPhones(BuildContext context, List<Registration> registrations) {
    final phones = registrations.where((r) => r.phone != null).map((r) => r.phone!).join(', ');
    Clipboard.setData(ClipboardData(text: phones));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${phones.split(',').length} téléphone(s) copié(s)')));
  }

  Widget _buildBulkActionsBar(BuildContext context, ThemeData theme) {
    return Card(
      color: theme.colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(Icons.check_circle_outline, color: theme.colorScheme.onPrimaryContainer),
            const SizedBox(width: 8),
            Text(
              '${_selectedRegistrationIds.length} sélectionné(s)',
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onPrimaryContainer, fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            TextButton(onPressed: () => setState(() => _selectedRegistrationIds.clear()), child: const Text('Désélectionner')),
            const SizedBox(width: 8),
            FilledButton.icon(onPressed: () => _showBulkActionsDialog(context), icon: const Icon(Icons.playlist_add_check), label: const Text('Actions groupées')),
          ],
        ),
      ),
    );
  }

  void _showBulkActionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _BulkActionsDialog(
        selectedIds: _selectedRegistrationIds.toList(),
        onComplete: () {
          setState(() => _selectedRegistrationIds.clear());
          widget.onRefresh?.call();
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, String message) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.inbox_outlined, size: 64, color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5)),
            const SizedBox(height: 16),
            Text(message, style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }

  void _toggleGroupExpansion(int? groupId) {
    setState(() {
      if (_expandedGroupIds.contains(groupId)) {
        _expandedGroupIds.remove(groupId);
      } else {
        _expandedGroupIds.add(groupId);
      }
    });
  }

  void _toggleRegistrationExpansion(int registrationId) {
    setState(() {
      if (_expandedRegistrationIds.contains(registrationId)) {
        _expandedRegistrationIds.remove(registrationId);
      } else {
        _expandedRegistrationIds.add(registrationId);
      }
    });
  }

  void _toggleSelection(int registrationId) {
    setState(() {
      if (_selectedRegistrationIds.contains(registrationId)) {
        _selectedRegistrationIds.remove(registrationId);
      } else {
        _selectedRegistrationIds.add(registrationId);
      }
    });
  }
}

class _RegistrationTile extends ConsumerWidget {
  const _RegistrationTile({
    required this.registration,
    this.onConfirmRegistration,
    required this.isExpanded,
    required this.isSelected,
    required this.onToggleExpansion,
    required this.onToggleSelection,
    this.isPrimaryContact = false,
    this.onRefresh,
  });

  final Registration registration;
  final Future<void> Function(Registration registration, bool confirmed)? onConfirmRegistration;
  final bool isExpanded;
  final bool isSelected;
  final VoidCallback onToggleExpansion;
  final VoidCallback onToggleSelection;
  final bool isPrimaryContact;
  final VoidCallback? onRefresh;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final df = DateFormat('dd/MM/yyyy HH:mm');
    final paymentsAsync = ref.watch(registrationPaymentsProvider(registration.id));

    return Card(
      color: isSelected ? colorScheme.primaryContainer.withOpacity(0.3) : null,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main row with avatar, info, and actions
            Row(
              children: [
                // Selection checkbox
                Checkbox(value: isSelected, onChanged: (_) => onToggleSelection()),
                const SizedBox(width: 8),

                // Avatar
                CircleAvatar(
                  backgroundColor: isPrimaryContact ? colorScheme.primaryContainer : null,
                  child: Text(registration.firstName.substring(0, 1).toUpperCase(), style: TextStyle(color: isPrimaryContact ? colorScheme.onPrimaryContainer : null)),
                ),
                const SizedBox(width: 12),

                // Info column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('${registration.firstName} ${registration.lastName}', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                          if (isPrimaryContact) ...[const SizedBox(width: 6), Icon(Icons.star, size: 16, color: colorScheme.primary)],
                        ],
                      ),
                      const SizedBox(height: 2),
                      _EmailRow(email: registration.email),
                      if (registration.phone != null && registration.phone!.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(Icons.phone, size: 14, color: theme.colorScheme.onSurfaceVariant),
                            const SizedBox(width: 4),
                            Expanded(child: Text(registration.phone!, style: theme.textTheme.bodySmall)),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                // Status and payment chips
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RegistrationStatusChip(status: registration.status),
                    const SizedBox(height: 4),
                    paymentsAsync.when(
                      loading: () => const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
                      error: (error, stack) => const SizedBox.shrink(),
                      data: (payments) {
                        if (payments.isEmpty) {
                          return const SizedBox.shrink();
                        } else {
                          return PaymentStatusChip(status: payments.first.status);
                        }
                      },
                    ),
                  ],
                ),

                const SizedBox(width: 8),

                // Quick action buttons
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (onConfirmRegistration != null && (registration.status == 'pending' || registration.status == 'waiting_list'))
                      IconButton(icon: const Icon(Icons.check_circle_outline), tooltip: 'Confirmer', onPressed: () => onConfirmRegistration!(registration, true)),
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert),
                      tooltip: 'Plus d\'actions',
                      onSelected: (value) => _handleAction(context, ref, value),
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'expand',
                          child: Row(children: [Icon(Icons.info_outline), SizedBox(width: 8), Text('Voir détails')]),
                        ),
                        if (registration.status == 'pending')
                          const PopupMenuItem(
                            value: 'confirm',
                            child: Row(children: [Icon(Icons.check_circle), SizedBox(width: 8), Text('Confirmer')]),
                          ),
                        if (registration.status != 'cancelled')
                          const PopupMenuItem(
                            value: 'cancel',
                            child: Row(children: [Icon(Icons.cancel), SizedBox(width: 8), Text('Annuler')]),
                          ),
                        const PopupMenuItem(
                          value: 'email',
                          child: Row(children: [Icon(Icons.email), SizedBox(width: 8), Text('Envoyer un email')]),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),

            // Expandable details section
            if (isExpanded) ...[
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 8),

              // Dates section
              Text('Dates', style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: [
                  _dateChip(context, 'Inscrit', df.format(registration.registrationDate)),
                  if (registration.confirmationDate != null) _dateChip(context, 'Confirmé', df.format(registration.confirmationDate!)),
                  if (registration.confirmationDeadline != null) _dateChip(context, 'Échéance', df.format(registration.confirmationDeadline!)),
                  if (registration.cancellationDate != null) _dateChip(context, 'Annulé', df.format(registration.cancellationDate!)),
                ],
              ),

              // Cancellation reason
              if (registration.cancellationReason != null && registration.cancellationReason!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text('Raison d\'annulation', style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(registration.cancellationReason!, style: theme.textTheme.bodySmall),
              ],

              // Payment details
              paymentsAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (error, stack) => const SizedBox.shrink(),
                data: (payments) {
                  if (payments.isEmpty) return const SizedBox.shrink();

                  final payment = payments.first;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      Text('Paiement', style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          PaymentStatusChip(status: payment.status),
                          const SizedBox(width: 12),
                          Text(
                            '${(payment.amount / 100).toStringAsFixed(2)} ${payment.currency.toUpperCase()}',
                            style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                          ),
                          if (payment.paidAt != null) ...[const SizedBox(width: 12), Text('Payé le ${df.format(payment.paidAt!)}', style: theme.textTheme.bodySmall)],
                        ],
                      ),
                    ],
                  );
                },
              ),
            ] else ...[
              // Collapsed view - show basic dates
              const SizedBox(height: 8),
              Row(
                children: [
                  Text('Inscrit le ${df.format(registration.registrationDate)}', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: onToggleExpansion,
                    icon: const Icon(Icons.expand_more, size: 16),
                    label: const Text('Voir plus'),
                    style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
                  ),
                ],
              ),
            ],

            // Collapse button when expanded
            if (isExpanded) ...[
              const SizedBox(height: 8),
              Center(
                child: TextButton.icon(onPressed: onToggleExpansion, icon: const Icon(Icons.expand_less, size: 16), label: const Text('Voir moins')),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _handleAction(BuildContext context, WidgetRef ref, String action) {
    switch (action) {
      case 'expand':
        onToggleExpansion();
        break;
      case 'confirm':
        if (onConfirmRegistration != null) {
          onConfirmRegistration!(registration, true);
        }
        break;
      case 'cancel':
        _showCancelDialog(context, ref);
        break;
      case 'email':
        _openEmailClient(context);
        break;
    }
  }

  void _showCancelDialog(BuildContext context, WidgetRef ref) {
    String? reason;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Annuler l\'inscription'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Êtes-vous sûr de vouloir annuler l\'inscription de ${registration.firstName} ${registration.lastName} ?'),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(labelText: 'Raison (optionnel)', border: OutlineInputBorder()),
              maxLines: 2,
              onChanged: (value) => reason = value.isEmpty ? null : value,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Annuler')),
          FilledButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _cancelRegistration(context, ref, reason);
            },
            child: const Text('Confirmer'),
          ),
        ],
      ),
    );
  }

  Future<void> _cancelRegistration(BuildContext context, WidgetRef ref, String? reason) async {
    final auth = ref.read(authenticationProvider);
    if (auth == null) return;

    try {
      await RegistrationsService.instance.cancelRegistration(registration.id, reason: reason);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Inscription annulée avec succès')));
        onRefresh?.call();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur: $e')));
      }
    }
  }

  Future<void> _openEmailClient(BuildContext context) async {
    final uri = Uri(scheme: 'mailto', path: registration.email);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Impossible d'ouvrir le client mail")));
      }
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

class _GroupedRegistrationsList extends ConsumerWidget {
  const _GroupedRegistrationsList({
    required this.registrations,
    this.onConfirmRegistration,
    required this.expandedGroupIds,
    required this.expandedRegistrationIds,
    required this.selectedRegistrationIds,
    required this.onToggleGroupExpansion,
    required this.onToggleRegistrationExpansion,
    required this.onToggleSelection,
    this.onRefresh,
  });

  final List<Registration> registrations;
  final Future<void> Function(Registration registration, bool confirmed)? onConfirmRegistration;
  final Set<int?> expandedGroupIds;
  final Set<int> expandedRegistrationIds;
  final Set<int> selectedRegistrationIds;
  final Function(int?) onToggleGroupExpansion;
  final Function(int) onToggleRegistrationExpansion;
  final Function(int) onToggleSelection;
  final VoidCallback? onRefresh;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Group registrations by groupId; null groupId = individual
    final Map<int?, List<Registration>> groups = {};
    for (final r in registrations) {
      groups.putIfAbsent(r.groupId, () => []).add(r);
    }

    final entries = groups.entries.toList()..sort((a, b) => (a.key ?? 0).compareTo(b.key ?? 0));

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: entries.length,
      itemBuilder: (context, idx) {
        final groupId = entries[idx].key;
        final regs = entries[idx].value;
        final isGroup = groupId != null && regs.length > 1;
        final isExpanded = expandedGroupIds.contains(groupId);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isGroup)
              _GroupHeader(
                groupId: groupId,
                registrations: regs,
                isExpanded: isExpanded,
                onToggleExpansion: () => onToggleGroupExpansion(groupId),
                onSelectAll: () {
                  for (final reg in regs) {
                    onToggleSelection(reg.id);
                  }
                },
              ),
            ...List.generate(regs.length, (i) {
              final isRegistrationExpanded = expandedRegistrationIds.contains(regs[i].id);
              final isSelected = selectedRegistrationIds.contains(regs[i].id);

              return Column(
                children: [
                  _RegistrationTile(
                    registration: regs[i],
                    onConfirmRegistration: onConfirmRegistration,
                    isExpanded: isRegistrationExpanded,
                    isSelected: isSelected,
                    onToggleExpansion: () => onToggleRegistrationExpansion(regs[i].id),
                    onToggleSelection: () => onToggleSelection(regs[i].id),
                    isPrimaryContact: groupId != null && i == 0,
                    onRefresh: onRefresh,
                  ),
                  if (i != regs.length - 1) const Divider(height: 12),
                ],
              );
            }),
            if (idx != entries.length - 1) const Divider(height: 20),
          ],
        );
      },
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
      onTap: () => _openMailto(context, email),
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

  Future<void> _openMailto(BuildContext context, String email) async {
    final uri = Uri(scheme: 'mailto', path: email);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Impossible d'ouvrir le client mail")));
      }
    }
  }
}

class _GroupHeader extends ConsumerWidget {
  const _GroupHeader({required this.groupId, required this.registrations, required this.isExpanded, required this.onToggleExpansion, required this.onSelectAll});

  final int groupId;
  final List<Registration> registrations;
  final bool isExpanded;
  final VoidCallback onToggleExpansion;
  final VoidCallback onSelectAll;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final allSameStatus = registrations.every((r) => r.status == registrations.first.status);

    // Fetch group payment data
    final groupPaymentsAsync = ref.watch(groupPaymentsProvider(groupId));

    return Card(
      color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
      child: InkWell(
        onTap: onToggleExpansion,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(isExpanded ? Icons.expand_less : Icons.expand_more, color: theme.colorScheme.onSurfaceVariant),
              const SizedBox(width: 8),
              Icon(Icons.groups, size: 20, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Groupe #$groupId', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                    Text('${registrations.length} participant(s)', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                  ],
                ),
              ),
              // Group payment status
              groupPaymentsAsync.when(
                loading: () => const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
                error: (error, stack) => const SizedBox.shrink(),
                data: (payments) {
                  if (payments.isEmpty) {
                    return const SizedBox.shrink();
                  } else {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: PaymentStatusChip(status: payments.first.status),
                    );
                  }
                },
              ),
              // Registration status
              if (allSameStatus) ...[RegistrationStatusChip(status: registrations.first.status), const SizedBox(width: 8)],
              IconButton.outlined(onPressed: onSelectAll, icon: const Icon(Icons.checklist, size: 20), tooltip: 'Sélectionner tout le groupe'),
            ],
          ),
        ),
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
      title: Text('Actions groupées (${widget.selectedIds.length} inscriptions)'),
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
          onPressed: isLoading ? null : _performBulkAction,
          child: isLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Appliquer'),
        ),
      ],
    );
  }

  void _performBulkAction() async {
    final auth = ref.read(authenticationProvider);
    if (auth == null) return;

    setState(() => isLoading = true);

    try {
      final payload = BulkRegistrationActionPayload(registrationIds: widget.selectedIds, action: selectedAction, reason: reason, sendEmail: sendEmail);

      final result = await RegistrationsService.instance.performBulkAction(payload, authorization: 'Bearer ${auth.token}');

      if (mounted) {
        Navigator.of(context).pop();

        if (result.successCount > 0) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${result.successCount} inscription(s) mise(s) à jour avec succès')));
          widget.onComplete();
        }

        if (result.failureCount > 0) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('${result.failureCount} erreur(s) lors de l\'opération'), backgroundColor: Theme.of(context).colorScheme.error));
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur: $e'), backgroundColor: Theme.of(context).colorScheme.error));
      }
    }
  }
}
