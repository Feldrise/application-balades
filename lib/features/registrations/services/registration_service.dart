import 'dart:convert';
import 'package:balade/core/constants.dart';
import 'package:balade/features/payments/models/payment.dart';
import 'package:http/http.dart' as http;

/// Reads a registration group for the payment page, until payments move to reservations
class RegistrationService {
  static final RegistrationService _instance = RegistrationService._();
  static RegistrationService get instance => _instance;

  final String serviceUrl = '$kApiBaseUrl/registrations';

  RegistrationService._();

  /// Get registration group details
  Future<RegistrationGroup?> getGroupDetails(int groupId, {required String authorization}) async {
    try {
      final response = await http.get(Uri.parse('$serviceUrl/groups/$groupId'), headers: {'Authorization': authorization, 'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return RegistrationGroup.fromJson(data);
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to get group details: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get group details: $e');
    }
  }
}
