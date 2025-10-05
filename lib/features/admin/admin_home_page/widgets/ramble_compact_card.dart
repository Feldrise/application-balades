import 'package:balade/core/constants.dart';
import 'package:balade/features/ramble/models/ramble/ramble.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

class RambleCompactCard extends StatelessWidget {
  const RambleCompactCard({super.key, required this.ramble, this.onEdit, this.onDelete, this.onCancel});

  final Ramble ramble;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('dd/MM');
    final timeFormat = DateFormat('HH:mm');

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _openDetails(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Compact header with status indicator
            _buildCompactHeader(context, theme),

            // Content area with fixed height
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title (fixed 2 lines)
                    SizedBox(
                      height: 40,
                      child: Text(
                        ramble.title,
                        style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600, height: 1.2),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Type and difficulty (single line)
                    Row(
                      children: [
                        Icon(rambleTypeIcons[ramble.type] ?? Icons.explore, size: 14, color: theme.colorScheme.primary),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            rambleTypeLabels[ramble.type] ?? ramble.type,
                            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.primary),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        _buildDifficultyDot(theme),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Date and key info
                    if (ramble.date != null) ...[
                      Row(
                        children: [
                          Icon(Icons.calendar_today, size: 12, color: theme.colorScheme.onSurfaceVariant),
                          const SizedBox(width: 4),
                          Text('${dateFormat.format(ramble.date!)} à ${timeFormat.format(ramble.date!)}', style: theme.textTheme.bodySmall),
                          const Spacer(),
                          if (ramble.maxParticipants != null) ...[
                            Icon(Icons.group, size: 12, color: theme.colorScheme.onSurfaceVariant),
                            const SizedBox(width: 2),
                            Text('${ramble.maxParticipants}', style: theme.textTheme.bodySmall),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                    ],

                    // Location (truncated)
                    if (ramble.location != null) ...[
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 12, color: theme.colorScheme.onSurfaceVariant),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(ramble.location!, style: theme.textTheme.bodySmall, overflow: TextOverflow.ellipsis),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],

                    // Compact guides display
                    if (ramble.guides.isNotEmpty) ...[_buildCompactGuides(theme), const SizedBox(height: 8)],

                    const Spacer(),

                    // Price indicator
                    if (ramble.prices.isNotEmpty) ...[
                      Row(
                        children: [
                          Icon(Icons.euro, size: 12, color: theme.colorScheme.onSurfaceVariant),
                          const SizedBox(width: 4),
                          Text('${ramble.prices.first.amount}€', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
                          if (ramble.prices.length > 1) ...[Text(' (+${ramble.prices.length - 1})', style: theme.textTheme.bodySmall)],
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // Action buttons (compact)
            _buildCompactActions(context, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactHeader(BuildContext context, ThemeData theme) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [theme.colorScheme.primaryContainer, theme.colorScheme.primaryContainer.withOpacity(0.7)],
        ),
        image: ramble.coverImage != null && ramble.coverImage!.isNotEmpty
            ? DecorationImage(image: NetworkImage('$kBaseUrl/uploads/ramble/${ramble.id}/${ramble.coverImage!}'), fit: BoxFit.cover)
            : null,
      ),
      child: Stack(
        children: [
          // Background pattern or icon
          Positioned(right: -10, top: -10, child: Icon(rambleTypeIcons[ramble.type] ?? Icons.explore, size: 80, color: theme.colorScheme.onPrimaryContainer.withOpacity(0.1))),
          // Status indicator
          Positioned(top: 8, right: 8, child: _buildStatusIndicator(theme)),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator(ThemeData theme) {
    Color statusColor;
    IconData statusIcon;

    if (ramble.isCancelled) {
      statusColor = Colors.red;
      statusIcon = Icons.cancel;
    } else {
      statusColor = Colors.green;
      statusIcon = Icons.visibility;
    }

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: statusColor, borderRadius: BorderRadius.circular(12)),
      child: Icon(statusIcon, size: 16, color: Colors.white),
    );
  }

  Widget _buildDifficultyDot(ThemeData theme) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(color: rambleDifficultyColors[ramble.difficulty] ?? Colors.grey, shape: BoxShape.circle),
    );
  }

  Widget _buildCompactGuides(ThemeData theme) {
    const maxVisible = 2;
    final visibleGuides = ramble.guides.take(maxVisible).toList();
    final remaining = ramble.guides.length - maxVisible;

    return Row(
      children: [
        Icon(Icons.person, size: 12, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 4),
        Expanded(
          child: Row(
            children: [
              ...visibleGuides.map(
                (guide) => Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
                    child: Text(
                      guide.firstName.isNotEmpty ? guide.firstName[0].toUpperCase() : '?',
                      style: theme.textTheme.bodySmall?.copyWith(fontSize: 10, fontWeight: FontWeight.w600, color: theme.colorScheme.primary),
                    ),
                  ),
                ),
              ),
              if (remaining > 0) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: theme.colorScheme.surfaceVariant, borderRadius: BorderRadius.circular(8)),
                  child: Text('+$remaining', style: theme.textTheme.bodySmall?.copyWith(fontSize: 10)),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCompactActions(BuildContext context, ThemeData theme) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: theme.colorScheme.outline.withOpacity(0.2), width: 1)),
      ),
      child: Row(
        children: [
          if (onEdit != null) ...[
            Expanded(
              child: TextButton.icon(
                onPressed: onEdit,
                icon: const Icon(Icons.edit, size: 14),
                label: const Text('Modifier'),
                style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 8), minimumSize: const Size(0, 32)),
              ),
            ),
          ],
          if (onCancel != null && !ramble.isCancelled) ...[
            if (onEdit != null) const SizedBox(width: 4),
            IconButton(
              onPressed: onCancel,
              icon: const Icon(Icons.cancel, size: 16),
              tooltip: 'Annuler',
              style: IconButton.styleFrom(minimumSize: const Size(32, 32), backgroundColor: theme.colorScheme.error.withOpacity(0.1)),
            ),
          ],
        ],
      ),
    );
  }

  void _openDetails(BuildContext context) {
    context.go('/admin/balade/${ramble.id}');
  }
}
