import 'package:balade/features/admin/design/management_theme.dart';
import 'package:balade/features/reservations/models/reservation/reservation.dart';
import 'package:flutter/material.dart';

/// Short label of a reservation status, as the management area shows it.
String reservationStatusLabel(ReservationStatus? status) => switch (status) {
  ReservationStatus.confirmed => 'Confirmée',
  ReservationStatus.pending => 'À confirmer',
  ReservationStatus.waitingList => 'Liste d\'attente',
  ReservationStatus.cancelled => 'Annulée',
  null => 'Inconnu',
};

Color reservationStatusColor(ReservationStatus? status) => switch (status) {
  ReservationStatus.confirmed => ManagementColors.confirmed,
  ReservationStatus.pending => ManagementColors.pending,
  ReservationStatus.waitingList => ManagementColors.waitingList,
  ReservationStatus.cancelled => ManagementColors.cancelled,
  null => ManagementColors.muted,
};

/// The status badge of a reservation. With [onTap] it becomes the clickable variant (a ▾ marks it),
/// used by the admin to change the status.
class ReservationStatusBadge extends StatelessWidget {
  const ReservationStatusBadge({super.key, required this.status, this.onTap});

  /// The status as the API gives it (`confirmed`, `pending`, `waiting_list`, `cancelled`).
  final String status;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final parsed = ReservationStatus.tryParse(status);
    final color = reservationStatusColor(parsed);
    final label = reservationStatusLabel(parsed);
    final style = Theme.of(context).textTheme.labelMedium?.copyWith(color: color, fontWeight: FontWeight.w800);

    final badge = Container(
      padding: EdgeInsets.fromLTRB(8, 3, onTap == null ? 8 : 4, 3),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.11), borderRadius: BorderRadius.circular(4)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: style),
          if (onTap != null) Icon(Icons.arrow_drop_down, size: 18, color: color),
        ],
      ),
    );
    if (onTap == null) return badge;
    return Semantics(
      button: true,
      label: 'Changer le statut ($label)',
      child: InkWell(onTap: onTap, borderRadius: BorderRadius.circular(4), child: badge),
    );
  }
}
