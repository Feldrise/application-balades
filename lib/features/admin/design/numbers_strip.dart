import 'package:balade/features/admin/design/management_theme.dart';
import 'package:flutter/material.dart';

/// One figure of a [NumbersStrip].
class StripNumber {
  const StripNumber({required this.value, required this.label, this.color, this.highlighted = false});

  final String value;
  final String label;
  final Color? color;

  /// Shown on a mint background, e.g. « présents ».
  final bool highlighted;
}

/// A strip of figures that wraps to a new line on narrow screens instead of scrolling sideways:
/// 3 per line under 600 px, all on one line above.
class NumbersStrip extends StatelessWidget {
  const NumbersStrip({super.key, required this.numbers});

  final List<StripNumber> numbers;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final perLine = constraints.maxWidth < 600 ? 3 : numbers.length;
        final width = constraints.maxWidth / perLine;
        return Wrap(
          children: [
            for (final n in numbers)
              Container(
                width: width,
                color: n.highlighted ? ManagementColors.mint : null,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(n.value, style: theme.textTheme.titleLarge?.copyWith(fontSize: 20, color: n.color ?? ManagementColors.text)),
                    Text(n.label, style: theme.textTheme.bodySmall, maxLines: 2),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}
