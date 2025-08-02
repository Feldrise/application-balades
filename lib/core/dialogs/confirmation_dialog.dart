import 'package:flutter/material.dart';
import 'package:balade/core/dialogs/closable_dialog.dart';

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({super.key, required this.title, this.isDeletationConfirmation = false, this.validationButtonLabel, this.cancelButtonLabel, this.content});

  final String title;
  final String? content;
  final bool isDeletationConfirmation;

  final String? validationButtonLabel;
  final String? cancelButtonLabel;

  @override
  Widget build(BuildContext context) {
    return ClosableDialog(
      title: title,
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(cancelButtonLabel ?? "Annuler")),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: FilledButton.styleFrom(foregroundColor: isDeletationConfirmation ? Colors.white : null, backgroundColor: isDeletationConfirmation ? Colors.red : null),
          child: Text(validationButtonLabel ?? (isDeletationConfirmation ? "Supprimer" : "Continuer")),
        ),
      ],
      child: Text(content ?? "Êtes-vous sûr de vouloir ${isDeletationConfirmation ? "supprimer" : "continuer"} ?"),
    );
  }
}
