import 'package:balade/features/reservations/models/reservation/reservation.dart';
import 'package:flutter/material.dart';

class ReservationStatusChip extends StatelessWidget {
  const ReservationStatusChip({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final parsed = ReservationStatus.tryParse(status);
    final color = _color(parsed, theme);

    return Chip(
      label: Text(
        parsed?.label ?? status,
        style: TextStyle(color: color, fontWeight: FontWeight.w500, fontSize: 12),
      ),
      backgroundColor: color.withValues(alpha: 0.1),
      side: BorderSide(color: color.withValues(alpha: 0.3)),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  Color _color(ReservationStatus? status, ThemeData theme) {
    switch (status) {
      case ReservationStatus.pending:
        return Colors.orange;
      case ReservationStatus.confirmed:
        return Colors.green;
      case ReservationStatus.waitingList:
        return Colors.blue;
      case ReservationStatus.cancelled:
        return theme.colorScheme.error;
      case null:
        return theme.colorScheme.onSurfaceVariant;
    }
  }
}
