import 'dart:convert';

import 'package:balade/features/users/models/user/user.dart';
import 'package:flutter/services.dart';
import 'package:balade/core/constants.dart';
import 'package:http/http.dart' as http;
import 'package:balade/features/authentication/data/models/login_result/login_result.dart';

class AuthenticationService {
  AuthenticationService._();

  final String serviceBaseUrl = '$kApiBaseUrl/authentication';

  static final AuthenticationService instance = AuthenticationService._();

  // This method is used to authenticate a user by sending their email and optional profile details.
  // It sends a POST request to the authentication service leading to an email code being sent to the user.
  Future<void> authenticate(String email, {String? firstName, String? lastName, String? phone}) async {
    final http.Response response = await http.post(
      Uri.parse('$serviceBaseUrl/authenticate'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, if (firstName != null) 'first_name': firstName, if (lastName != null) 'last_name': lastName, if (phone != null) 'phone': phone}),
    );

    if (response.statusCode != 200) {
      throw PlatformException(code: response.statusCode.toString(), message: 'Failed to authenticate user: ${response.reasonPhrase}');
    }
  }

  Future<User> getMe({required String authorization}) async {
    final http.Response response = await http.get(Uri.parse('$serviceBaseUrl/me'), headers: {'Authorization': authorization});

    if (response.statusCode != 200) {
      throw PlatformException(code: response.statusCode.toString(), message: 'Failed to get user: ${response.reasonPhrase}');
    }

    return User.fromJson(jsonDecode(response.body) as Map<String, Object?>);
  }

  Future<LoginResult> verifyAuthentication(String email, String code) async {
    final http.Response response = await http.post(
      Uri.parse('$serviceBaseUrl/verify-authentication'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'code': code}),
    );

    if (response.statusCode != 200) {
      throw PlatformException(code: response.statusCode.toString(), message: 'Failed to verify authentication: ${response.reasonPhrase}');
    }

    return LoginResult.fromJson(jsonDecode(response.body) as Map<String, Object?>);
  }
}
