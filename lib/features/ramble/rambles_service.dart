import 'dart:convert';

import 'package:balade/core/constants.dart';
import 'package:balade/features/ramble/models/ramble/ramble.dart';
import 'package:http/http.dart' as http;

class RamblesService {
  RamblesService._();

  final String serviceBaseUrl = '$kApiBaseUrl/rambles';

  static final RamblesService instance = RamblesService._();

  Future<List<Ramble>> fetchRambles({
    String? search,
    String? status,
    String? type,
    String? difficulty,
    String? location,
    DateTime? dateFrom,
    DateTime? dateTo,
    int? guideId,
    bool? isActive,
    String? authorization,
  }) async {
    Map<String, String> queryParameters = {};

    if (search != null && search.isNotEmpty) {
      queryParameters['search'] = search;
    }
    if (status != null && status.isNotEmpty) {
      queryParameters['status'] = status;
    }
    if (type != null && type.isNotEmpty) {
      queryParameters['type'] = type;
    }
    if (difficulty != null && difficulty.isNotEmpty) {
      queryParameters['difficulty'] = difficulty;
    }
    if (location != null && location.isNotEmpty) {
      queryParameters['location'] = location;
    }
    if (dateFrom != null) {
      queryParameters['date_from'] = dateFrom.toUtc().toIso8601String();
    }
    if (dateTo != null) {
      queryParameters['date_to'] = dateTo.toUtc().toIso8601String();
    }
    if (guideId != null) {
      queryParameters['guide_id'] = guideId.toString();
    }
    if (isActive != null) {
      queryParameters['is_active'] = isActive.toString();
    }

    final Uri uri = Uri.parse(serviceBaseUrl).replace(queryParameters: queryParameters);
    final http.Response response = await http.get(uri, headers: {'Content-Type': 'application/json', if (authorization != null) 'Authorization': "Bearer $authorization"});

    if (response.statusCode != 200) {
      throw Exception('Failed to load rambles: ${response.body}');
    }

    final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;
    return jsonList.map((json) => Ramble.fromJson(json as Map<String, Object?>)).toList();
  }

  Future<Ramble> fetchRamble(int id, {String? authorization}) async {
    final Uri uri = Uri.parse('$serviceBaseUrl/$id');
    final http.Response response = await http.get(uri, headers: {'Content-Type': 'application/json', if (authorization != null) 'Authorization': "Bearer $authorization"});

    if (response.statusCode != 200) {
      throw Exception('Failed to load ramble: ${response.body}');
    }

    return Ramble.fromJson(jsonDecode(response.body) as Map<String, Object?>);
  }

  Future<int> createRamble(Map<String, Object?> data, {required String authorization}) async {
    final http.Response response = await http.post(
      Uri.parse(serviceBaseUrl),
      headers: {'Content-Type': 'application/json', 'Authorization': "Bearer $authorization"},
      body: jsonEncode(data),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create ramble: ${response.body}');
    }

    return jsonDecode(response.body)['id'] as int;
  }
}
