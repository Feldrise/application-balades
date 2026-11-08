import 'package:balade/core/constants.dart';
import 'package:balade/features/admin/design/design.dart';
import 'package:balade/features/admin/rambles_management/managed_rambles.dart';
import 'package:balade/features/ramble/models/ramble/ramble.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

String _time(DateTime? date) => date == null ? 'Heure à définir' : DateFormat("HH'h'mm", 'fr').format(date);

String _guides(Ramble ramble) => ramble.guides.isEmpty ? 'Sans guide' : ramble.guides.map((g) => g.firstName).join(', ');

void _open(BuildContext context, Ramble ramble) => context.go('/admin/balade/${ramble.id}');

/// Width of the columns of the desktop table, shared by the header and the rows.
abstract final class RambleTableColumns {
  static const double date = 66;
  static const double guide = 140;
  static const double places = 150;
  static const double status = 110;
}

/// A balade in the list, on a phone or a tablet: the whole row opens the feuille de balade.
class RambleRow extends StatelessWidget {
  const RambleRow({super.key, required this.ramble});

  final Ramble ramble;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ManagementRow(
      onTap: () => _open(context, ramble),
      child: Row(
        children: [
          CalendarDateBlock(date: ramble.date),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ramble.title,
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  [_time(ramble.date), if (ramble.location?.isNotEmpty == true) ramble.location!, _guides(ramble)].join(' · '),
                  style: theme.textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    PlacesGauge(taken: placesTaken(ramble), capacity: ramble.maxParticipants),
                    const SizedBox(width: 12),
                    Flexible(child: RambleStatusLabel(ramble: ramble)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          RambleThumbnail(ramble: ramble),
        ],
      ),
    );
  }
}

/// A balade in the desktop table.
class RambleTableRow extends StatelessWidget {
  const RambleTableRow({super.key, required this.ramble});

  final Ramble ramble;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ManagementRow(
      onTap: () => _open(context, ramble),
      child: Row(
        children: [
          SizedBox(
            width: RambleTableColumns.date,
            child: Align(
              alignment: Alignment.centerLeft,
              child: CalendarDateBlock(date: ramble.date),
            ),
          ),
          RambleThumbnail(ramble: ramble),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ramble.title,
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text([_time(ramble.date), if (ramble.location?.isNotEmpty == true) ramble.location!].join(' · '), style: theme.textTheme.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: RambleTableColumns.guide,
            child: Text(_guides(ramble), style: theme.textTheme.bodyMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
          SizedBox(
            width: RambleTableColumns.places,
            child: Align(
              alignment: Alignment.centerLeft,
              child: PlacesGauge(taken: placesTaken(ramble), capacity: ramble.maxParticipants),
            ),
          ),
          SizedBox(
            width: RambleTableColumns.status,
            child: Align(
              alignment: Alignment.centerLeft,
              child: RambleStatusLabel(ramble: ramble),
            ),
          ),
        ],
      ),
    );
  }
}

class RambleTableHeader extends StatelessWidget {
  const RambleTableHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const ManagementTableHeader(
      child: Row(
        children: [
          SizedBox(width: RambleTableColumns.date, child: ManagementColumnLabel('Date')),
          Expanded(child: ManagementColumnLabel('Balade')),
          SizedBox(width: 12),
          SizedBox(width: RambleTableColumns.guide, child: ManagementColumnLabel('Guide')),
          SizedBox(width: RambleTableColumns.places, child: ManagementColumnLabel('Places')),
          SizedBox(width: RambleTableColumns.status, child: ManagementColumnLabel('Statut')),
        ],
      ),
    );
  }
}

/// The small cover photo of a balade, a mint square when it has none.
class RambleThumbnail extends StatelessWidget {
  const RambleThumbnail({super.key, required this.ramble, this.size = 40});

  final Ramble ramble;
  final double size;

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      width: size,
      height: size,
      color: ManagementColors.mint,
      child: Icon(Icons.landscape, size: size / 2, color: ManagementColors.green),
    );
    final cover = ramble.coverImage;
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: cover == null || cover.isEmpty
          ? placeholder
          : Image.network('$kBaseUrl/uploads/ramble/${ramble.id}/$cover', width: size, height: size, fit: BoxFit.cover, errorBuilder: (_, _, _) => placeholder),
    );
  }
}
