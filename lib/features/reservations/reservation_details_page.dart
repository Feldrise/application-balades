import 'package:balade/features/authentication/authentication_provider.dart';
import 'package:balade/features/reservations/providers/reservation_providers.dart';
import 'package:balade/features/reservations/widgets/reservation_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// One reservation of the booker: the target of the link of the confirmation request, after login.
class ReservationDetailsPage extends ConsumerWidget {
  const ReservationDetailsPage({super.key, required this.reservationId});

  final int reservationId;

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
                  Text('Connectez-vous pour voir votre réservation', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: () => context.go(Uri(path: '/connexion', queryParameters: {'redirection': '/mes-reservations/$reservationId'}).toString()),
                    icon: const Icon(Icons.login),
                    label: const Text('Se connecter'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final reservationAsync = ref.watch(reservationProvider(reservationId));

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Ma réservation'),
        leading: IconButton(onPressed: () => context.go('/mes-reservations'), icon: const Icon(Icons.arrow_back), tooltip: 'Mes réservations'),
        actions: [IconButton(onPressed: () => ref.invalidate(reservationProvider(reservationId)), icon: const Icon(Icons.refresh), tooltip: 'Actualiser')],
      ),
      body: reservationAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.red.shade300),
              const SizedBox(height: 16),
              Text('Impossible de charger cette réservation', style: theme.textTheme.titleMedium),
              const SizedBox(height: 16),
              FilledButton.icon(onPressed: () => ref.invalidate(reservationProvider(reservationId)), icon: const Icon(Icons.refresh), label: const Text('Réessayer')),
            ],
          ),
        ),
        data: (reservation) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: ReservationCard(reservation: reservation),
            ),
          ),
        ),
      ),
    );
  }
}
