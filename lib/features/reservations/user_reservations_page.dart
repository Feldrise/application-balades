import 'package:balade/features/authentication/authentication_provider.dart';
import 'package:balade/features/reservations/providers/reservation_providers.dart';
import 'package:balade/features/reservations/widgets/reservation_card.dart';
import 'package:balade/features/reservations/widgets/reservations_empty_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class UserReservationsPage extends ConsumerWidget {
  const UserReservationsPage({super.key});

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
                  Text('Connectez-vous pour voir vos réservations', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 12),
                  FilledButton.icon(onPressed: () => context.go('/connexion'), icon: const Icon(Icons.login), label: const Text('Se connecter')),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Mes réservations'),
        actions: [IconButton(onPressed: () => ref.invalidate(userReservationsProvider), icon: const Icon(Icons.refresh), tooltip: 'Actualiser')],
      ),
      body: const _ReservationsContent(),
    );
  }
}

class _ReservationsContent extends ConsumerWidget {
  const _ReservationsContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reservationsAsync = ref.watch(userReservationsProvider);

    return reservationsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) {
        if (e.toString().contains('NOT_AUTHENTICATED')) {
          return const Center(child: Text('Veuillez vous reconnecter.'));
        }
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.red.shade300),
              const SizedBox(height: 16),
              Text('Erreur lors du chargement', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text('$e'),
              const SizedBox(height: 16),
              FilledButton.icon(onPressed: () => ref.invalidate(userReservationsProvider), icon: const Icon(Icons.refresh), label: const Text('Réessayer')),
            ],
          ),
        );
      },
      data: (reservations) {
        if (reservations.isEmpty) return const ReservationsEmptyState();

        return ListView.builder(padding: const EdgeInsets.all(16), itemCount: reservations.length, itemBuilder: (context, index) => ReservationCard(reservation: reservations[index]));
      },
    );
  }
}
