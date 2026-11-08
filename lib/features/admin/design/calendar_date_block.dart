import 'package:balade/features/admin/design/management_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// The calendar-style date block: a green month band over the day and the weekday.
class CalendarDateBlock extends StatelessWidget {
  const CalendarDateBlock({super.key, required this.date});

  final DateTime? date;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final d = date;
    final month = d == null ? '—' : DateFormat('MMM', 'fr').format(d).replaceAll('.', '').toUpperCase();
    final day = d == null ? '?' : '${d.day}';
    final weekday = d == null ? 'à définir' : DateFormat('E', 'fr').format(d).replaceAll('.', '');

    return Semantics(
      label: d == null ? 'Date à définir' : DateFormat('EEEE d MMMM', 'fr').format(d),
      excludeSemantics: true,
      child: Container(
        width: 52,
        decoration: BoxDecoration(
          color: ManagementColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: ManagementColors.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              color: ManagementColors.green,
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text(
                month,
                textAlign: TextAlign.center,
                style: theme.textTheme.labelSmall?.copyWith(color: Colors.white, letterSpacing: 0.5),
              ),
            ),
            Text(day, style: theme.textTheme.titleLarge?.copyWith(color: ManagementColors.deepGreen, height: 1.2)),
            Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Text(weekday, style: theme.textTheme.bodySmall?.copyWith(fontSize: 10.5)),
            ),
          ],
        ),
      ),
    );
  }
}
