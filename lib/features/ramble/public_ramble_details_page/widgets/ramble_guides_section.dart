import 'package:balade/features/ramble/models/ramble/ramble.dart';
import 'package:balade/features/ramble/public_ramble_details_page/widgets/guide_big_card.dart';
import 'package:flutter/material.dart';

class RambleGuidesSection extends StatelessWidget {
  const RambleGuidesSection({super.key, required this.ramble, this.onContactGuide});

  final Ramble ramble;
  final Function(int guideId)? onContactGuide;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (ramble.guides.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Icon(Icons.person, color: colorScheme.primary, size: 24),
              const SizedBox(width: 8),
              Text(ramble.guides.length == 1 ? 'Votre guide' : 'Vos guides', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
        ),

        // Guides list
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: ramble.guides.map((guide) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: GuideBigCard(guide: guide, onContactGuide: onContactGuide != null ? () => onContactGuide!(guide.id) : null),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
