import 'package:balade/core/constants.dart';
import 'package:balade/features/ramble/models/ramble/ramble.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RambleDetailsHeader extends StatelessWidget {
  const RambleDetailsHeader({super.key, required this.ramble, this.onBack, this.onShare, this.onFavorite, this.isFavorite = false});

  final Ramble ramble;
  final VoidCallback? onBack;
  final VoidCallback? onShare;
  final VoidCallback? onFavorite;
  final bool isFavorite;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return SliverAppBar(
      expandedHeight: isMobile ? 280 : 360,
      pinned: true,
      leading: onBack != null
          ? IconButton(
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back),
              style: IconButton.styleFrom(backgroundColor: Colors.black.withValues(alpha: 0.3), foregroundColor: Colors.white),
            )
          : null,
      actions: [
        if (onFavorite != null)
          IconButton(
            onPressed: onFavorite,
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
            style: IconButton.styleFrom(backgroundColor: Colors.black.withValues(alpha: 0.3), foregroundColor: isFavorite ? Colors.red : Colors.white),
          ),
        if (onShare != null)
          IconButton(
            onPressed: onShare,
            icon: const Icon(Icons.share),
            style: IconButton.styleFrom(backgroundColor: Colors.black.withValues(alpha: 0.3), foregroundColor: Colors.white),
          ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Cover image or gradient background
            _buildCoverImage(context),

            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withValues(alpha: 0.7)],
                  stops: const [0.4, 1.0],
                ),
              ),
            ),

            // Content overlay
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Type and difficulty chips
                  Row(
                    children: [
                      _buildTypeChip(context),
                      const SizedBox(width: 8),
                      _buildDifficultyChip(context),
                      const Spacer(),
                      if (ramble.date != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(16)),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.calendar_today, size: 14, color: Colors.white),
                              const SizedBox(width: 4),
                              Text(
                                DateFormat('dd/MM/yyyy').format(ramble.date!),
                                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Title
                  Text(
                    ramble.title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      shadows: [Shadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 8)],
                    ),
                  ),

                  // Location and time
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (ramble.location != null) ...[
                        const Icon(Icons.location_on, size: 16, color: Colors.white),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            ramble.location!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              shadows: [Shadow(color: Colors.black54, blurRadius: 4)],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                      if (ramble.date != null && ramble.location != null) ...[const SizedBox(width: 16)],
                      if (ramble.date != null) ...[
                        const Icon(Icons.access_time, size: 16, color: Colors.white),
                        const SizedBox(width: 4),
                        Text(
                          DateFormat('HH:mm').format(ramble.date!),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            shadows: [Shadow(color: Colors.black54, blurRadius: 4)],
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoverImage(BuildContext context) {
    if (ramble.coverImage != null && ramble.coverImage!.isNotEmpty) {
      return Image.network(
        "$kBaseUrl/uploads/ramble/${ramble.id}/${ramble.coverImage!}",
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildFallbackBackground(context);
        },
      );
    } else {
      return _buildFallbackBackground(context);
    }
  }

  Widget _buildFallbackBackground(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colorScheme.primaryContainer, colorScheme.secondaryContainer, colorScheme.tertiaryContainer],
        ),
      ),
      child: Center(child: Icon(rambleTypeIcons[ramble.type] ?? Icons.explore, size: 80, color: colorScheme.primary.withValues(alpha: 0.7))),
    );
  }

  Widget _buildTypeChip(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(16)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(rambleTypeIcons[ramble.type] ?? Icons.explore, size: 14, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            rambleTypeLabels[ramble.type] ?? ramble.type,
            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildDifficultyChip(BuildContext context) {
    final color = rambleDifficultyColors[ramble.difficulty] ?? Colors.grey;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.9), borderRadius: BorderRadius.circular(16)),
      child: Text(
        rambleDifficultyLabels[ramble.difficulty] ?? ramble.difficulty,
        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}
