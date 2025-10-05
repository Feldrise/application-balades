import 'package:balade/features/admin/admin_home_page/widgets/grids/rambles_content.dart';
import 'package:flutter/material.dart';

class ViewModeToggle extends StatelessWidget {
  const ViewModeToggle({super.key, required this.currentMode, required this.onModeChanged});

  final RamblesViewMode currentMode;
  final Function(RamblesViewMode) onModeChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(color: theme.colorScheme.surfaceVariant.withOpacity(0.3), borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildModeButton(context, Icons.grid_view, 'Grille', RamblesViewMode.grid, theme),
          _buildModeButton(context, Icons.view_module, 'Compacte', RamblesViewMode.compact, theme),
          _buildModeButton(context, Icons.table_rows, 'Tableau', RamblesViewMode.table, theme),
          _buildModeButton(context, Icons.view_list, 'Liste', RamblesViewMode.list, theme),
        ],
      ),
    );
  }

  Widget _buildModeButton(BuildContext context, IconData icon, String tooltip, RamblesViewMode mode, ThemeData theme) {
    final isSelected = currentMode == mode;

    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onModeChanged(mode),
          borderRadius: BorderRadius.circular(6),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: isSelected ? theme.colorScheme.primary : Colors.transparent, borderRadius: BorderRadius.circular(6)),
            child: Icon(icon, size: 20, color: isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurfaceVariant),
          ),
        ),
      ),
    );
  }
}
