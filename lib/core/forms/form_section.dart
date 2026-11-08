import 'package:balade/core/forms/form_large_field.dart';
import 'package:balade/features/admin/design/design.dart';
import 'package:balade/themes/screen_helper.dart';
import 'package:flutter/material.dart';

/// A section of a form, drawn as a card with a sober title. Its [children] are laid out in two columns
/// when there is room and in one otherwise; a [FormLargeField] always takes a whole line.
class FormSection extends StatelessWidget {
  const FormSection({super.key, this.title, required this.children, this.actions = const []});

  final String? title;
  final List<Widget> children;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final twoColumns = constraints.maxWidth > ScreenHelper.breakpointTablet;
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if ((title ?? '').isNotEmpty) ...[
                  Row(
                    children: [
                      Expanded(child: Text(title!, style: theme.textTheme.titleMedium?.copyWith(color: ManagementColors.green))),
                      ...actions,
                    ],
                  ),
                  const SizedBox(height: 14),
                ],
                for (final line in _lines(twoColumns)) ...[line, const SizedBox(height: 16)],
              ]..removeLast(),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _lines(bool twoColumns) {
    if (!twoColumns) return children;

    final lines = <Widget>[];
    var i = 0;
    while (i < children.length) {
      final first = children[i];
      if (first is FormLargeField) {
        lines.add(first);
        i++;
        continue;
      }
      final second = i + 1 < children.length && children[i + 1] is! FormLargeField ? children[i + 1] : null;
      lines.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: first),
            const SizedBox(width: 16),
            Expanded(child: second ?? const SizedBox.shrink()),
          ],
        ),
      );
      i += second == null ? 1 : 2;
    }
    return lines;
  }
}
