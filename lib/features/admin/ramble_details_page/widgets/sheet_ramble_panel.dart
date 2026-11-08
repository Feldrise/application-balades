import 'package:balade/features/admin/design/design.dart';
import 'package:balade/features/admin/ramble_details_page/widgets/ramble_sheet_actions.dart';
import 'package:balade/features/ramble/models/ramble/ramble.dart';
import 'package:balade/features/reservations/reservation_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

/// The balade on its feuille: Modifier and Dupliquer, then the practical information, the tarifs and the description.
class SheetRamblePanel extends ConsumerWidget {
  const SheetRamblePanel({super.key, required this.ramble, required this.canEdit, required this.canDuplicate});

  final Ramble ramble;
  final bool canEdit;
  final bool canDuplicate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final guides = ramble.guides.map((g) => [g.firstName, g.lastName].whereType<String>().join(' ').trim()).where((n) => n.isNotEmpty).join(', ');
    final duration = ramble.estimatedDuration;
    final documents = ramble.additionalDocumentsUrl;

    return ManagementPanel(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(child: Text('La balade', style: theme.textTheme.titleMedium)),
                  RambleStatusLabel(ramble: ramble),
                ],
              ),
              if (canEdit || canDuplicate) ...[
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (canEdit)
                      FilledButton.icon(
                        style: FilledButton.styleFrom(backgroundColor: ManagementColors.deepGreen, visualDensity: VisualDensity.compact),
                        onPressed: () => context.go('/admin/modifier-balade/${ramble.id}'),
                        icon: const Icon(Icons.edit, size: 16),
                        label: const Text('Modifier'),
                      ),
                    if (canDuplicate)
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(visualDensity: VisualDensity.compact),
                        onPressed: () => duplicateRamble(context, ref, ramble),
                        icon: const Icon(Icons.copy, size: 16),
                        label: const Text('Dupliquer'),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
        if (ramble.isCancelled) _Fact('Annulée', ramble.cancellationReason?.isNotEmpty == true ? ramble.cancellationReason! : 'Sans motif'),
        if (guides.isNotEmpty) _Fact(ramble.guides.length > 1 ? 'Guides' : 'Guide', guides),
        if (ramble.location?.isNotEmpty == true) _Fact('Lieu', ramble.location!),
        if (ramble.meetingPoint?.isNotEmpty == true) _Fact('Rendez-vous', ramble.meetingPoint!),
        if (duration != null) _Fact('Durée', '${duration.inHours}h${duration.inMinutes.remainder(60).toString().padLeft(2, '0')}'),
        _Fact('Difficulté', rambleDifficultyLabels[ramble.difficulty] ?? ramble.difficulty),
        _Fact('Capacité', ramble.maxParticipants == null ? 'Sans limite' : '${ramble.maxParticipants} places'),
        _Fact('Tarifs', ramble.prices.isEmpty ? 'Gratuit' : ramble.prices.map((p) => '${p.label} · ${formatEuros(p.amount)}').join('\n')),
        if (ramble.equipmentNeeded?.isNotEmpty == true) _Fact('Équipement', ramble.equipmentNeeded!),
        if (ramble.prerequisites?.isNotEmpty == true) _Fact('Conditions', ramble.prerequisites!),
        if (documents?.isNotEmpty == true)
          ManagementRow(
            onTap: () => launchUrl(Uri.parse(documents!), mode: LaunchMode.externalApplication),
            child: Row(
              children: [
                const Icon(Icons.description_outlined, size: 18, color: ManagementColors.green),
                const SizedBox(width: 8),
                Expanded(child: Text('Documents complémentaires', style: theme.textTheme.labelLarge?.copyWith(color: ManagementColors.green))),
                const Icon(Icons.open_in_new, size: 16, color: ManagementColors.green),
              ],
            ),
          ),
        if (ramble.description?.isNotEmpty == true)
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('DESCRIPTION', style: theme.textTheme.labelSmall),
                const SizedBox(height: 6),
                Text(ramble.description!, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
      ],
    );
  }
}

class _Fact extends StatelessWidget {
  const _Fact(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 104, child: Text(label, style: theme.textTheme.bodySmall)),
          Expanded(child: Text(value, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }
}
