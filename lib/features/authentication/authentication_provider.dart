import 'dart:convert';

import 'package:balade/features/authentication/authentication_service.dart';
import 'package:balade/features/users/models/user/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:balade/features/authentication/data/models/authed_user/authed_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

final authenticationProvider = StateNotifierProvider<AuthenticationNotifier, AuthedUser?>((ref) {
  return AuthenticationNotifier();
});

class AuthenticationNotifier extends StateNotifier<AuthedUser?> {
  AuthenticationNotifier() : super(null);

  Future<void> init({bool shouldFakeDelay = false}) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    // await preferences.remove("authed_user");

    if (!preferences.containsKey('authed_user')) {
      if (shouldFakeDelay) {
        await Future.delayed(const Duration(seconds: 2));
      }
      return;
    }

    if (shouldFakeDelay) {
      await Future.delayed(const Duration(seconds: 2));
    }

    final AuthedUser localUser = AuthedUser.fromJson(jsonDecode(preferences.getString('authed_user')!) as Map<String, Object?>);

    try {
      final User user = await AuthenticationService.instance.getMe(authorization: 'Bearer ${localUser.token}');

      state = AuthedUser(user: user, token: localUser.token);
    } catch (e) {
      // If the user cannot be fetched, we assume the token is invalid and clear the state.
      state = null;
      await preferences.remove('authed_user');
    }
  }

  Future<void> login(AuthedUser user) async {
    state = user;

    final SharedPreferences preferences = await SharedPreferences.getInstance();

    await preferences.setString('authed_user', jsonEncode(user.toJson()));
  }

  Future<void> logout() async {
    state = null;

    final SharedPreferences preferences = await SharedPreferences.getInstance();

    await preferences.remove('authed_user');
  }
}
