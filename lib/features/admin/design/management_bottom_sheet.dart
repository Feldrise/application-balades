import 'package:flutter/material.dart';

/// Opens a bottom sheet of the management area: a drag handle, a [title], an optional [subtitle],
/// then the content built by [builder]. Scrolls when the content is taller than the screen.
Future<T?> showManagementBottomSheet<T>({required BuildContext context, required String title, String? subtitle, required WidgetBuilder builder}) {
  final theme = Theme.of(context);
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (context) => Theme(
      data: theme,
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 20 + MediaQuery.viewInsetsOf(context).bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: theme.textTheme.titleLarge),
            if (subtitle != null) Text(subtitle, style: theme.textTheme.bodySmall),
            const SizedBox(height: 12),
            builder(context),
          ],
        ),
      ),
    ),
  );
}
