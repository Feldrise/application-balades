import 'package:balade/features/admin/design/design.dart';
import 'package:balade/features/admin/reservations_management/providers/admin_reservations_provider.dart';
import 'package:balade/features/authentication/authentication_provider.dart';
import 'package:balade/features/reservations/models/reservation/reservation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The stat chips of the green header: « Toutes » then one per status, each with its count. Tapping one filters the list
/// on that status; tapping the selected one, or « Toutes », shows everything again.
class ReservationStatChips extends ConsumerWidget {
  const ReservationStatChips({super.key});

  static const _statuses = [ReservationStatus.confirmed, ReservationStatus.pending, ReservationStatus.waitingList, ReservationStatus.cancelled];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counts = ref.watch(reservationStatusCountsProvider).valueOrNull;
    final selected = ref.watch(adminReservationsProvider.select((s) => s.filters.statuses));
    final selectedStatus = selected == null || selected.length != 1 ? null : ReservationStatus.tryParse(selected.single);

    void select(ReservationStatus? status) {
      final notifier = ref.read(adminReservationsProvider.notifier);
      final filters = ref.read(adminReservationsProvider).filters;
      notifier.updateFilters(filters.copyWith(statuses: status == null ? null : [status.apiValue]), token: ref.read(authenticationProvider)?.token, debounce: false);
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _StatChip(
          key: const ValueKey('stat-chip-all'),
          label: 'Toutes',
          count: counts == null || counts.isEmpty ? null : counts.values.fold<int>(0, (sum, n) => sum + n),
          selected: selectedStatus == null,
          onTap: () => select(null),
        ),
        for (final status in _statuses)
          _StatChip(
            key: ValueKey('stat-chip-${status.apiValue}'),
            label: reservationStatusLabel(status),
            count: counts?[status],
            color: reservationStatusColor(status),
            selected: selectedStatus == status,
            onTap: () => select(selectedStatus == status ? null : status),
          ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({super.key, required this.label, required this.count, required this.selected, required this.onTap, this.color});

  final String label;
  final int? count;
  final bool selected;
  final VoidCallback onTap;

  /// The status dot, none for « Toutes ».
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foreground = selected ? ManagementColors.deepGreen : Colors.white;
    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: selected ? Colors.white : Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (color != null) ...[
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(color: selected ? color : Colors.white, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 6),
                ],
                if (count != null) ...[Text('$count', style: theme.textTheme.titleSmall?.copyWith(color: foreground)), const SizedBox(width: 5)],
                Text(label, style: theme.textTheme.labelMedium?.copyWith(color: foreground)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
