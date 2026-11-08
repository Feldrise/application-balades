import 'package:balade/core/constants.dart';
import 'package:balade/features/admin/design/design.dart';
import 'package:balade/features/admin/ramble_details_page/widgets/ramble_sheet_actions.dart';
import 'package:balade/features/ramble/models/ramble/ramble.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/// The short header of the feuille de balade: the balade photo behind the title, the date and time,
/// and the meeting point, which opens Maps. [actions] sit at the top right (the « ⋯ » menu).
class SheetHeader extends StatelessWidget {
  const SheetHeader({super.key, required this.ramble, this.actions = const []});

  final Ramble ramble;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gutter = ManagementBreakpoints.gutter(context);
    final cover = ramble.coverImage;
    final date = ramble.date;
    final place = ramble.meetingPoint?.isNotEmpty == true ? ramble.meetingPoint! : ramble.location;
    final white = theme.textTheme.labelLarge?.copyWith(color: Colors.white);

    return Container(
      decoration: BoxDecoration(
        color: ManagementColors.deepGreen,
        image: cover == null || cover.isEmpty
            ? null
            : DecorationImage(image: NetworkImage('$kBaseUrl/uploads/ramble/${ramble.id}/$cover'), fit: BoxFit.cover, onError: (_, _) {}),
      ),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0x8800341d), Color(0xf200341d)]),
        ),
        padding: EdgeInsets.fromLTRB(gutter - 8, MediaQuery.paddingOf(context).top + 4, gutter - 8, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                TextButton.icon(
                  style: TextButton.styleFrom(foregroundColor: Colors.white, visualDensity: VisualDensity.compact),
                  onPressed: () => context.go('/admin'),
                  icon: const Icon(Icons.arrow_back, size: 18),
                  label: const Text('Balades'),
                ),
                const Spacer(),
                IconTheme(
                  data: const IconThemeData(color: Colors.white),
                  child: Row(mainAxisSize: MainAxisSize.min, children: actions),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(ramble.title, style: theme.textTheme.headlineSmall?.copyWith(color: Colors.white), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 14,
                    runSpacing: 4,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.event, size: 15, color: Colors.white70),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(date == null ? 'Date à définir' : DateFormat("EEEE d MMMM · HH'h'mm", 'fr').format(date), style: white, overflow: TextOverflow.ellipsis),
                          ),
                        ],
                      ),
                      if (place != null && place.isNotEmpty)
                        InkWell(
                          onTap: () => openMeetingPoint(context, ramble),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.place, size: 15, color: ManagementColors.lightGreen),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  place,
                                  style: white?.copyWith(color: ManagementColors.lightGreen, decoration: TextDecoration.underline, decorationColor: ManagementColors.lightGreen),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
