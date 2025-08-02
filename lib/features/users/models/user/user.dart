import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:balade/features/users/models/user_profile/user_profile.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
abstract class User with _$User {
  const factory User(int id, {required String email, UserProfile? profile, String? token}) = _User;

  factory User.fromJson(Map<String, Object?> json) => _$UserFromJson(json);
}
