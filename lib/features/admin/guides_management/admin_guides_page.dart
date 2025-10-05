import 'package:flutter/material.dart';

class AdminGuidesPage extends StatelessWidget {
  const AdminGuidesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with actions
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Gestion des guides', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(
                          'Gérez les profils et les compétences de vos guides naturalistes',
                          style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
                  FilledButton.icon(
                    onPressed: () {
                      // TODO: Navigate to add guide page
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Nouveau guide'),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Placeholder content
          Expanded(
            child: Card(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(48),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.people_alt_outlined, size: 64, color: theme.colorScheme.onSurfaceVariant),
                    const SizedBox(height: 24),
                    Text(
                      'Gestion des guides en cours de développement',
                      style: theme.textTheme.headlineSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Cette page permettra de :\n\n'
                      '• Ajouter et modifier les profils des guides\n'
                      '• Gérer leurs spécialités (oiseaux, champignons, plantes...)\n'
                      '• Voir leurs statistiques de balades\n'
                      '• Planifier leurs disponibilités\n'
                      '• Exporter les listes de contacts',
                      style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    OutlinedButton.icon(
                      onPressed: () {
                        // TODO: Show guides mockup or prototype
                      },
                      icon: const Icon(Icons.preview),
                      label: const Text('Voir le prototype'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
