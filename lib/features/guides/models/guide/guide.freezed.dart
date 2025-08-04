// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'guide.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Guide {

 int get id;@JsonKey(name: "first_name") String get firstName;@JsonKey(name: "last_name") String get lastName; String get email; String? get phone; String? get bio; String? get experience; String? get specialties; String? get languages;@JsonKey(name: "certification_level") String? get certificationLevel; String? get avatar;@JsonKey(name: "is_active") bool get isActive;@JsonKey(name: "emergency_contact_name") String? get emergencyContactName;@JsonKey(name: "emergency_contact_phone") String? get emergencyContactPhone;
/// Create a copy of Guide
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GuideCopyWith<Guide> get copyWith => _$GuideCopyWithImpl<Guide>(this as Guide, _$identity);

  /// Serializes this Guide to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Guide&&(identical(other.id, id) || other.id == id)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.experience, experience) || other.experience == experience)&&(identical(other.specialties, specialties) || other.specialties == specialties)&&(identical(other.languages, languages) || other.languages == languages)&&(identical(other.certificationLevel, certificationLevel) || other.certificationLevel == certificationLevel)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.emergencyContactName, emergencyContactName) || other.emergencyContactName == emergencyContactName)&&(identical(other.emergencyContactPhone, emergencyContactPhone) || other.emergencyContactPhone == emergencyContactPhone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,firstName,lastName,email,phone,bio,experience,specialties,languages,certificationLevel,avatar,isActive,emergencyContactName,emergencyContactPhone);

@override
String toString() {
  return 'Guide(id: $id, firstName: $firstName, lastName: $lastName, email: $email, phone: $phone, bio: $bio, experience: $experience, specialties: $specialties, languages: $languages, certificationLevel: $certificationLevel, avatar: $avatar, isActive: $isActive, emergencyContactName: $emergencyContactName, emergencyContactPhone: $emergencyContactPhone)';
}


}

/// @nodoc
abstract mixin class $GuideCopyWith<$Res>  {
  factory $GuideCopyWith(Guide value, $Res Function(Guide) _then) = _$GuideCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: "first_name") String firstName,@JsonKey(name: "last_name") String lastName, String email, String? phone, String? bio, String? experience, String? specialties, String? languages,@JsonKey(name: "certification_level") String? certificationLevel, String? avatar,@JsonKey(name: "is_active") bool isActive,@JsonKey(name: "emergency_contact_name") String? emergencyContactName,@JsonKey(name: "emergency_contact_phone") String? emergencyContactPhone
});




}
/// @nodoc
class _$GuideCopyWithImpl<$Res>
    implements $GuideCopyWith<$Res> {
  _$GuideCopyWithImpl(this._self, this._then);

  final Guide _self;
  final $Res Function(Guide) _then;

/// Create a copy of Guide
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? firstName = null,Object? lastName = null,Object? email = null,Object? phone = freezed,Object? bio = freezed,Object? experience = freezed,Object? specialties = freezed,Object? languages = freezed,Object? certificationLevel = freezed,Object? avatar = freezed,Object? isActive = null,Object? emergencyContactName = freezed,Object? emergencyContactPhone = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,experience: freezed == experience ? _self.experience : experience // ignore: cast_nullable_to_non_nullable
as String?,specialties: freezed == specialties ? _self.specialties : specialties // ignore: cast_nullable_to_non_nullable
as String?,languages: freezed == languages ? _self.languages : languages // ignore: cast_nullable_to_non_nullable
as String?,certificationLevel: freezed == certificationLevel ? _self.certificationLevel : certificationLevel // ignore: cast_nullable_to_non_nullable
as String?,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,emergencyContactName: freezed == emergencyContactName ? _self.emergencyContactName : emergencyContactName // ignore: cast_nullable_to_non_nullable
as String?,emergencyContactPhone: freezed == emergencyContactPhone ? _self.emergencyContactPhone : emergencyContactPhone // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Guide].
extension GuidePatterns on Guide {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Guide value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Guide() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Guide value)  $default,){
final _that = this;
switch (_that) {
case _Guide():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Guide value)?  $default,){
final _that = this;
switch (_that) {
case _Guide() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: "first_name")  String firstName, @JsonKey(name: "last_name")  String lastName,  String email,  String? phone,  String? bio,  String? experience,  String? specialties,  String? languages, @JsonKey(name: "certification_level")  String? certificationLevel,  String? avatar, @JsonKey(name: "is_active")  bool isActive, @JsonKey(name: "emergency_contact_name")  String? emergencyContactName, @JsonKey(name: "emergency_contact_phone")  String? emergencyContactPhone)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Guide() when $default != null:
return $default(_that.id,_that.firstName,_that.lastName,_that.email,_that.phone,_that.bio,_that.experience,_that.specialties,_that.languages,_that.certificationLevel,_that.avatar,_that.isActive,_that.emergencyContactName,_that.emergencyContactPhone);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: "first_name")  String firstName, @JsonKey(name: "last_name")  String lastName,  String email,  String? phone,  String? bio,  String? experience,  String? specialties,  String? languages, @JsonKey(name: "certification_level")  String? certificationLevel,  String? avatar, @JsonKey(name: "is_active")  bool isActive, @JsonKey(name: "emergency_contact_name")  String? emergencyContactName, @JsonKey(name: "emergency_contact_phone")  String? emergencyContactPhone)  $default,) {final _that = this;
switch (_that) {
case _Guide():
return $default(_that.id,_that.firstName,_that.lastName,_that.email,_that.phone,_that.bio,_that.experience,_that.specialties,_that.languages,_that.certificationLevel,_that.avatar,_that.isActive,_that.emergencyContactName,_that.emergencyContactPhone);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: "first_name")  String firstName, @JsonKey(name: "last_name")  String lastName,  String email,  String? phone,  String? bio,  String? experience,  String? specialties,  String? languages, @JsonKey(name: "certification_level")  String? certificationLevel,  String? avatar, @JsonKey(name: "is_active")  bool isActive, @JsonKey(name: "emergency_contact_name")  String? emergencyContactName, @JsonKey(name: "emergency_contact_phone")  String? emergencyContactPhone)?  $default,) {final _that = this;
switch (_that) {
case _Guide() when $default != null:
return $default(_that.id,_that.firstName,_that.lastName,_that.email,_that.phone,_that.bio,_that.experience,_that.specialties,_that.languages,_that.certificationLevel,_that.avatar,_that.isActive,_that.emergencyContactName,_that.emergencyContactPhone);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Guide implements Guide {
  const _Guide(this.id, {@JsonKey(name: "first_name") required this.firstName, @JsonKey(name: "last_name") required this.lastName, required this.email, this.phone, this.bio, this.experience, this.specialties, this.languages, @JsonKey(name: "certification_level") this.certificationLevel, this.avatar, @JsonKey(name: "is_active") required this.isActive, @JsonKey(name: "emergency_contact_name") this.emergencyContactName, @JsonKey(name: "emergency_contact_phone") this.emergencyContactPhone});
  factory _Guide.fromJson(Map<String, dynamic> json) => _$GuideFromJson(json);

@override final  int id;
@override@JsonKey(name: "first_name") final  String firstName;
@override@JsonKey(name: "last_name") final  String lastName;
@override final  String email;
@override final  String? phone;
@override final  String? bio;
@override final  String? experience;
@override final  String? specialties;
@override final  String? languages;
@override@JsonKey(name: "certification_level") final  String? certificationLevel;
@override final  String? avatar;
@override@JsonKey(name: "is_active") final  bool isActive;
@override@JsonKey(name: "emergency_contact_name") final  String? emergencyContactName;
@override@JsonKey(name: "emergency_contact_phone") final  String? emergencyContactPhone;

/// Create a copy of Guide
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GuideCopyWith<_Guide> get copyWith => __$GuideCopyWithImpl<_Guide>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GuideToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Guide&&(identical(other.id, id) || other.id == id)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.experience, experience) || other.experience == experience)&&(identical(other.specialties, specialties) || other.specialties == specialties)&&(identical(other.languages, languages) || other.languages == languages)&&(identical(other.certificationLevel, certificationLevel) || other.certificationLevel == certificationLevel)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.emergencyContactName, emergencyContactName) || other.emergencyContactName == emergencyContactName)&&(identical(other.emergencyContactPhone, emergencyContactPhone) || other.emergencyContactPhone == emergencyContactPhone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,firstName,lastName,email,phone,bio,experience,specialties,languages,certificationLevel,avatar,isActive,emergencyContactName,emergencyContactPhone);

