import 'package:balade/features/registrations/models/registration/registration.dart';
import 'package:flutter/material.dart';

class RegistrationActions extends StatelessWidget {
  const RegistrationActions({super.key, required this.registration, required this.onConfirm, required this.onCancel});

  final Registration registration;
  final VoidCallback onConfirm;
  final Function(String?) onCancel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final actions = <Widget>[];

    if (_canConfirm()) {
      actions.add(
        FilledButton.icon(
          onPressed: onConfirm,
          icon: const Icon(Icons.check, size: 16),
          label: const Text('Confirmer'),
          style: FilledButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
        ),
      );
    }

    if (_canCancel()) {
      actions.add(
        OutlinedButton.icon(
          onPressed: () => _showCancelDialog(context),
          icon: const Icon(Icons.close, size: 16),
          label: const Text('Annuler'),
          style: OutlinedButton.styleFrom(
            foregroundColor: theme.colorScheme.error,
            side: BorderSide(color: theme.colorScheme.error),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
        ),
      );
    }

    if (actions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Wrap(spacing: 8, runSpacing: 8, children: actions);
  }

  bool _canConfirm() {
    if (registration.status != 'pending') return false;
    if (registration.ramble?.date == null) return false;

    final rambleDate = registration.ramble!.date!;
    final now = DateTime.now();
    final daysDifference = rambleDate.difference(now).inDays;

    return daysDifference <= 3;
  }

  bool _canCancel() {
    return registration.status != 'cancelled';
  }

  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _CancelRegistrationDialog(onConfirmCancel: onCancel),
    );
  }
}

class _CancelRegistrationDialog extends StatefulWidget {
  const _CancelRegistrationDialog({required this.onConfirmCancel});

  final Function(String?) onConfirmCancel;

  @override
  State<_CancelRegistrationDialog> createState() => _CancelRegistrationDialogState();
}

class _CancelRegistrationDialogState extends State<_CancelRegistrationDialog> {
  final _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: const Text('Annuler l\'inscription'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Êtes-vous sûr de vouloir annuler votre inscription à cette balade ?'),
          const SizedBox(height: 16),
          TextField(
            controller: _reasonController,
            decoration: const InputDecoration(labelText: 'Raison (optionnel)', hintText: 'Indiquez pourquoi vous annulez votre inscription', border: OutlineInputBorder()),
            maxLines: 3,
            maxLength: 500,
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Garder l\'inscription')),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop();
            widget.onConfirmCancel(_reasonController.text.trim().isEmpty ? null : _reasonController.text.trim());
          },
          style: FilledButton.styleFrom(backgroundColor: theme.colorScheme.error, foregroundColor: Colors.white),
          child: const Text('Annuler l\'inscription'),
        ),
      ],
    );
  }
}
