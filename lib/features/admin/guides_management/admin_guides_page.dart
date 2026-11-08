import 'package:balade/core/constants.dart';
import 'package:balade/core/widgets/loading_overlay.dart';
import 'package:balade/features/admin/design/design.dart';
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
  List<Guide> _guides = [];
  bool _isLoading = true;
  String? _error;
  String _search = '';
  bool? _activeFilter;

  @override
  void initState() {
    super.initState();
    _loadGuides();
  }

  Future<void> _loadGuides() async {
    setState(() {
      _isLoading = _guides.isEmpty;
      _error = null;
    });

    try {
      final token = ref.read(authenticationProvider)?.token;
      final guides = await GuidesService.instance.fetchGuides(_search, isActive: _activeFilter, authorization: token);
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

    final gutter = ManagementBreakpoints.gutter(context);

    return Column(
      children: [
        ManagementPageHeader(
          title: 'Guides',
          subtitle: _isLoading || _error != null ? null : '${_guides.length} ${_guides.length > 1 ? 'guides' : 'guide'}',
          actions: [ManagementHeaderButton(label: 'Nouveau guide', icon: Icons.add, onPressed: _addGuide)],
          bottom: ManagementHeaderSearchField(
            hint: 'Rechercher un guide',
            onChanged: (value) {
              _search = value;
              _loadGuides();
            },
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _loadGuides,
            child: ListView(
              padding: EdgeInsets.fromLTRB(gutter, 12, gutter, 32),
              children: [
                Wrap(
                  spacing: 8,
                  children: [
                    for (final (label, value) in [('Tous', null), ('Actifs', true), ('Inactifs', false)])
                      ChoiceChip(
                        label: Text(label),
                        selected: _activeFilter == value,
                        onSelected: (_) {
                          setState(() => _activeFilter = value);
                          _loadGuides();
                        },
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                if (_isLoading)
                  const Padding(padding: EdgeInsets.all(48), child: Center(child: CircularProgressIndicator()))
                else if (_error != null)
                  ManagementPanel(
                    children: [
                      ManagementEmptyState(
                        icon: Icons.cloud_off,
                        title: 'Impossible de charger les guides',
                        message: 'Vérifiez votre connexion puis réessayez.',
                        action: FilledButton(onPressed: _loadGuides, child: const Text('Réessayer')),
                      ),
                    ],
                  )
                else if (_guides.isEmpty)
                  const ManagementPanel(children: [ManagementEmptyState(icon: Icons.groups_outlined, title: 'Aucun guide trouvé', message: 'Aucun guide ne correspond à cette recherche.')])
                else
                  ManagementPanel(children: [for (final guide in _guides) _GuideRow(guide: guide, onTap: () => _editGuide(guide.id))]),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// What a guide without a first or last name is called in the list.
const unnamedGuideLabel = 'Guide sans nom';

String guideDisplayName(Guide guide) {
  final name = '${guide.firstName} ${guide.lastName}'.trim();
  return name.isEmpty ? unnamedGuideLabel : name;
}

class _GuideRow extends StatelessWidget {
  const _GuideRow({required this.guide, required this.onTap});

  final Guide guide;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final name = guideDisplayName(guide);
    final hasAvatar = guide.avatar != null && guide.avatar!.isNotEmpty;
    final specialties = guide.specialties?.trim() ?? '';

    return ManagementRow(
      onTap: onTap,
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: ManagementColors.mint,
            foregroundColor: ManagementColors.green,
            backgroundImage: hasAvatar ? NetworkImage('$kBaseUrl/uploads/guide/${guide.id}/${guide.avatar!}') : null,
            child: hasAvatar ? null : (guide.firstName.isEmpty ? const Icon(Icons.person_outline, size: 20) : Text(guide.firstName[0].toUpperCase(), style: theme.textTheme.titleSmall?.copyWith(color: ManagementColors.green))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800, color: guide.firstName.isEmpty && guide.lastName.isEmpty ? ManagementColors.muted : null),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(guide.email, style: theme.textTheme.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                if (specialties.isNotEmpty) Text(specialties, style: theme.textTheme.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _ActiveBadge(isActive: guide.isActive),
          const Icon(Icons.chevron_right, color: ManagementColors.muted),
        ],
      ),
    );
  }
}

class _ActiveBadge extends StatelessWidget {
  const _ActiveBadge({required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? ManagementColors.confirmed : ManagementColors.draft;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.11), borderRadius: BorderRadius.circular(4)),
      child: Text(isActive ? 'Actif' : 'Inactif', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: color, fontWeight: FontWeight.w800)),
    );
  }
}
