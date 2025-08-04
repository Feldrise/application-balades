import 'package:balade/core/dates.dart';
import 'package:balade/core/widgets/searchable_dropdown.dart';
import 'package:balade/features/authentication/authentication_provider.dart';
import 'package:balade/features/guides/guides_service.dart';
import 'package:balade/features/guides/models/guide/guide.dart';
import 'package:balade/features/ramble/models/ramble/ramble.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class RamblesFiltersSidebar extends ConsumerWidget {
  const RamblesFiltersSidebar({
    super.key,
    required this.selectedStatus,
    required this.selectedType,
    required this.selectedDifficulty,
    required this.selectedGuideId,
    required this.dateFrom,
    required this.dateTo,
    required this.onStatusChanged,
    required this.onTypeChanged,
    required this.onDifficultyChanged,
    required this.onGuideChanged,
    required this.onDateFromChanged,
    required this.onDateToChanged,
    required this.onClearFilters,
  });

  final String? selectedStatus;
  final String? selectedType;
  final String? selectedDifficulty;
  final int? selectedGuideId;
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final ValueChanged<String?> onStatusChanged;
  final ValueChanged<String?> onTypeChanged;
  final ValueChanged<String?> onDifficultyChanged;
  final ValueChanged<int?> onGuideChanged;
  final ValueChanged<DateTime?> onDateFromChanged;
  final ValueChanged<DateTime?> onDateToChanged;
  final VoidCallback onClearFilters;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Container(
      width: 320,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(right: BorderSide(color: theme.dividerColor)),
      ),
      child: Column(
        children: [
          _buildHeader(theme),
          Expanded(child: _buildFiltersContent(context, ref, theme)),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
        border: Border(bottom: BorderSide(color: theme.dividerColor)),
      ),
      child: Row(
        children: [
          Icon(Icons.tune, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Text(
            'Filtres',
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600, color: theme.colorScheme.primary),
          ),
          const Spacer(),
          TextButton(onPressed: onClearFilters, child: const Text('Effacer tout')),
        ],
      ),
    );
  }

  Widget _buildFiltersContent(BuildContext context, WidgetRef ref, ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quick filters section
          _buildFilterSection(theme, 'Filtres rapides', [_buildQuickFilterChips(context, theme)]),

          const SizedBox(height: 32),

          // Status filter
          _buildFilterSection(theme, 'Statut', [_buildStatusFilter(theme)]),

          const SizedBox(height: 24),

          // Type filter
          _buildFilterSection(theme, 'Type de balade', [_buildTypeFilter(theme)]),

          const SizedBox(height: 24),

          // Difficulty filter
          _buildFilterSection(theme, 'Difficulté', [_buildDifficultyFilter(theme)]),

          const SizedBox(height: 24),

          // Guide filter
          _buildFilterSection(theme, 'Guide', [_buildGuideFilter(ref, theme)]),

          const SizedBox(height: 24),

          // Date range filters
          _buildFilterSection(theme, 'Période', [_buildDateRangeFilters(theme)]),
        ],
      ),
    );
  }

  Widget _buildFilterSection(ThemeData theme, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600, color: theme.colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildQuickFilterChips(BuildContext context, ThemeData theme) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        FilterChip(
          label: const Text('Publié uniquement'),
          selected: selectedStatus == 'published',
          onSelected: (selected) {
            onStatusChanged(selected ? 'published' : null);
          },
        ),
        FilterChip(
          label: const Text('Cette semaine'),
          selected: dateFrom != null && dateFrom!.weekOfYear == DateTime.now().weekOfYear,
          onSelected: (selected) {
            if (selected) {
              final now = DateTime.now();
              final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
              final endOfWeek = startOfWeek.add(const Duration(days: 6));
              onDateFromChanged(startOfWeek);
              onDateToChanged(endOfWeek);
            } else {
              onDateFromChanged(null);
              onDateToChanged(null);
            }
          },
        ),
        FilterChip(
          label: const Text('Ce mois'),
          selected: dateFrom != null && dateFrom!.month == DateTime.now().month,
          onSelected: (selected) {
            if (selected) {
              final now = DateTime.now();
              final startOfMonth = DateTime(now.year, now.month, 1);
              final endOfMonth = DateTime(now.year, now.month + 1, 0);
              onDateFromChanged(startOfMonth);
              onDateToChanged(endOfMonth);
            } else {
              onDateFromChanged(null);
              onDateToChanged(null);
            }
          },
        ),
      ],
    );
  }

  Widget _buildStatusFilter(ThemeData theme) {
    return DropdownButtonFormField<String>(
      value: selectedStatus,
      decoration: const InputDecoration(border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
      items: const [
        DropdownMenuItem(value: null, child: Text('Tous les statuts')),
        DropdownMenuItem(value: 'published', child: Text('✅ Publié')),
        DropdownMenuItem(value: 'draft', child: Text('📝 Brouillon')),
        DropdownMenuItem(value: 'cancelled', child: Text('❌ Annulé')),
        DropdownMenuItem(value: 'completed', child: Text('✔️ Terminé')),
      ],
      onChanged: onStatusChanged,
    );
  }

  Widget _buildTypeFilter(ThemeData theme) {
    return DropdownButtonFormField<String>(
      value: selectedType,
      decoration: const InputDecoration(border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
      items: [
        const DropdownMenuItem(value: null, child: Text('Tous les types')),
        ...rambleTypeLabels.entries.map(
          (entry) => DropdownMenuItem(
            value: entry.key,
            child: Row(children: [Icon(rambleTypeIcons[entry.key], size: 18), const SizedBox(width: 8), Text(entry.value)]),
          ),
        ),
      ],
      onChanged: onTypeChanged,
    );
  }

  Widget _buildDifficultyFilter(ThemeData theme) {
    return DropdownButtonFormField<String>(
      value: selectedDifficulty,
      decoration: const InputDecoration(border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
      items: [
        const DropdownMenuItem(value: null, child: Text('Toutes difficultés')),
        ...rambleDifficultyLabels.entries.map(
          (entry) => DropdownMenuItem(
            value: entry.key,
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(color: rambleDifficultyColors[entry.key], shape: BoxShape.circle),
                ),
                const SizedBox(width: 8),
                Text(entry.value),
              ],
            ),
          ),
        ),
      ],
      onChanged: onDifficultyChanged,
    );
  }

  Widget _buildGuideFilter(WidgetRef ref, ThemeData theme) {
    return SearchableDropdown<Guide>(
      label: "Sélectionner un guide",
      value: selectedGuideId != null ? Guide(selectedGuideId!, firstName: '', lastName: '', email: '', isActive: true) : null,
      displayStringForOption: (guide) => '${guide.firstName} ${guide.lastName}',
      optionsBuilder: (textEditingValue) async {
        final auth = ref.read(authenticationProvider);
        final guides = await GuidesService.instance.fetchGuides(textEditingValue.text, authorization: auth?.token);
        return guides;
      },
      onSelected: (guide) => onGuideChanged(guide?.id),
      shouldResetOnTap: false,
    );
  }

  Widget _buildDateRangeFilters(ThemeData theme) {
    return Column(
      children: [
        DateTimeFormField(
          initialValue: dateFrom,
          dateFormat: DateFormat('dd/MM/yyyy'),
          decoration: const InputDecoration(
            labelText: 'Date de début',
            border: OutlineInputBorder(),
            suffixIcon: Icon(Icons.calendar_today),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          mode: DateTimeFieldPickerMode.date,
          onChanged: onDateFromChanged,
        ),
        const SizedBox(height: 16),
        DateTimeFormField(
          initialValue: dateTo,
          dateFormat: DateFormat('dd/MM/yyyy'),
          decoration: const InputDecoration(
            labelText: 'Date de fin',
            border: OutlineInputBorder(),
            suffixIcon: Icon(Icons.calendar_today),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          mode: DateTimeFieldPickerMode.date,
          onChanged: onDateToChanged,
        ),
      ],
    );
  }
}
