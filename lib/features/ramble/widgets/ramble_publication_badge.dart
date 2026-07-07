import 'package:balade/features/ramble/models/ramble/ramble.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RamblePublicationBadge extends StatelessWidget {
  const RamblePublicationBadge({super.key, required this.ramble, this.compact = false});

  final Ramble ramble;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    if (ramble.isPublished) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final (color, label) = _badgeStyle();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: compact ? 6 : 8, vertical: compact ? 2 : 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        label,
        style: theme.textTheme.bodySmall?.copyWith(color: color, fontWeight: FontWeight.w600, fontSize: compact ? 10 : null),
      ),
    );
  }

  (Color, String) _badgeStyle() {
    if (ramble.isDraft) {
      return (Colors.grey, 'Brouillon');
    }
    final dateLabel = DateFormat('dd/MM/yyyy', 'fr').format(ramble.publishedAt!.toLocal());
    return (Colors.orange, 'Planifié le $dateLabel');
  }
}
