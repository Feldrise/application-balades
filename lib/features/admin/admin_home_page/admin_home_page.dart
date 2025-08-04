import 'package:balade/features/admin/admin_home_page/widgets/rambles_list.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Administration')),
      body: const RamblesList(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.go("/admin/nouvelle-balade");
        },
        icon: const Icon(Icons.add),
        label: const Text('Ajouter une balade'),
      ),
    );
  }
}
