// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'registration.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Registration {

 int get id;@JsonKey(name: 'created_at')@DateSerializer() DateTime get createdAt;@JsonKey(name: 'updated_at')@DateSerializer() DateTime get updatedAt;@JsonKey(name: 'first_name') String get firstName;@JsonKey(name: 'last_name') String get lastName; String get email; String? get phone; String get status;@JsonKey(name: 'registration_date')@DateSerializer() DateTime get registrationDate;@JsonKey(name: 'confirmation_date')@DateSerializer() DateTime? get confirmationDate;@JsonKey(name: 'confirmation_deadline')@DateSerializer() DateTime? get confirmationDeadline;@JsonKey(name: 'cancellation_date')@DateSerializer() DateTime? get cancellationDate;@JsonKey(name: 'cancellation_reason') String? get cancellationReason;@JsonKey(name: 'ramble_id') int get rambleId;@JsonKey(name: 'user_id') int? get userId;@JsonKey(name: 'group_id') int? get groupId;// Optional embedded ramble summary returned by the list API
 RegistrationRambleSummary? get ramble;
/// Create a copy of Registration
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RegistrationCopyWith<Registration> get copyWith => _$RegistrationCopyWithImpl<Registration>(this as Registration, _$identity);

  /// Serializes this Registration to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Registration&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.status, status) || other.status == status)&&(identical(other.registrationDate, registrationDate) || other.registrationDate == registrationDate)&&(identical(other.confirmationDate, confirmationDate) || other.confirmationDate == confirmationDate)&&(identical(other.confirmationDeadline, confirmationDeadline) || other.confirmationDeadline == confirmationDeadline)&&(identical(other.cancellationDate, cancellationDate) || other.cancellationDate == cancellationDate)&&(identical(other.cancellationReason, cancellationReason) || other.cancellationReason == cancellationReason)&&(identical(other.rambleId, rambleId) || other.rambleId == rambleId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.ramble, ramble) || other.ramble == ramble));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,createdAt,updatedAt,firstName,lastName,email,phone,status,registrationDate,confirmationDate,confirmationDeadline,cancellationDate,cancellationReason,rambleId,userId,groupId,ramble);

@override
String toString() {
  return 'Registration(id: $id, createdAt: $createdAt, updatedAt: $updatedAt, firstName: $firstName, lastName: $lastName, email: $email, phone: $phone, status: $status, registrationDate: $registrationDate, confirmationDate: $confirmationDate, confirmationDeadline: $confirmationDeadline, cancellationDate: $cancellationDate, cancellationReason: $cancellationReason, rambleId: $rambleId, userId: $userId, groupId: $groupId, ramble: $ramble)';
}


}

/// @nodoc
abstract mixin class $RegistrationCopyWith<$Res>  {
  factory $RegistrationCopyWith(Registration value, $Res Function(Registration) _then) = _$RegistrationCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'created_at')@DateSerializer() DateTime createdAt,@JsonKey(name: 'updated_at')@DateSerializer() DateTime updatedAt,@JsonKey(name: 'first_name') String firstName,@JsonKey(name: 'last_name') String lastName, String email, String? phone, String status,@JsonKey(name: 'registration_date')@DateSerializer() DateTime registrationDate,@JsonKey(name: 'confirmation_date')@DateSerializer() DateTime? confirmationDate,@JsonKey(name: 'confirmation_deadline')@DateSerializer() DateTime? confirmationDeadline,@JsonKey(name: 'cancellation_date')@DateSerializer() DateTime? cancellationDate,@JsonKey(name: 'cancellation_reason') String? cancellationReason,@JsonKey(name: 'ramble_id') int rambleId,@JsonKey(name: 'user_id') int? userId,@JsonKey(name: 'group_id') int? groupId, RegistrationRambleSummary? ramble
});


$RegistrationRambleSummaryCopyWith<$Res>? get ramble;

}
/// @nodoc
class _$RegistrationCopyWithImpl<$Res>
    implements $RegistrationCopyWith<$Res> {
  _$RegistrationCopyWithImpl(this._self, this._then);

  final Registration _self;
  final $Res Function(Registration) _then;

/// Create a copy of Registration
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? createdAt = null,Object? updatedAt = null,Object? firstName = null,Object? lastName = null,Object? email = null,Object? phone = freezed,Object? status = null,Object? registrationDate = null,Object? confirmationDate = freezed,Object? confirmationDeadline = freezed,Object? cancellationDate = freezed,Object? cancellationReason = freezed,Object? rambleId = null,Object? userId = freezed,Object? groupId = freezed,Object? ramble = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,registrationDate: null == registrationDate ? _self.registrationDate : registrationDate // ignore: cast_nullable_to_non_nullable
as DateTime,confirmationDate: freezed == confirmationDate ? _self.confirmationDate : confirmationDate // ignore: cast_nullable_to_non_nullable
as DateTime?,confirmationDeadline: freezed == confirmationDeadline ? _self.confirmationDeadline : confirmationDeadline // ignore: cast_nullable_to_non_nullable
as DateTime?,cancellationDate: freezed == cancellationDate ? _self.cancellationDate : cancellationDate // ignore: cast_nullable_to_non_nullable
as DateTime?,cancellationReason: freezed == cancellationReason ? _self.cancellationReason : cancellationReason // ignore: cast_nullable_to_non_nullable
as String?,rambleId: null == rambleId ? _self.rambleId : rambleId // ignore: cast_nullable_to_non_nullable
as int,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int?,groupId: freezed == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as int?,ramble: freezed == ramble ? _self.ramble : ramble // ignore: cast_nullable_to_non_nullable
as RegistrationRambleSummary?,
  ));
}
/// Create a copy of Registration
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RegistrationRambleSummaryCopyWith<$Res>? get ramble {
    if (_self.ramble == null) {
    return null;
  }

  return $RegistrationRambleSummaryCopyWith<$Res>(_self.ramble!, (value) {
    return _then(_self.copyWith(ramble: value));
  });
}
}


