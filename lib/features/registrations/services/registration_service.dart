import 'dart:convert';
import 'package:balade/core/constants.dart';
import 'package:balade/features/payments/models/payment.dart';
import 'package:http/http.dart' as http;

/// Service to manage registration groups
class RegistrationService {
  static final RegistrationService _instance = RegistrationService._();
  static RegistrationService get instance => _instance;

  final String serviceUrl = '$kApiBaseUrl/registrations';

  RegistrationService._();

  /// Get registration group details
  Future<RegistrationGroup?> getGroupDetails(int groupId, {required String authorization}) async {
    try {
      final response = await http.get(Uri.parse('$serviceUrl/groups/$groupId'), headers: {'Authorization': authorization, 'Content-Type': 'application/json'});

      print("RESPONSE STATUS: ${response.statusCode}");
      print("RESPONSE BODY: ${response.body}");

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

  /// Confirm group registration
  Future<void> confirmGroup(int groupId, bool confirmed, {required String authorization}) async {
    try {
      final response = await http.put(
        Uri.parse('$serviceUrl/groups/$groupId/confirm'),
        headers: {'Authorization': authorization, 'Content-Type': 'application/json'},
        body: json.encode({'confirmed': confirmed}),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to confirm group: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to confirm group: $e');
    }
  }

  /// Cancel group registration
  Future<void> cancelGroup(int groupId, String reason, {required String authorization}) async {
    try {
      final response = await http.put(
        Uri.parse('$serviceUrl/groups/$groupId/cancel'),
        headers: {'Authorization': authorization, 'Content-Type': 'application/json'},
        body: json.encode({'reason': reason}),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to cancel group: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to cancel group: $e');
    }
  }
}
