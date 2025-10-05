import 'package:balade/features/authentication/authentication_provider.dart';
import 'package:balade/features/registrations/providers/registration_providers.dart';
import 'package:balade/features/registrations/widgets/registration_card.dart';
import 'package:balade/features/registrations/widgets/registrations_empty_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Mes inscriptions'),
        actions: [IconButton(onPressed: () => ref.invalidate(userRegistrationsProvider), icon: const Icon(Icons.refresh), tooltip: 'Actualiser')],
      ),
      body: _RegistrationsContent(),
    );
  }
}

class _RegistrationsContent extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registrationsAsync = ref.watch(userRegistrationsProvider);
    final actionsState = ref.watch(registrationActionsProvider);

    // Listen to action results and show snackbars
    ref.listen<RegistrationActionsState>(registrationActionsProvider, (previous, current) {
      if (current.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(current.error!), backgroundColor: Colors.red));
        ref.read(registrationActionsProvider.notifier).clearMessages();
      } else if (current.successMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(current.successMessage!), backgroundColor: Colors.green));
        ref.read(registrationActionsProvider.notifier).clearMessages();
        // Refresh the registrations list
        ref.invalidate(userRegistrationsProvider);
      }
    });

    return registrationsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) {
        final isAuth = e.toString().contains('NOT_AUTHENTICATED');
        if (isAuth) {
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
              FilledButton.icon(onPressed: () => ref.invalidate(userRegistrationsProvider), icon: const Icon(Icons.refresh), label: const Text('Réessayer')),
            ],
          ),
        );
      },
      data: (registrations) {
        if (registrations.isEmpty) {
          return const RegistrationsEmptyState();
        }

        return Stack(
          children: [
            ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: registrations.length,
              separatorBuilder: (_, __) => const SizedBox(height: 0),
              itemBuilder: (context, index) {
                final registration = registrations[index];
                return RegistrationCard(
                  registration: registration,
                  onConfirm: () => _handleConfirm(ref, registration.id),
                  onCancel: (reason) => _handleCancel(ref, registration.id, reason),
                );
              },
            ),
            if (actionsState.isLoading)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        );
      },
    );
  }

  void _handleConfirm(WidgetRef ref, int registrationId) {
    ref.read(registrationActionsProvider.notifier).confirmRegistration(registrationId);
  }

  void _handleCancel(WidgetRef ref, int registrationId, String? reason) {
    ref.read(registrationActionsProvider.notifier).cancelRegistration(registrationId, reason: reason);
  }
}
