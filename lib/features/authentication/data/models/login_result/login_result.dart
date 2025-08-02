import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:balade/features/users/models/user/user.dart';

part 'login_result.freezed.dart';
part 'login_result.g.dart';

@freezed
abstract class LoginResult with _$LoginResult {
  const factory LoginResult({User? user, String? token}) = _LoginResult;

  factory LoginResult.fromJson(Map<String, Object?> json) => _$LoginResultFromJson(json);
}
