import 'package:balade/features/authentication/authentication_provider.dart';
import 'package:balade/features/registrations/models/registration/registration.dart';
import 'package:balade/features/registrations/providers/registration_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

class UserRegistrationsPage extends ConsumerWidget {
  const UserRegistrationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final authed = ref.watch(authenticationProvider);

    if (authed == null) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.lock_outline, color: theme.colorScheme.primary, size: 40),
                  const SizedBox(height: 12),
                  Text('Connectez-vous pour voir vos inscriptions', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 12),
                  FilledButton.icon(onPressed: () => context.go('/connexion'), icon: const Icon(Icons.login), label: const Text('Se connecter')),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final registrationsAsync = ref.watch(userRegistrationsProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: const Text('Mes inscriptions')),
      body: registrationsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) {
          final isAuth = e.toString().contains('NOT_AUTHENTICATED');
          if (isAuth) {
            return const Center(child: Text('Veuillez vous reconnecter.'));
          }
          return Center(child: Text('Erreur: $e'));
        },
        data: (registrations) {
          if (registrations.isEmpty) {
            return _EmptyState();
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: registrations.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) => _RegistrationTile(registration: registrations[index]),
          );
        },
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.event_busy, size: 48, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(height: 12),
            Text('Aucune inscription pour le moment', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text('Explorez les balades et inscrivez-vous à celles qui vous intéressent.'),
          ],
        ),
      ),
    );
  }
}

class _RegistrationTile extends StatelessWidget {
  const _RegistrationTile({required this.registration});

  final Registration registration;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _statusColor(registration.status, theme);
    final title = registration.ramble?.title ?? 'Balade #${registration.rambleId}';
    final subtitle = _subtitle(registration);

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.15),
          child: Icon(_statusIcon(registration.status), color: color),
        ),
        title: Text(title, style: theme.textTheme.titleMedium),
        subtitle: Text(subtitle),
        trailing: Chip(
          label: Text(_statusLabel(registration.status)),
          backgroundColor: color.withOpacity(0.1),
          side: BorderSide(color: color.withOpacity(0.3)),
        ),
      ),
    );
  }

  String _subtitle(Registration r) {
    final parts = <String>[];
    if (r.ramble?.date != null) {
      parts.add(DateFormat('EEEE dd MMM, HH:mm', 'fr').format(r.ramble!.date!.toLocal()));
    }
    if (r.ramble?.location != null) {
      parts.add(r.ramble!.location!);
    }
    return parts.isEmpty ? DateFormat('dd/MM/yyyy HH:mm').format(r.registrationDate.toLocal()) : parts.join(' • ');
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'pending':
        return 'En attente';
      case 'confirmed':
        return 'Confirmé';
      case 'waiting_list':
        return 'Liste d\'attente';
      case 'cancelled':
        return 'Annulé';
      default:
        return status;
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case 'pending':
        return Icons.schedule;
      case 'confirmed':
        return Icons.check_circle;
      case 'waiting_list':
        return Icons.hourglass_top;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.info_outline;
    }
  }

  Color _statusColor(String status, ThemeData theme) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.green;
      case 'waiting_list':
        return Colors.blue;
      case 'cancelled':
        return theme.colorScheme.error;
      default:
        return theme.colorScheme.onSurfaceVariant;
    }
  }
}
