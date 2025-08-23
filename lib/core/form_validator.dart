import 'package:balade/core/utils.dart';
import 'package:phone_form_field/phone_form_field.dart';

class FormValidator {
  static String? emailValidator(String? value, {bool isRequired = false}) {
    if (isRequired && (value?.isEmpty ?? true)) return "";

    final regex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    if ((value ?? "").isNotEmpty && !regex.hasMatch(value!)) {
      return 'Veuillez entrer une adresse e-mail valide.';
    }

    return null;
  }

  static String? phoneValidator(PhoneNumber? value, {bool isRequired = false}) {
    if (isRequired && (value?.nsn.isEmpty ?? true)) return "";

    if (value!.nsn.isNotEmpty && !value.isValid()) {
      return 'Veuillez entrer un numéro de téléphone valide.';
    }

    return null;
  }

  static String? numberValidator(String? value, {bool isRequired = false}) {
    if (isRequired && (value?.isEmpty ?? true)) return "";

    if (isRequired && tryParseFrenchDouble(value ?? "") == null) {
      // return 'Veuillez entrer un nombre valide.';
      return "";
    }

    return null;
  }

  static String? intValidator(String? value, {bool isRequired = false}) {
    if (isRequired && (value?.isEmpty ?? true)) return "";

    if (isRequired && int.tryParse(value ?? "") == null) {
      // return 'Veuillez entrer un nombre valide.';
      return '';
    }

    return null;
  }

  static String? requiredValidator(String? value) {
    if (value?.isEmpty ?? true) return "";
    return null;
  }

  static String? requiredDateValidator(DateTime? value) {
    if (value == null) return "";
    return null;
  }

  // Additional validators for registration forms
  static String? validateRequired(String? value, String errorMessage) {
    if (value?.trim().isEmpty ?? true) {
      return errorMessage;
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value?.trim().isEmpty ?? true) {
      return 'L\'email est requis';
    }

    final regex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    if (!regex.hasMatch(value!.trim())) {
      return 'Veuillez entrer une adresse email valide';
    }

    return null;
  }

  static String? validatePhone(String? value) {
    if (value?.trim().isEmpty ?? true) {
      return null; // Phone is optional
    }

    // Basic French phone number validation
    final cleanPhone = value!.replaceAll(RegExp(r'[\s\-\.\(\)]'), '');
    final regex = RegExp(r'^(?:(?:\+|00)33|0)\s*[1-9](?:[\s\-]?\d{2}){4}$');

    if (!regex.hasMatch(cleanPhone)) {
      return 'Veuillez entrer un numéro de téléphone valide';
    }

    return null;
  }
}
