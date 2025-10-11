import 'dart:convert';

import 'package:balade/core/constants.dart';
import 'package:balade/core/forms/duration_picker.dart';
import 'package:balade/core/widgets/error_snackbar.dart';
import 'package:balade/core/widgets/loading_overlay.dart';
import 'package:balade/core/widgets/searchable_dropdown.dart';
import 'package:balade/features/admin/admin_home_page/providers/rambles_provider.dart';
import 'package:balade/features/authentication/authentication_provider.dart';
import 'package:balade/features/guides/dialogs/add_guide_dialog.dart';
import 'package:balade/features/guides/guides_service.dart';
import 'package:balade/features/guides/models/guide/guide.dart';
import 'package:balade/features/guides/widgets/guide_small_card.dart';
import 'package:balade/features/ramble/models/ramble/ramble.dart';
import 'package:balade/features/ramble/rambles_service.dart';
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
  ConsumerState<RambleForm> createState() => RambleFormState();
}

class RambleFormState extends ConsumerState<RambleForm> {
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

  final List<int> _selectedGuides = [];

  // Payment configuration
  bool _paymentEnabled = false;
  bool _paymentRequired = false;
  int? _paymentGuideId;
  List<Guide> _availablePaymentGuides = [];

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

    _selectedGuides.addAll(widget.initialRamble?.guides.map((g) => g.id) ?? []);

    // Initialize payment fields
    _paymentEnabled = widget.initialRamble?.paymentEnabled ?? false;
    _paymentRequired = widget.initialRamble?.paymentRequired ?? false;
    _paymentGuideId = widget.initialRamble?.paymentGuideId;

    if ((widget.initialRamble?.prices ?? []).isNotEmpty) {
      _prices.clear();
      for (final price in widget.initialRamble!.prices) {
        _prices.add((TextEditingController(text: price.label), TextEditingController(text: price.amount.toString())));
      }
    }

