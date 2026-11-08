import 'package:balade/features/admin/design/management_theme.dart';
import 'package:flutter/material.dart';

/// A white panel whose [children] are rows separated by thin lines: the base of every list
/// of the management area.
class ManagementPanel extends StatelessWidget {
  const ManagementPanel({super.key, required this.children, this.divided = true});

  final List<Widget> children;

  /// Draws a line between the children.
  final bool divided;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ManagementColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: ManagementColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < children.length; i++) ...[if (divided && i > 0) const Divider(height: 1), children[i]],
          ],
        ),
      ),
    );
  }
}

/// A row of a [ManagementPanel], tappable as a whole.
class ManagementRow extends StatelessWidget {
  const ManagementRow({super.key, required this.child, this.onTap, this.padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 10)});

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(padding: padding, child: child),
    );
  }
}

/// A group label inside a [ManagementPanel], e.g. « CETTE SEMAINE · 3 ».
class ManagementSectionLabel extends StatelessWidget {
  const ManagementSectionLabel(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ManagementColors.subtleSurface,
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 6),
      child: Text(label.toUpperCase(), style: Theme.of(context).textTheme.labelSmall?.copyWith(color: ManagementColors.green, letterSpacing: 0.8)),
    );
  }
}

/// The column headings row of a table, on desktop.
class ManagementTableHeader extends StatelessWidget {
  const ManagementTableHeader({super.key, required this.child});

  /// A row of [ManagementColumnLabel]s, laid out like the table rows.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(color: ManagementColors.background, padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9), child: child);
  }
}

class ManagementColumnLabel extends StatelessWidget {
  const ManagementColumnLabel(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) => Text(label.toUpperCase(), style: Theme.of(context).textTheme.labelSmall);
}
