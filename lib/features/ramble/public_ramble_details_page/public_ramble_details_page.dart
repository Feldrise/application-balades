import 'package:balade/features/ramble/models/ramble/ramble.dart';
import 'package:balade/features/ramble/public_ramble_details_page/widgets/ramble_details_header.dart';
import 'package:balade/features/ramble/public_ramble_details_page/widgets/ramble_details_info.dart';
import 'package:balade/features/ramble/public_ramble_details_page/widgets/ramble_guides_section.dart';
import 'package:balade/features/ramble/public_ramble_details_page/widgets/ramble_registration_section.dart';
import 'package:balade/features/ramble/rambles_service.dart';
import 'package:flutter/material.dart';

class PublicRambleDetailsPage extends StatefulWidget {
  const PublicRambleDetailsPage({super.key, required this.rambleId});

  final int rambleId;

  @override
  State<PublicRambleDetailsPage> createState() => _PublicRambleDetailsPageState();
}

class _PublicRambleDetailsPageState extends State<PublicRambleDetailsPage> {
  bool isRegistered = false;
  bool isLoading = false;
  bool isFavorite = false;

  void _handleShare() {
    // TODO: Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Fonctionnalité de partage à implémenter')));
  }

  void _handleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(isFavorite ? 'Ajouté aux favoris' : 'Retiré des favoris')));
  }

  void _handleContactGuide(int guideId) {
    // TODO: Implement contact guide functionality
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Contacter le guide $guideId (à implémenter)')));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Ramble>(
      future: RamblesService.instance.fetchRamble(widget.rambleId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text('Erreur')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64),
                  const SizedBox(height: 16),
                  Text('Erreur: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(onPressed: () => setState(() {}), child: const Text('Réessayer')),
                ],
              ),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Balade introuvable')),
            body: const Center(child: Text('Aucun détail trouvé pour cette balade.')),
          );
        }

        final ramble = snapshot.data!;
        final screenWidth = MediaQuery.of(context).size.width;
        final isDesktop = screenWidth >= 1200;
        final isTablet = screenWidth >= 768 && screenWidth < 1200;

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              // Header with cover image
              RambleDetailsHeader(ramble: ramble, onBack: () => Navigator.of(context).pop(), onShare: _handleShare, onFavorite: _handleFavorite, isFavorite: isFavorite),

              // Content with responsive layout
              SliverToBoxAdapter(child: _buildResponsiveContent(ramble, isDesktop, isTablet)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildResponsiveContent(Ramble ramble, bool isDesktop, bool isTablet) {
    if (isDesktop) {
      return _buildDesktopLayout(ramble);
    } else if (isTablet) {
      return _buildTabletLayout(ramble);
    } else {
      return _buildMobileLayout(ramble);
    }
  }

  Widget _buildDesktopLayout(Ramble ramble) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main content (left column)
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [RambleDetailsInfo(ramble: ramble)],
            ),
          ),

          const SizedBox(width: 32),

          // Sidebar (right column)
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Registration section
                RambleRegistrationSection(
                  ramble: ramble,
                  onShare: _handleShare,
                  isRegistered: isRegistered,
                  isLoading: isLoading,
                  isCompact: false, // Full desktop version
                ),

                const SizedBox(height: 24),

                // Guides section
                RambleGuidesSection(ramble: ramble, onContactGuide: _handleContactGuide),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(Ramble ramble) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main information
          RambleDetailsInfo(ramble: ramble),

          const SizedBox(height: 24),

          // Registration section
          RambleRegistrationSection(ramble: ramble, onShare: _handleShare, isRegistered: isRegistered, isLoading: isLoading, isCompact: false),

          const SizedBox(height: 24),

          // Guides section
          RambleGuidesSection(ramble: ramble, onContactGuide: _handleContactGuide),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(Ramble ramble) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),

        // Main information
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: RambleDetailsInfo(ramble: ramble),
        ),

        const SizedBox(height: 24),

        // Guides section
        RambleGuidesSection(ramble: ramble, onContactGuide: _handleContactGuide),

        const SizedBox(height: 24),

        // Registration section (bottom on mobile)
        Padding(
          padding: const EdgeInsets.all(16),
          child: RambleRegistrationSection(
            ramble: ramble,
            onShare: _handleShare,
            isRegistered: isRegistered,
            isLoading: isLoading,
            isCompact: true, // Compact mobile version
          ),
        ),

        const SizedBox(height: 24),
      ],
    );
  }
}
