import 'package:flutter/material.dart';

class CardTableHeader extends StatelessWidget {
  const CardTableHeader({
    super.key,
    required this.width,
    required this.child,
  });

  final TableColumnWidth width;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final Widget headerChild = DefaultTextStyle(
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: child,
      ),
    );

    if (width is FixedColumnWidth) {
      return SizedBox(
        width: (width as FixedColumnWidth).value,
        child: headerChild,
      );
    } else if (width is FlexColumnWidth) {
      return Expanded(
        flex: ((width as FlexColumnWidth).value * 10).toInt(),
        child: headerChild,
      );
    } else {
      return Expanded(child: headerChild);
    }
  }
}
