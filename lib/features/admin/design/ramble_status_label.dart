import 'package:balade/features/admin/design/management_theme.dart';
import 'package:balade/features/ramble/models/ramble/ramble.dart';
import 'package:flutter/material.dart';

/// Where a balade stands for its visitors: Annulée, Brouillon, Programmée or Publiée.
(String, Color) rambleStatus(Ramble ramble) {
  if (ramble.isCancelled) return ('Annulée', ManagementColors.cancelled);
  if (ramble.isDraft) return ('Brouillon', ManagementColors.draft);
  if (ramble.isScheduled) return ('Programmée', ManagementColors.pending);
  return ('Publiée', ManagementColors.green);
}

/// The status of a balade, as a coloured dot and its label.
class RambleStatusLabel extends StatelessWidget {
  const RambleStatusLabel({super.key, required this.ramble});

  final Ramble ramble;

  @override
  Widget build(BuildContext context) {
    final (label, color) = rambleStatus(ramble);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Flexible(
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(color: color, fontWeight: FontWeight.w800),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
