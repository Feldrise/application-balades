import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:balade/features/ramble/widget/ramble_form/ramble_form.dart';

class AddRamblePage extends ConsumerStatefulWidget {
  const AddRamblePage({super.key});

  @override
  ConsumerState<AddRamblePage> createState() => _AddRamblePageState();
}

class _AddRamblePageState extends ConsumerState<AddRamblePage> {
  final GlobalKey<RambleFormState> _formKey = GlobalKey<RambleFormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nouvelle Balade'),
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
            onPressed: () async {
              await _formKey.currentState?.save();
            },
            child: Text('Créer la balade'),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Center(child: RambleForm(key: _formKey)),
    );
  }
}
