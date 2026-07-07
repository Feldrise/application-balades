import 'package:balade/core/widgets/loading_overlay.dart';
import 'package:balade/features/admin/layout/admin_access_denied_page.dart';
import 'package:balade/features/authentication/authentication_provider.dart';
import 'package:balade/features/authentication/permission_provider.dart';
import 'package:balade/features/guides/dialogs/add_guide_dialog.dart';
import 'package:balade/features/guides/dialogs/edit_guide_dialog.dart';
import 'package:balade/features/guides/guides_service.dart';
import 'package:balade/features/guides/models/guide/guide.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminGuidesPage extends ConsumerStatefulWidget {
  const AdminGuidesPage({super.key});

  @override
  ConsumerState<AdminGuidesPage> createState() => _AdminGuidesPageState();
}

class _AdminGuidesPageState extends ConsumerState<AdminGuidesPage> {
  final _searchController = TextEditingController();
  List<Guide> _guides = [];
  bool _isLoading = true;
  String? _error;
  bool? _activeFilter;

  @override
  void initState() {
    super.initState();
    _loadGuides();
    _searchController.addListener(_loadGuides);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadGuides() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final token = ref.read(authenticationProvider)?.token;
      final guides = await GuidesService.instance.fetchGuides(_searchController.text, isActive: _activeFilter, authorization: token);
      if (mounted) {
        setState(() {
          _guides = guides;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _addGuide() async {
    await showDialog(context: context, builder: (context) => const LoadingOverlay(child: AddGuideDialog()));
    _loadGuides();
  }

  Future<void> _editGuide(int guideId) async {
    await showDialog(context: context, builder: (context) => LoadingOverlay(child: EditGuideDialog(guideId: guideId)));
    _loadGuides();
  }

  @override
  Widget build(BuildContext context) {
    final permission = ref.watch(permissionProvider);
    if (permission?.isAdmin() != true && permission?.canCreateUser() != true) {
      return const AdminAccessDeniedPage();
    }

    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                        Text('Gérez les profils et les compétences de vos guides naturalistes', style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 280,
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(prefixIcon: Icon(Icons.search), labelText: 'Rechercher', border: OutlineInputBorder()),
                    ),
                  ),
                  const SizedBox(width: 12),
                  DropdownButton<bool?>(
                    value: _activeFilter,
                    items: const [
                      DropdownMenuItem(value: null, child: Text('Tous')),
                      DropdownMenuItem(value: true, child: Text('Actifs')),
                      DropdownMenuItem(value: false, child: Text('Inactifs')),
                    ],
                    onChanged: (value) {
                      setState(() => _activeFilter = value);
                      _loadGuides();
                    },
                  ),
                  const SizedBox(width: 12),
                  IconButton.outlined(onPressed: _loadGuides, icon: const Icon(Icons.refresh)),
                  const SizedBox(width: 12),
                  FilledButton.icon(onPressed: _addGuide, icon: const Icon(Icons.add), label: const Text('Nouveau guide')),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                ? Center(child: Text('Erreur : $_error'))
                : _guides.isEmpty
                ? const Center(child: Text('Aucun guide trouvé'))
                : Card(
                    child: ListView.separated(
                      padding: const EdgeInsets.all(8),
                      itemCount: _guides.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final guide = _guides[index];
                        return ListTile(
                          leading: CircleAvatar(child: Text(guide.firstName.isNotEmpty ? guide.firstName[0].toUpperCase() : '?')),
                          title: Text('${guide.firstName} ${guide.lastName}'),
                          subtitle: Text('${guide.email}${guide.specialties != null ? ' · ${guide.specialties}' : ''}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Chip(
                                label: Text(guide.isActive ? 'Actif' : 'Inactif'),
                                backgroundColor: guide.isActive ? theme.colorScheme.primaryContainer : theme.colorScheme.errorContainer,
                              ),
                              IconButton(icon: const Icon(Icons.edit_outlined), tooltip: 'Modifier', onPressed: () => _editGuide(guide.id)),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
