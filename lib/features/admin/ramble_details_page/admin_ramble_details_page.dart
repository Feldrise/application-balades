import 'package:balade/features/authentication/authentication_provider.dart';
import 'package:balade/features/ramble/models/ramble/ramble.dart';
import 'package:balade/features/ramble/public_ramble_details_page/widgets/ramble_details_header.dart';
import 'package:balade/features/ramble/public_ramble_details_page/widgets/ramble_details_info.dart';
import 'package:balade/features/ramble/rambles_service.dart';
import 'package:balade/features/registrations/models/registration/registration.dart';
import 'package:balade/features/registrations/registrations_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'widgets/admin_participants_list.dart';
import 'widgets/additional_documents_card.dart';

class AdminRambleDetailsPage extends ConsumerStatefulWidget {
  const AdminRambleDetailsPage({super.key, required this.rambleId});

  final int rambleId;

  @override
  ConsumerState<AdminRambleDetailsPage> createState() => _AdminRambleDetailsPageState();
}

class _AdminRambleDetailsPageState extends ConsumerState<AdminRambleDetailsPage> {
  late Future<(Ramble, List<Registration>)> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<(Ramble, List<Registration>)> _load() async {
    final auth = ref.read(authenticationProvider);
    final token = auth?.token;

    try {
      final rambleFuture = RamblesService.instance.fetchRamble(widget.rambleId, authorization: token);
      final registrationsFuture = token == null
          ? Future.value(<Registration>[]) // no token: avoid 401 spam; page will show warning
          : RegistrationsService.instance.fetchRambleRegistrations(widget.rambleId, authorization: token);
      final result = await Future.wait([rambleFuture, registrationsFuture]);
      return (result[0] as Ramble, result[1] as List<Registration>);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authed = ref.watch(authenticationProvider);
    final hasToken = (authed?.token ?? '').isNotEmpty;
    return FutureBuilder<(Ramble, List<Registration>)>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (snapshot.hasError) {
          final message = snapshot.error.toString();
          return Scaffold(
            appBar: AppBar(title: const Text('Balade - Détails')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64),
                  const SizedBox(height: 16),
                  Text('Erreur lors du chargement\n$message', textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  FilledButton(onPressed: () => setState(() => _future = _load()), child: const Text('Réessayer')),
                ],
              ),
            ),
          );
        }

        if (!snapshot.hasData) {
          return const Scaffold(body: Center(child: Text('Aucune donnée')));
        }

        final ramble = snapshot.data!.$1;
        final registrations = snapshot.data!.$2;

        final screenWidth = MediaQuery.of(context).size.width;
        final isDesktop = screenWidth >= 1200;
        final isTablet = screenWidth >= 768 && screenWidth < 1200;

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              RambleDetailsHeader(ramble: ramble, onBack: () => Navigator.of(context).pop()),
              SliverToBoxAdapter(child: _buildResponsiveContent(context, ramble, registrations, isDesktop, isTablet, hasToken)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildResponsiveContent(BuildContext context, Ramble ramble, List<Registration> registrations, bool isDesktop, bool isTablet, bool hasToken) {
    if (isDesktop) return _buildDesktopLayout(context, ramble, registrations, hasToken);
    if (isTablet) return _buildTabletLayout(context, ramble, registrations, hasToken);
    return _buildMobileLayout(context, ramble, registrations, hasToken);
  }

  Widget _buildDesktopLayout(BuildContext context, Ramble ramble, List<Registration> registrations, bool hasToken) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 60,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RambleDetailsInfo(ramble: ramble),
                const SizedBox(height: 16),
                AdditionalDocumentsCard(url: ramble.additionalDocumentsUrl),
              ],
            ),
          ),
          const SizedBox(width: 32),
          Expanded(
            flex: 40,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!hasToken)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Icon(Icons.lock_outline, color: Theme.of(context).colorScheme.onSurfaceVariant),
                          const SizedBox(width: 8),
                          Expanded(child: Text('Connectez-vous en tant qu\'administrateur pour voir les inscriptions.', style: Theme.of(context).textTheme.bodyMedium)),
                        ],
                      ),
                    ),
                  ),
                AdminParticipantsList(
                  registrations: registrations,
                  maxParticipants: ramble.maxParticipants,
                  onConfirmRegistration: (registration, confirmed) => _handleConfirm(registration, confirmed),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context, Ramble ramble, List<Registration> registrations, bool hasToken) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RambleDetailsInfo(ramble: ramble),
          const SizedBox(height: 16),
          AdditionalDocumentsCard(url: ramble.additionalDocumentsUrl),
          const SizedBox(height: 16),
          if (!hasToken)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(Icons.lock_outline, color: Theme.of(context).colorScheme.onSurfaceVariant),
                    const SizedBox(width: 8),
                    Expanded(child: Text('Connectez-vous en tant qu\'administrateur pour voir les inscriptions.', style: Theme.of(context).textTheme.bodyMedium)),
                  ],
                ),
              ),
            ),
          AdminParticipantsList(
            registrations: registrations,
            maxParticipants: ramble.maxParticipants,
            onConfirmRegistration: (registration, confirmed) => _handleConfirm(registration, confirmed),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, Ramble ramble, List<Registration> registrations, bool hasToken) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RambleDetailsInfo(ramble: ramble),
          const SizedBox(height: 16),
          AdditionalDocumentsCard(url: ramble.additionalDocumentsUrl),
          const SizedBox(height: 16),
          if (!hasToken)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(Icons.lock_outline, color: Theme.of(context).colorScheme.onSurfaceVariant),
                    const SizedBox(width: 8),
                    Expanded(child: Text('Connectez-vous en tant qu\'administrateur pour voir les inscriptions.', style: Theme.of(context).textTheme.bodyMedium)),
                  ],
                ),
              ),
            ),
          AdminParticipantsList(
            registrations: registrations,
            maxParticipants: ramble.maxParticipants,
            onConfirmRegistration: (registration, confirmed) => _handleConfirm(registration, confirmed),
          ),
        ],
      ),
    );
  }

  Future<void> _handleConfirm(Registration registration, bool confirmed) async {
    final auth = ref.read(authenticationProvider);
    final token = auth?.token;
    if (token == null || token.isEmpty) return;
    try {
      await RegistrationsService.instance.confirmRegistration(registration.id, confirmed, authorization: 'Bearer $token');
      if (mounted) {
        setState(() {
          _future = _load();
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Échec de la confirmation: $e')));
      }
    }
  }
}
