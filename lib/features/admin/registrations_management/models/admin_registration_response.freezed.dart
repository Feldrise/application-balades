// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_registration_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AdminRegistrationListResponse {

 List<Registration> get registrations; int get total; int get page;@JsonKey(name: 'per_page') int get perPage;@JsonKey(name: 'total_pages') int get totalPages;
/// Create a copy of AdminRegistrationListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminRegistrationListResponseCopyWith<AdminRegistrationListResponse> get copyWith => _$AdminRegistrationListResponseCopyWithImpl<AdminRegistrationListResponse>(this as AdminRegistrationListResponse, _$identity);

  /// Serializes this AdminRegistrationListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminRegistrationListResponse&&const DeepCollectionEquality().equals(other.registrations, registrations)&&(identical(other.total, total) || other.total == total)&&(identical(other.page, page) || other.page == page)&&(identical(other.perPage, perPage) || other.perPage == perPage)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(registrations),total,page,perPage,totalPages);

@override
String toString() {
  return 'AdminRegistrationListResponse(registrations: $registrations, total: $total, page: $page, perPage: $perPage, totalPages: $totalPages)';
}


}

/// @nodoc
abstract mixin class $AdminRegistrationListResponseCopyWith<$Res>  {
  factory $AdminRegistrationListResponseCopyWith(AdminRegistrationListResponse value, $Res Function(AdminRegistrationListResponse) _then) = _$AdminRegistrationListResponseCopyWithImpl;
@useResult
$Res call({
 List<Registration> registrations, int total, int page,@JsonKey(name: 'per_page') int perPage,@JsonKey(name: 'total_pages') int totalPages
});




}
/// @nodoc
class _$AdminRegistrationListResponseCopyWithImpl<$Res>
    implements $AdminRegistrationListResponseCopyWith<$Res> {
  _$AdminRegistrationListResponseCopyWithImpl(this._self, this._then);

  final AdminRegistrationListResponse _self;
  final $Res Function(AdminRegistrationListResponse) _then;

/// Create a copy of AdminRegistrationListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? registrations = null,Object? total = null,Object? page = null,Object? perPage = null,Object? totalPages = null,}) {
  return _then(_self.copyWith(
registrations: null == registrations ? _self.registrations : registrations // ignore: cast_nullable_to_non_nullable
as List<Registration>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,perPage: null == perPage ? _self.perPage : perPage // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminRegistrationListResponse].
extension AdminRegistrationListResponsePatterns on AdminRegistrationListResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminRegistrationListResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminRegistrationListResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminRegistrationListResponse value)  $default,){
final _that = this;
switch (_that) {
case _AdminRegistrationListResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminRegistrationListResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AdminRegistrationListResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Registration> registrations,  int total,  int page, @JsonKey(name: 'per_page')  int perPage, @JsonKey(name: 'total_pages')  int totalPages)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminRegistrationListResponse() when $default != null:
return $default(_that.registrations,_that.total,_that.page,_that.perPage,_that.totalPages);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Registration> registrations,  int total,  int page, @JsonKey(name: 'per_page')  int perPage, @JsonKey(name: 'total_pages')  int totalPages)  $default,) {final _that = this;
switch (_that) {
case _AdminRegistrationListResponse():
return $default(_that.registrations,_that.total,_that.page,_that.perPage,_that.totalPages);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Registration> registrations,  int total,  int page, @JsonKey(name: 'per_page')  int perPage, @JsonKey(name: 'total_pages')  int totalPages)?  $default,) {final _that = this;
switch (_that) {
case _AdminRegistrationListResponse() when $default != null:
return $default(_that.registrations,_that.total,_that.page,_that.perPage,_that.totalPages);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminRegistrationListResponse implements AdminRegistrationListResponse {
  const _AdminRegistrationListResponse({required final  List<Registration> registrations, required this.total, required this.page, @JsonKey(name: 'per_page') required this.perPage, @JsonKey(name: 'total_pages') required this.totalPages}): _registrations = registrations;
  factory _AdminRegistrationListResponse.fromJson(Map<String, dynamic> json) => _$AdminRegistrationListResponseFromJson(json);

 final  List<Registration> _registrations;
@override List<Registration> get registrations {
  if (_registrations is EqualUnmodifiableListView) return _registrations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_registrations);
}

@override final  int total;
@override final  int page;
@override@JsonKey(name: 'per_page') final  int perPage;
@override@JsonKey(name: 'total_pages') final  int totalPages;

/// Create a copy of AdminRegistrationListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminRegistrationListResponseCopyWith<_AdminRegistrationListResponse> get copyWith => __$AdminRegistrationListResponseCopyWithImpl<_AdminRegistrationListResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminRegistrationListResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminRegistrationListResponse&&const DeepCollectionEquality().equals(other._registrations, _registrations)&&(identical(other.total, total) || other.total == total)&&(identical(other.page, page) || other.page == page)&&(identical(other.perPage, perPage) || other.perPage == perPage)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_registrations),total,page,perPage,totalPages);

@override
String toString() {
  return 'AdminRegistrationListResponse(registrations: $registrations, total: $total, page: $page, perPage: $perPage, totalPages: $totalPages)';
}


}

/// @nodoc
abstract mixin class _$AdminRegistrationListResponseCopyWith<$Res> implements $AdminRegistrationListResponseCopyWith<$Res> {
  factory _$AdminRegistrationListResponseCopyWith(_AdminRegistrationListResponse value, $Res Function(_AdminRegistrationListResponse) _then) = __$AdminRegistrationListResponseCopyWithImpl;
@override @useResult
$Res call({
 List<Registration> registrations, int total, int page,@JsonKey(name: 'per_page') int perPage,@JsonKey(name: 'total_pages') int totalPages
});




}
/// @nodoc
class __$AdminRegistrationListResponseCopyWithImpl<$Res>
    implements _$AdminRegistrationListResponseCopyWith<$Res> {
  __$AdminRegistrationListResponseCopyWithImpl(this._self, this._then);

  final _AdminRegistrationListResponse _self;
  final $Res Function(_AdminRegistrationListResponse) _then;

/// Create a copy of AdminRegistrationListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? registrations = null,Object? total = null,Object? page = null,Object? perPage = null,Object? totalPages = null,}) {
  return _then(_AdminRegistrationListResponse(
registrations: null == registrations ? _self._registrations : registrations // ignore: cast_nullable_to_non_nullable
as List<Registration>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,perPage: null == perPage ? _self.perPage : perPage // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$AdminRegistrationUpdatePayload {

@JsonKey(name: 'first_name') String? get firstName;@JsonKey(name: 'last_name') String? get lastName; String? get email; String? get phone; String? get status; String? get notes;
/// Create a copy of AdminRegistrationUpdatePayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminRegistrationUpdatePayloadCopyWith<AdminRegistrationUpdatePayload> get copyWith => _$AdminRegistrationUpdatePayloadCopyWithImpl<AdminRegistrationUpdatePayload>(this as AdminRegistrationUpdatePayload, _$identity);

  /// Serializes this AdminRegistrationUpdatePayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminRegistrationUpdatePayload&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.status, status) || other.status == status)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,firstName,lastName,email,phone,status,notes);

@override
String toString() {
  return 'AdminRegistrationUpdatePayload(firstName: $firstName, lastName: $lastName, email: $email, phone: $phone, status: $status, notes: $notes)';
}


}

/// @nodoc
abstract mixin class $AdminRegistrationUpdatePayloadCopyWith<$Res>  {
  factory $AdminRegistrationUpdatePayloadCopyWith(AdminRegistrationUpdatePayload value, $Res Function(AdminRegistrationUpdatePayload) _then) = _$AdminRegistrationUpdatePayloadCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'first_name') String? firstName,@JsonKey(name: 'last_name') String? lastName, String? email, String? phone, String? status, String? notes
});




}
/// @nodoc
class _$AdminRegistrationUpdatePayloadCopyWithImpl<$Res>
    implements $AdminRegistrationUpdatePayloadCopyWith<$Res> {
  _$AdminRegistrationUpdatePayloadCopyWithImpl(this._self, this._then);

  final AdminRegistrationUpdatePayload _self;
  final $Res Function(AdminRegistrationUpdatePayload) _then;

/// Create a copy of AdminRegistrationUpdatePayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? firstName = freezed,Object? lastName = freezed,Object? email = freezed,Object? phone = freezed,Object? status = freezed,Object? notes = freezed,}) {
  return _then(_self.copyWith(
firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminRegistrationUpdatePayload].
extension AdminRegistrationUpdatePayloadPatterns on AdminRegistrationUpdatePayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminRegistrationUpdatePayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminRegistrationUpdatePayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminRegistrationUpdatePayload value)  $default,){
final _that = this;
switch (_that) {
case _AdminRegistrationUpdatePayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminRegistrationUpdatePayload value)?  $default,){
final _that = this;
switch (_that) {
case _AdminRegistrationUpdatePayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'first_name')  String? firstName, @JsonKey(name: 'last_name')  String? lastName,  String? email,  String? phone,  String? status,  String? notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminRegistrationUpdatePayload() when $default != null:
return $default(_that.firstName,_that.lastName,_that.email,_that.phone,_that.status,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'first_name')  String? firstName, @JsonKey(name: 'last_name')  String? lastName,  String? email,  String? phone,  String? status,  String? notes)  $default,) {final _that = this;
switch (_that) {
case _AdminRegistrationUpdatePayload():
return $default(_that.firstName,_that.lastName,_that.email,_that.phone,_that.status,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'first_name')  String? firstName, @JsonKey(name: 'last_name')  String? lastName,  String? email,  String? phone,  String? status,  String? notes)?  $default,) {final _that = this;
switch (_that) {
case _AdminRegistrationUpdatePayload() when $default != null:
return $default(_that.firstName,_that.lastName,_that.email,_that.phone,_that.status,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminRegistrationUpdatePayload implements AdminRegistrationUpdatePayload {
  const _AdminRegistrationUpdatePayload({@JsonKey(name: 'first_name') this.firstName, @JsonKey(name: 'last_name') this.lastName, this.email, this.phone, this.status, this.notes});
  factory _AdminRegistrationUpdatePayload.fromJson(Map<String, dynamic> json) => _$AdminRegistrationUpdatePayloadFromJson(json);

@override@JsonKey(name: 'first_name') final  String? firstName;
@override@JsonKey(name: 'last_name') final  String? lastName;
@override final  String? email;
@override final  String? phone;
@override final  String? status;
@override final  String? notes;

/// Create a copy of AdminRegistrationUpdatePayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminRegistrationUpdatePayloadCopyWith<_AdminRegistrationUpdatePayload> get copyWith => __$AdminRegistrationUpdatePayloadCopyWithImpl<_AdminRegistrationUpdatePayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminRegistrationUpdatePayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminRegistrationUpdatePayload&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.status, status) || other.status == status)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,firstName,lastName,email,phone,status,notes);

@override
String toString() {
  return 'AdminRegistrationUpdatePayload(firstName: $firstName, lastName: $lastName, email: $email, phone: $phone, status: $status, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$AdminRegistrationUpdatePayloadCopyWith<$Res> implements $AdminRegistrationUpdatePayloadCopyWith<$Res> {
  factory _$AdminRegistrationUpdatePayloadCopyWith(_AdminRegistrationUpdatePayload value, $Res Function(_AdminRegistrationUpdatePayload) _then) = __$AdminRegistrationUpdatePayloadCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'first_name') String? firstName,@JsonKey(name: 'last_name') String? lastName, String? email, String? phone, String? status, String? notes
});




}
/// @nodoc
class __$AdminRegistrationUpdatePayloadCopyWithImpl<$Res>
    implements _$AdminRegistrationUpdatePayloadCopyWith<$Res> {
  __$AdminRegistrationUpdatePayloadCopyWithImpl(this._self, this._then);

  final _AdminRegistrationUpdatePayload _self;
  final $Res Function(_AdminRegistrationUpdatePayload) _then;

/// Create a copy of AdminRegistrationUpdatePayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? firstName = freezed,Object? lastName = freezed,Object? email = freezed,Object? phone = freezed,Object? status = freezed,Object? notes = freezed,}) {
  return _then(_AdminRegistrationUpdatePayload(
firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$AdminRegistrationStatusUpdatePayload {

 String get status; String? get reason;@JsonKey(name: 'send_email') bool get sendEmail;
/// Create a copy of AdminRegistrationStatusUpdatePayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminRegistrationStatusUpdatePayloadCopyWith<AdminRegistrationStatusUpdatePayload> get copyWith => _$AdminRegistrationStatusUpdatePayloadCopyWithImpl<AdminRegistrationStatusUpdatePayload>(this as AdminRegistrationStatusUpdatePayload, _$identity);

  /// Serializes this AdminRegistrationStatusUpdatePayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminRegistrationStatusUpdatePayload&&(identical(other.status, status) || other.status == status)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.sendEmail, sendEmail) || other.sendEmail == sendEmail));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,reason,sendEmail);

@override
String toString() {
  return 'AdminRegistrationStatusUpdatePayload(status: $status, reason: $reason, sendEmail: $sendEmail)';
}


}

/// @nodoc
abstract mixin class $AdminRegistrationStatusUpdatePayloadCopyWith<$Res>  {
  factory $AdminRegistrationStatusUpdatePayloadCopyWith(AdminRegistrationStatusUpdatePayload value, $Res Function(AdminRegistrationStatusUpdatePayload) _then) = _$AdminRegistrationStatusUpdatePayloadCopyWithImpl;
@useResult
$Res call({
 String status, String? reason,@JsonKey(name: 'send_email') bool sendEmail
});




}
/// @nodoc
class _$AdminRegistrationStatusUpdatePayloadCopyWithImpl<$Res>
    implements $AdminRegistrationStatusUpdatePayloadCopyWith<$Res> {
  _$AdminRegistrationStatusUpdatePayloadCopyWithImpl(this._self, this._then);

  final AdminRegistrationStatusUpdatePayload _self;
  final $Res Function(AdminRegistrationStatusUpdatePayload) _then;

/// Create a copy of AdminRegistrationStatusUpdatePayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? reason = freezed,Object? sendEmail = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,sendEmail: null == sendEmail ? _self.sendEmail : sendEmail // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminRegistrationStatusUpdatePayload].
extension AdminRegistrationStatusUpdatePayloadPatterns on AdminRegistrationStatusUpdatePayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminRegistrationStatusUpdatePayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminRegistrationStatusUpdatePayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminRegistrationStatusUpdatePayload value)  $default,){
final _that = this;
switch (_that) {
case _AdminRegistrationStatusUpdatePayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminRegistrationStatusUpdatePayload value)?  $default,){
final _that = this;
switch (_that) {
case _AdminRegistrationStatusUpdatePayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String status,  String? reason, @JsonKey(name: 'send_email')  bool sendEmail)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminRegistrationStatusUpdatePayload() when $default != null:
return $default(_that.status,_that.reason,_that.sendEmail);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String status,  String? reason, @JsonKey(name: 'send_email')  bool sendEmail)  $default,) {final _that = this;
switch (_that) {
case _AdminRegistrationStatusUpdatePayload():
return $default(_that.status,_that.reason,_that.sendEmail);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String status,  String? reason, @JsonKey(name: 'send_email')  bool sendEmail)?  $default,) {final _that = this;
switch (_that) {
case _AdminRegistrationStatusUpdatePayload() when $default != null:
return $default(_that.status,_that.reason,_that.sendEmail);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminRegistrationStatusUpdatePayload implements AdminRegistrationStatusUpdatePayload {
  const _AdminRegistrationStatusUpdatePayload({required this.status, this.reason, @JsonKey(name: 'send_email') this.sendEmail = false});
  factory _AdminRegistrationStatusUpdatePayload.fromJson(Map<String, dynamic> json) => _$AdminRegistrationStatusUpdatePayloadFromJson(json);

@override final  String status;
@override final  String? reason;
@override@JsonKey(name: 'send_email') final  bool sendEmail;

/// Create a copy of AdminRegistrationStatusUpdatePayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminRegistrationStatusUpdatePayloadCopyWith<_AdminRegistrationStatusUpdatePayload> get copyWith => __$AdminRegistrationStatusUpdatePayloadCopyWithImpl<_AdminRegistrationStatusUpdatePayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminRegistrationStatusUpdatePayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminRegistrationStatusUpdatePayload&&(identical(other.status, status) || other.status == status)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.sendEmail, sendEmail) || other.sendEmail == sendEmail));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,reason,sendEmail);

@override
String toString() {
  return 'AdminRegistrationStatusUpdatePayload(status: $status, reason: $reason, sendEmail: $sendEmail)';
}


}

/// @nodoc
abstract mixin class _$AdminRegistrationStatusUpdatePayloadCopyWith<$Res> implements $AdminRegistrationStatusUpdatePayloadCopyWith<$Res> {
  factory _$AdminRegistrationStatusUpdatePayloadCopyWith(_AdminRegistrationStatusUpdatePayload value, $Res Function(_AdminRegistrationStatusUpdatePayload) _then) = __$AdminRegistrationStatusUpdatePayloadCopyWithImpl;
@override @useResult
$Res call({
 String status, String? reason,@JsonKey(name: 'send_email') bool sendEmail
});




}
/// @nodoc
class __$AdminRegistrationStatusUpdatePayloadCopyWithImpl<$Res>
    implements _$AdminRegistrationStatusUpdatePayloadCopyWith<$Res> {
  __$AdminRegistrationStatusUpdatePayloadCopyWithImpl(this._self, this._then);

  final _AdminRegistrationStatusUpdatePayload _self;
  final $Res Function(_AdminRegistrationStatusUpdatePayload) _then;

/// Create a copy of AdminRegistrationStatusUpdatePayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? reason = freezed,Object? sendEmail = null,}) {
  return _then(_AdminRegistrationStatusUpdatePayload(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,sendEmail: null == sendEmail ? _self.sendEmail : sendEmail // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
