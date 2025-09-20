import 'dart:convert';

import 'package:balade/core/constants.dart';
import 'package:balade/features/registrations/models/registration/registration.dart';
import 'package:http/http.dart' as http;

class RegistrationsService {
  RegistrationsService._();

  final String serviceBaseUrl = '$kApiBaseUrl/registrations';

  static final RegistrationsService instance = RegistrationsService._();

  /// Create a new registration for a ramble
  /// Supports both single and group registrations (1-10 participants)
  Future<Registration> createRegistration(CreateRegistrationRequest request) async {
    final http.Response response = await http.post(Uri.parse(serviceBaseUrl), headers: {'Content-Type': 'application/json'}, body: jsonEncode(request.toJson()));

    if (response.statusCode == 201) {
      return Registration.fromJson(jsonDecode(response.body) as Map<String, Object?>);
    } else {
      throw Exception('Failed to create registration: ${response.body}');
    }
  }

  /// Get registration details by ID
  Future<Registration> fetchRegistration(int id) async {
    final Uri uri = Uri.parse('$serviceBaseUrl/$id');
    final http.Response response = await http.get(uri, headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      return Registration.fromJson(jsonDecode(response.body) as Map<String, Object?>);
    } else {
      throw Exception('Failed to load registration: ${response.body}');
    }
  }

  /// Get all registrations for the authenticated user
  Future<List<Registration>> fetchUserRegistrations({required String authorization}) async {
    final http.Response response = await http.get(Uri.parse(serviceBaseUrl), headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $authorization'});

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;
      return jsonList.map((json) => Registration.fromJson(json as Map<String, Object?>)).toList();
    } else {
      throw Exception('Failed to load user registrations: ${response.body}');
    }
  }

  /// Confirm or decline participation in a ramble
  Future<Registration> confirmRegistration(int id, bool confirmed, {String? authorization}) async {
    final Uri uri = Uri.parse('$serviceBaseUrl/$id/confirm');
    final http.Response response = await http.put(
      uri,
      headers: {'Content-Type': 'application/json', if (authorization != null) 'Authorization': authorization},
      body: jsonEncode(ConfirmRegistrationRequest(confirmed: confirmed).toJson()),
    );

    if (response.statusCode == 200) {
      return Registration.fromJson(jsonDecode(response.body) as Map<String, Object?>);
    } else {
      throw Exception('Failed to confirm registration: ${response.body}');
    }
  }

  /// Cancel a registration
  Future<Registration> cancelRegistration(int id, {String? reason}) async {
    final Uri uri = Uri.parse('$serviceBaseUrl/$id/cancel');
    final http.Response response = await http.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(CancelRegistrationRequest(reason: reason).toJson()),
    );

    if (response.statusCode == 200) {
      return Registration.fromJson(jsonDecode(response.body) as Map<String, Object?>);
    } else {
      throw Exception('Failed to cancel registration: ${response.body}');
    }
  }

  /// Get all registrations for a specific ramble (admin access)
  Future<List<Registration>> fetchRambleRegistrations(int rambleId, {required String authorization}) async {
    final Uri uri = Uri.parse('$serviceBaseUrl/ramble/$rambleId');
    final http.Response response = await http.get(uri, headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $authorization'});

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;
      return jsonList.map((json) => Registration.fromJson(json as Map<String, Object?>)).toList();
    } else {
      throw Exception('Failed to load ramble registrations: ${response.body}');
    }
  }
}
