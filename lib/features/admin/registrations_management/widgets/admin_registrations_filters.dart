import 'package:balade/features/admin/registrations_management/providers/admin_registrations_provider.dart';
import 'package:balade/features/authentication/authentication_provider.dart';
import 'package:balade/features/ramble/models/ramble/ramble.dart';
import 'package:balade/features/ramble/rambles_service.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class AdminRegistrationsFilters extends ConsumerStatefulWidget {
  const AdminRegistrationsFilters({super.key});

  @override
  ConsumerState<AdminRegistrationsFilters> createState() => _AdminRegistrationsFiltersState();
}

class _AdminRegistrationsFiltersState extends ConsumerState<AdminRegistrationsFilters> {
  String? selectedStatus;
  DateTime? selectedDateFrom;
  DateTime? selectedDateTo;
  List<Ramble> availableRambles = [];
  int? selectedRambleId;
  bool isLoadingRambles = false;

  @override
  void initState() {
    super.initState();
    _loadRambles();
  }

  Future<void> _loadRambles() async {
    setState(() => isLoadingRambles = true);
    try {
      final auth = ref.read(authenticationProvider);
      final rambles = await RamblesService.instance.fetchRambles(authorization: auth?.token);
      setState(() {
        availableRambles = rambles;
        isLoadingRambles = false;
      });
    } catch (e) {
      setState(() => isLoadingRambles = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Compact header
            _buildCompactHeader(theme),
            const SizedBox(height: 12),
            
            // Quick filter chips only
            _buildQuickFilterChips(theme),
            
            // Detailed filters in expandable section
            if (!isMobile) ...[
              const SizedBox(height: 12),
              _buildCompactDetailedFilters(context, theme),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCompactHeader(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(Icons.tune, size: 18, color: theme.colorScheme.primary),
            const SizedBox(width: 6),
            Text(
              'Filtres',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
        TextButton(
          onPressed: _clearAllFilters,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            'Effacer',
            style: theme.textTheme.bodySmall,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickFilterChips(ThemeData theme) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        // Status filters
        _buildCompactChip('Confirmées', selectedStatus == 'confirmed', () => _setStatusFilter(selectedStatus == 'confirmed' ? null : 'confirmed'), theme),
        _buildCompactChip('En attente', selectedStatus == 'pending', () => _setStatusFilter(selectedStatus == 'pending' ? null : 'pending'), theme),
        _buildCompactChip('Liste d\'attente', selectedStatus == 'waiting_list', () => _setStatusFilter(selectedStatus == 'waiting_list' ? null : 'waiting_list'), theme),
        
        // Date filters
        _buildCompactChip('Aujourd\'hui', _isToday(selectedDateFrom), () => _setDateFilter(_isToday(selectedDateFrom) ? null : DateTime.now(), null), theme),
        _buildCompactChip('Cette semaine', _isThisWeek(selectedDateFrom, selectedDateTo), () => _setWeekFilter(!_isThisWeek(selectedDateFrom, selectedDateTo)), theme),
        _buildCompactChip('Ce mois', _isThisMonth(selectedDateFrom, selectedDateTo), () => _setMonthFilter(!_isThisMonth(selectedDateFrom, selectedDateTo)), theme),
      ],
    );
  }

  Widget _buildCompactChip(String label, bool isSelected, VoidCallback onTap, ThemeData theme) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primaryContainer : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? theme.colorScheme.primary : theme.colorScheme.outline,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: isSelected ? theme.colorScheme.onPrimaryContainer : theme.colorScheme.onSurfaceVariant,
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildCompactDetailedFilters(BuildContext context, ThemeData theme) {
    return Row(
      children: [
        // Ramble dropdown (compact)
        Expanded(
          flex: 2,
          child: DropdownButtonFormField<int>(
            value: selectedRambleId,
            decoration: InputDecoration(
              labelText: 'Balade',
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              labelStyle: theme.textTheme.bodySmall,
              isDense: true,
            ),
            items: [
              const DropdownMenuItem<int>(value: null, child: Text('Toutes')),
              ...availableRambles.map((ramble) => DropdownMenuItem<int>(
                value: ramble.id,
                child: Text(
                  ramble.title,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall,
                ),
              )),
            ],
            onChanged: (value) => _setRambleFilter(value),
            isExpanded: true,
          ),
        ),
        
        const SizedBox(width: 12),
        
        // Date range (compact)
        Expanded(
          flex: 3,
          child: Row(
            children: [
              Expanded(
                child: _buildCompactDateField(
                  label: 'Du',
                  value: selectedDateFrom,
                  onChanged: (date) => _setDateFilter(date, selectedDateTo),
                  theme: theme,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildCompactDateField(
                  label: 'Au',
                  value: selectedDateTo,
                  onChanged: (date) => _setDateFilter(selectedDateFrom, date),
                  theme: theme,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCompactDateField({
    required String label,
    required DateTime? value,
    required Function(DateTime?) onChanged,
    required ThemeData theme,
  }) {
    return DateTimeFormField(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        labelStyle: theme.textTheme.bodySmall,
        isDense: true,
      ),
      mode: DateTimeFieldPickerMode.date,
      initialValue: value,
      onChanged: onChanged,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      dateFormat: DateFormat('dd/MM/yy'),
    );
  }

  // Helper methods for date filtering
  bool _isToday(DateTime? date) {
    if (date == null) return false;
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  bool _isThisWeek(DateTime? startDate, DateTime? endDate) {
    if (startDate == null || endDate == null) return false;
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 6));
    return startDate.year == weekStart.year &&
        startDate.month == weekStart.month &&
        startDate.day == weekStart.day &&
        endDate.year == weekEnd.year &&
        endDate.month == weekEnd.month &&
        endDate.day == weekEnd.day;
  }

  bool _isThisMonth(DateTime? startDate, DateTime? endDate) {
    if (startDate == null || endDate == null) return false;
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    final monthEnd = DateTime(now.year, now.month + 1, 0);
    return startDate.year == monthStart.year &&
        startDate.month == monthStart.month &&
        startDate.day == monthStart.day &&
        endDate.year == monthEnd.year &&
        endDate.month == monthEnd.month &&
        endDate.day == monthEnd.day;
  }

  // Filter action methods
  void _setStatusFilter(String? status) {
    setState(() => selectedStatus = status);
    _applyFilters();
  }

  void _setRambleFilter(int? rambleId) {
    setState(() => selectedRambleId = rambleId);
    _applyFilters();
  }

  void _setDateFilter(DateTime? dateFrom, DateTime? dateTo) {
    setState(() {
      selectedDateFrom = dateFrom;
      selectedDateTo = dateTo;
    });
    _applyFilters();
  }

  void _setWeekFilter(bool selected) {
    if (selected) {
      final now = DateTime.now();
      final weekStart = now.subtract(Duration(days: now.weekday - 1));
      final weekEnd = weekStart.add(const Duration(days: 6));
      _setDateFilter(weekStart, weekEnd);
    } else {
      _setDateFilter(null, null);
    }
  }

  void _setMonthFilter(bool selected) {
    if (selected) {
      final now = DateTime.now();
      final monthStart = DateTime(now.year, now.month, 1);
      final monthEnd = DateTime(now.year, now.month + 1, 0);
      _setDateFilter(monthStart, monthEnd);
    } else {
      _setDateFilter(null, null);
    }
  }

  void _applyFilters() {
    final auth = ref.read(authenticationProvider);
    final currentFilters = ref.read(adminRegistrationsProvider).filters;
    final newFilters = currentFilters.copyWith(
      status: selectedStatus,
      rambleId: selectedRambleId,
      dateFrom: selectedDateFrom,
      dateTo: selectedDateTo,
    );
    ref.read(adminRegistrationsProvider.notifier).updateFilters(newFilters, authorization: auth?.token);
  }

  void _clearAllFilters() {
    setState(() {
      selectedStatus = null;
      selectedRambleId = null;
      selectedDateFrom = null;
      selectedDateTo = null;
    });
    final auth = ref.read(authenticationProvider);
    ref.read(adminRegistrationsProvider.notifier).clearFilters(authorization: auth?.token);
  }
}