/// Adds pattern-matching-related methods to [Registration].
extension RegistrationPatterns on Registration {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Registration value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Registration() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Registration value)  $default,){
final _that = this;
switch (_that) {
case _Registration():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Registration value)?  $default,){
final _that = this;
switch (_that) {
case _Registration() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'created_at')@DateSerializer()  DateTime createdAt, @JsonKey(name: 'updated_at')@DateSerializer()  DateTime updatedAt, @JsonKey(name: 'first_name')  String firstName, @JsonKey(name: 'last_name')  String lastName,  String email,  String? phone,  String status, @JsonKey(name: 'registration_date')@DateSerializer()  DateTime registrationDate, @JsonKey(name: 'confirmation_date')@DateSerializer()  DateTime? confirmationDate, @JsonKey(name: 'confirmation_deadline')@DateSerializer()  DateTime? confirmationDeadline, @JsonKey(name: 'cancellation_date')@DateSerializer()  DateTime? cancellationDate, @JsonKey(name: 'cancellation_reason')  String? cancellationReason, @JsonKey(name: 'ramble_id')  int rambleId, @JsonKey(name: 'user_id')  int? userId, @JsonKey(name: 'group_id')  int? groupId,  RegistrationRambleSummary? ramble)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Registration() when $default != null:
return $default(_that.id,_that.createdAt,_that.updatedAt,_that.firstName,_that.lastName,_that.email,_that.phone,_that.status,_that.registrationDate,_that.confirmationDate,_that.confirmationDeadline,_that.cancellationDate,_that.cancellationReason,_that.rambleId,_that.userId,_that.groupId,_that.ramble);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'created_at')@DateSerializer()  DateTime createdAt, @JsonKey(name: 'updated_at')@DateSerializer()  DateTime updatedAt, @JsonKey(name: 'first_name')  String firstName, @JsonKey(name: 'last_name')  String lastName,  String email,  String? phone,  String status, @JsonKey(name: 'registration_date')@DateSerializer()  DateTime registrationDate, @JsonKey(name: 'confirmation_date')@DateSerializer()  DateTime? confirmationDate, @JsonKey(name: 'confirmation_deadline')@DateSerializer()  DateTime? confirmationDeadline, @JsonKey(name: 'cancellation_date')@DateSerializer()  DateTime? cancellationDate, @JsonKey(name: 'cancellation_reason')  String? cancellationReason, @JsonKey(name: 'ramble_id')  int rambleId, @JsonKey(name: 'user_id')  int? userId, @JsonKey(name: 'group_id')  int? groupId,  RegistrationRambleSummary? ramble)  $default,) {final _that = this;
switch (_that) {
case _Registration():
return $default(_that.id,_that.createdAt,_that.updatedAt,_that.firstName,_that.lastName,_that.email,_that.phone,_that.status,_that.registrationDate,_that.confirmationDate,_that.confirmationDeadline,_that.cancellationDate,_that.cancellationReason,_that.rambleId,_that.userId,_that.groupId,_that.ramble);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'created_at')@DateSerializer()  DateTime createdAt, @JsonKey(name: 'updated_at')@DateSerializer()  DateTime updatedAt, @JsonKey(name: 'first_name')  String firstName, @JsonKey(name: 'last_name')  String lastName,  String email,  String? phone,  String status, @JsonKey(name: 'registration_date')@DateSerializer()  DateTime registrationDate, @JsonKey(name: 'confirmation_date')@DateSerializer()  DateTime? confirmationDate, @JsonKey(name: 'confirmation_deadline')@DateSerializer()  DateTime? confirmationDeadline, @JsonKey(name: 'cancellation_date')@DateSerializer()  DateTime? cancellationDate, @JsonKey(name: 'cancellation_reason')  String? cancellationReason, @JsonKey(name: 'ramble_id')  int rambleId, @JsonKey(name: 'user_id')  int? userId, @JsonKey(name: 'group_id')  int? groupId,  RegistrationRambleSummary? ramble)?  $default,) {final _that = this;
switch (_that) {
case _Registration() when $default != null:
return $default(_that.id,_that.createdAt,_that.updatedAt,_that.firstName,_that.lastName,_that.email,_that.phone,_that.status,_that.registrationDate,_that.confirmationDate,_that.confirmationDeadline,_that.cancellationDate,_that.cancellationReason,_that.rambleId,_that.userId,_that.groupId,_that.ramble);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Registration implements Registration {
  const _Registration(this.id, {@JsonKey(name: 'created_at')@DateSerializer() required this.createdAt, @JsonKey(name: 'updated_at')@DateSerializer() required this.updatedAt, @JsonKey(name: 'first_name') required this.firstName, @JsonKey(name: 'last_name') required this.lastName, required this.email, this.phone, required this.status, @JsonKey(name: 'registration_date')@DateSerializer() required this.registrationDate, @JsonKey(name: 'confirmation_date')@DateSerializer() this.confirmationDate, @JsonKey(name: 'confirmation_deadline')@DateSerializer() this.confirmationDeadline, @JsonKey(name: 'cancellation_date')@DateSerializer() this.cancellationDate, @JsonKey(name: 'cancellation_reason') this.cancellationReason, @JsonKey(name: 'ramble_id') required this.rambleId, @JsonKey(name: 'user_id') this.userId, @JsonKey(name: 'group_id') this.groupId, this.ramble});
  factory _Registration.fromJson(Map<String, dynamic> json) => _$RegistrationFromJson(json);

@override final  int id;
@override@JsonKey(name: 'created_at')@DateSerializer() final  DateTime createdAt;
@override@JsonKey(name: 'updated_at')@DateSerializer() final  DateTime updatedAt;
@override@JsonKey(name: 'first_name') final  String firstName;
@override@JsonKey(name: 'last_name') final  String lastName;
@override final  String email;
@override final  String? phone;
@override final  String status;
@override@JsonKey(name: 'registration_date')@DateSerializer() final  DateTime registrationDate;
@override@JsonKey(name: 'confirmation_date')@DateSerializer() final  DateTime? confirmationDate;
@override@JsonKey(name: 'confirmation_deadline')@DateSerializer() final  DateTime? confirmationDeadline;
@override@JsonKey(name: 'cancellation_date')@DateSerializer() final  DateTime? cancellationDate;
@override@JsonKey(name: 'cancellation_reason') final  String? cancellationReason;
@override@JsonKey(name: 'ramble_id') final  int rambleId;
@override@JsonKey(name: 'user_id') final  int? userId;
@override@JsonKey(name: 'group_id') final  int? groupId;
// Optional embedded ramble summary returned by the list API
@override final  RegistrationRambleSummary? ramble;

/// Create a copy of Registration
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RegistrationCopyWith<_Registration> get copyWith => __$RegistrationCopyWithImpl<_Registration>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RegistrationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Registration&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.status, status) || other.status == status)&&(identical(other.registrationDate, registrationDate) || other.registrationDate == registrationDate)&&(identical(other.confirmationDate, confirmationDate) || other.confirmationDate == confirmationDate)&&(identical(other.confirmationDeadline, confirmationDeadline) || other.confirmationDeadline == confirmationDeadline)&&(identical(other.cancellationDate, cancellationDate) || other.cancellationDate == cancellationDate)&&(identical(other.cancellationReason, cancellationReason) || other.cancellationReason == cancellationReason)&&(identical(other.rambleId, rambleId) || other.rambleId == rambleId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.ramble, ramble) || other.ramble == ramble));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,createdAt,updatedAt,firstName,lastName,email,phone,status,registrationDate,confirmationDate,confirmationDeadline,cancellationDate,cancellationReason,rambleId,userId,groupId,ramble);

