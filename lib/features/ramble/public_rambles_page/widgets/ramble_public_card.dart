import 'package:balade/core/constants.dart';
import 'package:balade/features/ramble/models/ramble/ramble.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RamblePublicCard extends StatelessWidget {
  const RamblePublicCard({super.key, required this.ramble, this.onTap});

  final Ramble ramble;
  final VoidCallback? onTap;

  bool get _isPastRamble {
    if (ramble.date == null) return false;
    return ramble.date!.isBefore(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Opacity(
      opacity: _isPastRamble ? 0.5 : 1.0,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cover image or type icon
              _buildHeader(context),

              // Content
              Expanded(
                child: Padding(
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
                              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (ramble.isCancelled) _buildCancelledChip(context) else _buildDifficultyChip(context),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Cancellation notice or type and guides
                      if (ramble.isCancelled) ...[
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.cancel, size: 16, color: Colors.red),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Balade annulée',
                                    style: theme.textTheme.bodySmall?.copyWith(color: Colors.red, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              if (ramble.cancellationReason != null && ramble.cancellationReason!.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  ramble.cancellationReason!,
                                  style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ] else ...[
                        // Type and guides
                        Row(
                          children: [
                            Icon(rambleTypeIcons[ramble.type] ?? Icons.explore, size: 16, color: colorScheme.primary),
                            const SizedBox(width: 4),
                            Text(
                              rambleTypeLabels[ramble.type] ?? ramble.type,
                              style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.primary, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),

                        if (ramble.guides.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Avec ${ramble.guides.map((g) => '${g.firstName} ${g.lastName}').join(', ')}',
                            style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],

                      const Spacer(),

                      // Date and location
                      if (ramble.date != null) ...[
                        Row(
                          children: [
                            Icon(Icons.calendar_today, size: 16, color: colorScheme.onSurfaceVariant),
                            const SizedBox(width: 4),
                            Text(DateFormat('dd/MM/yyyy').format(ramble.date!), style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
                            if (ramble.date != null) ...[
                              const SizedBox(width: 8),
                              Text(
                                DateFormat('HH:mm').format(ramble.date!),
                                style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ],
                        ),
                      ],

                      if (ramble.location != null) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.location_on, size: 16, color: colorScheme.onSurfaceVariant),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                ramble.location!,
                                style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],

                      const SizedBox(height: 12),

                      // Price and button
                      Row(
                        children: [
                          if (ramble.prices.isNotEmpty && !ramble.isCancelled) ...[
                            Text(
                              _formatPrice(),
                              style: theme.textTheme.titleSmall?.copyWith(color: colorScheme.primary, fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                          ] else ...[
                            const Spacer(),
                          ],

                          FilledButton.icon(
                            onPressed: onTap,
                            icon: Icon(ramble.isCancelled ? Icons.info_outline : Icons.info_outline, size: 16),
                            label: Text(ramble.isCancelled ? 'Détails' : 'Détails'),
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              textStyle: theme.textTheme.bodySmall,
                              backgroundColor: ramble.isCancelled ? colorScheme.surfaceContainerHighest : null,
                              foregroundColor: ramble.isCancelled ? colorScheme.onSurface : null,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Widget headerContent;
    if (ramble.coverImage != null && ramble.coverImage!.isNotEmpty) {
      headerContent = Container(
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(image: NetworkImage("$kBaseUrl/uploads/ramble/${ramble.id}/${ramble.coverImage}"), fit: BoxFit.cover),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black.withValues(alpha: 0.3)]),
          ),
        ),
      );
    } else {
      headerContent = Container(
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [colorScheme.primaryContainer, colorScheme.secondaryContainer]),
        ),
        child: Center(child: Icon(rambleTypeIcons[ramble.type] ?? Icons.explore, size: 48, color: colorScheme.primary)),
      );
    }

    // Add grey overlay for cancelled rambles
    if (ramble.isCancelled) {
      return Stack(
        children: [
          headerContent,
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.grey.withValues(alpha: 0.4)),
            child: Center(child: Icon(Icons.cancel, size: 32, color: Colors.red)),
          ),
        ],
      );
    }

    return headerContent;
  }

  Widget _buildDifficultyChip(BuildContext context) {
    final theme = Theme.of(context);
    final color = rambleDifficultyColors[ramble.difficulty] ?? Colors.grey;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        rambleDifficultyLabels[ramble.difficulty] ?? ramble.difficulty,
        style: theme.textTheme.bodySmall?.copyWith(color: color, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildCancelledChip(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
      ),
      child: Text(
        'Annulée',
        style: theme.textTheme.bodySmall?.copyWith(color: Colors.red, fontWeight: FontWeight.w500),
      ),
    );
  }

  String _formatPrice() {
    if (ramble.prices.isEmpty) return '';

    if (ramble.prices.length == 1) {
      return '${ramble.prices.first.amount.toStringAsFixed(0)}€';
    }

    final prices = ramble.prices.map((p) => p.amount).toList()..sort();
    return '${prices.first.toStringAsFixed(0)}€ - ${prices.last.toStringAsFixed(0)}€';
  }
}
