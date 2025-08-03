import 'package:flutter/material.dart';

class DurationPicker extends StatefulWidget {
  const DurationPicker({super.key, required this.initialDuration, required this.onChanged, this.label = 'Durée estimée', this.maxHours = 8});

  final Duration initialDuration;
  final Function(Duration) onChanged;
  final String label;
  final int maxHours;

  @override
  State<DurationPicker> createState() => _DurationPickerState();
}

class _DurationPickerState extends State<DurationPicker> {
  late int _selectedHours;
  late int _selectedMinutes;

  @override
  void initState() {
    super.initState();
    _selectedHours = widget.initialDuration.inHours;
    _selectedMinutes = widget.initialDuration.inMinutes.remainder(60);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<int>(
            value: _selectedHours,
            decoration: InputDecoration(labelText: widget.label, suffixText: 'heures', icon: const Icon(Icons.schedule)),
            items: List.generate(widget.maxHours, (index) => index + 1).map((hours) => DropdownMenuItem(value: hours, child: Text('$hours heure${hours > 1 ? 's' : ''}'))).toList(),
            onChanged: (value) {
              setState(() {
                _selectedHours = value ?? 1;
                widget.onChanged(Duration(hours: _selectedHours, minutes: _selectedMinutes));
              });
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: DropdownButtonFormField<int>(
            value: _selectedMinutes,
            decoration: const InputDecoration(labelText: 'Minutes', suffixText: 'min'),
            items: const [0, 15, 30, 45].map((min) => DropdownMenuItem(value: min, child: Text('$min min'))).toList(),
            onChanged: (value) {
              setState(() {
                _selectedMinutes = value ?? 0;
                widget.onChanged(Duration(hours: _selectedHours, minutes: _selectedMinutes));
              });
            },
          ),
        ),
      ],
    );
  }
}
