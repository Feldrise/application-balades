import 'package:balade/features/admin/design/design.dart';
import 'package:balade/features/admin/reservations_management/status_change/reservation_status_change.dart';
import 'package:balade/features/reservations/models/reservation/reservation.dart';
import 'package:balade/features/reservations/reservation_format.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String _when(Reservation reservation) {
  final date = reservation.ramble?.date;
  return date == null ? 'Date à définir' : DateFormat("d MMM · HH'h'mm", 'fr').format(date.toLocal());
}

String _rambleTitle(Reservation reservation) => reservation.ramble?.title ?? 'Balade n° ${reservation.rambleId}';

String _participants(Reservation reservation) => '${reservation.participants.length}';

/// The payment of a reservation: « Payé 30 € » in green once paid, the amount otherwise.
class ReservationPayment extends StatelessWidget {
  const ReservationPayment({super.key, required this.reservation, this.textAlign});

  final Reservation reservation;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    final paid = isReservationPaid(reservation);
    return Text(
      formatReservationPayment(reservation),
      textAlign: textAlign,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.labelMedium?.copyWith(color: paid ? ManagementColors.green : ManagementColors.text),
    );
  }
}

/// A reservation in the list, on a phone or a tablet: the booker and the status badge, the balade, then date, participants and payment.
/// The whole row opens the detail.
class ReservationRow extends StatelessWidget {
  const ReservationRow({super.key, required this.reservation, required this.onOpen, required this.onChanged});

  final Reservation reservation;
  final VoidCallback onOpen;

  /// Called with the reservation once its status was changed from the badge.
  final ValueChanged<Reservation> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ManagementRow(
      onTap: onOpen,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(bookerName(reservation), style: theme.textTheme.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
              const SizedBox(width: 8),
              ChangeableStatusBadge(reservation: reservation, onChanged: onChanged),
            ],
          ),
          const SizedBox(height: 2),
          Text(_rambleTitle(reservation), style: theme.textTheme.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.event_outlined, size: 14, color: ManagementColors.muted),
              const SizedBox(width: 4),
              Flexible(
                child: Text(_when(reservation), style: theme.textTheme.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.group_outlined, size: 14, color: ManagementColors.muted),
              const SizedBox(width: 4),
              Text(_participants(reservation), style: theme.textTheme.bodySmall),
              const SizedBox(width: 12),
              Expanded(
                child: ReservationPayment(reservation: reservation, textAlign: TextAlign.end),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Width of the columns of the desktop table, shared by its header and its rows; the booker and the balade share what is left.
abstract final class ReservationTableColumns {
  static const double select = 44;
  static const double participants = 110;
  static const double status = 140;
  static const double payment = 150;
}

/// The headings of the desktop table. [onSort] makes the booker and status headings sortable.
class ReservationTableHeader extends StatelessWidget {
  const ReservationTableHeader({super.key, required this.selection, this.sortBy, this.sortAscending = false, this.onSort});

  /// The select-all checkbox, or null when the account cannot act on several reservations.
  final Widget? selection;
  final String? sortBy;
  final bool sortAscending;
  final ValueChanged<String>? onSort;

  @override
  Widget build(BuildContext context) {
    Widget sortable(String label, String key) {
      final active = sortBy == key;
      return InkWell(
        onTap: onSort == null ? null : () => onSort!(key),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ManagementColumnLabel(label),
            if (active) Icon(sortAscending ? Icons.arrow_upward : Icons.arrow_downward, size: 12, color: ManagementColors.muted),
          ],
        ),
      );
    }

    return ManagementTableHeader(
      child: Row(
        children: [
          if (selection != null) SizedBox(width: ReservationTableColumns.select, child: selection),
          Expanded(
            flex: 3,
            child: Align(alignment: Alignment.centerLeft, child: sortable('Personne qui réserve', 'contact_email')),
          ),
          const Expanded(flex: 3, child: ManagementColumnLabel('Balade')),
          const SizedBox(width: ReservationTableColumns.participants, child: ManagementColumnLabel('Participants')),
          SizedBox(
            width: ReservationTableColumns.status,
            child: Align(alignment: Alignment.centerLeft, child: sortable('Statut', 'status')),
          ),
          const SizedBox(
            width: ReservationTableColumns.payment,
            child: Align(alignment: Alignment.centerRight, child: ManagementColumnLabel('Paiement')),
          ),
        ],
      ),
    );
  }
}

/// A reservation in the desktop table. [selection] is its checkbox, null when the account cannot act on several reservations.
class ReservationTableRow extends StatelessWidget {
  const ReservationTableRow({super.key, required this.reservation, required this.selection, required this.selected, required this.onOpen, required this.onChanged});

  final Reservation reservation;
  final Widget? selection;
  final bool selected;
  final VoidCallback onOpen;
  final ValueChanged<Reservation> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: selected ? ManagementColors.mint.withValues(alpha: 0.5) : null,
      child: InkWell(
        onTap: onOpen,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Row(
            children: [
              if (selection != null) SizedBox(width: ReservationTableColumns.select, child: selection),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(bookerName(reservation), style: theme.textTheme.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                    Text(reservation.contactEmail, style: theme.textTheme.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_rambleTitle(reservation), style: theme.textTheme.bodyMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                    Text(_when(reservation), style: theme.textTheme.bodySmall),
                  ],
                ),
              ),
              SizedBox(
                width: ReservationTableColumns.participants,
                child: Text(_participants(reservation), style: theme.textTheme.bodyMedium),
              ),
              SizedBox(
                width: ReservationTableColumns.status,
                // Shrinks rather than overflows when a font is wider than expected
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: ChangeableStatusBadge(reservation: reservation, onChanged: onChanged),
                ),
              ),
              SizedBox(
                width: ReservationTableColumns.payment,
                child: ReservationPayment(reservation: reservation, textAlign: TextAlign.end),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
