import 'package:balade/core/constants.dart';
import 'package:balade/features/guides/widgets/guide_small_card.dart';
import 'package:balade/features/ramble/models/ramble/ramble.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RambleAdminCard extends StatelessWidget {
  const RambleAdminCard({super.key, required this.ramble, this.onEdit, this.onDelete, this.onToggleStatus});

  final Ramble ramble;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onToggleStatus;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('dd/MM/yyyy');
    final timeFormat = DateFormat('HH:mm');

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with cover image or type icon
          _buildHeader(context),

          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and status
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        ramble.title,
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    _buildStatusChip(context),
                  ],
                ),

                const SizedBox(height: 8),

                // Type and difficulty
                Row(
                  children: [
                    Icon(rambleTypeIcons[ramble.type] ?? Icons.explore, size: 16, color: theme.colorScheme.primary),
                    const SizedBox(width: 4),
                    Text(rambleTypeLabels[ramble.type] ?? ramble.type, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.primary)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: rambleDifficultyColors[ramble.difficulty]?.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: rambleDifficultyColors[ramble.difficulty] ?? Colors.grey, width: 1),
                      ),
                      child: Text(
                        rambleDifficultyLabels[ramble.difficulty] ?? ramble.difficulty,
                        style: theme.textTheme.bodySmall?.copyWith(color: rambleDifficultyColors[ramble.difficulty], fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Date and location
                if (ramble.date != null) ...[
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 14, color: theme.colorScheme.onSurfaceVariant),
                      const SizedBox(width: 4),
                      Text('${dateFormat.format(ramble.date!)} à ${timeFormat.format(ramble.date!)}', style: theme.textTheme.bodySmall),
                    ],
                  ),
                  const SizedBox(height: 4),
                ],

                if (ramble.location != null) ...[
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 14, color: theme.colorScheme.onSurfaceVariant),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(ramble.location!, style: theme.textTheme.bodySmall, overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                ],

                // Duration and participants
                Row(
                  children: [
                    if (ramble.estimatedDuration != null) ...[
                      Icon(Icons.schedule, size: 14, color: theme.colorScheme.onSurfaceVariant),
                      const SizedBox(width: 4),
                      Text(
                        '${ramble.estimatedDuration!.inHours}h${ramble.estimatedDuration!.inMinutes % 60 > 0 ? '${ramble.estimatedDuration!.inMinutes % 60}' : ''}',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                    if (ramble.estimatedDuration != null && ramble.maxParticipants != null) const SizedBox(width: 12),
                    if (ramble.maxParticipants != null) ...[
                      Icon(Icons.group, size: 14, color: theme.colorScheme.onSurfaceVariant),
                      const SizedBox(width: 4),
                      Text('${ramble.maxParticipants} places', style: theme.textTheme.bodySmall),
                    ],
                  ],
                ),

                // Guides
                if (ramble.guides.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text('Guides:', style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  ...ramble.guides.map((guide) => GuideSmallCard(guideId: guide.id, showRemoveButton: false)),
                ],

                // Prices
                if (ramble.prices.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.euro, size: 14, color: theme.colorScheme.onSurfaceVariant),
                      const SizedBox(width: 4),
                      Text(ramble.prices.map((p) => '${p.label}: ${p.amount}€').join(', '), style: theme.textTheme.bodySmall, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ],

                const SizedBox(height: 16),

                // Action buttons
                Row(
                  children: [
                    if (onEdit != null)
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onEdit,
                          icon: const Icon(Icons.edit, size: 16),
                          label: const Text('Modifier'),
                          style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 8)),
                        ),
                      ),
                    if (onEdit != null && onToggleStatus != null) const SizedBox(width: 8),
                    if (onToggleStatus != null)
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: onToggleStatus,
                          icon: Icon(ramble.status == 'published' ? Icons.visibility_off : Icons.visibility, size: 16),
                          label: Text(ramble.status == 'published' ? 'Masquer' : 'Publier'),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            backgroundColor: ramble.status == 'published' ? theme.colorScheme.secondary : theme.colorScheme.primary,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        color: theme.colorScheme.primary.withOpacity(0.1),
        image: ramble.coverImage != null && ramble.coverImage!.isNotEmpty
            ? DecorationImage(image: NetworkImage('$kBaseUrl/uploads/ramble/${ramble.id}/${ramble.coverImage!}'), fit: BoxFit.cover)
            : null,
      ),
      child: ramble.coverImage == null || ramble.coverImage!.isEmpty
          ? Center(child: Icon(rambleTypeIcons[ramble.type] ?? Icons.explore, size: 48, color: theme.colorScheme.primary))
          : Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black.withOpacity(0.3)]),
              ),
            ),
    );
  }

  Widget _buildStatusChip(BuildContext context) {
    final theme = Theme.of(context);
    Color statusColor;
    String statusLabel;

    switch (ramble.status) {
      case 'published':
        statusColor = Colors.green;
        statusLabel = 'Publié';
        break;
      case 'draft':
        statusColor = Colors.orange;
        statusLabel = 'Brouillon';
        break;
      case 'cancelled':
        statusColor = Colors.red;
        statusLabel = 'Annulé';
        break;
      case 'completed':
        statusColor = Colors.blue;
        statusLabel = 'Terminé';
        break;
      default:
        statusColor = Colors.grey;
        statusLabel = ramble.status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor, width: 1),
      ),
      child: Text(
        statusLabel,
        style: theme.textTheme.bodySmall?.copyWith(color: statusColor, fontWeight: FontWeight.w600),
      ),
    );
  }
}