@override
String toString() {
  return 'Guide(id: $id, firstName: $firstName, lastName: $lastName, email: $email, phone: $phone, bio: $bio, experience: $experience, specialties: $specialties, languages: $languages, certificationLevel: $certificationLevel, avatar: $avatar, isActive: $isActive, emergencyContactName: $emergencyContactName, emergencyContactPhone: $emergencyContactPhone)';
}


}

/// @nodoc
abstract mixin class _$GuideCopyWith<$Res> implements $GuideCopyWith<$Res> {
  factory _$GuideCopyWith(_Guide value, $Res Function(_Guide) _then) = __$GuideCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: "first_name") String firstName,@JsonKey(name: "last_name") String lastName, String email, String? phone, String? bio, String? experience, String? specialties, String? languages,@JsonKey(name: "certification_level") String? certificationLevel, String? avatar,@JsonKey(name: "is_active") bool isActive,@JsonKey(name: "emergency_contact_name") String? emergencyContactName,@JsonKey(name: "emergency_contact_phone") String? emergencyContactPhone
});




}
/// @nodoc
class __$GuideCopyWithImpl<$Res>
    implements _$GuideCopyWith<$Res> {
  __$GuideCopyWithImpl(this._self, this._then);

  final _Guide _self;
  final $Res Function(_Guide) _then;

/// Create a copy of Guide
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? firstName = null,Object? lastName = null,Object? email = null,Object? phone = freezed,Object? bio = freezed,Object? experience = freezed,Object? specialties = freezed,Object? languages = freezed,Object? certificationLevel = freezed,Object? avatar = freezed,Object? isActive = null,Object? emergencyContactName = freezed,Object? emergencyContactPhone = freezed,}) {
  return _then(_Guide(
null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,experience: freezed == experience ? _self.experience : experience // ignore: cast_nullable_to_non_nullable
as String?,specialties: freezed == specialties ? _self.specialties : specialties // ignore: cast_nullable_to_non_nullable
as String?,languages: freezed == languages ? _self.languages : languages // ignore: cast_nullable_to_non_nullable
as String?,certificationLevel: freezed == certificationLevel ? _self.certificationLevel : certificationLevel // ignore: cast_nullable_to_non_nullable
as String?,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,emergencyContactName: freezed == emergencyContactName ? _self.emergencyContactName : emergencyContactName // ignore: cast_nullable_to_non_nullable
as String?,emergencyContactPhone: freezed == emergencyContactPhone ? _self.emergencyContactPhone : emergencyContactPhone // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
