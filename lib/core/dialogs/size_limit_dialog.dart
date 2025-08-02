import 'package:flutter/material.dart';
import 'package:balade/core/dialogs/closable_dialog.dart';

class SizeLimitDialog extends StatelessWidget {
  const SizeLimitDialog({super.key, this.title = "Image trop lourde", this.content = "L'image ne doit pas dépasser 5MB"});

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return ClosableDialog(
      title: title,
      actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("Ok"))],
      child: Text(content),
    );
  }
}
