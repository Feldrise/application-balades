import 'dart:convert';

import 'package:balade/core/constants.dart';
import 'package:balade/features/guides/models/guide/guide.dart';
import 'package:http/http.dart' as http;

class GuidesService {
  GuidesService._();

  final String serviceBaseUrl = '$kApiBaseUrl/guides';

  static final GuidesService instance = GuidesService._();

  Future<List<Guide>> fetchGuides(String search, {bool? isActive, String? authorization}) async {
    final Uri uri = Uri.parse(serviceBaseUrl).replace(queryParameters: {'search': search, if (isActive != null) 'is_active': isActive.toString()});
    final http.Response response = await http.get(uri, headers: {'Content-Type': 'application/json', if (authorization != null) 'Authorization': "Bearer $authorization"});

    if (response.statusCode != 200) {
      throw Exception('Failed to load guides: ${response.body}');
    }

    final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;
    return jsonList.map((json) => Guide.fromJson(json as Map<String, Object?>)).toList();
  }

  Future<Guide> fetchGuide(int id, {String? authorization}) async {
    final Uri uri = Uri.parse('$serviceBaseUrl/$id');
    final http.Response response = await http.get(uri, headers: {'Content-Type': 'application/json', if (authorization != null) 'Authorization': "Bearer $authorization"});

    if (response.statusCode != 200) {
      throw Exception('Failed to load guide: ${response.body}');
    }

    return Guide.fromJson(jsonDecode(response.body) as Map<String, Object?>);
  }

  Future<int> createGuide(Map<String, Object?> data, {required String authorization}) async {
    final http.Response response = await http.post(
      Uri.parse(serviceBaseUrl),
      headers: {'Content-Type': 'application/json', 'Authorization': "Bearer $authorization"},
      body: jsonEncode(data),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create guide: ${response.body}');
    }

    return jsonDecode(response.body)['id'] as int;
  }

  Future<void> updateGuide(int id, Map<String, Object?> data, {required String authorization}) async {
    final http.Response response = await http.put(
      Uri.parse('$serviceBaseUrl/$id'),
      headers: {'Content-Type': 'application/json', 'Authorization': "Bearer $authorization"},
      body: jsonEncode(data),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update guide: ${response.body}');
    }
  }
}
