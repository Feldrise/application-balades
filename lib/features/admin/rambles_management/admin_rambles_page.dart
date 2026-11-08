import 'package:balade/features/admin/design/design.dart';
import 'package:balade/features/admin/rambles_management/managed_rambles.dart';
import 'package:balade/features/admin/rambles_management/widgets/ramble_row.dart';
import 'package:balade/features/admin/rambles_management/widgets/rambles_filter_bar.dart';
import 'package:balade/features/authentication/permission_provider.dart';
import 'package:balade/features/guides/providers/current_guide_provider.dart';
import 'package:balade/features/ramble/models/ramble/ramble.dart';
import 'package:balade/features/ramble/ramble_permissions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// The balades list of the management area: grouped by period, a table on desktop, filters in a bar above.
class AdminRamblesPage extends ConsumerWidget {
  const AdminRamblesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rambles = ref.watch(managedRamblesProvider);
    final query = ref.watch(rambleListQueryProvider);
    final permission = ref.watch(permissionProvider);
    final canCreate = canCreateBalade(permission, ref.watch(isFunctionalGuideProvider));
    final groups = groupRambles(rambles.valueOrNull ?? const [], query);
    final count = groups.fold<int>(0, (sum, g) => sum + g.rambles.length);

    return Column(
      children: [
        ManagementPageHeader(
          title: 'Balades',
          subtitle: rambles.hasValue ? '$count ${count > 1 ? 'balades' : 'balade'} · ${query.filter.label.toLowerCase()}' : null,
          actions: [if (canCreate) ManagementHeaderButton(label: 'Nouvelle balade', icon: Icons.add, onPressed: () => context.go('/admin/nouvelle-balade'))],
          bottom: ManagementHeaderSearchField(
            hint: 'Rechercher une balade, un lieu, un guide',
            onChanged: (value) => ref.read(rambleListQueryProvider.notifier).update((q) => q.copyWith(search: value)),
          ),
        ),
        Expanded(
          child: rambles.when(
            skipLoadingOnRefresh: false,
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(
              child: ManagementEmptyState(
                icon: Icons.cloud_off,
                title: 'Impossible de charger les balades',
                message: 'Vérifiez votre connexion puis réessayez.',
                action: FilledButton(onPressed: () => ref.invalidate(managedRamblesProvider), child: const Text('Réessayer')),
              ),
            ),
            data: (all) => _RamblesList(all: all, groups: groups, showGuideFilter: permission?.isAdmin() == true),
          ),
        ),
      ],
    );
  }
}

class _RamblesList extends ConsumerWidget {
  const _RamblesList({required this.all, required this.groups, required this.showGuideFilter});

  final List<Ramble> all;
  final List<RambleGroup> groups;
  final bool showGuideFilter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gutter = ManagementBreakpoints.gutter(context);
    final table = ManagementBreakpoints.isDesktop(context);

    return RefreshIndicator(
      onRefresh: () => ref.refresh(managedRamblesProvider.future),
      child: ListView(
        padding: EdgeInsets.fromLTRB(gutter, 12, gutter, 32),
        children: [
          RamblesFilterBar(rambles: all, showGuideFilter: showGuideFilter),
          const SizedBox(height: 10),
          if (groups.isEmpty)
            ManagementPanel(
              children: [
                ManagementEmptyState(
                  icon: Icons.landscape_outlined,
                  title: 'Aucune balade',
                  message: 'Aucune balade ne correspond à ces filtres.',
                  action: OutlinedButton(onPressed: () => ref.invalidate(rambleListQueryProvider), child: const Text('Effacer les filtres')),
                ),
              ],
            )
          else
            ManagementPanel(
              children: [
                if (table) const RambleTableHeader(),
                for (final group in groups) ...[
                  ManagementSectionLabel('${group.label} · ${group.rambles.length}'),
                  for (final ramble in group.rambles) table ? RambleTableRow(ramble: ramble) : RambleRow(ramble: ramble),
                ],
              ],
            ),
        ],
      ),
    );
  }
}
