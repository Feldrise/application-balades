import 'dart:convert';

import 'package:balade/core/constants.dart';
import 'package:balade/features/admin/registrations_management/models/admin_registration_response.dart';
import 'package:balade/features/admin/registrations_management/models/bulk_action_request.dart';
import 'package:balade/features/admin/registrations_management/models/bulk_action_result.dart';
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

  // ===============================
  // ADMIN METHODS
  // ===============================

  /// Get all registrations with admin filtering and pagination
  Future<AdminRegistrationListResponse> fetchAllRegistrations({
    required String authorization,
    int? rambleId,
    int? userId,
    String? email,
    String? status,
    List<String>? statuses,
    DateTime? dateFrom,
    DateTime? dateTo,
    String? search,
    String? rambleTitle,
    int page = 1,
    int perPage = 50,
    String sortBy = 'created_at',
    String sortOrder = 'desc',
  }) async {
    final Map<String, String> queryParams = {};

    if (rambleId != null) queryParams['ramble_id'] = rambleId.toString();
    if (userId != null) queryParams['user_id'] = userId.toString();
    if (email != null && email.isNotEmpty) queryParams['email'] = email;
    if (status != null && status.isNotEmpty) queryParams['status'] = status;
    if (statuses != null && statuses.isNotEmpty) {
      for (int i = 0; i < statuses.length; i++) {
        queryParams['statuses[$i]'] = statuses[i];
      }
    }
    if (dateFrom != null) queryParams['date_from'] = dateFrom.toIso8601String().split('T')[0];
    if (dateTo != null) queryParams['date_to'] = dateTo.toIso8601String().split('T')[0];
    if (search != null && search.isNotEmpty) queryParams['search'] = search;
    if (rambleTitle != null && rambleTitle.isNotEmpty) queryParams['ramble_title'] = rambleTitle;
    queryParams['page'] = page.toString();
    queryParams['per_page'] = perPage.toString();
    queryParams['sort_by'] = sortBy;
    queryParams['sort_order'] = sortOrder;

    final Uri uri = Uri.parse('$serviceBaseUrl/admin').replace(queryParameters: queryParams);
    final http.Response response = await http.get(uri, headers: {'Content-Type': 'application/json', 'Authorization': authorization});

    if (response.statusCode == 200) {
      return AdminRegistrationListResponse.fromJson(jsonDecode(response.body) as Map<String, Object?>);
    } else {
      throw Exception('Failed to load registrations: ${response.body}');
    }
  }

  /// Update registration details (admin)
  Future<Registration> updateRegistrationDetails(int id, AdminRegistrationUpdatePayload payload, {required String authorization}) async {
    final Uri uri = Uri.parse('$serviceBaseUrl/admin/$id');
    final http.Response response = await http.put(uri, headers: {'Content-Type': 'application/json', 'Authorization': authorization}, body: jsonEncode(payload.toJson()));

    if (response.statusCode == 200) {
      return Registration.fromJson(jsonDecode(response.body) as Map<String, Object?>);
    } else {
      throw Exception('Failed to update registration: ${response.body}');
    }
  }

  /// Update registration status (admin)
  Future<Registration> updateRegistrationStatus(int id, AdminRegistrationStatusUpdatePayload payload, {required String authorization}) async {
    final Uri uri = Uri.parse('$serviceBaseUrl/admin/$id/status');
    final http.Response response = await http.put(uri, headers: {'Content-Type': 'application/json', 'Authorization': authorization}, body: jsonEncode(payload.toJson()));

    if (response.statusCode == 200) {
      return Registration.fromJson(jsonDecode(response.body) as Map<String, Object?>);
    } else {
      throw Exception('Failed to update registration status: ${response.body}');
    }
  }

  /// Delete registration (admin)
  Future<void> deleteRegistration(int id, {required String authorization}) async {
    final Uri uri = Uri.parse('$serviceBaseUrl/admin/$id');
    final http.Response response = await http.delete(uri, headers: {'Content-Type': 'application/json', 'Authorization': authorization});

    if (response.statusCode != 204) {
      throw Exception('Failed to delete registration: ${response.body}');
    }
  }

  /// Perform bulk actions on registrations (admin)
  Future<BulkActionResult> performBulkAction(BulkRegistrationActionPayload payload, {required String authorization}) async {
    final Uri uri = Uri.parse('$serviceBaseUrl/admin/bulk-action');
    final http.Response response = await http.post(uri, headers: {'Content-Type': 'application/json', 'Authorization': authorization}, body: jsonEncode(payload.toJson()));

    if (response.statusCode == 200) {
      return BulkActionResult.fromJson(jsonDecode(response.body) as Map<String, Object?>);
    } else {
      throw Exception('Failed to perform bulk action: ${response.body}');
    }
  }
}
