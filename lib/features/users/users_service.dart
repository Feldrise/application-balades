import 'dart:convert';

import 'package:balade/core/constants.dart';
import 'package:balade/features/users/models/user/user.dart';
import 'package:http/http.dart' as http;

class UsersService {
  UsersService._();

  final String serviceBaseUrl = '$kApiBaseUrl/authentication/users';

  static final UsersService instance = UsersService._();

  Future<List<User>> searchUsers(String search, {required String authorization}) async {
    final Uri uri = Uri.parse(serviceBaseUrl).replace(queryParameters: {if (search.isNotEmpty) 'search': search});
    final http.Response response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $authorization'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to search users: ${response.body}');
    }

    final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;
    return jsonList.map((json) => User.fromJson(json as Map<String, Object?>)).toList();
  }
}
