import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:balade/features/ramble/widget/ramble_form/ramble_form.dart';

class RambleFormDemoPage extends ConsumerStatefulWidget {
  const RambleFormDemoPage({super.key});

  @override
  ConsumerState<RambleFormDemoPage> createState() => _RambleFormDemoPageState();
}

class _RambleFormDemoPageState extends ConsumerState<RambleFormDemoPage> {
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
          FilledButton(onPressed: () {}, child: Text('Créer la balade')),
          const SizedBox(width: 12),
        ],
      ),
      body: Center(child: RambleForm()),
    );
  }
}
