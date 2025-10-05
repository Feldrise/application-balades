import 'package:balade/features/ramble/models/ramble/ramble.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

class RambleTableRow extends StatelessWidget {
  const RambleTableRow({super.key, required this.ramble, this.onEdit, this.onCancel, this.isHeader = false});

  final Ramble? ramble;
  final VoidCallback? onEdit;
  final VoidCallback? onCancel;
  final bool isHeader;

  @override
  Widget build(BuildContext context) {
    if (isHeader) {
      return _buildHeader(context);
    }

    return _buildRow(context);
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
        border: Border(bottom: BorderSide(color: theme.colorScheme.outline.withOpacity(0.2), width: 1)),
      ),
      child: Row(
        children: [
          // Title
          const Expanded(
            flex: 3,
            child: Text('Titre', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          // Type
          const Expanded(
            flex: 2,
            child: Text('Type', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          // Date
          const Expanded(
            flex: 2,
            child: Text('Date', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          // Guides
          const Expanded(
            flex: 2,
            child: Text('Guides', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          // Status
          const Expanded(
            flex: 1,
            child: Text('Statut', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          // Actions
          const SizedBox(
            width: 120,
            child: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('dd/MM/yy');
    final timeFormat = DateFormat('HH:mm');

    return InkWell(
      onTap: () => _openDetails(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: theme.colorScheme.outline.withOpacity(0.1), width: 1)),
        ),
        child: Row(
          children: [
            // Title and location
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ramble?.title ?? '',
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (ramble?.location != null) ...[
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 12, color: theme.colorScheme.onSurfaceVariant),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            ramble!.location!,
                            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            // Type and difficulty
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(rambleTypeIcons[ramble?.type] ?? Icons.explore, size: 16, color: theme.colorScheme.primary),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(rambleTypeLabels[ramble?.type] ?? ramble?.type ?? '', style: theme.textTheme.bodyMedium, overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(color: rambleDifficultyColors[ramble?.difficulty] ?? Colors.grey, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          rambleDifficultyLabels[ramble?.difficulty] ?? ramble?.difficulty ?? '',
                          style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Date and time
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (ramble?.date != null) ...[
                    Text(dateFormat.format(ramble!.date!), style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
                    Text(timeFormat.format(ramble!.date!), style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                  ] else ...[
                    Text('Non programmé', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                  ],
                ],
              ),
            ),

            // Guides (compact)
            Expanded(
              flex: 2,
              child: ramble?.guides.isNotEmpty == true
                  ? Row(
                      children: [
                        ...ramble!.guides
                            .take(2)
                            .map(
                              (guide) => Padding(
                                padding: const EdgeInsets.only(right: 4),
                                child: CircleAvatar(
                                  radius: 12,
                                  backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                                  child: Text(
                                    guide.firstName.isNotEmpty ? guide.firstName[0].toUpperCase() : '?',
                                    style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600, color: theme.colorScheme.primary),
                                  ),
                                ),
                              ),
                            ),
                        if (ramble!.guides.length > 2) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(color: theme.colorScheme.surfaceVariant, borderRadius: BorderRadius.circular(8)),
                            child: Text('+${ramble!.guides.length - 2}', style: theme.textTheme.bodySmall),
                          ),
                        ],
                      ],
                    )
                  : Text('Aucun guide', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            ),

            // Status
            Expanded(flex: 1, child: _buildStatusChip(context, theme)),

            // Actions
            SizedBox(
              width: 120,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (onEdit != null) ...[
                    IconButton(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit, size: 16),
                      tooltip: 'Modifier',
                      style: IconButton.styleFrom(minimumSize: const Size(32, 32)),
                    ),
                  ],
                  if (onCancel != null && ramble != null && !ramble!.isCancelled) ...[
                    IconButton(
                      onPressed: onCancel,
                      icon: const Icon(Icons.cancel, size: 16),
                      tooltip: 'Annuler',
                      style: IconButton.styleFrom(minimumSize: const Size(32, 32)),
                    ),
                  ],
                  IconButton(
                    onPressed: () => _openDetails(context),
                    icon: const Icon(Icons.open_in_new, size: 16),
                    tooltip: 'Voir détails',
                    style: IconButton.styleFrom(minimumSize: const Size(32, 32)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context, ThemeData theme) {
    if (ramble == null) return const SizedBox.shrink();

    Color statusColor;
    String statusLabel;

    if (ramble!.isCancelled) {
      statusColor = Colors.red;
      statusLabel = 'Annulé';
    } else {
      statusColor = Colors.green;
      statusLabel = 'Actif';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withOpacity(0.3), width: 1),
      ),
      child: Text(
        statusLabel,
        style: theme.textTheme.bodySmall?.copyWith(color: statusColor, fontWeight: FontWeight.w500),
      ),
    );
  }

  void _openDetails(BuildContext context) {
    if (ramble != null) {
      context.go('/admin/balade/${ramble!.id}');
    }
  }
}
