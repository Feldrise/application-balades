import 'package:balade/features/admin/design/design.dart';
import 'package:balade/features/ramble/widget/ramble_form/ramble_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddRamblePage extends ConsumerStatefulWidget {
  const AddRamblePage({super.key});

  @override
  ConsumerState<AddRamblePage> createState() => _AddRamblePageState();
}

class _AddRamblePageState extends ConsumerState<AddRamblePage> {
  final GlobalKey<RambleFormState> _formKey = GlobalKey<RambleFormState>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ManagementPageHeader(title: 'Nouvelle balade', leading: ManagementBackButton()),
        Expanded(child: RambleForm(key: _formKey)),
        ManagementActionBar(
          actions: [
            OutlinedButton(onPressed: () => leaveManagementForm(context), child: const Text('Annuler')),
            FilledButton(onPressed: () async => await _formKey.currentState?.save(), child: const Text('Créer la balade')),
          ],
        ),
      ],
    );
  }
}
