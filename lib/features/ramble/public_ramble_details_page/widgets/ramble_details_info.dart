import 'package:balade/features/ramble/models/ramble/ramble.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RambleDetailsInfo extends StatelessWidget {
  const RambleDetailsInfo({super.key, required this.ramble});

  final Ramble ramble;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Cancellation Alert
        if (ramble.isCancelled) ...[
          Card(
            color: colorScheme.errorContainer,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.cancel, color: colorScheme.error, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Balade annulée',
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.error),
                      ),
                    ],
                  ),
                  if (ramble.cancellationReason != null) ...[
                    const SizedBox(height: 12),
                    Text('Motif : ${ramble.cancellationReason!}', style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onErrorContainer)),
                  ],
                  if (ramble.cancellationDate != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Annulée le ${DateFormat('dd/MM/yyyy à HH:mm', 'fr').format(ramble.cancellationDate!.toLocal())}',
                      style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onErrorContainer.withValues(alpha: 0.7)),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
        // Description
        if (ramble.description != null && ramble.description!.isNotEmpty) ...[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.description, color: colorScheme.primary, size: 20),
                      const SizedBox(width: 8),
                      Text('Description', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(ramble.description!, style: theme.textTheme.bodyMedium?.copyWith(height: 1.6)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Practical Information
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info_outline, color: colorScheme.primary, size: 20),
                    const SizedBox(width: 8),
                    Text('Informations pratiques', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 16),

                // Duration
                if (ramble.estimatedDuration != null) _buildInfoRow(context, Icons.schedule, 'Durée estimée', _formatDuration(ramble.estimatedDuration!)),

                // Max participants
                if (ramble.maxParticipants != null) _buildInfoRow(context, Icons.group, 'Nombre maximum de participants', ramble.maxParticipants.toString()),

                // Meeting point
                if (ramble.meetingPoint != null && ramble.meetingPoint!.isNotEmpty) _buildInfoRow(context, Icons.place, 'Point de rendez-vous', ramble.meetingPoint!),

                // Equipment needed
                if (ramble.equipmentNeeded != null && ramble.equipmentNeeded!.isNotEmpty) _buildInfoRow(context, Icons.backpack, 'Équipement nécessaire', ramble.equipmentNeeded!),

                // Prerequisites
                if (ramble.prerequisites != null && ramble.prerequisites!.isNotEmpty) _buildInfoRow(context, Icons.checklist, 'Prérequis', ramble.prerequisites!),
              ],
            ),
          ),
        ),

        // Pricing
        if (ramble.prices.isNotEmpty) ...[
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.euro, color: colorScheme.primary, size: 20),
                      const SizedBox(width: 8),
                      Text('Tarifs', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...ramble.prices.map(
                    (price) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: Text(price.label, style: theme.textTheme.bodyMedium)),
                          Text(
                            '${price.amount.toStringAsFixed(0)}€',
                            style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.primary),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String label, String value) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: colorScheme.onSurfaceVariant),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600, color: colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 2),
                Text(value, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours > 0 && minutes > 0) {
      return '${hours}h${minutes.toString().padLeft(2, '0')}';
    } else if (hours > 0) {
      return '${hours}h';
    } else {
      return '${minutes}min';
    }
  }
}
