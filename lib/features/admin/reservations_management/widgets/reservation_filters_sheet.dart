import 'package:balade/features/admin/design/design.dart';
import 'package:balade/features/admin/rambles_management/managed_rambles.dart';
import 'package:balade/features/admin/reservations_management/models/admin_reservation_filter.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

/// The quick periods of the filters sheet.
enum ReservationPeriod {
  today('Aujourd\'hui'),
  week('Cette semaine'),
  month('Ce mois');

  const ReservationPeriod(this.label);

  final String label;

  /// The first and last day of the period around [now].
  (DateTime, DateTime) range(DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    return switch (this) {
      ReservationPeriod.today => (today, today),
      ReservationPeriod.week => (today.subtract(Duration(days: today.weekday - 1)), today.add(Duration(days: DateTime.daysPerWeek - today.weekday))),
      ReservationPeriod.month => (DateTime(now.year, now.month, 1), DateTime(now.year, now.month + 1, 0)),
    };
  }

  bool matches(DateTime? from, DateTime? to, DateTime now) {
    if (from == null || to == null) return false;
    final (start, end) = range(now);
    bool sameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;
    return sameDay(from, start) && sameDay(to, end);
  }
}

/// How many filters of the sheet are set: the balade and the dates (the search and the status have their own place on the screen).
int activeSheetFilters(AdminReservationFilter filter) => (filter.rambleId != null ? 1 : 0) + (filter.dateFrom != null || filter.dateTo != null ? 1 : 0);

/// Opens the filters that do not fit on the screen: the balade and the period. Gives the filters to apply, or null when dismissed.
Future<AdminReservationFilter?> showReservationFiltersSheet(BuildContext context, {required AdminReservationFilter current}) {
  return showManagementBottomSheet<AdminReservationFilter>(
    context: context,
    title: 'Filtres',
    builder: (context) => _FiltersForm(current: current),
  );
}

class _FiltersForm extends ConsumerStatefulWidget {
  const _FiltersForm({required this.current});

  final AdminReservationFilter current;

  @override
  ConsumerState<_FiltersForm> createState() => _FiltersFormState();
}

class _FiltersFormState extends ConsumerState<_FiltersForm> {
  late AdminReservationFilter _draft = widget.current;

  void _setPeriod(ReservationPeriod? period) {
    final range = period?.range(DateTime.now());
    setState(() => _draft = _draft.copyWith(dateFrom: range?.$1, dateTo: range?.$2));
  }

  @override
  Widget build(BuildContext context) {
    final rambles = ref.watch(managedRamblesProvider).valueOrNull ?? const [];
    final now = DateTime.now();
    final dateFormat = DateFormat('dd/MM/yy');
    final knownRamble = rambles.any((r) => r.id == _draft.rambleId);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DropdownButtonFormField<int>(
          isExpanded: true,
          initialValue: knownRamble ? _draft.rambleId : null,
          decoration: const InputDecoration(labelText: 'Balade', border: OutlineInputBorder()),
          items: [
            const DropdownMenuItem<int>(value: null, child: Text('Toutes les balades')),
            for (final ramble in rambles)
              DropdownMenuItem<int>(
                value: ramble.id,
                child: Text(
                  ramble.date == null ? ramble.title : '${ramble.title} · ${DateFormat('dd/MM/yyyy').format(ramble.date!)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
          onChanged: (id) => setState(() => _draft = _draft.copyWith(rambleId: id)),
        ),
        const SizedBox(height: 16),
        Text('PÉRIODE', style: Theme.of(context).textTheme.labelSmall),
        const SizedBox(height: 6),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            for (final period in ReservationPeriod.values)
              ChoiceChip(label: Text(period.label), selected: period.matches(_draft.dateFrom, _draft.dateTo, now), onSelected: (selected) => _setPeriod(selected ? period : null)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: DateTimeFormField(
                key: ValueKey('from-${_draft.dateFrom}'),
                decoration: const InputDecoration(labelText: 'Du', border: OutlineInputBorder(), isDense: true),
                mode: DateTimeFieldPickerMode.date,
                initialValue: _draft.dateFrom,
                firstDate: DateTime(2020),
                lastDate: DateTime(2035),
                dateFormat: dateFormat,
                onChanged: (date) => setState(() => _draft = _draft.copyWith(dateFrom: date)),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: DateTimeFormField(
                key: ValueKey('to-${_draft.dateTo}'),
                decoration: const InputDecoration(labelText: 'Au', border: OutlineInputBorder(), isDense: true),
                mode: DateTimeFieldPickerMode.date,
                initialValue: _draft.dateTo,
                firstDate: DateTime(2020),
                lastDate: DateTime(2035),
                dateFormat: dateFormat,
                onChanged: (date) => setState(() => _draft = _draft.copyWith(dateTo: date)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(onPressed: () => Navigator.of(context).pop(_draft.copyWith(rambleId: null, dateFrom: null, dateTo: null)), child: const Text('Effacer')),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton(onPressed: () => Navigator.of(context).pop(_draft), child: const Text('Appliquer')),
            ),
          ],
        ),
      ],
    );
  }
}
