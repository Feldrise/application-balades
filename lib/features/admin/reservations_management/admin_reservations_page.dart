import 'package:balade/features/admin/design/design.dart';
import 'package:balade/features/admin/reservations_management/providers/admin_reservations_provider.dart';
import 'package:balade/features/admin/reservations_management/providers/bulk_actions_provider.dart';
import 'package:balade/features/admin/reservations_management/widgets/bulk_actions_toolbar.dart';
import 'package:balade/features/admin/reservations_management/widgets/reservation_detail_sheet.dart';
import 'package:balade/features/admin/reservations_management/widgets/reservation_filters_sheet.dart';
import 'package:balade/features/admin/reservations_management/widgets/reservation_row.dart';
import 'package:balade/features/admin/reservations_management/widgets/reservation_stat_chips.dart';
import 'package:balade/features/authentication/authentication_provider.dart';
import 'package:balade/features/reservations/models/reservation/reservation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// The reservations of the management area: a green header with the search and the stat chips that filter the list,
/// rows on a phone and a tablet, a full table with bulk actions on desktop. A guide only sees the reservations of their balades.
class AdminReservationsPage extends ConsumerStatefulWidget {
  const AdminReservationsPage({super.key});

  @override
  ConsumerState<AdminReservationsPage> createState() => _AdminReservationsPageState();
}

class _AdminReservationsPageState extends ConsumerState<AdminReservationsPage> {
  late final TextEditingController _search = TextEditingController(text: ref.read(adminReservationsProvider).filters.search ?? '');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _reload());
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  String? get _token => ref.read(authenticationProvider)?.token;

  void _reload() {
    if (_token == null) return;
    ref.read(adminReservationsProvider.notifier).loadReservations(token: _token);
  }

  void _onSearchChanged(String value) {
    final filters = ref.read(adminReservationsProvider).filters;
    ref.read(adminReservationsProvider.notifier).updateFilters(filters.copyWith(search: value.isEmpty ? null : value), token: _token);
  }

  Future<void> _openFilters() async {
    final filters = ref.read(adminReservationsProvider).filters;
    final chosen = await showReservationFiltersSheet(context, current: filters);
    if (chosen != null) ref.read(adminReservationsProvider.notifier).updateFilters(chosen, token: _token, debounce: false);
  }

  void _onSort(String sortBy) {
    final sort = ref.read(adminReservationsProvider).sort;
    final next = sort.copyWith(sortBy: sortBy, sortAscending: sort.sortBy == sortBy ? !sort.sortAscending : false);
    ref.read(adminReservationsProvider.notifier).updateSort(next, token: _token);
  }

  void _clearFilters() {
    _search.clear();
    ref.read(adminReservationsProvider.notifier).clearFilters(token: _token);
  }

  void _export() {
    // TODO: Implement export functionality
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Export en cours de développement')));
  }

  void _open(Reservation reservation) {
    showReservationDetailSheet(context, reservation: reservation, onChanged: _reload, onOpenRamble: () => context.go('/admin/balade/${reservation.rambleId}'));
  }

  @override
  Widget build(BuildContext context) {
    final isPhone = ManagementBreakpoints.isPhone(context);
    final isDesktop = ManagementBreakpoints.isDesktop(context);

    return Column(
      children: [
        ManagementPageHeader(
          title: 'Réservations',
          actions: [
            if (!isPhone)
              IconButton(
                tooltip: 'Actualiser',
                onPressed: _reload,
                icon: const Icon(Icons.refresh, color: Colors.white70),
              ),
            if (isPhone)
              IconButton(
                tooltip: 'Exporter',
                onPressed: _export,
                icon: const Icon(Icons.download, color: Colors.white),
              )
            else
              ManagementHeaderButton(label: 'Exporter', icon: Icons.download, onPressed: _export),
          ],
          bottom: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ManagementHeaderSearchField(hint: 'Personne qui réserve, email, balade', controller: _search, onChanged: _onSearchChanged),
              const SizedBox(height: 10),
              const ReservationStatChips(),
            ],
          ),
        ),
        Expanded(
          child: _Content(onOpen: _open, onReload: _reload, onSort: _onSort, onFilters: _openFilters, onClearFilters: _clearFilters, table: isDesktop),
        ),
        if (isDesktop) const BulkActionsToolbar(),
      ],
    );
  }
}

class _Content extends ConsumerWidget {
  const _Content({required this.onOpen, required this.onReload, required this.onSort, required this.onFilters, required this.onClearFilters, required this.table});

