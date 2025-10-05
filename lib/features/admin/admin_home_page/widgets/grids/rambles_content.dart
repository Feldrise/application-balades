import 'package:balade/features/admin/admin_home_page/widgets/ramble_admin_card.dart';
import 'package:balade/features/admin/admin_home_page/widgets/ramble_compact_card.dart';
import 'package:balade/features/admin/admin_home_page/widgets/ramble_table_row.dart';
import 'package:balade/features/ramble/models/ramble/ramble.dart';
import 'package:flutter/material.dart';

enum RamblesViewMode { grid, compact, table, list }

class RamblesGrid extends StatelessWidget {
  const RamblesGrid({
    super.key,
    required this.rambles,
    required this.onEdit,
    required this.onCancel,
    this.viewMode = RamblesViewMode.grid,
    this.crossAxisCount = 2,
    this.childAspectRatio = 1.2,
    this.padding = const EdgeInsets.all(24),
    this.spacing = 24,
  });

  final List<Ramble> rambles;
  final Function(Ramble) onEdit;
  final Function(Ramble) onCancel;
  final RamblesViewMode viewMode;
  final int crossAxisCount;
  final double childAspectRatio;
  final EdgeInsets padding;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    switch (viewMode) {
      case RamblesViewMode.grid:
        return _buildOriginalGrid();
      case RamblesViewMode.compact:
        return _buildCompactGrid();
      case RamblesViewMode.table:
        return _buildTableView();
      case RamblesViewMode.list:
        return _buildListView();
    }
  }

  Widget _buildOriginalGrid() {
    return GridView.builder(
      padding: padding,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        mainAxisExtent: 540,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
      ),
      itemCount: rambles.length,
      itemBuilder: (context, index) {
        return RambleAdminCard(ramble: rambles[index], onEdit: () => onEdit(rambles[index]), onCancel: () => onCancel(rambles[index]));
      },
    );
  }

  Widget _buildCompactGrid() {
    // Determine responsive grid layout
    return LayoutBuilder(
      builder: (context, constraints) {
        int responsiveCrossAxisCount;
        if (constraints.maxWidth > 1200) {
          responsiveCrossAxisCount = 4; // Desktop: 4 columns
        } else if (constraints.maxWidth > 900) {
          responsiveCrossAxisCount = 3; // Large tablet: 3 columns
        } else if (constraints.maxWidth > 600) {
          responsiveCrossAxisCount = 2; // Small tablet: 2 columns
        } else {
          responsiveCrossAxisCount = 1; // Mobile: 1 column
        }

        return GridView.builder(
          padding: padding,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: responsiveCrossAxisCount,
            mainAxisExtent: 290, // Fixed height for consistent layout
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
          ),
          itemCount: rambles.length,
          itemBuilder: (context, index) {
            return RambleCompactCard(ramble: rambles[index], onEdit: () => onEdit(rambles[index]), onCancel: () => onCancel(rambles[index]));
          },
        );
      },
    );
  }

  Widget _buildTableView() {
    return Column(
      children: [
        // Table header
        RambleTableRow(ramble: null, isHeader: true),
        // Table rows
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: rambles.length,
            itemBuilder: (context, index) {
              return RambleTableRow(ramble: rambles[index], onEdit: () => onEdit(rambles[index]), onCancel: () => onCancel(rambles[index]));
            },
          ),
        ),
      ],
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: padding.copyWith(top: padding.top / 2, bottom: padding.bottom / 2),
      itemCount: rambles.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: spacing / 2),
          child: RambleAdminCard(ramble: rambles[index], onEdit: () => onEdit(rambles[index]), onCancel: () => onCancel(rambles[index])),
        );
      },
    );
  }
}

class RamblesListView extends StatelessWidget {
  const RamblesListView({super.key, required this.rambles, required this.onEdit, required this.onCancel, this.padding = const EdgeInsets.all(8)});

  final List<Ramble> rambles;
  final Function(Ramble) onEdit;
  final Function(Ramble) onCancel;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: padding,
      itemCount: rambles.length,
      itemBuilder: (context, index) {
        return RambleAdminCard(ramble: rambles[index], onEdit: () => onEdit(rambles[index]), onCancel: () => onCancel(rambles[index]));
      },
    );
  }
}
