import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Administration')),
      body: const Center(child: Text('Welcome to the Admin Home Page')),
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
