// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authed_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuthedUser _$AuthedUserFromJson(Map<String, dynamic> json) => _AuthedUser(
  user: User.fromJson(json['user'] as Map<String, dynamic>),
  token: json['token'] as String,
);

Map<String, dynamic> _$AuthedUserToJson(_AuthedUser instance) =>
    <String, dynamic>{'user': instance.user, 'token': instance.token};
