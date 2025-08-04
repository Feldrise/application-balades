import 'package:balade/features/admin/admin_home_page/widgets/ramble_admin_card.dart';
import 'package:balade/features/ramble/models/ramble/ramble.dart';
import 'package:flutter/material.dart';

class RamblesGrid extends StatelessWidget {
  const RamblesGrid({
    super.key,
    required this.rambles,
    required this.onEdit,
    required this.onToggleStatus,
    this.crossAxisCount = 2,
    this.childAspectRatio = 1.2,
    this.padding = const EdgeInsets.all(24),
    this.spacing = 24,
  });

  final List<Ramble> rambles;
  final Function(Ramble) onEdit;
  final Function(Ramble) onToggleStatus;
  final int crossAxisCount;
  final double childAspectRatio;
  final EdgeInsets padding;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: padding,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
      ),
      itemCount: rambles.length,
      itemBuilder: (context, index) {
        return RambleAdminCard(ramble: rambles[index], onEdit: () => onEdit(rambles[index]), onToggleStatus: () => onToggleStatus(rambles[index]));
      },
    );
  }
}

class RamblesListView extends StatelessWidget {
  const RamblesListView({super.key, required this.rambles, required this.onEdit, required this.onToggleStatus, this.padding = const EdgeInsets.all(8)});

  final List<Ramble> rambles;
  final Function(Ramble) onEdit;
  final Function(Ramble) onToggleStatus;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: padding,
      itemCount: rambles.length,
      itemBuilder: (context, index) {
        return RambleAdminCard(ramble: rambles[index], onEdit: () => onEdit(rambles[index]), onToggleStatus: () => onToggleStatus(rambles[index]));
      },
    );
  }
}
