import 'package:balade/core/constants.dart';
import 'package:balade/features/admin/design/design.dart';
import 'package:balade/features/ramble/models/ramble/ramble.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// The top of a balade page, in the visual language of the management area: the green header with the title,
/// then the cover and a band with the calendar date block, the type, the difficulty, the place and the time.
class RambleDetailsHeader extends StatelessWidget {
  const RambleDetailsHeader({super.key, required this.ramble, this.onBack, this.onShare, this.onFavorite, this.isFavorite = false});

  final Ramble ramble;
  final VoidCallback? onBack;
  final VoidCallback? onShare;
  final VoidCallback? onFavorite;
  final bool isFavorite;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 768;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ManagementPageHeader(
          title: ramble.title,
          linkToPublicSite: false,
          leading: onBack == null ? null : IconButton(tooltip: 'Retour', onPressed: onBack, icon: const Icon(Icons.arrow_back)),
          actions: [
            if (onFavorite != null)
              IconButton(
                tooltip: isFavorite ? 'Retirer des favoris' : 'Ajouter aux favoris',
                onPressed: onFavorite,
                icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: isFavorite ? ManagementColors.lightGreen : Colors.white),
              ),
            if (onShare != null)
              IconButton(
                tooltip: 'Partager',
                onPressed: onShare,
                icon: const Icon(Icons.share, color: Colors.white),
              ),
          ],
        ),
        SizedBox(height: isMobile ? 160 : 240, child: _buildCover(context)),
        _buildBand(context),
      ],
    );
  }

  Widget _buildBand(BuildContext context) {
    final theme = Theme.of(context);
    final date = ramble.date;

    return Material(
      color: ManagementColors.surface,
      shape: const Border(bottom: BorderSide(color: ManagementColors.border)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: ManagementBreakpoints.gutter(context), vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CalendarDateBlock(date: date),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      _chip(context, rambleTypeLabels[ramble.type] ?? ramble.type, ManagementColors.green, icon: rambleTypeIcons[ramble.type] ?? Icons.explore),
                      _chip(context, rambleDifficultyLabels[ramble.difficulty] ?? ramble.difficulty, rambleDifficultyColors[ramble.difficulty] ?? Colors.grey),
                      if (ramble.isCancelled) _chip(context, 'Annulée', ManagementColors.cancelled, icon: Icons.cancel),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (date != null) _detail(context, Icons.access_time, '${DateFormat('dd/MM/yyyy').format(date)} à ${DateFormat('HH:mm').format(date)}'),
                  if (ramble.location != null) _detail(context, Icons.location_on, ramble.location!),
                  if (date == null && ramble.location == null) Text('Date à définir', style: theme.textTheme.bodySmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detail(BuildContext context, IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Row(
        children: [
          Icon(icon, size: 16, color: ManagementColors.muted),
          const SizedBox(width: 6),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }

  Widget _chip(BuildContext context, String label, Color color, {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[Icon(icon, size: 14, color: color), const SizedBox(width: 4)],
          Flexible(
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(color: color),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCover(BuildContext context) {
    if (ramble.coverImage != null && ramble.coverImage!.isNotEmpty) {
      return Image.network(
        "$kBaseUrl/uploads/ramble/${ramble.id}/${ramble.coverImage!}",
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildFallbackBackground(context),
      );
    }
    return _buildFallbackBackground(context);
  }

  Widget _buildFallbackBackground(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [ManagementColors.mint, ManagementColors.lightGreen]),
      ),
      child: Center(child: Icon(rambleTypeIcons[ramble.type] ?? Icons.explore, size: 72, color: ManagementColors.green.withValues(alpha: 0.6))),
    );
  }
}