    // Load available payment guides
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAvailablePaymentGuides();
    });
  }

  Future<void> _loadAvailablePaymentGuides() async {
    try {
      final authToken = ref.read(authenticationProvider)?.token;
      if (authToken == null) return;

      final allGuides = await GuidesService.instance.fetchGuides('', authorization: authToken);
      _availablePaymentGuides = allGuides.where((guide) => guide.paymentEnabled == true).toList();

      if (mounted) setState(() {});
    } catch (e) {
      // Handle error silently or show a message
      debugPrint('Error loading payment guides: $e');
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
                    // networkImageUrl: widget.initialRamble?.coverImageUrl ?? '',
                    networkImageUrl: "$kBaseUrl/uploads/ramble/${widget.initialRamble?.id}/${widget.initialRamble?.coverImage}",
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

            // Guide information
            FormSection(
              title: 'Informations sur le(s) guide(s)',
              children: [
                SearchableDropdown<Guide>(
                  label: "Rechercher un guide",
                  displayStringForOption: (guide) => '${guide.firstName} ${guide.lastName}',
                  onCreate: (name) async {
                    final int? newGuideID = await showDialog<int>(
                      context: context,
                      builder: (context) => const LoadingOverlay(child: AddGuideDialog()),
                    );

                    if (newGuideID != null) {
                      setState(() {
                        _selectedGuides.add(newGuideID);
                      });
                    }
                  },
                  optionsBuilder: (textEditingValue) async {
                    final List<Guide> guides = await GuidesService.instance.fetchGuides(textEditingValue.text, authorization: ref.read(authenticationProvider)?.token);

                    return guides.where((guide) => !_selectedGuides.contains(guide.id)).toList();
                  },
                  onSelected: (guide) {
                    if (guide != null && !_selectedGuides.contains(guide.id)) {
                      setState(() {
                        _selectedGuides.add(guide.id);
                      });
                    }
                  },
                  fakeOnCreate: (value) => Guide(0, firstName: "", lastName: "", email: "", isActive: true),
                  shouldResetOnTap: true,
                ),
                SizedBox(),
                FormLargeField(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final guideId in _selectedGuides)
                        GuideSmallCard(
                          guideId: guideId,
                          onRemove: () {
                            setState(() {
                              _selectedGuides.remove(guideId);
                            });
                          },
                          onGuideEdited: () => setState(() {}),
                        ),
                    ],
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
                    decoration: InputDecoration(
                      labelText: 'Description',
                      hintText: 'Décrivez le contenu de la balade, ce que les participants vont découvrir...',
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
                      ),
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
                    decoration: InputDecoration(
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
                    decoration: InputDecoration(
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

            const SizedBox(height: 24),

            // Configuration des paiements
            FormSection(
              title: 'Configuration des paiements',
              children: [
                SwitchListTile(
                  title: const Text('Activer les paiements'),
                  subtitle: const Text('Permettre aux participants de payer en ligne'),
                  value: _paymentEnabled,
                  onChanged: (value) {
                    setState(() {
                      _paymentEnabled = value;
                      if (!value) {
                        _paymentRequired = false;
                        _paymentGuideId = null;
                      }
                    });
                  },
                ),

                if (_paymentEnabled) ...[
                  const SizedBox(height: 16),

                  SwitchListTile(
                    title: const Text('Paiement obligatoire'),
                    subtitle: const Text('Rendre le paiement obligatoire pour finaliser l\'inscription'),
                    value: _paymentRequired,
                    onChanged: (value) {
                      setState(() {
                        _paymentRequired = value;
                      });
                    },
                  ),

                  const SizedBox(height: 16),

                  DropdownButtonFormField<int>(
                    value: _paymentGuideId,
                    decoration: InputDecoration(
                      labelText: 'Guide recevant les paiements *',
                      helperText: 'Seuls les guides avec Stripe configuré apparaissent',
                      suffixIcon: IconButton(icon: const Icon(Icons.refresh), tooltip: 'Actualiser la liste des guides', onPressed: _loadAvailablePaymentGuides),
                    ),
                    items: _availablePaymentGuides.map((guide) {
                      return DropdownMenuItem<int>(
                        value: guide.id,
                        child: Row(
                          children: [
                            Icon(Icons.person, size: 20),
                            const SizedBox(width: 8),
                            Text('${guide.firstName} ${guide.lastName}'),
                            if (guide.paymentEnabled == true) ...[const SizedBox(width: 8), Icon(Icons.verified, size: 16, color: Colors.green)],
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _paymentGuideId = value;
                      });
                    },
                    validator: _paymentEnabled ? (value) => value == null ? 'Veuillez sélectionner un guide pour les paiements' : null : null,
                  ),

                  if (_availablePaymentGuides.isEmpty)
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.orange.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.warning, color: Colors.orange, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Aucun guide n\'a configuré Stripe pour recevoir des paiements. Ajoutez la configuration de paiement aux guides d\'abord.',
                              style: TextStyle(color: Colors.orange.shade700),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ],
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Future<void> save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Additional validation for payment configuration
    if (_paymentEnabled && _paymentGuideId == null) {
      if (mounted) {
        ErrorSnackbar.show(context, 'Veuillez sélectionner un guide pour recevoir les paiements');
      }
      return;
    }

    try {
      LoadingOverlay.of(context).show();

      final Map<String, Object?> data = {
        'title': _titleController.text,
        'description': _descriptionController.text,
        'type': _selectedType,
        'date': _selectedDate?.toUtc().toIso8601String(),
        'location': _locationController.text,
        'meeting_point': _meetingPointController.text,
        'max_participants': int.tryParse(_maxParticipantsController.text),
        'difficulty': _selectedDifficulty,
        'estimated_duration': _selectedDuration.toString().split('.').first,
        'equipment_needed': _equipmentController.text,
        'prerequisites': _prerequisitesController.text,
        if (_coverImage != null) 'cover_image_base64': base64Encode(_coverImage!.bytes),
        'guide_ids': _selectedGuides,
        'prices': [
          for (final price in _prices) {'label': price.$1.text, 'amount': double.tryParse(price.$2.text) ?? 0.0},
        ],
        // Payment configuration fields
        'payment_enabled': _paymentEnabled,
        'payment_required': _paymentRequired,
        'payment_guide_id': _paymentGuideId,
      };

      if (widget.initialRamble != null) {
        // Update existing ramble
        await RamblesService.instance.updateRamble(widget.initialRamble!.id, data, authorization: ref.read(authenticationProvider)!.token);
      } else {
        // Create new ramble
        await RamblesService.instance.createRamble(data, authorization: ref.read(authenticationProvider)!.token);
      }

      if (mounted) {
        ref.read(ramblesProvider.notifier).loadRambles(authorization: ref.read(authenticationProvider)!.token);

        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ErrorSnackbar.show(context, 'Erreur lors de la sauvegarde : $e');
      }
    } finally {
      if (mounted) {
        LoadingOverlay.of(context).hide();
      }
    }
  }
}
