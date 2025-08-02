import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:balade/features/users/models/user/user.dart';

part 'authed_user.freezed.dart';
part 'authed_user.g.dart';

@freezed
abstract class AuthedUser with _$AuthedUser {
  const factory AuthedUser({required User user, required String token}) = _AuthedUser;

  factory AuthedUser.fromJson(Map<String, Object?> json) => _$AuthedUserFromJson(json);
}
