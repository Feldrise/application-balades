import 'package:balade/core/dialogs/closable_dialog.dart';
import 'package:balade/features/authentication/authentication_provider.dart';
import 'package:balade/features/guides/guides_service.dart';
import 'package:balade/features/guides/models/guide/guide.dart';
import 'package:balade/features/guides/widgets/guide_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditGuideDialog extends ConsumerStatefulWidget {
  const EditGuideDialog({super.key, required this.guideId});

  final int guideId;

  @override
  ConsumerState<EditGuideDialog> createState() => _EditGuideDialogState();
}

class _EditGuideDialogState extends ConsumerState<EditGuideDialog> {
  final GlobalKey<GuideFormState> _formKey = GlobalKey<GuideFormState>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: GuidesService.instance.fetchGuide(widget.guideId, authorization: ref.read(authenticationProvider)?.token),
      builder: (context, snapshot) {
        return ClosableDialog(
          title: 'Modifier un guide',
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Annuler')),
            const SizedBox(width: 8),
            FilledButton.icon(
              onPressed: snapshot.hasData
                  ? () async {
                      await _formKey.currentState?.save();
                    }
                  : null,
              icon: const Icon(Icons.save_outlined),
              label: const Text('Enregistrer'),
            ),
          ],
          child: Builder(
            builder: (context) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(height: 200, child: Center(child: CircularProgressIndicator()));
              }

              if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('Erreur lors du chargement du guide: ${snapshot.error}', style: TextStyle(color: Theme.of(context).colorScheme.error)),
                );
              }

              final Guide guide = snapshot.data as Guide;

              return GuideForm(key: _formKey, initialGuide: guide);
            },
          ),
        );
      },
    );
  }
}
