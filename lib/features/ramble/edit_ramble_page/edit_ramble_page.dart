import 'package:balade/features/admin/design/design.dart';
import 'package:balade/features/authentication/authentication_provider.dart';
import 'package:balade/features/ramble/rambles_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:balade/features/ramble/widget/ramble_form/ramble_form.dart';

class EditRamblePage extends ConsumerStatefulWidget {
  const EditRamblePage({super.key, required this.id});

  final String id;

  @override
  ConsumerState<EditRamblePage> createState() => _EditRamblePageState();
}

class _EditRamblePageState extends ConsumerState<EditRamblePage> {
  final GlobalKey<RambleFormState> _formKey = GlobalKey<RambleFormState>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: RamblesService.instance.fetchRamble(int.parse(widget.id), includeUnpublished: true, authorization: ref.read(authenticationProvider)!.token),
      builder: (context, snapshot) {
        final loaded = snapshot.connectionState == ConnectionState.done && !snapshot.hasError;
        return Column(
          children: [
            const ManagementPageHeader(title: 'Modifier la balade', leading: ManagementBackButton()),
            Expanded(
              child: Builder(
                builder: (context) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Erreur lors de la récupération de la balade : ${snapshot.error}'));
                  }

                  return RambleForm(key: _formKey, initialRamble: snapshot.data!);
                },
              ),
            ),
            ManagementActionBar(
              actions: [
                OutlinedButton(onPressed: () => leaveManagementForm(context), child: const Text('Annuler')),
                FilledButton(onPressed: loaded ? () async => await _formKey.currentState?.save() : null, child: const Text('Enregistrer')),
              ],
            ),
          ],
        );
      },
    );
  }
}
