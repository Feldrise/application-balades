import 'package:balade/features/admin/design/design.dart';
import 'package:balade/features/admin/rambles_management/managed_rambles.dart';
import 'package:balade/features/guides/models/guide/guide.dart';
import 'package:balade/features/ramble/models/ramble/ramble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The filters above the balades list: quick chips, then a guide (admin only) and a type.
class RamblesFilterBar extends ConsumerWidget {
  const RamblesFilterBar({super.key, required this.rambles, required this.showGuideFilter});

  /// All the managed balades, to offer only the guides and types they have.
  final List<Ramble> rambles;
  final bool showGuideFilter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(rambleListQueryProvider);
    void update(RambleListQuery Function(RambleListQuery) change) => ref.read(rambleListQueryProvider.notifier).update(change);

    final guides = <int, Guide>{
      for (final r in rambles)
        for (final g in r.guides) g.id: g,
    }.values.toList()..sort((a, b) => a.firstName.compareTo(b.firstName));
    final types = {for (final r in rambles) r.type}.toList()..sort();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final filter in RambleListFilter.values)
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: ChoiceChip(
                label: Text(filter.label),
                selected: query.filter == filter,
                onSelected: (_) => update((q) => q.copyWith(filter: filter)),
              ),
            ),
          if (showGuideFilter && guides.isNotEmpty)
            _MenuChip<int>(
              label: query.guideId == null ? 'Tous les guides' : guides.where((g) => g.id == query.guideId).map((g) => g.firstName).firstOrNull ?? 'Guide',
              selected: query.guideId != null,
              allLabel: 'Tous les guides',
              options: {for (final g in guides) g.id: '${g.firstName} ${g.lastName}'.trim()},
              onSelected: (id) => update((q) => q.copyWith(guideId: () => id)),
            ),
          if (types.length > 1 || query.type != null)
            _MenuChip<String>(
              label: query.type == null ? 'Tous les types' : rambleTypeLabels[query.type] ?? query.type!,
              selected: query.type != null,
              allLabel: 'Tous les types',
              options: {for (final t in types) t: rambleTypeLabels[t] ?? t},
              onSelected: (type) => update((q) => q.copyWith(type: () => type)),
            ),
        ],
      ),
    );
  }
}

/// A chip opening a menu of [options], with a first entry [allLabel] that clears the choice.
class _MenuChip<T extends Object> extends StatelessWidget {
  const _MenuChip({required this.label, required this.selected, required this.allLabel, required this.options, required this.onSelected});

  final String label;
  final bool selected;
  final String allLabel;
  final Map<T, String> options;
  final ValueChanged<T?> onSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: MenuAnchor(
        menuChildren: [
          MenuItemButton(onPressed: () => onSelected(null), child: Text(allLabel)),
          for (final entry in options.entries) MenuItemButton(onPressed: () => onSelected(entry.key), child: Text(entry.value)),
        ],
        builder: (context, controller, _) => FilterChip(
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label),
              const Icon(Icons.arrow_drop_down, size: 18, color: ManagementColors.muted),
            ],
          ),
          selected: selected,
          onSelected: (_) => controller.isOpen ? controller.close() : controller.open(),
        ),
      ),
    );
  }
}