@override
String toString() {
  return 'Registration(id: $id, createdAt: $createdAt, updatedAt: $updatedAt, firstName: $firstName, lastName: $lastName, email: $email, phone: $phone, status: $status, registrationDate: $registrationDate, confirmationDate: $confirmationDate, confirmationDeadline: $confirmationDeadline, cancellationDate: $cancellationDate, cancellationReason: $cancellationReason, rambleId: $rambleId, userId: $userId, groupId: $groupId, ramble: $ramble)';
}


}

/// @nodoc
abstract mixin class _$RegistrationCopyWith<$Res> implements $RegistrationCopyWith<$Res> {
  factory _$RegistrationCopyWith(_Registration value, $Res Function(_Registration) _then) = __$RegistrationCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'created_at')@DateSerializer() DateTime createdAt,@JsonKey(name: 'updated_at')@DateSerializer() DateTime updatedAt,@JsonKey(name: 'first_name') String firstName,@JsonKey(name: 'last_name') String lastName, String email, String? phone, String status,@JsonKey(name: 'registration_date')@DateSerializer() DateTime registrationDate,@JsonKey(name: 'confirmation_date')@DateSerializer() DateTime? confirmationDate,@JsonKey(name: 'confirmation_deadline')@DateSerializer() DateTime? confirmationDeadline,@JsonKey(name: 'cancellation_date')@DateSerializer() DateTime? cancellationDate,@JsonKey(name: 'cancellation_reason') String? cancellationReason,@JsonKey(name: 'ramble_id') int rambleId,@JsonKey(name: 'user_id') int? userId,@JsonKey(name: 'group_id') int? groupId, RegistrationRambleSummary? ramble
});


