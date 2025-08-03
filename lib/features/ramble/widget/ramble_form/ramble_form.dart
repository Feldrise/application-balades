import 'package:balade/core/forms/duration_picker.dart';
import 'package:balade/features/ramble/models/ramble/ramble.dart';
import 'package:balade/features/ramble/widget/ramble_form/widgets/pricing_list.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:balade/core/forms/form_layout.dart';
import 'package:balade/core/forms/form_section.dart';
import 'package:balade/core/forms/form_large_field.dart';
import 'package:balade/core/forms/image_input.dart';
import 'package:balade/core/form_validator.dart';

class RambleForm extends ConsumerStatefulWidget {
  const RambleForm({super.key, this.initialRamble});

  final Ramble? initialRamble;

  @override
  ConsumerState<RambleForm> createState() => _RambleFormState();
}

class _RambleFormState extends ConsumerState<RambleForm> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _meetingPointController = TextEditingController();
  final _maxParticipantsController = TextEditingController();
  final _equipmentController = TextEditingController();
  final _prerequisitesController = TextEditingController();

  final List<(TextEditingController, TextEditingController)> _prices = [
    (TextEditingController(text: "Adulte"), TextEditingController()), // Default price entry
  ];

  ImageFile? _coverImage;
  String _selectedType = "decouverte"; // Default type
  DateTime? _selectedDate;
  String _selectedDifficulty = "facile"; // Default difficulty
  Duration _selectedDuration = const Duration(hours: 2);

  @override
  void initState() {
    super.initState();

    _titleController.text = widget.initialRamble?.title ?? "";
    _descriptionController.text = widget.initialRamble?.description ?? "";
    _locationController.text = widget.initialRamble?.location ?? "";
    _meetingPointController.text = widget.initialRamble?.meetingPoint ?? "";
    _maxParticipantsController.text = widget.initialRamble?.maxParticipants.toString() ?? "";
    _equipmentController.text = widget.initialRamble?.equipmentNeeded ?? "";
    _prerequisitesController.text = widget.initialRamble?.prerequisites ?? "";

    _selectedType = widget.initialRamble?.type ?? "decouverte";
    _selectedDate = widget.initialRamble?.date;
    _selectedDifficulty = widget.initialRamble?.difficulty ?? "facile";
    _selectedDuration = widget.initialRamble?.estimatedDuration ?? const Duration(hours: 2);

    if ((widget.initialRamble?.prices ?? []).isNotEmpty) {
      _prices.clear();
      for (final price in widget.initialRamble!.prices) {
        _prices.add((TextEditingController(text: price.label), TextEditingController(text: price.amount.toString())));
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _meetingPointController.dispose();
    _maxParticipantsController.dispose();
    _equipmentController.dispose();
    _prerequisitesController.dispose();

    for (final price in _prices) {
      price.$1.dispose();
      price.$2.dispose();
    }
    super.dispose();
  }

  // Duration picker is now a widget

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: FormLayout(
          key: UniqueKey(),
          children: [
            // Image de couverture
            FormSection(
              title: 'Image de couverture',
              children: [
                FormLargeField(
                  child: ImageInput(
                    networkImageUrl: widget.initialRamble?.coverImageUrl ?? '',
                    imageFile: _coverImage,
                    onChanged: (image) {
                      setState(() {
                        _coverImage = image;
                      });
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Informations générales
            FormSection(
              title: 'Informations générales',
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Titre de la balade', hintText: 'Ex: Découverte des champignons d\'automne'),
                  validator: FormValidator.requiredValidator,
                ),

                DropdownButtonFormField<String>(
                  value: _selectedType,
                  decoration: const InputDecoration(labelText: 'Type de balade'),
                  items: [
                    for (final type in rambleTypeLabels.keys)
                      DropdownMenuItem(
                        value: type,
                        child: Row(children: [Icon(rambleTypeIcons[type], size: 20), const SizedBox(width: 8), Text(rambleTypeLabels[type] ?? '')]),
                      ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedType = value;
                      });
                    }
                  },
                ),

                FormLargeField(
                  child: TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      hintText: 'Décrivez le contenu de la balade, ce que les participants vont découvrir...',
                      alignLabelWithHint: true,
                    ),
                    maxLines: 4,
                    validator: FormValidator.requiredValidator,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Date et horaires
            FormSection(
              title: 'Date et horaires',
              children: [
                DateTimeFormField(
                  initialValue: _selectedDate,
                  dateFormat: DateFormat('EEEE d MMMM yyyy à HH:mm', 'fr_FR'),
                  decoration: const InputDecoration(labelText: 'Date et heure', suffixIcon: Icon(Icons.calendar_today)),
                  mode: DateTimeFieldPickerMode.dateAndTime,
                  onChanged: (date) {
                    setState(() {
                      _selectedDate = date;
                    });
                  },
                ),

                DurationPicker(
                  initialDuration: _selectedDuration,
                  onChanged: (duration) {
                    setState(() {
                      _selectedDuration = duration;
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Lieu et logistique
            FormSection(
              title: 'Lieu et logistique',
              children: [
                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(labelText: 'Lieu général', hintText: 'Ex: Forêt de Fontainebleau'),
                  validator: FormValidator.requiredValidator,
                ),

                TextFormField(
                  controller: _meetingPointController,
                  decoration: const InputDecoration(labelText: 'Point de rendez-vous', hintText: 'Ex: Parking de la Croix du Grand Maître'),
                  validator: FormValidator.requiredValidator,
                ),

                TextFormField(
                  controller: _maxParticipantsController,
                  decoration: const InputDecoration(labelText: 'Nombre maximum de participants', suffixText: 'personnes'),
                  keyboardType: TextInputType.number,
                  validator: (value) => FormValidator.intValidator(value, isRequired: true),
                ),

                DropdownButtonFormField<String>(
                  value: _selectedDifficulty,
                  decoration: const InputDecoration(labelText: 'Niveau de difficulté'),
                  items: rambleDifficultyLabels.keys.map((difficulty) {
                    return DropdownMenuItem(
                      value: difficulty,
                      child: Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(color: rambleDifficultyColors[difficulty], shape: BoxShape.circle),
                          ),
                          const SizedBox(width: 8),
                          Text(rambleDifficultyLabels[difficulty] ?? ''),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedDifficulty = value;
                      });
                    }
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Tarifs et prérequis
            FormSection(
              title: 'Tarifs et prérequis',
              children: [
                PricingList(
                  prices: _prices,
                  onChanged: (newPrices) {
                    setState(() {
                      _prices.clear();
                      _prices.addAll(newPrices);
                    });
                  },
                ),

                FormLargeField(
                  child: TextFormField(
                    controller: _equipmentController,
                    decoration: const InputDecoration(
                      labelText: 'Équipement recommandé',
                      hintText: 'Ex: Chaussures de marche, vêtements adaptés à la météo...',
                      alignLabelWithHint: true,
                    ),
                    maxLines: 3,
                    maxLength: 300,
                  ),
                ),

                FormLargeField(
                  child: TextFormField(
                    controller: _prerequisitesController,
                    decoration: const InputDecoration(
                      labelText: 'Prérequis et conditions particulières',
                      hintText: 'Ex: Bonne condition physique requise, accessible aux débutants...',
                      alignLabelWithHint: true,
                    ),
                    maxLines: 3,
                    maxLength: 300,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
