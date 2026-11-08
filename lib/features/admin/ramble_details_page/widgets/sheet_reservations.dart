import 'package:balade/features/admin/design/design.dart';
import 'package:balade/features/admin/ramble_details_page/ramble_sheet.dart';
import 'package:balade/features/admin/reservations_management/status_change/reservation_status_change.dart';
import 'package:balade/features/admin/reservations_management/widgets/booker_contact_buttons.dart';
import 'package:balade/features/admin/reservations_management/widgets/managed_participant_row.dart';
import 'package:balade/features/admin/reservations_management/widgets/reservation_detail_sheet.dart';
import 'package:balade/features/reservations/models/reservation/reservation.dart';
import 'package:balade/features/reservations/reservation_format.dart';
import 'package:flutter/material.dart';

/// The numbers strip of the feuille de balade: places taken, present, confirmed, to confirm, cancelled.
class SheetNumbers extends StatelessWidget {
  const SheetNumbers({super.key, required this.sheet});

  final RambleSheet sheet;

  @override
  Widget build(BuildContext context) {
    final max = sheet.ramble.maxParticipants;
    return ManagementPanel(
      children: [
        NumbersStrip(
          numbers: [
            StripNumber(value: max == null ? '${sheet.placesTaken}' : '${sheet.placesTaken}/$max', label: 'places prises'),
            StripNumber(value: '${sheet.presentCount}/${sheet.placesTaken}', label: 'présents', color: ManagementColors.green, highlighted: true),
            StripNumber(value: '${sheet.count(ReservationStatus.confirmed)}', label: 'confirmées', color: ManagementColors.confirmed),
            StripNumber(value: '${sheet.count(ReservationStatus.pending)}', label: 'à confirmer', color: ManagementColors.pending),
            StripNumber(value: '${sheet.count(ReservationStatus.cancelled)}', label: 'annulées', color: ManagementColors.cancelled),
          ],
        ),
      ],
    );
  }
}

/// The reservations of the feuille de balade: the expected ones first, then the waiting list and the cancelled ones apart.
/// Searchable by name or email. [wide] lays each reservation out as a table row (desktop).
class SheetReservations extends StatefulWidget {
  const SheetReservations({super.key, required this.sheet, required this.wide, required this.onChanged});

  final RambleSheet sheet;
  final bool wide;

  /// A reservation changed: the sheet reloads.
  final VoidCallback onChanged;

  @override
  State<SheetReservations> createState() => _SheetReservationsState();
}

class _SheetReservationsState extends State<SheetReservations> {
  String _search = '';

  bool _matches(Reservation reservation) {
    final query = _search.trim().toLowerCase();
    if (query.isEmpty) return true;
    return reservation.contactEmail.toLowerCase().contains(query) || reservation.participants.any((p) => '${p.firstName} ${p.lastName}'.toLowerCase().contains(query));
  }

  @override
  Widget build(BuildContext context) {
    final sheet = widget.sheet;
    final sections = [
      ('Attendues', sheet.expected.where(_matches).toList(), false),
      ('Liste d\'attente', sheet.waitingList.where(_matches).toList(), true),
      ('Annulées', sheet.cancelled.where(_matches).toList(), true),
    ];
    final shown = sections.fold<int>(0, (sum, s) => sum + s.$2.length);

    return ManagementPanel(
      divided: false,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Réservations', style: Theme.of(context).textTheme.titleMedium),
              if (sheet.reservations.isNotEmpty) ...[
                const SizedBox(height: 10),
                TextField(
                  onChanged: (value) => setState(() => _search = value),
                  decoration: InputDecoration(
                    hintText: 'Rechercher un nom ou un email',
                    prefixIcon: const Icon(Icons.search, size: 20),
                    isDense: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ],
          ),
        ),
        if (sheet.reservations.isEmpty)
          const ManagementEmptyState(icon: Icons.group_outlined, title: 'Aucune réservation', message: 'Personne n\'a encore réservé cette balade.')
        else if (shown == 0)
          const ManagementEmptyState(icon: Icons.search_off, title: 'Aucune réservation trouvée', message: 'Essayez un autre nom ou un autre email.')
        else ...[
          if (widget.wide)
            const ManagementTableHeader(
              child: Row(
                children: [
                  Expanded(child: ManagementColumnLabel('Personne qui réserve')),
                  SizedBox(width: 150, child: ManagementColumnLabel('Statut')),
                  SizedBox(width: 130, child: ManagementColumnLabel('Paiement')),
                  SizedBox(width: 96),
                ],
              ),
            ),
          for (final (label, reservations, apart) in sections)
            if (reservations.isNotEmpty) ...[
              ManagementSectionLabel('$label · ${reservations.length}'),
              for (final reservation in reservations) _ReservationRow(reservation: reservation, wide: widget.wide, muted: apart, onChanged: widget.onChanged),
            ],
        ],
      ],
    );
  }
}

class _ReservationRow extends StatelessWidget {
  const _ReservationRow({required this.reservation, required this.wide, required this.muted, required this.onChanged});

  final Reservation reservation;
  final bool wide;
  final bool muted;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final paid = isReservationPaid(reservation);
    final who = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          bookerName(reservation),
          style: theme.textTheme.titleSmall?.copyWith(color: muted ? ManagementColors.muted : null),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(reservation.contactEmail, style: theme.textTheme.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
      ],
    );
    final badge = ChangeableStatusBadge(reservation: reservation, onChanged: (_) => onChanged());
    final payment = Text(formatReservationPayment(reservation), style: theme.textTheme.labelMedium?.copyWith(color: paid ? ManagementColors.green : ManagementColors.muted));
    final contact = BookerContactButtons(reservation: reservation);

    return Container(
      color: muted ? ManagementColors.subtleSurface : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Divider(height: 1),
          ManagementRow(
            padding: const EdgeInsets.fromLTRB(14, 10, 6, 2),
            onTap: () => showReservationDetailSheet(context, reservation: reservation, onChanged: onChanged),
            child: wide
                ? Row(
                    children: [
                      Expanded(child: who),
                      SizedBox(
                        width: 150,
                        child: Align(alignment: Alignment.centerLeft, child: badge),
                      ),
                      SizedBox(width: 130, child: payment),
                      SizedBox(
                        width: 96,
                        child: Align(alignment: Alignment.centerRight, child: contact),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Expanded(child: who),
                          contact,
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          badge,
                          const SizedBox(width: 10),
                          Expanded(child: payment),
                        ],
                      ),
                    ],
                  ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 8),
            child: Column(
              children: [for (final participant in reservation.participants) ManagedParticipantRow(participant: participant, muted: muted)],
            ),
          ),
        ],
      ),
    );
  }
}
