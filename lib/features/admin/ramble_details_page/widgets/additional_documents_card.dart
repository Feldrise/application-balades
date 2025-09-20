import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AdditionalDocumentsCard extends StatelessWidget {
  const AdditionalDocumentsCard({super.key, required this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    if (url == null || url!.isEmpty) return const SizedBox.shrink();
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.description_outlined, color: theme.colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Text('Documents complémentaires', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            ),
            const SizedBox(width: 12),
            OutlinedButton.icon(onPressed: () => _openUrl(context, url!), icon: const Icon(Icons.download), label: const Text('Télécharger')),
          ],
        ),
      ),
    );
  }

  Future<void> _openUrl(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Impossible d\'ouvrir le document')));
      }
    }
  }
}