@override $RegistrationRambleSummaryCopyWith<$Res>? get ramble;

}
/// @nodoc
class __$RegistrationCopyWithImpl<$Res>
    implements _$RegistrationCopyWith<$Res> {
  __$RegistrationCopyWithImpl(this._self, this._then);

  final _Registration _self;
  final $Res Function(_Registration) _then;

/// Create a copy of Registration
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? createdAt = null,Object? updatedAt = null,Object? firstName = null,Object? lastName = null,Object? email = null,Object? phone = freezed,Object? status = null,Object? registrationDate = null,Object? confirmationDate = freezed,Object? confirmationDeadline = freezed,Object? cancellationDate = freezed,Object? cancellationReason = freezed,Object? rambleId = null,Object? userId = freezed,Object? groupId = freezed,Object? ramble = freezed,}) {
  return _then(_Registration(
null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,registrationDate: null == registrationDate ? _self.registrationDate : registrationDate // ignore: cast_nullable_to_non_nullable
as DateTime,confirmationDate: freezed == confirmationDate ? _self.confirmationDate : confirmationDate // ignore: cast_nullable_to_non_nullable
as DateTime?,confirmationDeadline: freezed == confirmationDeadline ? _self.confirmationDeadline : confirmationDeadline // ignore: cast_nullable_to_non_nullable
as DateTime?,cancellationDate: freezed == cancellationDate ? _self.cancellationDate : cancellationDate // ignore: cast_nullable_to_non_nullable
as DateTime?,cancellationReason: freezed == cancellationReason ? _self.cancellationReason : cancellationReason // ignore: cast_nullable_to_non_nullable
as String?,rambleId: null == rambleId ? _self.rambleId : rambleId // ignore: cast_nullable_to_non_nullable
as int,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int?,groupId: freezed == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as int?,ramble: freezed == ramble ? _self.ramble : ramble // ignore: cast_nullable_to_non_nullable
as RegistrationRambleSummary?,
  ));
}

/// Create a copy of Registration
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RegistrationRambleSummaryCopyWith<$Res>? get ramble {
    if (_self.ramble == null) {
    return null;
  }

  return $RegistrationRambleSummaryCopyWith<$Res>(_self.ramble!, (value) {
    return _then(_self.copyWith(ramble: value));
  });
}
}


/// @nodoc
mixin _$RegistrationRambleSummary {

 String get title;@DateSerializer() DateTime? get date; String? get location;
/// Create a copy of RegistrationRambleSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RegistrationRambleSummaryCopyWith<RegistrationRambleSummary> get copyWith => _$RegistrationRambleSummaryCopyWithImpl<RegistrationRambleSummary>(this as RegistrationRambleSummary, _$identity);

  /// Serializes this RegistrationRambleSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RegistrationRambleSummary&&(identical(other.title, title) || other.title == title)&&(identical(other.date, date) || other.date == date)&&(identical(other.location, location) || other.location == location));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,date,location);

@override
String toString() {
  return 'RegistrationRambleSummary(title: $title, date: $date, location: $location)';
}


}

