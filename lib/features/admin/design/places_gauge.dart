import 'package:balade/features/admin/design/management_theme.dart';
import 'package:flutter/material.dart';

/// The places gauge: places taken over the capacity, amber once the balade is full.
/// Without a capacity, it reads « Sans limite ».
class PlacesGauge extends StatelessWidget {
  const PlacesGauge({super.key, required this.taken, required this.capacity});

  final int taken;
  final int? capacity;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w800);
    final max = capacity;
    if (max == null) return Text('Sans limite', style: style);

    final full = taken >= max;
    return Semantics(
      label: '$taken places prises sur $max',
      excludeSemantics: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 60,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: max == 0 ? 1 : (taken / max).clamp(0, 1),
                minHeight: 5,
                color: full ? ManagementColors.pending : ManagementColors.green,
                backgroundColor: ManagementColors.border,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Text('$taken/$max', style: style),
        ],
      ),
    );
  }
}
