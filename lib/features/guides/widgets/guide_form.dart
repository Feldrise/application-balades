import 'dart:convert';

import 'package:balade/core/widgets/error_snackbar.dart';
import 'package:balade/core/widgets/loading_overlay.dart';
import 'package:balade/features/authentication/authentication_provider.dart';
import 'package:balade/features/guides/guides_service.dart';
import 'package:balade/features/guides/models/guide/guide.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:balade/core/forms/form_layout.dart';
import 'package:balade/core/forms/form_section.dart';
import 'package:balade/core/forms/form_large_field.dart';
import 'package:balade/core/forms/image_input.dart';
import 'package:balade/core/forms/image_input_round.dart';
import 'package:balade/core/form_validator.dart';

class GuideForm extends ConsumerStatefulWidget {
  const GuideForm({super.key, this.initialGuide});

  final Guide? initialGuide;

  @override
  ConsumerState<GuideForm> createState() => GuideFormState();
}

class GuideFormState extends ConsumerState<GuideForm> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = PhoneController(
    initialValue: PhoneNumber(isoCode: IsoCode.FR, nsn: ''), // Default empty phone number
  );
  final _bioController = TextEditingController();
  final _experienceController = TextEditingController();
  final _specialtiesController = TextEditingController();
  final _languagesController = TextEditingController();
  final _emergencyContactNameController = TextEditingController();
  final _emergencyContactPhoneController = PhoneController(
    initialValue: PhoneNumber(isoCode: IsoCode.FR, nsn: ''), // Default empty emergency contact phone
  );

  ImageFile? _avatarImage;
  String _selectedCertificationLevel = "debutant"; // Default certification level
  bool _isActive = true;

  @override
  void initState() {
    super.initState();

    _firstNameController.text = widget.initialGuide?.firstName ?? "";
    _lastNameController.text = widget.initialGuide?.lastName ?? "";
    _emailController.text = widget.initialGuide?.email ?? "";
    // _phoneController.value = PhoneNumber.parse(widget.initialGuide?.phone ?? "");
    _bioController.text = widget.initialGuide?.bio ?? "";
    _experienceController.text = widget.initialGuide?.experience ?? "";
    _specialtiesController.text = widget.initialGuide?.specialties ?? "";
    _languagesController.text = widget.initialGuide?.languages ?? "";
    _emergencyContactNameController.text = widget.initialGuide?.emergencyContactName ?? "";
    // _emergencyContactPhoneController.value = PhoneNumber.parse(widget.initialGuide?.emergencyContactPhone ?? "");

    _selectedCertificationLevel = widget.initialGuide?.certificationLevel ?? "debutant";
    _isActive = widget.initialGuide?.isActive ?? true;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    _experienceController.dispose();
    _specialtiesController.dispose();
    _languagesController.dispose();
    _emergencyContactNameController.dispose();
    _emergencyContactPhoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: FormLayout(
          key: UniqueKey(),
          children: [
            // Photo de profil
            FormSection(
              title: 'Photo de profil',
              children: [
                FormLargeField(
                  child: Center(
                    child: ImageInputRound(
                      networkImageUrl: widget.initialGuide?.avatar ?? '',
                      imageFile: _avatarImage,
                      onChanged: (image) {
                        setState(() {
                          _avatarImage = image;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Informations personnelles
            FormSection(
              title: 'Informations personnelles',
              children: [
                TextFormField(
                  controller: _firstNameController,
                  decoration: const InputDecoration(labelText: 'Prénom', hintText: 'Ex: Jean'),
                  validator: FormValidator.requiredValidator,
                ),

                TextFormField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(labelText: 'Nom', hintText: 'Ex: Dupont'),
                  validator: FormValidator.requiredValidator,
                ),

                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Adresse e-mail', hintText: 'jean.dupont@email.com'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => FormValidator.emailValidator(value, isRequired: true),
                ),

                // PhoneFormField(
                //   controller: _phoneController,
                //   decoration: const InputDecoration(labelText: 'Téléphone', hintText: '06 12 34 56 78'),
                //   validator: (value) => FormValidator.phoneValidator(value, isRequired: false),
                // ),
                SwitchListTile(
                  title: const Text('Guide actif'),
                  subtitle: const Text('Le guide peut être assigné à des balades'),
                  value: _isActive,
                  onChanged: (value) {
                    setState(() {
                      _isActive = value;
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Compétences et certification
            FormSection(
              title: 'Compétences et certification',
              children: [
                DropdownButtonFormField<String>(
                  value: _selectedCertificationLevel,
                  decoration: const InputDecoration(labelText: 'Niveau de certification'),
                  items: [
                    for (final level in kCertificationLevelLabels.keys)
                      DropdownMenuItem(
                        value: level,
                        child: Row(children: [Icon(kCertificationLevelIcons[level], size: 20), const SizedBox(width: 8), Text(kCertificationLevelLabels[level] ?? '')]),
                      ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedCertificationLevel = value;
                      });
                    }
                  },
                ),

                FormLargeField(
                  child: TextFormField(
                    controller: _specialtiesController,
                    decoration: const InputDecoration(labelText: 'Spécialités', hintText: 'Ex: Botanique, Ornithologie, Mycologie...', alignLabelWithHint: true),
                    maxLines: 2,
                  ),
                ),

                FormLargeField(
                  child: TextFormField(
                    controller: _languagesController,
                    decoration: const InputDecoration(labelText: 'Langues parlées', hintText: 'Ex: Français, Anglais, Espagnol...', alignLabelWithHint: true),
                    maxLines: 2,
                  ),
                ),

                FormLargeField(
                  child: TextFormField(
                    controller: _experienceController,
                    decoration: const InputDecoration(
                      labelText: 'Expérience professionnelle',
                      hintText: 'Décrivez votre parcours et vos expériences en tant que guide nature...',
                      alignLabelWithHint: true,
                    ),
                    maxLines: 4,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Présentation
            FormSection(
              title: 'Présentation',
              children: [
                FormLargeField(
                  child: TextFormField(
                    controller: _bioController,
                    decoration: const InputDecoration(labelText: 'Biographie', hintText: 'Présentez-vous aux futurs participants de vos balades...', alignLabelWithHint: true),
                    maxLines: 6,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Contact d'urgence
            FormSection(
              title: 'Contact d\'urgence',
              children: [
                TextFormField(
                  controller: _emergencyContactNameController,
                  decoration: const InputDecoration(labelText: 'Nom du contact d\'urgence', hintText: 'Ex: Marie Dupont'),
                ),

                PhoneFormField(
                  controller: _emergencyContactPhoneController,
                  decoration: const InputDecoration(labelText: 'Téléphone du contact d\'urgence', hintText: '06 12 34 56 78'),
                  validator: (value) => FormValidator.phoneValidator(value, isRequired: false),
                ),
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

    try {
      LoadingOverlay.of(context).show();

      final Map<String, Object?> data = {
        'first_name': _firstNameController.text,
        'last_name': _lastNameController.text,
        'email': _emailController.text,
        'phone': _phoneController.value.toString(),
        'bio': _bioController.text,
        'experience': _experienceController.text,
        'specialties': _specialtiesController.text,
        'languages': _languagesController.text,
        'certification_level': _selectedCertificationLevel,
        if (_avatarImage != null) 'avatar_base64': base64Encode(_avatarImage!.bytes),
        'emergency_contact_name': _emergencyContactNameController.text,
        'emergency_contact_phone': _emergencyContactPhoneController.value.toString(),
      };

      if (widget.initialGuide == null) {
        final int guideId = await GuidesService.instance.createGuide(data, authorization: ref.read(authenticationProvider)!.token);

        if (mounted) {
          // Close the dialog and return the new guide ID
          Navigator.of(context).pop(guideId);
        }
      }
    } catch (e) {
      if (mounted) {
        ErrorSnackbar.show(context, 'Erreur lors de la sauvegarde du guide : ${e.toString()}');
      }
      return;
    } finally {
      if (mounted) {
        LoadingOverlay.of(context).hide();
      }
    }
  }
}
