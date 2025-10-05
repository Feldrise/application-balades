import 'package:balade/features/admin/admin_home_page/widgets/rambles_list.dart';
import 'package:flutter/material.dart';

class AdminRamblesPage extends StatelessWidget {
  const AdminRamblesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(backgroundColor: Colors.transparent, body: RamblesList());
  }
}
