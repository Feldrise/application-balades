import 'package:flutter/material.dart';
import 'package:balade/core/dialogs/dialog_header.dart';
import 'package:balade/themes/screen_helper.dart';

class ClosableDialog extends StatelessWidget {
  const ClosableDialog({super.key, this.title, required this.child, this.actions = const [], this.maxWidth = 670, this.isClosable = true});

  final String? title;
  final Widget child;
  final List<Widget> actions;

  final double maxWidth;

  final bool isClosable;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).colorScheme.surface,
      surfaceTintColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth),
        padding: EdgeInsets.symmetric(vertical: title != null ? ScreenHelper.instance.horizontalPadding : 20, horizontal: ScreenHelper.instance.horizontalPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // The header
            DialogHeader(title: title, isClosable: isClosable),
            if (title != null) const SizedBox(height: 12),

            // The content
            Flexible(child: child),
            const SizedBox(height: 20),

            // The actions
            Row(mainAxisAlignment: MainAxisAlignment.end, children: actions),
          ],
        ),
      ),
    );
  }
}
