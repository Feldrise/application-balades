import 'package:flutter/material.dart';
import 'package:balade/core/widgets/card_table/card_table_header.dart';

class CardTable extends StatelessWidget {
  const CardTable({super.key, required this.headers, required this.rows, required this.columnWidths, this.showHeaders = true, this.backgroundColor, this.isScrollable = false})
    : assert(headers.length == columnWidths.length, "Headers and columnWidths must have the same length");

  final List<Widget> headers;
  final List<Widget> rows;

  final List<TableColumnWidth> columnWidths;
  final bool showHeaders;

  final Color? backgroundColor;

  final bool isScrollable;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (showHeaders)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [for (int i = 0; i < headers.length; i++) CardTableHeader(width: columnWidths[i], child: headers[i])],
              ),
            ),
          if (isScrollable)
            Expanded(
              child: SingleChildScrollView(
                child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [for (final row in rows) row]),
              ),
            )
          else
            for (final row in rows) row,
        ],
      ),
    );
  }
}
