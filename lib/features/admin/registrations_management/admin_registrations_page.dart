import 'package:flutter/material.dart';

class AdminRegistrationsPage extends StatelessWidget {
  const AdminRegistrationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with search and filters
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Gestion des inscriptions', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text('Suivez et gérez toutes les réservations de balades', style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 24),
                      Row(
                        children: [
                          OutlinedButton.icon(
                            onPressed: () {
                              // TODO: Export functionality
                            },
                            icon: const Icon(Icons.download),
                            label: const Text('Exporter'),
                          ),
                          const SizedBox(width: 12),
                          FilledButton.icon(
                            onPressed: () {
                              // TODO: Bulk actions
                            },
                            icon: const Icon(Icons.playlist_add_check),
                            label: const Text('Actions groupées'),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Search and filters row
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Rechercher par nom, email ou téléphone...',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'Balade',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          items: const [
                            DropdownMenuItem(value: null, child: Text('Toutes les balades')),
                            DropdownMenuItem(value: 'mushrooms', child: Text('Champignons d\'automne')),
                            DropdownMenuItem(value: 'birds', child: Text('Oiseaux migrateurs')),
                            DropdownMenuItem(value: 'plants', child: Text('Plantes medicinales')),
                          ],
                          onChanged: (value) {
                            // TODO: Filter by ramble
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'Statut',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          items: const [
                            DropdownMenuItem(value: null, child: Text('Tous les statuts')),
                            DropdownMenuItem(value: 'confirmed', child: Text('✅ Confirmé')),
                            DropdownMenuItem(value: 'pending', child: Text('⏳ En attente')),
                            DropdownMenuItem(value: 'waitlist', child: Text('📋 Liste d\'attente')),
                            DropdownMenuItem(value: 'cancelled', child: Text('❌ Annulé')),
                          ],
                          onChanged: (value) {
                            // TODO: Filter by status
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Stats cards
          Row(
            children: [
              Expanded(child: _buildStatCard(context, 'Total inscriptions', '156', Icons.how_to_reg, theme.colorScheme.primary)),
              const SizedBox(width: 16),
              Expanded(child: _buildStatCard(context, 'Confirmées', '134', Icons.check_circle, Colors.green)),
              const SizedBox(width: 16),
              Expanded(child: _buildStatCard(context, 'En attente', '15', Icons.schedule, Colors.orange)),
              const SizedBox(width: 16),
              Expanded(child: _buildStatCard(context, 'Liste d\'attente', '7', Icons.queue, Colors.blue)),
            ],
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
                    Icon(Icons.assignment_outlined, size: 64, color: theme.colorScheme.onSurfaceVariant),
                    const SizedBox(height: 24),
                    Text(
                      'Interface de gestion en cours de développement',
                      style: theme.textTheme.headlineSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Cette page permettra de :\n\n'
                      '• Voir toutes les inscriptions en temps réel\n'
                      '• Filtrer par balade, statut, date\n'
                      '• Confirmer ou annuler des réservations\n'
                      '• Gérer les listes d\'attente\n'
                      '• Envoyer des notifications groupées\n'
                      '• Exporter les listes de participants',
                      style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    OutlinedButton.icon(
                      onPressed: () {
                        // TODO: Show registrations mockup or prototype
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

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon, Color color) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, size: 24, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: color),
                  ),
                  Text(title, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
