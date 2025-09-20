import 'package:balade/features/registrations/models/registration/registration.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminParticipantsList extends StatelessWidget {
  const AdminParticipantsList({super.key, required this.registrations, this.maxParticipants, this.onConfirmRegistration});

  final List<Registration> registrations;
  final int? maxParticipants;
  final Future<void> Function(Registration registration, bool confirmed)? onConfirmRegistration;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final confirmed = registrations.where((r) => r.status == 'confirmed').length;
    final pending = registrations.where((r) => r.status == 'pending').length;
    final cancelled = registrations.where((r) => r.status == 'cancelled').length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.people_alt, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text('Inscriptions', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const Spacer(),
                if (maxParticipants != null)
                  Text(
                    '${registrations.length}/${maxParticipants!}',
                    style: theme.textTheme.labelLarge?.copyWith(color: colorScheme.primary, fontWeight: FontWeight.w700),
                  ),
              ],
            ),

            const SizedBox(height: 12),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildStatusChip(context, 'Confirmées', confirmed, Colors.green),
                _buildStatusChip(context, 'En attente', pending, Colors.orange),
                _buildStatusChip(context, 'Annulées', cancelled, Colors.red),
                _buildStatusChip(context, 'Total', registrations.length, colorScheme.primary),
              ],
            ),

            const SizedBox(height: 12),

            if (registrations.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text('Aucune inscription pour le moment.', style: theme.textTheme.bodyMedium),
              )
            else
              _GroupedRegistrationsList(registrations: registrations, onConfirmRegistration: onConfirmRegistration),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context, String label, int count, Color color) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        '$label: $count',
        style: theme.textTheme.bodySmall?.copyWith(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _RegistrationTile extends StatelessWidget {
  const _RegistrationTile({required this.registration, this.onConfirmRegistration});

  final Registration registration;
  final Future<void> Function(Registration registration, bool confirmed)? onConfirmRegistration;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final df = DateFormat('dd/MM/yyyy HH:mm');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(child: Text(registration.firstName.substring(0, 1).toUpperCase())),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${registration.firstName} ${registration.lastName}', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  _EmailRow(email: registration.email),
                  if (registration.phone != null && registration.phone!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(Icons.phone, size: 14, color: theme.colorScheme.onSurfaceVariant),
                        const SizedBox(width: 4),
                        Expanded(child: Text(registration.phone!, style: theme.textTheme.bodySmall)),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _StatusBadge(status: registration.status),
                const SizedBox(width: 8),
                if (onConfirmRegistration != null && (registration.status == 'pending' || registration.status == 'waiting_list'))
                  OutlinedButton(onPressed: () => onConfirmRegistration!(registration, true), child: const Text('Confirmer')),
              ],
            ),
          ],
        ),

        const SizedBox(height: 8),

        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            _dateChip(context, 'Inscrit', df.format(registration.registrationDate)),
            if (registration.confirmationDate != null) _dateChip(context, 'Confirmé', df.format(registration.confirmationDate!)),
            if (registration.cancellationDate != null) _dateChip(context, 'Annulé', df.format(registration.cancellationDate!)),
          ],
        ),

        if (registration.cancellationReason != null && registration.cancellationReason!.isNotEmpty) ...[
          const SizedBox(height: 6),
          Text('Raison: ${registration.cancellationReason!}', style: theme.textTheme.bodySmall),
        ],
      ],
    );
  }

  Widget _dateChip(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: theme.colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(8)),
      child: Text('$label: $value', style: theme.textTheme.bodySmall),
    );
  }
}

class _GroupedRegistrationsList extends StatelessWidget {
  const _GroupedRegistrationsList({required this.registrations, this.onConfirmRegistration});

  final List<Registration> registrations;
  final Future<void> Function(Registration registration, bool confirmed)? onConfirmRegistration;

  @override
  Widget build(BuildContext context) {
    // Group registrations by groupId; null groupId = individual
    final Map<int?, List<Registration>> groups = {};
    for (final r in registrations) {
      groups.putIfAbsent(r.groupId, () => []).add(r);
    }

    final entries = groups.entries.toList()..sort((a, b) => (a.key ?? 0).compareTo(b.key ?? 0));

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: entries.length,
      itemBuilder: (context, idx) {
        final groupId = entries[idx].key;
        final regs = entries[idx].value;
        final isGroup = groupId != null && regs.length > 1;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isGroup)
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 4),
                child: Row(
                  children: [
                    const Icon(Icons.groups, size: 18),
                    const SizedBox(width: 6),
                    Text('Groupe #$groupId (${regs.length} personnes)', style: Theme.of(context).textTheme.labelLarge),
                  ],
                ),
              ),
            ...List.generate(regs.length, (i) {
              return Column(
                children: [
                  _RegistrationTile(registration: regs[i], onConfirmRegistration: onConfirmRegistration),
                  if (i != regs.length - 1) const Divider(height: 12),
                ],
              );
            }),
            if (idx != entries.length - 1) const Divider(height: 20),
          ],
        );
      },
    );
  }
}

class _EmailRow extends StatelessWidget {
  const _EmailRow({required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => _openMailto(context, email),
      child: Row(
        children: [
          Icon(Icons.mail, size: 14, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              email,
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.primary, decoration: TextDecoration.underline),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openMailto(BuildContext context, String email) async {
    final uri = Uri(scheme: 'mailto', path: email);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Impossible d'ouvrir le client mail")));
      }
    }
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;
    switch (status) {
      case 'confirmed':
        color = Colors.green;
        label = 'Confirmé';
        break;
      case 'pending':
        color = Colors.orange;
        label = 'En attente';
        break;
      case 'cancelled':
        color = Colors.red;
        label = 'Annulé';
        break;
      case 'waiting_list':
        color = Colors.blueGrey;
        label = 'Liste d\'attente';
        break;
      default:
        color = Colors.grey;
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}
