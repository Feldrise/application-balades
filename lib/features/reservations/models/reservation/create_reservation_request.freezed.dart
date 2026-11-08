// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_reservation_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateReservationRequest {

@JsonKey(name: 'ramble_id') int get rambleId;@JsonKey(name: 'contact_email') String get contactEmail;@JsonKey(name: 'contact_phone', includeIfNull: false) String? get contactPhone; List<ParticipantRequest> get participants;
/// Create a copy of CreateReservationRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateReservationRequestCopyWith<CreateReservationRequest> get copyWith => _$CreateReservationRequestCopyWithImpl<CreateReservationRequest>(this as CreateReservationRequest, _$identity);

  /// Serializes this CreateReservationRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateReservationRequest&&(identical(other.rambleId, rambleId) || other.rambleId == rambleId)&&(identical(other.contactEmail, contactEmail) || other.contactEmail == contactEmail)&&(identical(other.contactPhone, contactPhone) || other.contactPhone == contactPhone)&&const DeepCollectionEquality().equals(other.participants, participants));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,rambleId,contactEmail,contactPhone,const DeepCollectionEquality().hash(participants));

@override
String toString() {
  return 'CreateReservationRequest(rambleId: $rambleId, contactEmail: $contactEmail, contactPhone: $contactPhone, participants: $participants)';
}


}

/// @nodoc
abstract mixin class $CreateReservationRequestCopyWith<$Res>  {
  factory $CreateReservationRequestCopyWith(CreateReservationRequest value, $Res Function(CreateReservationRequest) _then) = _$CreateReservationRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'ramble_id') int rambleId,@JsonKey(name: 'contact_email') String contactEmail,@JsonKey(name: 'contact_phone', includeIfNull: false) String? contactPhone, List<ParticipantRequest> participants
});




}
/// @nodoc
class _$CreateReservationRequestCopyWithImpl<$Res>
    implements $CreateReservationRequestCopyWith<$Res> {
  _$CreateReservationRequestCopyWithImpl(this._self, this._then);

  final CreateReservationRequest _self;
  final $Res Function(CreateReservationRequest) _then;

/// Create a copy of CreateReservationRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? rambleId = null,Object? contactEmail = null,Object? contactPhone = freezed,Object? participants = null,}) {
  return _then(_self.copyWith(
rambleId: null == rambleId ? _self.rambleId : rambleId // ignore: cast_nullable_to_non_nullable
as int,contactEmail: null == contactEmail ? _self.contactEmail : contactEmail // ignore: cast_nullable_to_non_nullable
as String,contactPhone: freezed == contactPhone ? _self.contactPhone : contactPhone // ignore: cast_nullable_to_non_nullable
as String?,participants: null == participants ? _self.participants : participants // ignore: cast_nullable_to_non_nullable
as List<ParticipantRequest>,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateReservationRequest].
extension CreateReservationRequestPatterns on CreateReservationRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateReservationRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateReservationRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateReservationRequest value)  $default,){
final _that = this;
switch (_that) {
case _CreateReservationRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateReservationRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CreateReservationRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'ramble_id')  int rambleId, @JsonKey(name: 'contact_email')  String contactEmail, @JsonKey(name: 'contact_phone', includeIfNull: false)  String? contactPhone,  List<ParticipantRequest> participants)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateReservationRequest() when $default != null:
return $default(_that.rambleId,_that.contactEmail,_that.contactPhone,_that.participants);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'ramble_id')  int rambleId, @JsonKey(name: 'contact_email')  String contactEmail, @JsonKey(name: 'contact_phone', includeIfNull: false)  String? contactPhone,  List<ParticipantRequest> participants)  $default,) {final _that = this;
switch (_that) {
case _CreateReservationRequest():
return $default(_that.rambleId,_that.contactEmail,_that.contactPhone,_that.participants);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'ramble_id')  int rambleId, @JsonKey(name: 'contact_email')  String contactEmail, @JsonKey(name: 'contact_phone', includeIfNull: false)  String? contactPhone,  List<ParticipantRequest> participants)?  $default,) {final _that = this;
switch (_that) {
case _CreateReservationRequest() when $default != null:
return $default(_that.rambleId,_that.contactEmail,_that.contactPhone,_that.participants);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateReservationRequest implements CreateReservationRequest {
  const _CreateReservationRequest({@JsonKey(name: 'ramble_id') required this.rambleId, @JsonKey(name: 'contact_email') required this.contactEmail, @JsonKey(name: 'contact_phone', includeIfNull: false) this.contactPhone, required final  List<ParticipantRequest> participants}): _participants = participants;
  factory _CreateReservationRequest.fromJson(Map<String, dynamic> json) => _$CreateReservationRequestFromJson(json);

@override@JsonKey(name: 'ramble_id') final  int rambleId;
@override@JsonKey(name: 'contact_email') final  String contactEmail;
@override@JsonKey(name: 'contact_phone', includeIfNull: false) final  String? contactPhone;
 final  List<ParticipantRequest> _participants;
@override List<ParticipantRequest> get participants {
  if (_participants is EqualUnmodifiableListView) return _participants;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_participants);
}


/// Create a copy of CreateReservationRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateReservationRequestCopyWith<_CreateReservationRequest> get copyWith => __$CreateReservationRequestCopyWithImpl<_CreateReservationRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateReservationRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateReservationRequest&&(identical(other.rambleId, rambleId) || other.rambleId == rambleId)&&(identical(other.contactEmail, contactEmail) || other.contactEmail == contactEmail)&&(identical(other.contactPhone, contactPhone) || other.contactPhone == contactPhone)&&const DeepCollectionEquality().equals(other._participants, _participants));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,rambleId,contactEmail,contactPhone,const DeepCollectionEquality().hash(_participants));

@override
String toString() {
  return 'CreateReservationRequest(rambleId: $rambleId, contactEmail: $contactEmail, contactPhone: $contactPhone, participants: $participants)';
}


}

/// @nodoc
abstract mixin class _$CreateReservationRequestCopyWith<$Res> implements $CreateReservationRequestCopyWith<$Res> {
  factory _$CreateReservationRequestCopyWith(_CreateReservationRequest value, $Res Function(_CreateReservationRequest) _then) = __$CreateReservationRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'ramble_id') int rambleId,@JsonKey(name: 'contact_email') String contactEmail,@JsonKey(name: 'contact_phone', includeIfNull: false) String? contactPhone, List<ParticipantRequest> participants
});




}
/// @nodoc
class __$CreateReservationRequestCopyWithImpl<$Res>
    implements _$CreateReservationRequestCopyWith<$Res> {
  __$CreateReservationRequestCopyWithImpl(this._self, this._then);

  final _CreateReservationRequest _self;
  final $Res Function(_CreateReservationRequest) _then;

/// Create a copy of CreateReservationRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? rambleId = null,Object? contactEmail = null,Object? contactPhone = freezed,Object? participants = null,}) {
  return _then(_CreateReservationRequest(
rambleId: null == rambleId ? _self.rambleId : rambleId // ignore: cast_nullable_to_non_nullable
as int,contactEmail: null == contactEmail ? _self.contactEmail : contactEmail // ignore: cast_nullable_to_non_nullable
as String,contactPhone: freezed == contactPhone ? _self.contactPhone : contactPhone // ignore: cast_nullable_to_non_nullable
as String?,participants: null == participants ? _self._participants : participants // ignore: cast_nullable_to_non_nullable
as List<ParticipantRequest>,
  ));
}


}


