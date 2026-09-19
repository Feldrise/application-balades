import 'package:balade/core/dialogs/closable_dialog.dart';
import 'package:balade/core/widgets/error_snackbar.dart';
import 'package:balade/core/widgets/searchable_dropdown.dart';
import 'package:balade/features/authentication/authentication_provider.dart';
import 'package:balade/features/guides/guides_service.dart';
import 'package:balade/features/guides/models/guide/guide.dart';
import 'package:balade/features/guides/widgets/guide_form.dart';
import 'package:balade/features/users/models/user/user.dart';
import 'package:balade/features/users/user_display.dart';
import 'package:balade/features/users/users_service.dart';
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
  User? _selectedUser;
  bool _linkingUser = false;

  Future<void> _linkUser() async {
    final userId = _selectedUser?.id;
    if (userId == null) {
      ErrorSnackbar.show(context, 'Veuillez sélectionner un utilisateur');
      return;
    }

    final token = ref.read(authenticationProvider)?.token;
    if (token == null) return;

    setState(() => _linkingUser = true);
    try {
      await GuidesService.instance.linkUserToGuide(widget.guideId, userId, authorization: token);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Utilisateur lié avec succès. L\'utilisateur doit se reconnecter pour obtenir le rôle guide.')),
        );
      }
    } catch (e) {
      if (mounted) ErrorSnackbar.show(context, 'Erreur : $e');
    } finally {
      if (mounted) setState(() => _linkingUser = false);
    }
  }

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

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GuideForm(key: _formKey, initialGuide: guide),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Lier un utilisateur', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 8),
                  const Text('Associez ce profil guide à un compte utilisateur existant. Le rôle guide sera accordé automatiquement.'),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: SearchableDropdown<User>(
                          label: 'Rechercher un utilisateur',
                          value: _selectedUser,
                          displayStringForOption: userDisplayLabel,
                          optionsBuilder: (textEditingValue) async {
                            final token = ref.read(authenticationProvider)?.token;
                            if (token == null) return [];

                            return UsersService.instance.searchUsers(textEditingValue.text, authorization: token);
                          },
                          onSelected: (user) {
                            setState(() => _selectedUser = user);
                          },
                          shouldResetOnTap: false,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: FilledButton.icon(
                          onPressed: _linkingUser || _selectedUser == null ? null : _linkUser,
                          icon: _linkingUser ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.link),
                          label: const Text('Lier'),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
