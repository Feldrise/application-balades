import 'package:balade/core/dialogs/closable_dialog.dart';
import 'package:balade/features/guides/widgets/guide_form.dart';
import 'package:flutter/material.dart';

class AddGuideDialog extends StatefulWidget {
  const AddGuideDialog({super.key});

  @override
  State<AddGuideDialog> createState() => _AddGuideDialogState();
}

class _AddGuideDialogState extends State<AddGuideDialog> {
  final GlobalKey<GuideFormState> _formKey = GlobalKey<GuideFormState>();

  @override
  Widget build(BuildContext context) {
    return ClosableDialog(
      title: 'Ajouter un guide',
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Annuler')),
        const SizedBox(width: 8),
        FilledButton.icon(
          onPressed: () async {
            await _formKey.currentState?.save();
          },
          icon: const Icon(Icons.save_outlined),
          label: const Text('Enregistrer'),
        ),
      ],
      child: GuideForm(key: _formKey),
    );
  }
}