/// @nodoc
abstract mixin class $RegistrationRambleSummaryCopyWith<$Res>  {
  factory $RegistrationRambleSummaryCopyWith(RegistrationRambleSummary value, $Res Function(RegistrationRambleSummary) _then) = _$RegistrationRambleSummaryCopyWithImpl;
@useResult
$Res call({
 String title,@DateSerializer() DateTime? date, String? location
});




}
/// @nodoc
class _$RegistrationRambleSummaryCopyWithImpl<$Res>
    implements $RegistrationRambleSummaryCopyWith<$Res> {
  _$RegistrationRambleSummaryCopyWithImpl(this._self, this._then);

  final RegistrationRambleSummary _self;
  final $Res Function(RegistrationRambleSummary) _then;

/// Create a copy of RegistrationRambleSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? date = freezed,Object? location = freezed,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [RegistrationRambleSummary].
extension RegistrationRambleSummaryPatterns on RegistrationRambleSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RegistrationRambleSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RegistrationRambleSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RegistrationRambleSummary value)  $default,){
final _that = this;
switch (_that) {
case _RegistrationRambleSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RegistrationRambleSummary value)?  $default,){
final _that = this;
switch (_that) {
case _RegistrationRambleSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title, @DateSerializer()  DateTime? date,  String? location)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RegistrationRambleSummary() when $default != null:
return $default(_that.title,_that.date,_that.location);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title, @DateSerializer()  DateTime? date,  String? location)  $default,) {final _that = this;
switch (_that) {
case _RegistrationRambleSummary():
return $default(_that.title,_that.date,_that.location);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title, @DateSerializer()  DateTime? date,  String? location)?  $default,) {final _that = this;
switch (_that) {
case _RegistrationRambleSummary() when $default != null:
return $default(_that.title,_that.date,_that.location);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RegistrationRambleSummary implements RegistrationRambleSummary {
  const _RegistrationRambleSummary({required this.title, @DateSerializer() this.date, this.location});
  factory _RegistrationRambleSummary.fromJson(Map<String, dynamic> json) => _$RegistrationRambleSummaryFromJson(json);

@override final  String title;
@override@DateSerializer() final  DateTime? date;
@override final  String? location;

/// Create a copy of RegistrationRambleSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RegistrationRambleSummaryCopyWith<_RegistrationRambleSummary> get copyWith => __$RegistrationRambleSummaryCopyWithImpl<_RegistrationRambleSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RegistrationRambleSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RegistrationRambleSummary&&(identical(other.title, title) || other.title == title)&&(identical(other.date, date) || other.date == date)&&(identical(other.location, location) || other.location == location));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,date,location);

@override
String toString() {
  return 'RegistrationRambleSummary(title: $title, date: $date, location: $location)';
}


}

/// @nodoc
abstract mixin class _$RegistrationRambleSummaryCopyWith<$Res> implements $RegistrationRambleSummaryCopyWith<$Res> {
  factory _$RegistrationRambleSummaryCopyWith(_RegistrationRambleSummary value, $Res Function(_RegistrationRambleSummary) _then) = __$RegistrationRambleSummaryCopyWithImpl;
@override @useResult
$Res call({
 String title,@DateSerializer() DateTime? date, String? location
});




}
/// @nodoc
class __$RegistrationRambleSummaryCopyWithImpl<$Res>
    implements _$RegistrationRambleSummaryCopyWith<$Res> {
  __$RegistrationRambleSummaryCopyWithImpl(this._self, this._then);

  final _RegistrationRambleSummary _self;
  final $Res Function(_RegistrationRambleSummary) _then;

/// Create a copy of RegistrationRambleSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? date = freezed,Object? location = freezed,}) {
  return _then(_RegistrationRambleSummary(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$RegistrationParticipant {

@JsonKey(name: 'first_name') String get firstName;@JsonKey(name: 'last_name') String get lastName; String get email; String? get phone;
/// Create a copy of RegistrationParticipant
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RegistrationParticipantCopyWith<RegistrationParticipant> get copyWith => _$RegistrationParticipantCopyWithImpl<RegistrationParticipant>(this as RegistrationParticipant, _$identity);

  /// Serializes this RegistrationParticipant to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RegistrationParticipant&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,firstName,lastName,email,phone);

@override
String toString() {
  return 'RegistrationParticipant(firstName: $firstName, lastName: $lastName, email: $email, phone: $phone)';
}


}

/// @nodoc
abstract mixin class $RegistrationParticipantCopyWith<$Res>  {
  factory $RegistrationParticipantCopyWith(RegistrationParticipant value, $Res Function(RegistrationParticipant) _then) = _$RegistrationParticipantCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'first_name') String firstName,@JsonKey(name: 'last_name') String lastName, String email, String? phone
});




}
/// @nodoc
class _$RegistrationParticipantCopyWithImpl<$Res>
    implements $RegistrationParticipantCopyWith<$Res> {
  _$RegistrationParticipantCopyWithImpl(this._self, this._then);

  final RegistrationParticipant _self;
  final $Res Function(RegistrationParticipant) _then;

/// Create a copy of RegistrationParticipant
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? firstName = null,Object? lastName = null,Object? email = null,Object? phone = freezed,}) {
  return _then(_self.copyWith(
firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [RegistrationParticipant].
extension RegistrationParticipantPatterns on RegistrationParticipant {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RegistrationParticipant value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RegistrationParticipant() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RegistrationParticipant value)  $default,){
final _that = this;
switch (_that) {
case _RegistrationParticipant():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RegistrationParticipant value)?  $default,){
final _that = this;
switch (_that) {
case _RegistrationParticipant() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'first_name')  String firstName, @JsonKey(name: 'last_name')  String lastName,  String email,  String? phone)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RegistrationParticipant() when $default != null:
return $default(_that.firstName,_that.lastName,_that.email,_that.phone);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'first_name')  String firstName, @JsonKey(name: 'last_name')  String lastName,  String email,  String? phone)  $default,) {final _that = this;
switch (_that) {
case _RegistrationParticipant():
return $default(_that.firstName,_that.lastName,_that.email,_that.phone);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'first_name')  String firstName, @JsonKey(name: 'last_name')  String lastName,  String email,  String? phone)?  $default,) {final _that = this;
switch (_that) {
case _RegistrationParticipant() when $default != null:
return $default(_that.firstName,_that.lastName,_that.email,_that.phone);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RegistrationParticipant implements RegistrationParticipant {
  const _RegistrationParticipant({@JsonKey(name: 'first_name') required this.firstName, @JsonKey(name: 'last_name') required this.lastName, required this.email, this.phone});
  factory _RegistrationParticipant.fromJson(Map<String, dynamic> json) => _$RegistrationParticipantFromJson(json);

@override@JsonKey(name: 'first_name') final  String firstName;
@override@JsonKey(name: 'last_name') final  String lastName;
@override final  String email;
@override final  String? phone;

/// Create a copy of RegistrationParticipant
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RegistrationParticipantCopyWith<_RegistrationParticipant> get copyWith => __$RegistrationParticipantCopyWithImpl<_RegistrationParticipant>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RegistrationParticipantToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RegistrationParticipant&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,firstName,lastName,email,phone);

@override
String toString() {
  return 'RegistrationParticipant(firstName: $firstName, lastName: $lastName, email: $email, phone: $phone)';
}


}

/// @nodoc
abstract mixin class _$RegistrationParticipantCopyWith<$Res> implements $RegistrationParticipantCopyWith<$Res> {
  factory _$RegistrationParticipantCopyWith(_RegistrationParticipant value, $Res Function(_RegistrationParticipant) _then) = __$RegistrationParticipantCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'first_name') String firstName,@JsonKey(name: 'last_name') String lastName, String email, String? phone
});




}
/// @nodoc
class __$RegistrationParticipantCopyWithImpl<$Res>
    implements _$RegistrationParticipantCopyWith<$Res> {
  __$RegistrationParticipantCopyWithImpl(this._self, this._then);

  final _RegistrationParticipant _self;
  final $Res Function(_RegistrationParticipant) _then;

/// Create a copy of RegistrationParticipant
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? firstName = null,Object? lastName = null,Object? email = null,Object? phone = freezed,}) {
  return _then(_RegistrationParticipant(
firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$CreateRegistrationRequest {

@JsonKey(name: 'ramble_id') int get rambleId; List<RegistrationParticipant> get participants;@JsonKey(name: 'primary_email') String? get primaryEmail;
/// Create a copy of CreateRegistrationRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateRegistrationRequestCopyWith<CreateRegistrationRequest> get copyWith => _$CreateRegistrationRequestCopyWithImpl<CreateRegistrationRequest>(this as CreateRegistrationRequest, _$identity);

  /// Serializes this CreateRegistrationRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateRegistrationRequest&&(identical(other.rambleId, rambleId) || other.rambleId == rambleId)&&const DeepCollectionEquality().equals(other.participants, participants)&&(identical(other.primaryEmail, primaryEmail) || other.primaryEmail == primaryEmail));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,rambleId,const DeepCollectionEquality().hash(participants),primaryEmail);

@override
String toString() {
  return 'CreateRegistrationRequest(rambleId: $rambleId, participants: $participants, primaryEmail: $primaryEmail)';
}


}

/// @nodoc
abstract mixin class $CreateRegistrationRequestCopyWith<$Res>  {
  factory $CreateRegistrationRequestCopyWith(CreateRegistrationRequest value, $Res Function(CreateRegistrationRequest) _then) = _$CreateRegistrationRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'ramble_id') int rambleId, List<RegistrationParticipant> participants,@JsonKey(name: 'primary_email') String? primaryEmail
});




}
/// @nodoc
class _$CreateRegistrationRequestCopyWithImpl<$Res>
    implements $CreateRegistrationRequestCopyWith<$Res> {
  _$CreateRegistrationRequestCopyWithImpl(this._self, this._then);

  final CreateRegistrationRequest _self;
  final $Res Function(CreateRegistrationRequest) _then;

/// Create a copy of CreateRegistrationRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? rambleId = null,Object? participants = null,Object? primaryEmail = freezed,}) {
  return _then(_self.copyWith(
rambleId: null == rambleId ? _self.rambleId : rambleId // ignore: cast_nullable_to_non_nullable
as int,participants: null == participants ? _self.participants : participants // ignore: cast_nullable_to_non_nullable
as List<RegistrationParticipant>,primaryEmail: freezed == primaryEmail ? _self.primaryEmail : primaryEmail // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateRegistrationRequest].
extension CreateRegistrationRequestPatterns on CreateRegistrationRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateRegistrationRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateRegistrationRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateRegistrationRequest value)  $default,){
final _that = this;
switch (_that) {
case _CreateRegistrationRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateRegistrationRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CreateRegistrationRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'ramble_id')  int rambleId,  List<RegistrationParticipant> participants, @JsonKey(name: 'primary_email')  String? primaryEmail)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateRegistrationRequest() when $default != null:
return $default(_that.rambleId,_that.participants,_that.primaryEmail);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'ramble_id')  int rambleId,  List<RegistrationParticipant> participants, @JsonKey(name: 'primary_email')  String? primaryEmail)  $default,) {final _that = this;
switch (_that) {
case _CreateRegistrationRequest():
return $default(_that.rambleId,_that.participants,_that.primaryEmail);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'ramble_id')  int rambleId,  List<RegistrationParticipant> participants, @JsonKey(name: 'primary_email')  String? primaryEmail)?  $default,) {final _that = this;
switch (_that) {
case _CreateRegistrationRequest() when $default != null:
return $default(_that.rambleId,_that.participants,_that.primaryEmail);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateRegistrationRequest implements CreateRegistrationRequest {
  const _CreateRegistrationRequest({@JsonKey(name: 'ramble_id') required this.rambleId, required final  List<RegistrationParticipant> participants, @JsonKey(name: 'primary_email') this.primaryEmail}): _participants = participants;
  factory _CreateRegistrationRequest.fromJson(Map<String, dynamic> json) => _$CreateRegistrationRequestFromJson(json);

@override@JsonKey(name: 'ramble_id') final  int rambleId;
 final  List<RegistrationParticipant> _participants;
@override List<RegistrationParticipant> get participants {
  if (_participants is EqualUnmodifiableListView) return _participants;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_participants);
}

@override@JsonKey(name: 'primary_email') final  String? primaryEmail;

/// Create a copy of CreateRegistrationRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateRegistrationRequestCopyWith<_CreateRegistrationRequest> get copyWith => __$CreateRegistrationRequestCopyWithImpl<_CreateRegistrationRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateRegistrationRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateRegistrationRequest&&(identical(other.rambleId, rambleId) || other.rambleId == rambleId)&&const DeepCollectionEquality().equals(other._participants, _participants)&&(identical(other.primaryEmail, primaryEmail) || other.primaryEmail == primaryEmail));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,rambleId,const DeepCollectionEquality().hash(_participants),primaryEmail);

@override
String toString() {
  return 'CreateRegistrationRequest(rambleId: $rambleId, participants: $participants, primaryEmail: $primaryEmail)';
}


}

/// @nodoc
abstract mixin class _$CreateRegistrationRequestCopyWith<$Res> implements $CreateRegistrationRequestCopyWith<$Res> {
  factory _$CreateRegistrationRequestCopyWith(_CreateRegistrationRequest value, $Res Function(_CreateRegistrationRequest) _then) = __$CreateRegistrationRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'ramble_id') int rambleId, List<RegistrationParticipant> participants,@JsonKey(name: 'primary_email') String? primaryEmail
});




}
/// @nodoc
class __$CreateRegistrationRequestCopyWithImpl<$Res>
    implements _$CreateRegistrationRequestCopyWith<$Res> {
  __$CreateRegistrationRequestCopyWithImpl(this._self, this._then);

  final _CreateRegistrationRequest _self;
  final $Res Function(_CreateRegistrationRequest) _then;

/// Create a copy of CreateRegistrationRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? rambleId = null,Object? participants = null,Object? primaryEmail = freezed,}) {
  return _then(_CreateRegistrationRequest(
rambleId: null == rambleId ? _self.rambleId : rambleId // ignore: cast_nullable_to_non_nullable
as int,participants: null == participants ? _self._participants : participants // ignore: cast_nullable_to_non_nullable
as List<RegistrationParticipant>,primaryEmail: freezed == primaryEmail ? _self.primaryEmail : primaryEmail // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ConfirmRegistrationRequest {

 bool get confirmed;
/// Create a copy of ConfirmRegistrationRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConfirmRegistrationRequestCopyWith<ConfirmRegistrationRequest> get copyWith => _$ConfirmRegistrationRequestCopyWithImpl<ConfirmRegistrationRequest>(this as ConfirmRegistrationRequest, _$identity);

  /// Serializes this ConfirmRegistrationRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConfirmRegistrationRequest&&(identical(other.confirmed, confirmed) || other.confirmed == confirmed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,confirmed);

@override
String toString() {
  return 'ConfirmRegistrationRequest(confirmed: $confirmed)';
}


}

/// @nodoc
abstract mixin class $ConfirmRegistrationRequestCopyWith<$Res>  {
  factory $ConfirmRegistrationRequestCopyWith(ConfirmRegistrationRequest value, $Res Function(ConfirmRegistrationRequest) _then) = _$ConfirmRegistrationRequestCopyWithImpl;
@useResult
$Res call({
 bool confirmed
});




}
/// @nodoc
class _$ConfirmRegistrationRequestCopyWithImpl<$Res>
    implements $ConfirmRegistrationRequestCopyWith<$Res> {
  _$ConfirmRegistrationRequestCopyWithImpl(this._self, this._then);

  final ConfirmRegistrationRequest _self;
  final $Res Function(ConfirmRegistrationRequest) _then;

/// Create a copy of ConfirmRegistrationRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? confirmed = null,}) {
  return _then(_self.copyWith(
confirmed: null == confirmed ? _self.confirmed : confirmed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ConfirmRegistrationRequest].
extension ConfirmRegistrationRequestPatterns on ConfirmRegistrationRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConfirmRegistrationRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConfirmRegistrationRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConfirmRegistrationRequest value)  $default,){
final _that = this;
switch (_that) {
case _ConfirmRegistrationRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConfirmRegistrationRequest value)?  $default,){
final _that = this;
switch (_that) {
case _ConfirmRegistrationRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool confirmed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConfirmRegistrationRequest() when $default != null:
return $default(_that.confirmed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool confirmed)  $default,) {final _that = this;
switch (_that) {
case _ConfirmRegistrationRequest():
return $default(_that.confirmed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool confirmed)?  $default,) {final _that = this;
switch (_that) {
case _ConfirmRegistrationRequest() when $default != null:
return $default(_that.confirmed);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ConfirmRegistrationRequest implements ConfirmRegistrationRequest {
  const _ConfirmRegistrationRequest({required this.confirmed});
  factory _ConfirmRegistrationRequest.fromJson(Map<String, dynamic> json) => _$ConfirmRegistrationRequestFromJson(json);

@override final  bool confirmed;

/// Create a copy of ConfirmRegistrationRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConfirmRegistrationRequestCopyWith<_ConfirmRegistrationRequest> get copyWith => __$ConfirmRegistrationRequestCopyWithImpl<_ConfirmRegistrationRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConfirmRegistrationRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConfirmRegistrationRequest&&(identical(other.confirmed, confirmed) || other.confirmed == confirmed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,confirmed);

@override
String toString() {
  return 'ConfirmRegistrationRequest(confirmed: $confirmed)';
}


}

/// @nodoc
abstract mixin class _$ConfirmRegistrationRequestCopyWith<$Res> implements $ConfirmRegistrationRequestCopyWith<$Res> {
  factory _$ConfirmRegistrationRequestCopyWith(_ConfirmRegistrationRequest value, $Res Function(_ConfirmRegistrationRequest) _then) = __$ConfirmRegistrationRequestCopyWithImpl;
@override @useResult
$Res call({
 bool confirmed
});




}
/// @nodoc
class __$ConfirmRegistrationRequestCopyWithImpl<$Res>
    implements _$ConfirmRegistrationRequestCopyWith<$Res> {
  __$ConfirmRegistrationRequestCopyWithImpl(this._self, this._then);

  final _ConfirmRegistrationRequest _self;
  final $Res Function(_ConfirmRegistrationRequest) _then;

/// Create a copy of ConfirmRegistrationRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? confirmed = null,}) {
  return _then(_ConfirmRegistrationRequest(
confirmed: null == confirmed ? _self.confirmed : confirmed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$CancelRegistrationRequest {

 String? get reason;
/// Create a copy of CancelRegistrationRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CancelRegistrationRequestCopyWith<CancelRegistrationRequest> get copyWith => _$CancelRegistrationRequestCopyWithImpl<CancelRegistrationRequest>(this as CancelRegistrationRequest, _$identity);

  /// Serializes this CancelRegistrationRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CancelRegistrationRequest&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,reason);

@override
String toString() {
  return 'CancelRegistrationRequest(reason: $reason)';
}


}

/// @nodoc
abstract mixin class $CancelRegistrationRequestCopyWith<$Res>  {
  factory $CancelRegistrationRequestCopyWith(CancelRegistrationRequest value, $Res Function(CancelRegistrationRequest) _then) = _$CancelRegistrationRequestCopyWithImpl;
@useResult
$Res call({
 String? reason
});




}
/// @nodoc
class _$CancelRegistrationRequestCopyWithImpl<$Res>
    implements $CancelRegistrationRequestCopyWith<$Res> {
  _$CancelRegistrationRequestCopyWithImpl(this._self, this._then);

  final CancelRegistrationRequest _self;
  final $Res Function(CancelRegistrationRequest) _then;

/// Create a copy of CancelRegistrationRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? reason = freezed,}) {
  return _then(_self.copyWith(
reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CancelRegistrationRequest].
extension CancelRegistrationRequestPatterns on CancelRegistrationRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CancelRegistrationRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CancelRegistrationRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CancelRegistrationRequest value)  $default,){
final _that = this;
switch (_that) {
case _CancelRegistrationRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CancelRegistrationRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CancelRegistrationRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? reason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CancelRegistrationRequest() when $default != null:
return $default(_that.reason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? reason)  $default,) {final _that = this;
switch (_that) {
case _CancelRegistrationRequest():
return $default(_that.reason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? reason)?  $default,) {final _that = this;
switch (_that) {
case _CancelRegistrationRequest() when $default != null:
return $default(_that.reason);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CancelRegistrationRequest implements CancelRegistrationRequest {
  const _CancelRegistrationRequest({this.reason});
  factory _CancelRegistrationRequest.fromJson(Map<String, dynamic> json) => _$CancelRegistrationRequestFromJson(json);

@override final  String? reason;

/// Create a copy of CancelRegistrationRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CancelRegistrationRequestCopyWith<_CancelRegistrationRequest> get copyWith => __$CancelRegistrationRequestCopyWithImpl<_CancelRegistrationRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CancelRegistrationRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CancelRegistrationRequest&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,reason);

@override
String toString() {
  return 'CancelRegistrationRequest(reason: $reason)';
}


}

/// @nodoc
abstract mixin class _$CancelRegistrationRequestCopyWith<$Res> implements $CancelRegistrationRequestCopyWith<$Res> {
  factory _$CancelRegistrationRequestCopyWith(_CancelRegistrationRequest value, $Res Function(_CancelRegistrationRequest) _then) = __$CancelRegistrationRequestCopyWithImpl;
@override @useResult
$Res call({
 String? reason
});




}
/// @nodoc
class __$CancelRegistrationRequestCopyWithImpl<$Res>
    implements _$CancelRegistrationRequestCopyWith<$Res> {
  __$CancelRegistrationRequestCopyWithImpl(this._self, this._then);

  final _CancelRegistrationRequest _self;
  final $Res Function(_CancelRegistrationRequest) _then;

/// Create a copy of CancelRegistrationRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? reason = freezed,}) {
  return _then(_CancelRegistrationRequest(
reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
