import 'package:balade/features/ramble/models/ramble/ramble.dart';
import 'package:balade/features/registrations/models/registration/registration.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RegistrationSuccessDialog extends StatelessWidget {
  const RegistrationSuccessDialog({super.key, required this.registration, required this.ramble});

  final Registration registration;
  final Ramble ramble;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Success icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(color: Colors.green.withValues(alpha: 0.1), shape: BoxShape.circle),
              child: const Icon(Icons.check_circle, color: Colors.green, size: 40),
            ),

            const SizedBox(height: 24),

            // Title
            Text(
              'Inscription confirmée !',
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.green),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            // Status message
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _getStatusColor(registration.status).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _getStatusColor(registration.status).withValues(alpha: 0.3)),
              ),
              child: Column(
                children: [
                  Icon(_getStatusIcon(registration.status), color: _getStatusColor(registration.status), size: 24),
                  const SizedBox(height: 8),
                  Text(
                    _getStatusTitle(registration.status),
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: _getStatusColor(registration.status)),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(_getStatusDescription(registration.status), style: theme.textTheme.bodyMedium, textAlign: TextAlign.center),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Ramble details
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Détails de la balade', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  _buildDetailRow(Icons.title, 'Titre', ramble.title, theme),
                  if (ramble.date != null) ...[
                    const SizedBox(height: 8),
                    _buildDetailRow(Icons.event, 'Date', DateFormat('EEEE dd MMMM yyyy à HH:mm', 'fr').format(ramble.date!), theme),
                  ],
                  if (ramble.location != null) ...[const SizedBox(height: 8), _buildDetailRow(Icons.location_on, 'Lieu', ramble.location!, theme)],
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Email notification info
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colorScheme.primary.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  Icon(Icons.email_outlined, color: colorScheme.primary, size: 20),
                  const SizedBox(width: 12),
                  Expanded(child: Text('Un email de confirmation a été envoyé à ${registration.email}', style: theme.textTheme.bodyMedium)),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Fermer')),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      // TODO: Navigate to user registrations page
                    },
                    icon: const Icon(Icons.list_alt),
                    label: const Text('Mes inscriptions'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value, ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$label: ',
                  style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, color: theme.colorScheme.onSurfaceVariant),
                ),
                TextSpan(text: value, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
        ),
      ],
    );
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'pending':
        return Icons.schedule;
      case 'waiting_list':
        return Icons.queue;
      case 'confirmed':
        return Icons.check_circle;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }

  String _getStatusTitle(String status) {
    switch (status) {
      case 'pending':
        return 'Inscription confirmée';
      case 'waiting_list':
        return 'Liste d\'attente';
      case 'confirmed':
        return 'Participation confirmée';
      case 'cancelled':
        return 'Inscription annulée';
      default:
        return 'Statut inconnu';
    }
  }

  String _getStatusDescription(String status) {
    switch (status) {
      case 'pending':
        return 'Vous recevrez un email de confirmation finale 3 jours avant la balade.';
      case 'waiting_list':
        return 'La balade est complète. Vous serez notifié si une place se libère.';
      case 'confirmed':
        return 'Votre participation est confirmée. Rendez-vous le jour J !';
      case 'cancelled':
        return 'Votre inscription a été annulée.';
      default:
        return 'Contactez l\'organisateur pour plus d\'informations.';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'waiting_list':
        return Colors.blue;
      case 'confirmed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
