// Widget for dynamic pricing list
import 'package:balade/core/form_validator.dart';
import 'package:flutter/material.dart';

class PricingList extends StatelessWidget {
  const PricingList({super.key, required this.prices, required this.onChanged});

  final List<(TextEditingController, TextEditingController)> prices;
  final Function(List<(TextEditingController, TextEditingController)>) onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Tarifs', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'Ajouter un tarif',
              onPressed: () {
                final newList = List<(TextEditingController, TextEditingController)>.from(prices)..add((TextEditingController(), TextEditingController()));
                onChanged(newList);
              },
            ),
          ],
        ),
        for (final price in prices) ...[
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: price.$1,
                  decoration: const InputDecoration(labelText: 'Type (ex: Adulte, Enfant)'),
                  validator: FormValidator.requiredValidator,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 1,
                child: TextFormField(
                  controller: price.$2,
                  decoration: const InputDecoration(labelText: 'Prix (€)'),
                  keyboardType: TextInputType.number,
                  validator: (value) => FormValidator.numberValidator(value, isRequired: true),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                tooltip: 'Supprimer',
                onPressed: prices.length > 1
                    ? () {
                        final newList = List<(TextEditingController, TextEditingController)>.from(prices)..remove(price);
                        onChanged(newList);
                      }
                    : null,
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ],
    );
  }
}
