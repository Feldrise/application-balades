import 'package:balade/core/widgets/searchable_dropdown.dart';
import 'package:balade/features/authentication/authentication_provider.dart';
import 'package:balade/features/guides/guides_service.dart';
import 'package:balade/features/guides/models/guide/guide.dart';
import 'package:balade/features/ramble/models/ramble/ramble.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class RamblesFiltersPanel extends ConsumerWidget {
  const RamblesFiltersPanel({
    super.key,
    required this.selectedCancellationStatus,
    required this.selectedType,
    required this.selectedDifficulty,
    required this.selectedGuideId,
    required this.dateFrom,
    required this.dateTo,
    required this.onCancellationStatusChanged,
    required this.onTypeChanged,
    required this.onDifficultyChanged,
    required this.onGuideChanged,
    required this.onDateFromChanged,
    required this.onDateToChanged,
    required this.onClearFilters,
  });

  final bool? selectedCancellationStatus; // null = all, false = active, true = cancelled
  final String? selectedType;
  final String? selectedDifficulty;
  final int? selectedGuideId;
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final ValueChanged<bool?> onCancellationStatusChanged;
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
        border: Border(bottom: BorderSide(color: theme.dividerColor)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_buildHeader(theme), const SizedBox(height: 16), _buildFiltersContent(context, ref, theme)]),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Row(
      children: [
        Text('Filtres', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
        const Spacer(),
        TextButton.icon(onPressed: onClearFilters, icon: const Icon(Icons.clear_all), label: const Text('Effacer les filtres')),
      ],
    );
  }

  Widget _buildFiltersContent(BuildContext context, WidgetRef ref, ThemeData theme) {
    return Column(
      children: [
        // Filter options in a responsive layout
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            // Cancellation Status filter
            SizedBox(
              width: 200,
              child: DropdownButtonFormField<bool?>(
                value: selectedCancellationStatus,
                decoration: const InputDecoration(labelText: 'Statut', border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
                items: const [
                  DropdownMenuItem(value: null, child: Text('Toutes les balades')),
                  DropdownMenuItem(value: false, child: Text('Actives')),
                  DropdownMenuItem(value: true, child: Text('Annulées')),
                ],
                onChanged: onCancellationStatusChanged,
              ),
            ),

            // Type filter
            SizedBox(
              width: 200,
              child: DropdownButtonFormField<String>(
                value: selectedType,
                decoration: const InputDecoration(labelText: 'Type', border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
                items: [
                  const DropdownMenuItem(value: null, child: Text('Tous les types')),
                  ...rambleTypeLabels.entries.map((entry) => DropdownMenuItem(value: entry.key, child: Text(entry.value))),
                ],
                onChanged: onTypeChanged,
              ),
            ),

            // Difficulty filter
            SizedBox(
              width: 200,
              child: DropdownButtonFormField<String>(
                value: selectedDifficulty,
                decoration: const InputDecoration(labelText: 'Difficulté', border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
                items: [
                  const DropdownMenuItem(value: null, child: Text('Toutes difficultés')),
                  ...rambleDifficultyLabels.entries.map((entry) => DropdownMenuItem(value: entry.key, child: Text(entry.value))),
                ],
                onChanged: onDifficultyChanged,
              ),
            ),

            // Guide filter
            SizedBox(
              width: 250,
              child: SearchableDropdown<Guide>(
                label: "Guide",
                value: selectedGuideId != null ? Guide(selectedGuideId!, firstName: '', lastName: '', email: '', isActive: true) : null,
                displayStringForOption: (guide) => '${guide.firstName} ${guide.lastName}',
                optionsBuilder: (textEditingValue) async {
                  final auth = ref.read(authenticationProvider);
                  final guides = await GuidesService.instance.fetchGuides(textEditingValue.text, authorization: auth?.token);
                  return guides;
                },
                onSelected: (guide) => onGuideChanged(guide?.id),
                shouldResetOnTap: false,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Date range filters
        Row(
          children: [
            Expanded(
              child: DateTimeFormField(
                initialValue: dateFrom,
                dateFormat: DateFormat('dd/MM/yyyy'),
                decoration: const InputDecoration(
                  labelText: 'Date de début',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                mode: DateTimeFieldPickerMode.date,
                onChanged: onDateFromChanged,
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: DateTimeFormField(
                initialValue: dateTo,
                dateFormat: DateFormat('dd/MM/yyyy'),
                decoration: const InputDecoration(
                  labelText: 'Date de fin',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                mode: DateTimeFieldPickerMode.date,
                onChanged: onDateToChanged,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
