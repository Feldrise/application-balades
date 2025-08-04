import 'dart:convert';

import 'package:balade/core/constants.dart';
import 'package:http/http.dart' as http;

class RamblesService {
  RamblesService._();

  final String serviceBaseUrl = '$kApiBaseUrl/rambles';

  static final RamblesService instance = RamblesService._();

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
