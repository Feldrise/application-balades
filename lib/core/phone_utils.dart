import 'package:phone_form_field/phone_form_field.dart';

/// Serializes a [PhoneNumber] for API storage (E.164-style international format).
String? phoneToApiValue(PhoneNumber phone) {
  final nsn = phone.nsn.trim();
  if (nsn.isEmpty) return null;
  return phone.international;
}

/// Returns true when a stored phone value is non-empty and usable.
bool hasStoredPhone(String? phone) => formatStoredPhone(phone) != null;

/// Formats a stored phone value for display (handles legacy toString() corruption).
String? formatStoredPhone(String? phone) {
  if (phone == null || phone.trim().isEmpty) return null;

  final parsed = _parseStoredPhone(phone);
  if (parsed == null || parsed.nsn.trim().isEmpty) return null;

  return parsed.formatNsn();
}

/// Parses a stored phone value, including legacy toString() corruption.
PhoneNumber? parseStoredPhone(String phone) => _parseStoredPhone(phone);

/// Returns an international phone string suitable for tel: URIs.
String? phoneToTelUri(String? phone) {
  if (phone == null || phone.trim().isEmpty) return null;

  final parsed = _parseStoredPhone(phone);
  if (parsed == null || parsed.nsn.trim().isEmpty) return null;

  return parsed.international;
}

PhoneNumber? _parseStoredPhone(String phone) {
  final trimmed = phone.trim();

  // Legacy format saved via PhoneNumber.toString()
  if (trimmed.startsWith('PhoneNumber(')) {
    final nsnMatch = RegExp(r'nsn:\s*([^),]*)').firstMatch(trimmed);
    final isoMatch = RegExp(r'isoCode:\s*IsoCode\.(\w+)').firstMatch(trimmed);
    final nsn = nsnMatch?.group(1)?.trim() ?? '';
    if (nsn.isEmpty) return null;

    try {
      final iso = isoMatch != null ? IsoCode.values.byName(isoMatch.group(1)!) : IsoCode.FR;
      return PhoneNumber(isoCode: iso, nsn: nsn);
    } catch (_) {
      return null;
    }
  }

  try {
    return PhoneNumber.parse(trimmed);
  } catch (_) {
    return null;
  }
}
