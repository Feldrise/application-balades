import 'package:balade/features/authentication/authentication_provider.dart';
import 'package:balade/features/ramble/models/ramble/ramble.dart';
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
      future: RamblesService.instance.fetchRamble(int.parse(widget.id), authorization: ref.read(authenticationProvider)!.token),
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Modifier la Balade'),
            backgroundColor: Theme.of(context).colorScheme.surface,
            actions: [
              OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Annuler'),
              ),
              const SizedBox(width: 12),
              FilledButton(
                onPressed: snapshot.connectionState != ConnectionState.done
                    ? null
                    : () async {
                        await _formKey.currentState?.save();
                      },
                child: Text('Modifier la balade'),
              ),
              const SizedBox(width: 12),
            ],
          ),
          body: Builder(
            builder: (context) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Erreur lors de la récupération de la balade : ${snapshot.error}'));
              }

              final Ramble ramble = snapshot.data!;

              return RambleForm(key: _formKey, initialRamble: ramble);
            },
          ),
        );
      },
    );
  }
}
