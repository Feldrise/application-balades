import 'package:balade/features/admin/design/design.dart';
import 'package:balade/features/reservations/models/reservation/reservation.dart';
import 'package:balade/features/reservations/reservation_format.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/// One reservation in « Mes réservations »: the date, the ramble, the status and the amount. It opens the reservation.
class ReservationCard extends StatelessWidget {
  const ReservationCard({super.key, required this.reservation});

  final Reservation reservation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ramble = reservation.ramble;
    final date = ramble?.date;
    final participants = reservation.participants.length;
    final period = reservation.status == 'pending' ? confirmationPeriodText(reservation) : null;
    final place = ramble?.location;

    return Semantics(
      button: true,
      label: 'Ouvrir la réservation ${ramble?.title ?? 'Balade'}',
      child: InkWell(
        onTap: () => context.go('/mes-reservations/${reservation.id}'),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: ManagementColors.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: ManagementColors.border),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CalendarDateBlock(date: date?.toLocal()),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(ramble?.title ?? 'Balade', style: theme.textTheme.titleMedium),
                    if (date != null) Text('${DateFormat('HH:mm').format(date.toLocal())}${place != null && place.isNotEmpty ? ' · $place' : ''}', style: theme.textTheme.bodySmall),
                    const SizedBox(height: 6),
                    ReservationStatusBadge(status: reservation.status),
                    const SizedBox(height: 6),
                    Text('${participants > 1 ? '$participants participants' : '1 participant'} · ${formatReservationAmount(reservation)}', style: theme.textTheme.bodyMedium),
                    if (period != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        period,
                        style: theme.textTheme.bodySmall?.copyWith(color: ManagementColors.pending, fontWeight: FontWeight.w800),
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: ManagementColors.muted),
            ],
          ),
        ),
      ),
    );
  }
}
