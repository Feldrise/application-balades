double weightToKg(double weight, String unit) {
  if (unit == 'g') {
    return weight / 1000;
  } else if (unit == 'mg') {
    return weight / 1000000;
  } else if (unit == 't') {
    return weight * 1000;
  } else {
    return weight;
  }
}

double? tryParseFrenchDouble(String? value) {
  if (value == null) {
    return null;
  }
  return double.tryParse(value.replaceAll(',', '.'));
}

double parseFrenchDouble(String value) {
  return double.parse(value.replaceAll(',', '.'));
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) {
      return this;
    }
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