/// @nodoc
mixin _$ParticipantRequest {

@JsonKey(name: 'first_name') String get firstName;@JsonKey(name: 'last_name') String get lastName;@JsonKey(name: 'price_label') String get priceLabel;@JsonKey(name: 'is_booker') bool get isBooker;
/// Create a copy of ParticipantRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParticipantRequestCopyWith<ParticipantRequest> get copyWith => _$ParticipantRequestCopyWithImpl<ParticipantRequest>(this as ParticipantRequest, _$identity);

  /// Serializes this ParticipantRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParticipantRequest&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.priceLabel, priceLabel) || other.priceLabel == priceLabel)&&(identical(other.isBooker, isBooker) || other.isBooker == isBooker));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,firstName,lastName,priceLabel,isBooker);

@override
String toString() {
  return 'ParticipantRequest(firstName: $firstName, lastName: $lastName, priceLabel: $priceLabel, isBooker: $isBooker)';
}


}

/// @nodoc
abstract mixin class $ParticipantRequestCopyWith<$Res>  {
  factory $ParticipantRequestCopyWith(ParticipantRequest value, $Res Function(ParticipantRequest) _then) = _$ParticipantRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'first_name') String firstName,@JsonKey(name: 'last_name') String lastName,@JsonKey(name: 'price_label') String priceLabel,@JsonKey(name: 'is_booker') bool isBooker
});




}
/// @nodoc
class _$ParticipantRequestCopyWithImpl<$Res>
    implements $ParticipantRequestCopyWith<$Res> {
  _$ParticipantRequestCopyWithImpl(this._self, this._then);

  final ParticipantRequest _self;
  final $Res Function(ParticipantRequest) _then;

/// Create a copy of ParticipantRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? firstName = null,Object? lastName = null,Object? priceLabel = null,Object? isBooker = null,}) {
  return _then(_self.copyWith(
firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,priceLabel: null == priceLabel ? _self.priceLabel : priceLabel // ignore: cast_nullable_to_non_nullable
as String,isBooker: null == isBooker ? _self.isBooker : isBooker // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ParticipantRequest].
extension ParticipantRequestPatterns on ParticipantRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ParticipantRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ParticipantRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ParticipantRequest value)  $default,){
final _that = this;
switch (_that) {
case _ParticipantRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ParticipantRequest value)?  $default,){
final _that = this;
switch (_that) {
case _ParticipantRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'first_name')  String firstName, @JsonKey(name: 'last_name')  String lastName, @JsonKey(name: 'price_label')  String priceLabel, @JsonKey(name: 'is_booker')  bool isBooker)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ParticipantRequest() when $default != null:
return $default(_that.firstName,_that.lastName,_that.priceLabel,_that.isBooker);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'first_name')  String firstName, @JsonKey(name: 'last_name')  String lastName, @JsonKey(name: 'price_label')  String priceLabel, @JsonKey(name: 'is_booker')  bool isBooker)  $default,) {final _that = this;
switch (_that) {
case _ParticipantRequest():
return $default(_that.firstName,_that.lastName,_that.priceLabel,_that.isBooker);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'first_name')  String firstName, @JsonKey(name: 'last_name')  String lastName, @JsonKey(name: 'price_label')  String priceLabel, @JsonKey(name: 'is_booker')  bool isBooker)?  $default,) {final _that = this;
switch (_that) {
case _ParticipantRequest() when $default != null:
return $default(_that.firstName,_that.lastName,_that.priceLabel,_that.isBooker);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ParticipantRequest implements ParticipantRequest {
  const _ParticipantRequest({@JsonKey(name: 'first_name') required this.firstName, @JsonKey(name: 'last_name') required this.lastName, @JsonKey(name: 'price_label') this.priceLabel = '', @JsonKey(name: 'is_booker') this.isBooker = false});
  factory _ParticipantRequest.fromJson(Map<String, dynamic> json) => _$ParticipantRequestFromJson(json);

@override@JsonKey(name: 'first_name') final  String firstName;
@override@JsonKey(name: 'last_name') final  String lastName;
@override@JsonKey(name: 'price_label') final  String priceLabel;
@override@JsonKey(name: 'is_booker') final  bool isBooker;

/// Create a copy of ParticipantRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ParticipantRequestCopyWith<_ParticipantRequest> get copyWith => __$ParticipantRequestCopyWithImpl<_ParticipantRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ParticipantRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ParticipantRequest&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.priceLabel, priceLabel) || other.priceLabel == priceLabel)&&(identical(other.isBooker, isBooker) || other.isBooker == isBooker));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,firstName,lastName,priceLabel,isBooker);

@override
String toString() {
  return 'ParticipantRequest(firstName: $firstName, lastName: $lastName, priceLabel: $priceLabel, isBooker: $isBooker)';
}


}

/// @nodoc
abstract mixin class _$ParticipantRequestCopyWith<$Res> implements $ParticipantRequestCopyWith<$Res> {
  factory _$ParticipantRequestCopyWith(_ParticipantRequest value, $Res Function(_ParticipantRequest) _then) = __$ParticipantRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'first_name') String firstName,@JsonKey(name: 'last_name') String lastName,@JsonKey(name: 'price_label') String priceLabel,@JsonKey(name: 'is_booker') bool isBooker
});




}
/// @nodoc
class __$ParticipantRequestCopyWithImpl<$Res>
    implements _$ParticipantRequestCopyWith<$Res> {
  __$ParticipantRequestCopyWithImpl(this._self, this._then);

  final _ParticipantRequest _self;
  final $Res Function(_ParticipantRequest) _then;

/// Create a copy of ParticipantRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? firstName = null,Object? lastName = null,Object? priceLabel = null,Object? isBooker = null,}) {
  return _then(_ParticipantRequest(
firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,priceLabel: null == priceLabel ? _self.priceLabel : priceLabel // ignore: cast_nullable_to_non_nullable
as String,isBooker: null == isBooker ? _self.isBooker : isBooker // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
