// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bulk_action_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BulkRegistrationActionPayload {

@JsonKey(name: 'registration_ids') List<int> get registrationIds; String get action; String? get reason;@JsonKey(name: 'send_email') bool get sendEmail;
/// Create a copy of BulkRegistrationActionPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BulkRegistrationActionPayloadCopyWith<BulkRegistrationActionPayload> get copyWith => _$BulkRegistrationActionPayloadCopyWithImpl<BulkRegistrationActionPayload>(this as BulkRegistrationActionPayload, _$identity);

  /// Serializes this BulkRegistrationActionPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BulkRegistrationActionPayload&&const DeepCollectionEquality().equals(other.registrationIds, registrationIds)&&(identical(other.action, action) || other.action == action)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.sendEmail, sendEmail) || other.sendEmail == sendEmail));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(registrationIds),action,reason,sendEmail);

@override
String toString() {
  return 'BulkRegistrationActionPayload(registrationIds: $registrationIds, action: $action, reason: $reason, sendEmail: $sendEmail)';
}


}

/// @nodoc
abstract mixin class $BulkRegistrationActionPayloadCopyWith<$Res>  {
  factory $BulkRegistrationActionPayloadCopyWith(BulkRegistrationActionPayload value, $Res Function(BulkRegistrationActionPayload) _then) = _$BulkRegistrationActionPayloadCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'registration_ids') List<int> registrationIds, String action, String? reason,@JsonKey(name: 'send_email') bool sendEmail
});




}
/// @nodoc
class _$BulkRegistrationActionPayloadCopyWithImpl<$Res>
    implements $BulkRegistrationActionPayloadCopyWith<$Res> {
  _$BulkRegistrationActionPayloadCopyWithImpl(this._self, this._then);

  final BulkRegistrationActionPayload _self;
  final $Res Function(BulkRegistrationActionPayload) _then;

/// Create a copy of BulkRegistrationActionPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? registrationIds = null,Object? action = null,Object? reason = freezed,Object? sendEmail = null,}) {
  return _then(_self.copyWith(
registrationIds: null == registrationIds ? _self.registrationIds : registrationIds // ignore: cast_nullable_to_non_nullable
as List<int>,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,sendEmail: null == sendEmail ? _self.sendEmail : sendEmail // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [BulkRegistrationActionPayload].
extension BulkRegistrationActionPayloadPatterns on BulkRegistrationActionPayload {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BulkRegistrationActionPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BulkRegistrationActionPayload() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BulkRegistrationActionPayload value)  $default,){
final _that = this;
switch (_that) {
case _BulkRegistrationActionPayload():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BulkRegistrationActionPayload value)?  $default,){
final _that = this;
switch (_that) {
case _BulkRegistrationActionPayload() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'registration_ids')  List<int> registrationIds,  String action,  String? reason, @JsonKey(name: 'send_email')  bool sendEmail)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BulkRegistrationActionPayload() when $default != null:
return $default(_that.registrationIds,_that.action,_that.reason,_that.sendEmail);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'registration_ids')  List<int> registrationIds,  String action,  String? reason, @JsonKey(name: 'send_email')  bool sendEmail)  $default,) {final _that = this;
switch (_that) {
case _BulkRegistrationActionPayload():
return $default(_that.registrationIds,_that.action,_that.reason,_that.sendEmail);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'registration_ids')  List<int> registrationIds,  String action,  String? reason, @JsonKey(name: 'send_email')  bool sendEmail)?  $default,) {final _that = this;
switch (_that) {
case _BulkRegistrationActionPayload() when $default != null:
return $default(_that.registrationIds,_that.action,_that.reason,_that.sendEmail);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BulkRegistrationActionPayload implements BulkRegistrationActionPayload {
  const _BulkRegistrationActionPayload({@JsonKey(name: 'registration_ids') required final  List<int> registrationIds, required this.action, this.reason, @JsonKey(name: 'send_email') this.sendEmail = false}): _registrationIds = registrationIds;
  factory _BulkRegistrationActionPayload.fromJson(Map<String, dynamic> json) => _$BulkRegistrationActionPayloadFromJson(json);

 final  List<int> _registrationIds;
@override@JsonKey(name: 'registration_ids') List<int> get registrationIds {
  if (_registrationIds is EqualUnmodifiableListView) return _registrationIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_registrationIds);
}

@override final  String action;
@override final  String? reason;
@override@JsonKey(name: 'send_email') final  bool sendEmail;

/// Create a copy of BulkRegistrationActionPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BulkRegistrationActionPayloadCopyWith<_BulkRegistrationActionPayload> get copyWith => __$BulkRegistrationActionPayloadCopyWithImpl<_BulkRegistrationActionPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BulkRegistrationActionPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BulkRegistrationActionPayload&&const DeepCollectionEquality().equals(other._registrationIds, _registrationIds)&&(identical(other.action, action) || other.action == action)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.sendEmail, sendEmail) || other.sendEmail == sendEmail));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_registrationIds),action,reason,sendEmail);

@override
String toString() {
  return 'BulkRegistrationActionPayload(registrationIds: $registrationIds, action: $action, reason: $reason, sendEmail: $sendEmail)';
}


}

/// @nodoc
abstract mixin class _$BulkRegistrationActionPayloadCopyWith<$Res> implements $BulkRegistrationActionPayloadCopyWith<$Res> {
  factory _$BulkRegistrationActionPayloadCopyWith(_BulkRegistrationActionPayload value, $Res Function(_BulkRegistrationActionPayload) _then) = __$BulkRegistrationActionPayloadCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'registration_ids') List<int> registrationIds, String action, String? reason,@JsonKey(name: 'send_email') bool sendEmail
});




}
/// @nodoc
class __$BulkRegistrationActionPayloadCopyWithImpl<$Res>
    implements _$BulkRegistrationActionPayloadCopyWith<$Res> {
  __$BulkRegistrationActionPayloadCopyWithImpl(this._self, this._then);

  final _BulkRegistrationActionPayload _self;
  final $Res Function(_BulkRegistrationActionPayload) _then;

/// Create a copy of BulkRegistrationActionPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? registrationIds = null,Object? action = null,Object? reason = freezed,Object? sendEmail = null,}) {
  return _then(_BulkRegistrationActionPayload(
registrationIds: null == registrationIds ? _self._registrationIds : registrationIds // ignore: cast_nullable_to_non_nullable
as List<int>,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,sendEmail: null == sendEmail ? _self.sendEmail : sendEmail // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