  final ValueChanged<Reservation> onOpen;
  final VoidCallback onReload;
  final ValueChanged<String> onSort;
  final VoidCallback onFilters;
  final VoidCallback onClearFilters;
  final bool table;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(adminReservationsProvider);
    final reservations = state.reservations;

    if (state.isLoading && reservations.isEmpty) return const Center(child: CircularProgressIndicator());

    if (state.error != null) {
      return Center(
        child: ManagementEmptyState(
          icon: Icons.cloud_off,
          title: 'Impossible de charger les réservations',
          message: state.error,
          action: FilledButton(onPressed: onReload, child: const Text('Réessayer')),
        ),
      );
    }

    final gutter = ManagementBreakpoints.gutter(context);
    final selectable = table && canBulkReservations(ref);
    final bulk = selectable ? ref.watch(bulkActionsProvider) : null;
    final notifier = ref.read(bulkActionsProvider.notifier);
    final activeFilters = activeSheetFilters(state.filters);

    void changed(Reservation updated) {
      ref.read(adminReservationsProvider.notifier).refreshReservation(updated);
      onReload();
    }

    final allSelected = reservations.isNotEmpty && reservations.every((r) => bulk?.selectedReservationIds.contains(r.id) ?? false);
    final selectAll = selectable
        ? Checkbox(
            key: const ValueKey('select-all-reservations'),
            value: allSelected,
            onChanged: (_) => allSelected ? notifier.clearSelection() : notifier.selectAll([for (final r in reservations) r.id]),
          )
        : null;

    return RefreshIndicator(
      onRefresh: () async => onReload(),
      child: ListView(
        padding: EdgeInsets.fromLTRB(gutter, 8, gutter, 32),
        children: [
          Row(
            children: [
              Expanded(child: Text('${state.pagination.total} réservation${state.pagination.total > 1 ? 's' : ''}', style: Theme.of(context).textTheme.bodySmall)),
              if (state.isLoading)
                const Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
                ),
              TextButton.icon(
                onPressed: onFilters,
                style: TextButton.styleFrom(foregroundColor: ManagementColors.green, visualDensity: VisualDensity.compact),
                icon: const Icon(Icons.tune, size: 18),
                label: Text(activeFilters == 0 ? 'Filtres' : 'Filtres · $activeFilters'),
              ),
            ],
          ),
          if (reservations.isEmpty)
            ManagementPanel(
              children: [
                ManagementEmptyState(
                  icon: Icons.assignment_outlined,
                  title: 'Aucune réservation',
                  message: state.filters.hasActiveFilters
                      ? 'Aucune réservation ne correspond à ces filtres.'
                      : 'Les réservations apparaîtront ici dès qu\'une personne aura réservé.',
                  action: state.filters.hasActiveFilters ? OutlinedButton(onPressed: onClearFilters, child: const Text('Effacer les filtres')) : null,
                ),
              ],
            )
          else
            ManagementPanel(
              children: [
                if (table) ReservationTableHeader(selection: selectAll, sortBy: state.sort.sortBy, sortAscending: state.sort.sortAscending, onSort: onSort),
                for (final reservation in reservations)
                  if (table)
                    ReservationTableRow(
                      reservation: reservation,
                      selection: selectable
                          ? Checkbox(
                              key: ValueKey('select-reservation-${reservation.id}'),
                              value: bulk!.selectedReservationIds.contains(reservation.id),
                              onChanged: (_) => notifier.toggleSelection(reservation.id),
                            )
                          : null,
                      selected: bulk?.selectedReservationIds.contains(reservation.id) ?? false,
                      onOpen: () => onOpen(reservation),
                      onChanged: changed,
                    )
                  else
                    ReservationRow(reservation: reservation, onOpen: () => onOpen(reservation), onChanged: changed),
              ],
            ),
          if (state.pagination.totalPages > 1) _Pagination(pagination: state.pagination),
        ],
      ),
    );
  }
}

class _Pagination extends ConsumerWidget {
  const _Pagination({required this.pagination});

  final AdminReservationsPaginationState pagination;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(adminReservationsProvider.notifier);
    final token = ref.read(authenticationProvider)?.token;
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            tooltip: 'Page précédente',
            onPressed: pagination.hasPreviousPage ? () => notifier.previousPage(token: token) : null,
            icon: const Icon(Icons.chevron_left),
          ),
          Text('Page ${pagination.page} sur ${pagination.totalPages}', style: Theme.of(context).textTheme.bodySmall),
          IconButton(
            tooltip: 'Page suivante',
            onPressed: pagination.hasNextPage ? () => notifier.nextPage(token: token) : null,
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }
}
