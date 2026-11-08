import 'package:balade/features/admin/design/design.dart';
import 'package:flutter/material.dart';

/// The large roll-call checkbox: a touch zone of 48 px around a 28 px box, for one-handed use at the meeting point.
class PresenceCheckbox extends StatelessWidget {
  const PresenceCheckbox({super.key, required this.name, required this.present, required this.onChanged});

  /// The participant, for the screen readers.
  final String name;
  final bool present;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: 'Présence de $name',
      checked: present,
      button: true,
      excludeSemantics: true,
      child: InkResponse(
        onTap: () => onChanged(!present),
        radius: 26,
        child: SizedBox(
          width: 48,
          height: 48,
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: present ? ManagementColors.green : ManagementColors.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: present ? ManagementColors.green : const Color(0xffa9b5ae), width: 2),
              ),
              child: present ? const Icon(Icons.check, size: 20, color: Colors.white) : null,
            ),
          ),
        ),
      ),
    );
  }
}

/// The state of the roll call: « X / Y présents », and whether every change reached the API.
class RollCallBar extends StatelessWidget {
  const RollCallBar({super.key, required this.present, required this.expected, required this.pendingCount});

  final int present;
  final int expected;
  final int pendingCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final synced = pendingCount == 0;
    final color = synced ? ManagementColors.green : ManagementColors.pending;
    return Container(
      color: ManagementColors.mint,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 12,
        runSpacing: 4,
        children: [
          Text(
            '$present / $expected présents',
            style: theme.textTheme.titleMedium?.copyWith(color: ManagementColors.green, fontWeight: FontWeight.w800),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(synced ? Icons.cloud_done_outlined : Icons.cloud_upload_outlined, size: 16, color: color),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  synced ? 'Synchronisé' : '$pendingCount modification${pendingCount > 1 ? 's' : ''} en attente',
                  style: theme.textTheme.bodySmall?.copyWith(color: color),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
