import 'package:balade/features/admin/design/design.dart';
import 'package:balade/features/reservations/models/reservation/reservation.dart';
import 'package:balade/features/reservations/reservation_format.dart';
import 'package:flutter/material.dart';

/// A participant of a reservation in the management area: name, and tariff on the right.
/// An unknown tariff reads « tarif à préciser », discreetly.
class ManagedParticipantRow extends StatelessWidget {
  const ManagedParticipantRow({super.key, required this.participant, this.leading, this.muted = false});

  final Participant participant;

  /// Before the name, e.g. the roll-call checkbox. A plain person icon by default.
  final Widget? leading;

  /// For the participants of a reservation that is not expected (waiting list, cancelled).
  final bool muted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tariff = formatParticipantTariff(participant);
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 34),
      child: Row(
        children: [
          SizedBox(
            width: 32,
            child: leading ?? Icon(Icons.person_outline, size: 16, color: ManagementColors.muted.withValues(alpha: muted ? 0.6 : 1)),
          ),
          Expanded(
            child: Text(
              '${participant.firstName} ${participant.lastName}',
              style: theme.textTheme.bodyMedium?.copyWith(color: muted ? ManagementColors.muted : null),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (tariff.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(tariff, style: theme.textTheme.bodySmall?.copyWith(color: participant.priceMissing ? ManagementColors.pending : null)),
            ),
        ],
      ),
    );
  }
}
