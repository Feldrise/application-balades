import 'package:balade/features/reservations/reservation_draft.dart';
import 'package:flutter/material.dart';

/// One participant of the reservation: first name, last name and tariff. Only the contact gives an email.
class ReservationParticipantLine extends StatefulWidget {
  const ReservationParticipantLine({super.key, required this.participant, required this.number, required this.tariffLabels, required this.onChanged, this.onRemove, this.canBeBooker = true});

  final DraftParticipant participant;
  final int number;

  /// Tariffs to choose from; empty when the ramble has no tariff choice.
  final List<String> tariffLabels;
  final void Function({String? firstName, String? lastName, String? priceLabel, bool? isBooker}) onChanged;
  final VoidCallback? onRemove;

  /// False when the booker is already a participant of the reservation.
  final bool canBeBooker;

  @override
  State<ReservationParticipantLine> createState() => _ReservationParticipantLineState();
}

class _ReservationParticipantLineState extends State<ReservationParticipantLine> {
  late final TextEditingController _firstName = TextEditingController(text: widget.participant.firstName);
  late final TextEditingController _lastName = TextEditingController(text: widget.participant.lastName);

  @override
  void didUpdateWidget(ReservationParticipantLine oldWidget) {
    super.didUpdateWidget(oldWidget);
    // The line can be prefilled after it is built.
    if (_firstName.text != widget.participant.firstName) _firstName.text = widget.participant.firstName;
    if (_lastName.text != widget.participant.lastName) _lastName.text = widget.participant.lastName;
  }

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final participant = widget.participant;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(participant.isBooker ? Icons.person : Icons.person_outline, color: theme.colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text('Participant ${widget.number}', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                ),
                if (widget.onRemove != null)
                  IconButton(
                    onPressed: widget.onRemove,
                    icon: Icon(Icons.remove_circle_outline, color: theme.colorScheme.error),
                    tooltip: 'Retirer ce participant',
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _firstName,
                    decoration: const InputDecoration(labelText: 'Prénom *', border: OutlineInputBorder()),
                    textCapitalization: TextCapitalization.words,
                    onChanged: (value) => widget.onChanged(firstName: value),
                    validator: (value) => (value?.trim().isEmpty ?? true) ? 'Prénom requis' : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _lastName,
                    decoration: const InputDecoration(labelText: 'Nom *', border: OutlineInputBorder()),
                    textCapitalization: TextCapitalization.words,
                    onChanged: (value) => widget.onChanged(lastName: value),
                    validator: (value) => (value?.trim().isEmpty ?? true) ? 'Nom requis' : null,
                  ),
                ),
              ],
            ),
            if (widget.tariffLabels.isNotEmpty) ...[
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: widget.tariffLabels.contains(participant.priceLabel) ? participant.priceLabel : null,
                decoration: const InputDecoration(labelText: 'Tarif *', border: OutlineInputBorder()),
                items: [for (final label in widget.tariffLabels) DropdownMenuItem(value: label, child: Text(label))],
                onChanged: (value) => widget.onChanged(priceLabel: value),
                validator: (value) => value == null ? 'Tarif requis' : null,
              ),
            ],
            if (widget.canBeBooker)
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                dense: true,
                value: participant.isBooker,
                onChanged: (value) => widget.onChanged(isBooker: value ?? false),
                title: const Text('C\'est moi (la personne qui réserve)'),
              ),
          ],
        ),
      ),
    );
  }
}
