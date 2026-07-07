import 'package:balade/core/constants.dart';
import 'package:balade/core/phone_utils.dart';
import 'package:balade/features/guides/models/guide/guide.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class GuideBigCard extends StatelessWidget {
  const GuideBigCard({super.key, required this.guide});

  final Guide guide;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final displayPhone = formatStoredPhone(guide.phone);
    final telUri = phoneToTelUri(guide.phone);
    final canContact = telUri != null || guide.email.isNotEmpty;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Avatar
                CircleAvatar(
                  radius: 32,
                  backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
                  backgroundImage: guide.avatar != null && guide.avatar!.isNotEmpty ? NetworkImage("$kBaseUrl/uploads/guide/${guide.id}/${guide.avatar!}") : null,
                  child: guide.avatar == null || guide.avatar!.isEmpty ? Icon(Icons.person, color: colorScheme.primary, size: 32) : null,
                ),

                const SizedBox(width: 16),

                // Guide name and certification
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${guide.firstName} ${guide.lastName}', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),

                      const SizedBox(height: 4),

                      if (guide.certificationLevel != null) ...[
                        Row(
                          children: [
                            Icon(kCertificationLevelIcons[guide.certificationLevel!] ?? Icons.verified, size: 20, color: colorScheme.primary),
                            const SizedBox(width: 6),
                            Text(
                              kCertificationLevelLabels[guide.certificationLevel!] ?? guide.certificationLevel!,
                              style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.primary, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ],
                      if (displayPhone != null && telUri != null) ...[
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: () => _launchTel(telUri),
                          child: Row(
                            children: [
                              Icon(Icons.phone, size: 18, color: colorScheme.primary),
                              const SizedBox(width: 6),
                              Text(displayPhone, style: theme.textTheme.bodyMedium),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Contact button
                if (canContact)
                  FilledButton.icon(
                    onPressed: () => _contactGuide(context),
                    icon: const Icon(Icons.message, size: 18),
                    label: const Text('Contact'),
                    style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
                  ),
              ],
            ),

            // Specialties
            if (guide.specialties != null && guide.specialties!.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildInfoSection(context, 'Spécialités', Icons.star, guide.specialties!),
            ],

            // Experience
            if (guide.experience != null && guide.experience!.isNotEmpty) ...[const SizedBox(height: 12), _buildInfoSection(context, 'Expérience', Icons.work, guide.experience!)],

            // Languages
            if (guide.languages != null && guide.languages!.isNotEmpty) ...[const SizedBox(height: 12), _buildInfoSection(context, 'Langues', Icons.language, guide.languages!)],

            // Bio
            if (guide.bio != null && guide.bio!.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text('À propos', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Text(guide.bio!, style: theme.textTheme.bodyMedium?.copyWith(height: 1.5)),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _contactGuide(BuildContext context) async {
    final telUri = phoneToTelUri(guide.phone);
    if (telUri != null) {
      await _launchTel(telUri);
      return;
    }

    if (guide.email.isNotEmpty) {
      final uri = Uri(scheme: 'mailto', path: guide.email);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
        return;
      }
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Aucun moyen de contact disponible pour ce guide.')));
    }
  }

  Future<void> _launchTel(String telUri) async {
    final uri = Uri.parse('tel:$telUri');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Widget _buildInfoSection(BuildContext context, String title, IconData icon, String content) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: colorScheme.onSurfaceVariant),
            const SizedBox(width: 6),
            Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, color: colorScheme.onSurfaceVariant),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(left: 22),
          child: Text(content, style: theme.textTheme.bodyMedium),
        ),
      ],
    );
  }
}
