import 'package:flutter/material.dart';

class CardTableRow extends StatelessWidget {
  const CardTableRow({
    super.key,
    required this.index,
    required this.columnWidths,
    required this.cellPadding,
    required this.children,
    this.backgroundColor,
    this.shape,
    this.fullWidthChild,
    this.mainPadding = const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
  });

  final int index;
  final List<Widget> children;
  final List<TableColumnWidth> columnWidths;

  final EdgeInsets cellPadding;
  final EdgeInsets mainPadding;

  final Color? backgroundColor;
  final ShapeBorder? shape;

  final Widget? fullWidthChild;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor ?? Theme.of(context).colorScheme.surfaceContainer,
      surfaceTintColor: backgroundColor ?? Theme.of(context).colorScheme.surfaceContainer,
      shape: shape,
      child: Padding(
        padding: mainPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [for (int i = 0; i < children.length; i++) _createDataCell(width: columnWidths[i], child: children[i])],
            ),
            if (fullWidthChild != null) ...[const SizedBox(height: 12), fullWidthChild!],
          ],
        ),
      ),
    );
  }

  Widget _createDataCell({required TableColumnWidth width, required Widget child}) {
    final Widget rowChild = Padding(padding: cellPadding, child: child);

    if (width is FixedColumnWidth) {
      return SizedBox(width: (width).value, child: rowChild);
    } else if (width is FlexColumnWidth) {
      return Expanded(flex: ((width).value * 10).toInt(), child: rowChild);
    } else {
      return Expanded(child: rowChild);
    }
  }
}
