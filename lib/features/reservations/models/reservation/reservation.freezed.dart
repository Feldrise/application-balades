// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reservation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Reservation {

 int get id;@JsonKey(name: 'created_at')@DateSerializer() DateTime get createdAt;@JsonKey(name: 'updated_at')@DateSerializer() DateTime get updatedAt;@JsonKey(name: 'ramble_id') int get rambleId;@JsonKey(name: 'user_id') int get userId;@JsonKey(name: 'contact_email') String get contactEmail; String get status;@JsonKey(name: 'confirmation_deadline')@DateSerializer() DateTime? get confirmationDeadline;@JsonKey(name: 'confirmation_date')@DateSerializer() DateTime? get confirmationDate;@JsonKey(name: 'cancellation_date')@DateSerializer() DateTime? get cancellationDate;@JsonKey(name: 'cancellation_reason') String? get cancellationReason; List<Participant> get participants;// Amount in cents, computed by the API from the participants' prices
@JsonKey(name: 'estimated_amount') int get estimatedAmount;// A participant's tariff is unknown (migrated reservations): the estimated amount leaves it out
@JsonKey(name: 'has_missing_prices') bool get hasMissingPrices; List<ReservationPayment> get payments;// After a removal or a cancellation, the booker is invited to contact the guide for a refund
@JsonKey(name: 'has_successful_payment') bool get hasSuccessfulPayment; ReservationRambleSummary? get ramble;
/// Create a copy of Reservation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReservationCopyWith<Reservation> get copyWith => _$ReservationCopyWithImpl<Reservation>(this as Reservation, _$identity);

  /// Serializes this Reservation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Reservation&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.rambleId, rambleId) || other.rambleId == rambleId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.contactEmail, contactEmail) || other.contactEmail == contactEmail)&&(identical(other.status, status) || other.status == status)&&(identical(other.confirmationDeadline, confirmationDeadline) || other.confirmationDeadline == confirmationDeadline)&&(identical(other.confirmationDate, confirmationDate) || other.confirmationDate == confirmationDate)&&(identical(other.cancellationDate, cancellationDate) || other.cancellationDate == cancellationDate)&&(identical(other.cancellationReason, cancellationReason) || other.cancellationReason == cancellationReason)&&const DeepCollectionEquality().equals(other.participants, participants)&&(identical(other.estimatedAmount, estimatedAmount) || other.estimatedAmount == estimatedAmount)&&(identical(other.hasMissingPrices, hasMissingPrices) || other.hasMissingPrices == hasMissingPrices)&&const DeepCollectionEquality().equals(other.payments, payments)&&(identical(other.hasSuccessfulPayment, hasSuccessfulPayment) || other.hasSuccessfulPayment == hasSuccessfulPayment)&&(identical(other.ramble, ramble) || other.ramble == ramble));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,createdAt,updatedAt,rambleId,userId,contactEmail,status,confirmationDeadline,confirmationDate,cancellationDate,cancellationReason,const DeepCollectionEquality().hash(participants),estimatedAmount,hasMissingPrices,const DeepCollectionEquality().hash(payments),hasSuccessfulPayment,ramble);

@override
String toString() {
  return 'Reservation(id: $id, createdAt: $createdAt, updatedAt: $updatedAt, rambleId: $rambleId, userId: $userId, contactEmail: $contactEmail, status: $status, confirmationDeadline: $confirmationDeadline, confirmationDate: $confirmationDate, cancellationDate: $cancellationDate, cancellationReason: $cancellationReason, participants: $participants, estimatedAmount: $estimatedAmount, hasMissingPrices: $hasMissingPrices, payments: $payments, hasSuccessfulPayment: $hasSuccessfulPayment, ramble: $ramble)';
}


}

/// @nodoc
abstract mixin class $ReservationCopyWith<$Res>  {
  factory $ReservationCopyWith(Reservation value, $Res Function(Reservation) _then) = _$ReservationCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'created_at')@DateSerializer() DateTime createdAt,@JsonKey(name: 'updated_at')@DateSerializer() DateTime updatedAt,@JsonKey(name: 'ramble_id') int rambleId,@JsonKey(name: 'user_id') int userId,@JsonKey(name: 'contact_email') String contactEmail, String status,@JsonKey(name: 'confirmation_deadline')@DateSerializer() DateTime? confirmationDeadline,@JsonKey(name: 'confirmation_date')@DateSerializer() DateTime? confirmationDate,@JsonKey(name: 'cancellation_date')@DateSerializer() DateTime? cancellationDate,@JsonKey(name: 'cancellation_reason') String? cancellationReason, List<Participant> participants,@JsonKey(name: 'estimated_amount') int estimatedAmount,@JsonKey(name: 'has_missing_prices') bool hasMissingPrices, List<ReservationPayment> payments,@JsonKey(name: 'has_successful_payment') bool hasSuccessfulPayment, ReservationRambleSummary? ramble
});


$ReservationRambleSummaryCopyWith<$Res>? get ramble;

}
/// @nodoc
class _$ReservationCopyWithImpl<$Res>
    implements $ReservationCopyWith<$Res> {
  _$ReservationCopyWithImpl(this._self, this._then);

  final Reservation _self;
  final $Res Function(Reservation) _then;

/// Create a copy of Reservation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? createdAt = null,Object? updatedAt = null,Object? rambleId = null,Object? userId = null,Object? contactEmail = null,Object? status = null,Object? confirmationDeadline = freezed,Object? confirmationDate = freezed,Object? cancellationDate = freezed,Object? cancellationReason = freezed,Object? participants = null,Object? estimatedAmount = null,Object? hasMissingPrices = null,Object? payments = null,Object? hasSuccessfulPayment = null,Object? ramble = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,rambleId: null == rambleId ? _self.rambleId : rambleId // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,contactEmail: null == contactEmail ? _self.contactEmail : contactEmail // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,confirmationDeadline: freezed == confirmationDeadline ? _self.confirmationDeadline : confirmationDeadline // ignore: cast_nullable_to_non_nullable
as DateTime?,confirmationDate: freezed == confirmationDate ? _self.confirmationDate : confirmationDate // ignore: cast_nullable_to_non_nullable
as DateTime?,cancellationDate: freezed == cancellationDate ? _self.cancellationDate : cancellationDate // ignore: cast_nullable_to_non_nullable
as DateTime?,cancellationReason: freezed == cancellationReason ? _self.cancellationReason : cancellationReason // ignore: cast_nullable_to_non_nullable
as String?,participants: null == participants ? _self.participants : participants // ignore: cast_nullable_to_non_nullable
as List<Participant>,estimatedAmount: null == estimatedAmount ? _self.estimatedAmount : estimatedAmount // ignore: cast_nullable_to_non_nullable
as int,hasMissingPrices: null == hasMissingPrices ? _self.hasMissingPrices : hasMissingPrices // ignore: cast_nullable_to_non_nullable
as bool,payments: null == payments ? _self.payments : payments // ignore: cast_nullable_to_non_nullable
as List<ReservationPayment>,hasSuccessfulPayment: null == hasSuccessfulPayment ? _self.hasSuccessfulPayment : hasSuccessfulPayment // ignore: cast_nullable_to_non_nullable
as bool,ramble: freezed == ramble ? _self.ramble : ramble // ignore: cast_nullable_to_non_nullable
as ReservationRambleSummary?,
  ));
}
/// Create a copy of Reservation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReservationRambleSummaryCopyWith<$Res>? get ramble {
    if (_self.ramble == null) {
    return null;
  }

  return $ReservationRambleSummaryCopyWith<$Res>(_self.ramble!, (value) {
    return _then(_self.copyWith(ramble: value));
  });
}
}


/// Adds pattern-matching-related methods to [Reservation].
extension ReservationPatterns on Reservation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Reservation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Reservation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Reservation value)  $default,){
final _that = this;
switch (_that) {
case _Reservation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Reservation value)?  $default,){
final _that = this;
switch (_that) {
case _Reservation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'created_at')@DateSerializer()  DateTime createdAt, @JsonKey(name: 'updated_at')@DateSerializer()  DateTime updatedAt, @JsonKey(name: 'ramble_id')  int rambleId, @JsonKey(name: 'user_id')  int userId, @JsonKey(name: 'contact_email')  String contactEmail,  String status, @JsonKey(name: 'confirmation_deadline')@DateSerializer()  DateTime? confirmationDeadline, @JsonKey(name: 'confirmation_date')@DateSerializer()  DateTime? confirmationDate, @JsonKey(name: 'cancellation_date')@DateSerializer()  DateTime? cancellationDate, @JsonKey(name: 'cancellation_reason')  String? cancellationReason,  List<Participant> participants, @JsonKey(name: 'estimated_amount')  int estimatedAmount, @JsonKey(name: 'has_missing_prices')  bool hasMissingPrices,  List<ReservationPayment> payments, @JsonKey(name: 'has_successful_payment')  bool hasSuccessfulPayment,  ReservationRambleSummary? ramble)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Reservation() when $default != null:
return $default(_that.id,_that.createdAt,_that.updatedAt,_that.rambleId,_that.userId,_that.contactEmail,_that.status,_that.confirmationDeadline,_that.confirmationDate,_that.cancellationDate,_that.cancellationReason,_that.participants,_that.estimatedAmount,_that.hasMissingPrices,_that.payments,_that.hasSuccessfulPayment,_that.ramble);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'created_at')@DateSerializer()  DateTime createdAt, @JsonKey(name: 'updated_at')@DateSerializer()  DateTime updatedAt, @JsonKey(name: 'ramble_id')  int rambleId, @JsonKey(name: 'user_id')  int userId, @JsonKey(name: 'contact_email')  String contactEmail,  String status, @JsonKey(name: 'confirmation_deadline')@DateSerializer()  DateTime? confirmationDeadline, @JsonKey(name: 'confirmation_date')@DateSerializer()  DateTime? confirmationDate, @JsonKey(name: 'cancellation_date')@DateSerializer()  DateTime? cancellationDate, @JsonKey(name: 'cancellation_reason')  String? cancellationReason,  List<Participant> participants, @JsonKey(name: 'estimated_amount')  int estimatedAmount, @JsonKey(name: 'has_missing_prices')  bool hasMissingPrices,  List<ReservationPayment> payments, @JsonKey(name: 'has_successful_payment')  bool hasSuccessfulPayment,  ReservationRambleSummary? ramble)  $default,) {final _that = this;
switch (_that) {
case _Reservation():
return $default(_that.id,_that.createdAt,_that.updatedAt,_that.rambleId,_that.userId,_that.contactEmail,_that.status,_that.confirmationDeadline,_that.confirmationDate,_that.cancellationDate,_that.cancellationReason,_that.participants,_that.estimatedAmount,_that.hasMissingPrices,_that.payments,_that.hasSuccessfulPayment,_that.ramble);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'created_at')@DateSerializer()  DateTime createdAt, @JsonKey(name: 'updated_at')@DateSerializer()  DateTime updatedAt, @JsonKey(name: 'ramble_id')  int rambleId, @JsonKey(name: 'user_id')  int userId, @JsonKey(name: 'contact_email')  String contactEmail,  String status, @JsonKey(name: 'confirmation_deadline')@DateSerializer()  DateTime? confirmationDeadline, @JsonKey(name: 'confirmation_date')@DateSerializer()  DateTime? confirmationDate, @JsonKey(name: 'cancellation_date')@DateSerializer()  DateTime? cancellationDate, @JsonKey(name: 'cancellation_reason')  String? cancellationReason,  List<Participant> participants, @JsonKey(name: 'estimated_amount')  int estimatedAmount, @JsonKey(name: 'has_missing_prices')  bool hasMissingPrices,  List<ReservationPayment> payments, @JsonKey(name: 'has_successful_payment')  bool hasSuccessfulPayment,  ReservationRambleSummary? ramble)?  $default,) {final _that = this;
switch (_that) {
case _Reservation() when $default != null:
return $default(_that.id,_that.createdAt,_that.updatedAt,_that.rambleId,_that.userId,_that.contactEmail,_that.status,_that.confirmationDeadline,_that.confirmationDate,_that.cancellationDate,_that.cancellationReason,_that.participants,_that.estimatedAmount,_that.hasMissingPrices,_that.payments,_that.hasSuccessfulPayment,_that.ramble);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Reservation implements Reservation {
  const _Reservation(this.id, {@JsonKey(name: 'created_at')@DateSerializer() required this.createdAt, @JsonKey(name: 'updated_at')@DateSerializer() required this.updatedAt, @JsonKey(name: 'ramble_id') required this.rambleId, @JsonKey(name: 'user_id') required this.userId, @JsonKey(name: 'contact_email') required this.contactEmail, required this.status, @JsonKey(name: 'confirmation_deadline')@DateSerializer() this.confirmationDeadline, @JsonKey(name: 'confirmation_date')@DateSerializer() this.confirmationDate, @JsonKey(name: 'cancellation_date')@DateSerializer() this.cancellationDate, @JsonKey(name: 'cancellation_reason') this.cancellationReason, final  List<Participant> participants = const <Participant>[], @JsonKey(name: 'estimated_amount') this.estimatedAmount = 0, @JsonKey(name: 'has_missing_prices') this.hasMissingPrices = false, final  List<ReservationPayment> payments = const <ReservationPayment>[], @JsonKey(name: 'has_successful_payment') this.hasSuccessfulPayment = false, this.ramble}): _participants = participants,_payments = payments;
  factory _Reservation.fromJson(Map<String, dynamic> json) => _$ReservationFromJson(json);

@override final  int id;
@override@JsonKey(name: 'created_at')@DateSerializer() final  DateTime createdAt;
@override@JsonKey(name: 'updated_at')@DateSerializer() final  DateTime updatedAt;
@override@JsonKey(name: 'ramble_id') final  int rambleId;
@override@JsonKey(name: 'user_id') final  int userId;
@override@JsonKey(name: 'contact_email') final  String contactEmail;
@override final  String status;
@override@JsonKey(name: 'confirmation_deadline')@DateSerializer() final  DateTime? confirmationDeadline;
@override@JsonKey(name: 'confirmation_date')@DateSerializer() final  DateTime? confirmationDate;
@override@JsonKey(name: 'cancellation_date')@DateSerializer() final  DateTime? cancellationDate;
@override@JsonKey(name: 'cancellation_reason') final  String? cancellationReason;
 final  List<Participant> _participants;
@override@JsonKey() List<Participant> get participants {
  if (_participants is EqualUnmodifiableListView) return _participants;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_participants);
}

// Amount in cents, computed by the API from the participants' prices
@override@JsonKey(name: 'estimated_amount') final  int estimatedAmount;
// A participant's tariff is unknown (migrated reservations): the estimated amount leaves it out
@override@JsonKey(name: 'has_missing_prices') final  bool hasMissingPrices;
 final  List<ReservationPayment> _payments;
@override@JsonKey() List<ReservationPayment> get payments {
  if (_payments is EqualUnmodifiableListView) return _payments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_payments);
}

// After a removal or a cancellation, the booker is invited to contact the guide for a refund
@override@JsonKey(name: 'has_successful_payment') final  bool hasSuccessfulPayment;
@override final  ReservationRambleSummary? ramble;

/// Create a copy of Reservation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReservationCopyWith<_Reservation> get copyWith => __$ReservationCopyWithImpl<_Reservation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReservationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Reservation&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.rambleId, rambleId) || other.rambleId == rambleId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.contactEmail, contactEmail) || other.contactEmail == contactEmail)&&(identical(other.status, status) || other.status == status)&&(identical(other.confirmationDeadline, confirmationDeadline) || other.confirmationDeadline == confirmationDeadline)&&(identical(other.confirmationDate, confirmationDate) || other.confirmationDate == confirmationDate)&&(identical(other.cancellationDate, cancellationDate) || other.cancellationDate == cancellationDate)&&(identical(other.cancellationReason, cancellationReason) || other.cancellationReason == cancellationReason)&&const DeepCollectionEquality().equals(other._participants, _participants)&&(identical(other.estimatedAmount, estimatedAmount) || other.estimatedAmount == estimatedAmount)&&(identical(other.hasMissingPrices, hasMissingPrices) || other.hasMissingPrices == hasMissingPrices)&&const DeepCollectionEquality().equals(other._payments, _payments)&&(identical(other.hasSuccessfulPayment, hasSuccessfulPayment) || other.hasSuccessfulPayment == hasSuccessfulPayment)&&(identical(other.ramble, ramble) || other.ramble == ramble));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,createdAt,updatedAt,rambleId,userId,contactEmail,status,confirmationDeadline,confirmationDate,cancellationDate,cancellationReason,const DeepCollectionEquality().hash(_participants),estimatedAmount,hasMissingPrices,const DeepCollectionEquality().hash(_payments),hasSuccessfulPayment,ramble);

@override
String toString() {
  return 'Reservation(id: $id, createdAt: $createdAt, updatedAt: $updatedAt, rambleId: $rambleId, userId: $userId, contactEmail: $contactEmail, status: $status, confirmationDeadline: $confirmationDeadline, confirmationDate: $confirmationDate, cancellationDate: $cancellationDate, cancellationReason: $cancellationReason, participants: $participants, estimatedAmount: $estimatedAmount, hasMissingPrices: $hasMissingPrices, payments: $payments, hasSuccessfulPayment: $hasSuccessfulPayment, ramble: $ramble)';
}


}

/// @nodoc
abstract mixin class _$ReservationCopyWith<$Res> implements $ReservationCopyWith<$Res> {
  factory _$ReservationCopyWith(_Reservation value, $Res Function(_Reservation) _then) = __$ReservationCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'created_at')@DateSerializer() DateTime createdAt,@JsonKey(name: 'updated_at')@DateSerializer() DateTime updatedAt,@JsonKey(name: 'ramble_id') int rambleId,@JsonKey(name: 'user_id') int userId,@JsonKey(name: 'contact_email') String contactEmail, String status,@JsonKey(name: 'confirmation_deadline')@DateSerializer() DateTime? confirmationDeadline,@JsonKey(name: 'confirmation_date')@DateSerializer() DateTime? confirmationDate,@JsonKey(name: 'cancellation_date')@DateSerializer() DateTime? cancellationDate,@JsonKey(name: 'cancellation_reason') String? cancellationReason, List<Participant> participants,@JsonKey(name: 'estimated_amount') int estimatedAmount,@JsonKey(name: 'has_missing_prices') bool hasMissingPrices, List<ReservationPayment> payments,@JsonKey(name: 'has_successful_payment') bool hasSuccessfulPayment, ReservationRambleSummary? ramble
});


@override $ReservationRambleSummaryCopyWith<$Res>? get ramble;

}
/// @nodoc
class __$ReservationCopyWithImpl<$Res>
    implements _$ReservationCopyWith<$Res> {
  __$ReservationCopyWithImpl(this._self, this._then);

  final _Reservation _self;
  final $Res Function(_Reservation) _then;

/// Create a copy of Reservation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? createdAt = null,Object? updatedAt = null,Object? rambleId = null,Object? userId = null,Object? contactEmail = null,Object? status = null,Object? confirmationDeadline = freezed,Object? confirmationDate = freezed,Object? cancellationDate = freezed,Object? cancellationReason = freezed,Object? participants = null,Object? estimatedAmount = null,Object? hasMissingPrices = null,Object? payments = null,Object? hasSuccessfulPayment = null,Object? ramble = freezed,}) {
  return _then(_Reservation(
null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,rambleId: null == rambleId ? _self.rambleId : rambleId // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,contactEmail: null == contactEmail ? _self.contactEmail : contactEmail // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,confirmationDeadline: freezed == confirmationDeadline ? _self.confirmationDeadline : confirmationDeadline // ignore: cast_nullable_to_non_nullable
as DateTime?,confirmationDate: freezed == confirmationDate ? _self.confirmationDate : confirmationDate // ignore: cast_nullable_to_non_nullable
as DateTime?,cancellationDate: freezed == cancellationDate ? _self.cancellationDate : cancellationDate // ignore: cast_nullable_to_non_nullable
as DateTime?,cancellationReason: freezed == cancellationReason ? _self.cancellationReason : cancellationReason // ignore: cast_nullable_to_non_nullable
as String?,participants: null == participants ? _self._participants : participants // ignore: cast_nullable_to_non_nullable
as List<Participant>,estimatedAmount: null == estimatedAmount ? _self.estimatedAmount : estimatedAmount // ignore: cast_nullable_to_non_nullable
as int,hasMissingPrices: null == hasMissingPrices ? _self.hasMissingPrices : hasMissingPrices // ignore: cast_nullable_to_non_nullable
as bool,payments: null == payments ? _self._payments : payments // ignore: cast_nullable_to_non_nullable
as List<ReservationPayment>,hasSuccessfulPayment: null == hasSuccessfulPayment ? _self.hasSuccessfulPayment : hasSuccessfulPayment // ignore: cast_nullable_to_non_nullable
as bool,ramble: freezed == ramble ? _self.ramble : ramble // ignore: cast_nullable_to_non_nullable
as ReservationRambleSummary?,
  ));
}

/// Create a copy of Reservation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReservationRambleSummaryCopyWith<$Res>? get ramble {
    if (_self.ramble == null) {
    return null;
  }

  return $ReservationRambleSummaryCopyWith<$Res>(_self.ramble!, (value) {
    return _then(_self.copyWith(ramble: value));
  });
}
}


/// @nodoc
mixin _$Participant {

 int get id;@JsonKey(name: 'first_name') String get firstName;@JsonKey(name: 'last_name') String get lastName;@JsonKey(name: 'price_label') String get priceLabel;// Amount in euros
@JsonKey(name: 'price_amount') double get priceAmount;// The ramble has tariffs but this participant's is unknown (migrated participants)
@JsonKey(name: 'price_missing') bool get priceMissing;@JsonKey(name: 'is_booker') bool get isBooker;
/// Create a copy of Participant
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParticipantCopyWith<Participant> get copyWith => _$ParticipantCopyWithImpl<Participant>(this as Participant, _$identity);

  /// Serializes this Participant to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Participant&&(identical(other.id, id) || other.id == id)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.priceLabel, priceLabel) || other.priceLabel == priceLabel)&&(identical(other.priceAmount, priceAmount) || other.priceAmount == priceAmount)&&(identical(other.priceMissing, priceMissing) || other.priceMissing == priceMissing)&&(identical(other.isBooker, isBooker) || other.isBooker == isBooker));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,firstName,lastName,priceLabel,priceAmount,priceMissing,isBooker);

@override
String toString() {
  return 'Participant(id: $id, firstName: $firstName, lastName: $lastName, priceLabel: $priceLabel, priceAmount: $priceAmount, priceMissing: $priceMissing, isBooker: $isBooker)';
}


}

/// @nodoc
abstract mixin class $ParticipantCopyWith<$Res>  {
  factory $ParticipantCopyWith(Participant value, $Res Function(Participant) _then) = _$ParticipantCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'first_name') String firstName,@JsonKey(name: 'last_name') String lastName,@JsonKey(name: 'price_label') String priceLabel,@JsonKey(name: 'price_amount') double priceAmount,@JsonKey(name: 'price_missing') bool priceMissing,@JsonKey(name: 'is_booker') bool isBooker
});




}
/// @nodoc
class _$ParticipantCopyWithImpl<$Res>
    implements $ParticipantCopyWith<$Res> {
  _$ParticipantCopyWithImpl(this._self, this._then);

  final Participant _self;
  final $Res Function(Participant) _then;

/// Create a copy of Participant
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? firstName = null,Object? lastName = null,Object? priceLabel = null,Object? priceAmount = null,Object? priceMissing = null,Object? isBooker = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,priceLabel: null == priceLabel ? _self.priceLabel : priceLabel // ignore: cast_nullable_to_non_nullable
as String,priceAmount: null == priceAmount ? _self.priceAmount : priceAmount // ignore: cast_nullable_to_non_nullable
as double,priceMissing: null == priceMissing ? _self.priceMissing : priceMissing // ignore: cast_nullable_to_non_nullable
as bool,isBooker: null == isBooker ? _self.isBooker : isBooker // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Participant].
extension ParticipantPatterns on Participant {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Participant value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Participant() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Participant value)  $default,){
final _that = this;
switch (_that) {
case _Participant():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Participant value)?  $default,){
final _that = this;
switch (_that) {
case _Participant() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'first_name')  String firstName, @JsonKey(name: 'last_name')  String lastName, @JsonKey(name: 'price_label')  String priceLabel, @JsonKey(name: 'price_amount')  double priceAmount, @JsonKey(name: 'price_missing')  bool priceMissing, @JsonKey(name: 'is_booker')  bool isBooker)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Participant() when $default != null:
return $default(_that.id,_that.firstName,_that.lastName,_that.priceLabel,_that.priceAmount,_that.priceMissing,_that.isBooker);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'first_name')  String firstName, @JsonKey(name: 'last_name')  String lastName, @JsonKey(name: 'price_label')  String priceLabel, @JsonKey(name: 'price_amount')  double priceAmount, @JsonKey(name: 'price_missing')  bool priceMissing, @JsonKey(name: 'is_booker')  bool isBooker)  $default,) {final _that = this;
switch (_that) {
case _Participant():
return $default(_that.id,_that.firstName,_that.lastName,_that.priceLabel,_that.priceAmount,_that.priceMissing,_that.isBooker);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'first_name')  String firstName, @JsonKey(name: 'last_name')  String lastName, @JsonKey(name: 'price_label')  String priceLabel, @JsonKey(name: 'price_amount')  double priceAmount, @JsonKey(name: 'price_missing')  bool priceMissing, @JsonKey(name: 'is_booker')  bool isBooker)?  $default,) {final _that = this;
switch (_that) {
case _Participant() when $default != null:
return $default(_that.id,_that.firstName,_that.lastName,_that.priceLabel,_that.priceAmount,_that.priceMissing,_that.isBooker);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Participant implements Participant {
  const _Participant(this.id, {@JsonKey(name: 'first_name') required this.firstName, @JsonKey(name: 'last_name') required this.lastName, @JsonKey(name: 'price_label') this.priceLabel = '', @JsonKey(name: 'price_amount') this.priceAmount = 0.0, @JsonKey(name: 'price_missing') this.priceMissing = false, @JsonKey(name: 'is_booker') this.isBooker = false});
  factory _Participant.fromJson(Map<String, dynamic> json) => _$ParticipantFromJson(json);

@override final  int id;
@override@JsonKey(name: 'first_name') final  String firstName;
@override@JsonKey(name: 'last_name') final  String lastName;
@override@JsonKey(name: 'price_label') final  String priceLabel;
// Amount in euros
@override@JsonKey(name: 'price_amount') final  double priceAmount;
// The ramble has tariffs but this participant's is unknown (migrated participants)
@override@JsonKey(name: 'price_missing') final  bool priceMissing;
@override@JsonKey(name: 'is_booker') final  bool isBooker;

/// Create a copy of Participant
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ParticipantCopyWith<_Participant> get copyWith => __$ParticipantCopyWithImpl<_Participant>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ParticipantToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Participant&&(identical(other.id, id) || other.id == id)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.priceLabel, priceLabel) || other.priceLabel == priceLabel)&&(identical(other.priceAmount, priceAmount) || other.priceAmount == priceAmount)&&(identical(other.priceMissing, priceMissing) || other.priceMissing == priceMissing)&&(identical(other.isBooker, isBooker) || other.isBooker == isBooker));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,firstName,lastName,priceLabel,priceAmount,priceMissing,isBooker);

@override
String toString() {
  return 'Participant(id: $id, firstName: $firstName, lastName: $lastName, priceLabel: $priceLabel, priceAmount: $priceAmount, priceMissing: $priceMissing, isBooker: $isBooker)';
}


}

/// @nodoc
abstract mixin class _$ParticipantCopyWith<$Res> implements $ParticipantCopyWith<$Res> {
  factory _$ParticipantCopyWith(_Participant value, $Res Function(_Participant) _then) = __$ParticipantCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'first_name') String firstName,@JsonKey(name: 'last_name') String lastName,@JsonKey(name: 'price_label') String priceLabel,@JsonKey(name: 'price_amount') double priceAmount,@JsonKey(name: 'price_missing') bool priceMissing,@JsonKey(name: 'is_booker') bool isBooker
});




}
/// @nodoc
class __$ParticipantCopyWithImpl<$Res>
    implements _$ParticipantCopyWith<$Res> {
  __$ParticipantCopyWithImpl(this._self, this._then);

  final _Participant _self;
  final $Res Function(_Participant) _then;

/// Create a copy of Participant
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? firstName = null,Object? lastName = null,Object? priceLabel = null,Object? priceAmount = null,Object? priceMissing = null,Object? isBooker = null,}) {
  return _then(_Participant(
null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,priceLabel: null == priceLabel ? _self.priceLabel : priceLabel // ignore: cast_nullable_to_non_nullable
as String,priceAmount: null == priceAmount ? _self.priceAmount : priceAmount // ignore: cast_nullable_to_non_nullable
as double,priceMissing: null == priceMissing ? _self.priceMissing : priceMissing // ignore: cast_nullable_to_non_nullable
as bool,isBooker: null == isBooker ? _self.isBooker : isBooker // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$ReservationPayment {

 int get id;@JsonKey(name: 'created_at')@DateSerializer() DateTime get createdAt;// Amount in cents
 int get amount; String get currency; String get status;@JsonKey(name: 'paid_at')@DateSerializer() DateTime? get paidAt;@JsonKey(name: 'refunded_at')@DateSerializer() DateTime? get refundedAt;@JsonKey(name: 'refund_amount') int? get refundAmount;
/// Create a copy of ReservationPayment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReservationPaymentCopyWith<ReservationPayment> get copyWith => _$ReservationPaymentCopyWithImpl<ReservationPayment>(this as ReservationPayment, _$identity);

  /// Serializes this ReservationPayment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReservationPayment&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.status, status) || other.status == status)&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt)&&(identical(other.refundedAt, refundedAt) || other.refundedAt == refundedAt)&&(identical(other.refundAmount, refundAmount) || other.refundAmount == refundAmount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,createdAt,amount,currency,status,paidAt,refundedAt,refundAmount);

@override
String toString() {
  return 'ReservationPayment(id: $id, createdAt: $createdAt, amount: $amount, currency: $currency, status: $status, paidAt: $paidAt, refundedAt: $refundedAt, refundAmount: $refundAmount)';
}


}

/// @nodoc
abstract mixin class $ReservationPaymentCopyWith<$Res>  {
  factory $ReservationPaymentCopyWith(ReservationPayment value, $Res Function(ReservationPayment) _then) = _$ReservationPaymentCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'created_at')@DateSerializer() DateTime createdAt, int amount, String currency, String status,@JsonKey(name: 'paid_at')@DateSerializer() DateTime? paidAt,@JsonKey(name: 'refunded_at')@DateSerializer() DateTime? refundedAt,@JsonKey(name: 'refund_amount') int? refundAmount
});




}
/// @nodoc
class _$ReservationPaymentCopyWithImpl<$Res>
    implements $ReservationPaymentCopyWith<$Res> {
  _$ReservationPaymentCopyWithImpl(this._self, this._then);

  final ReservationPayment _self;
  final $Res Function(ReservationPayment) _then;

/// Create a copy of ReservationPayment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? createdAt = null,Object? amount = null,Object? currency = null,Object? status = null,Object? paidAt = freezed,Object? refundedAt = freezed,Object? refundAmount = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,paidAt: freezed == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as DateTime?,refundedAt: freezed == refundedAt ? _self.refundedAt : refundedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,refundAmount: freezed == refundAmount ? _self.refundAmount : refundAmount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [ReservationPayment].
extension ReservationPaymentPatterns on ReservationPayment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReservationPayment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReservationPayment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReservationPayment value)  $default,){
final _that = this;
switch (_that) {
case _ReservationPayment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReservationPayment value)?  $default,){
final _that = this;
switch (_that) {
case _ReservationPayment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'created_at')@DateSerializer()  DateTime createdAt,  int amount,  String currency,  String status, @JsonKey(name: 'paid_at')@DateSerializer()  DateTime? paidAt, @JsonKey(name: 'refunded_at')@DateSerializer()  DateTime? refundedAt, @JsonKey(name: 'refund_amount')  int? refundAmount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReservationPayment() when $default != null:
return $default(_that.id,_that.createdAt,_that.amount,_that.currency,_that.status,_that.paidAt,_that.refundedAt,_that.refundAmount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'created_at')@DateSerializer()  DateTime createdAt,  int amount,  String currency,  String status, @JsonKey(name: 'paid_at')@DateSerializer()  DateTime? paidAt, @JsonKey(name: 'refunded_at')@DateSerializer()  DateTime? refundedAt, @JsonKey(name: 'refund_amount')  int? refundAmount)  $default,) {final _that = this;
switch (_that) {
case _ReservationPayment():
return $default(_that.id,_that.createdAt,_that.amount,_that.currency,_that.status,_that.paidAt,_that.refundedAt,_that.refundAmount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'created_at')@DateSerializer()  DateTime createdAt,  int amount,  String currency,  String status, @JsonKey(name: 'paid_at')@DateSerializer()  DateTime? paidAt, @JsonKey(name: 'refunded_at')@DateSerializer()  DateTime? refundedAt, @JsonKey(name: 'refund_amount')  int? refundAmount)?  $default,) {final _that = this;
switch (_that) {
case _ReservationPayment() when $default != null:
return $default(_that.id,_that.createdAt,_that.amount,_that.currency,_that.status,_that.paidAt,_that.refundedAt,_that.refundAmount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReservationPayment implements ReservationPayment {
  const _ReservationPayment(this.id, {@JsonKey(name: 'created_at')@DateSerializer() required this.createdAt, required this.amount, required this.currency, required this.status, @JsonKey(name: 'paid_at')@DateSerializer() this.paidAt, @JsonKey(name: 'refunded_at')@DateSerializer() this.refundedAt, @JsonKey(name: 'refund_amount') this.refundAmount});
  factory _ReservationPayment.fromJson(Map<String, dynamic> json) => _$ReservationPaymentFromJson(json);

@override final  int id;
@override@JsonKey(name: 'created_at')@DateSerializer() final  DateTime createdAt;
// Amount in cents
@override final  int amount;
@override final  String currency;
@override final  String status;
@override@JsonKey(name: 'paid_at')@DateSerializer() final  DateTime? paidAt;
@override@JsonKey(name: 'refunded_at')@DateSerializer() final  DateTime? refundedAt;
@override@JsonKey(name: 'refund_amount') final  int? refundAmount;

/// Create a copy of ReservationPayment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReservationPaymentCopyWith<_ReservationPayment> get copyWith => __$ReservationPaymentCopyWithImpl<_ReservationPayment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReservationPaymentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReservationPayment&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.status, status) || other.status == status)&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt)&&(identical(other.refundedAt, refundedAt) || other.refundedAt == refundedAt)&&(identical(other.refundAmount, refundAmount) || other.refundAmount == refundAmount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,createdAt,amount,currency,status,paidAt,refundedAt,refundAmount);

@override
String toString() {
  return 'ReservationPayment(id: $id, createdAt: $createdAt, amount: $amount, currency: $currency, status: $status, paidAt: $paidAt, refundedAt: $refundedAt, refundAmount: $refundAmount)';
}


}

/// @nodoc
abstract mixin class _$ReservationPaymentCopyWith<$Res> implements $ReservationPaymentCopyWith<$Res> {
  factory _$ReservationPaymentCopyWith(_ReservationPayment value, $Res Function(_ReservationPayment) _then) = __$ReservationPaymentCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'created_at')@DateSerializer() DateTime createdAt, int amount, String currency, String status,@JsonKey(name: 'paid_at')@DateSerializer() DateTime? paidAt,@JsonKey(name: 'refunded_at')@DateSerializer() DateTime? refundedAt,@JsonKey(name: 'refund_amount') int? refundAmount
});




}
/// @nodoc
class __$ReservationPaymentCopyWithImpl<$Res>
    implements _$ReservationPaymentCopyWith<$Res> {
  __$ReservationPaymentCopyWithImpl(this._self, this._then);

  final _ReservationPayment _self;
  final $Res Function(_ReservationPayment) _then;

/// Create a copy of ReservationPayment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? createdAt = null,Object? amount = null,Object? currency = null,Object? status = null,Object? paidAt = freezed,Object? refundedAt = freezed,Object? refundAmount = freezed,}) {
  return _then(_ReservationPayment(
null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,paidAt: freezed == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as DateTime?,refundedAt: freezed == refundedAt ? _self.refundedAt : refundedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,refundAmount: freezed == refundAmount ? _self.refundAmount : refundAmount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$ReservationRambleSummary {

 String get title;@DateSerializer() DateTime? get date; String? get location;
/// Create a copy of ReservationRambleSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReservationRambleSummaryCopyWith<ReservationRambleSummary> get copyWith => _$ReservationRambleSummaryCopyWithImpl<ReservationRambleSummary>(this as ReservationRambleSummary, _$identity);

  /// Serializes this ReservationRambleSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReservationRambleSummary&&(identical(other.title, title) || other.title == title)&&(identical(other.date, date) || other.date == date)&&(identical(other.location, location) || other.location == location));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,date,location);

@override
String toString() {
  return 'ReservationRambleSummary(title: $title, date: $date, location: $location)';
}


}

/// @nodoc
abstract mixin class $ReservationRambleSummaryCopyWith<$Res>  {
  factory $ReservationRambleSummaryCopyWith(ReservationRambleSummary value, $Res Function(ReservationRambleSummary) _then) = _$ReservationRambleSummaryCopyWithImpl;
@useResult
$Res call({
 String title,@DateSerializer() DateTime? date, String? location
});




}
/// @nodoc
class _$ReservationRambleSummaryCopyWithImpl<$Res>
    implements $ReservationRambleSummaryCopyWith<$Res> {
  _$ReservationRambleSummaryCopyWithImpl(this._self, this._then);

  final ReservationRambleSummary _self;
  final $Res Function(ReservationRambleSummary) _then;

/// Create a copy of ReservationRambleSummary
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


/// Adds pattern-matching-related methods to [ReservationRambleSummary].
extension ReservationRambleSummaryPatterns on ReservationRambleSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReservationRambleSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReservationRambleSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReservationRambleSummary value)  $default,){
final _that = this;
switch (_that) {
case _ReservationRambleSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReservationRambleSummary value)?  $default,){
final _that = this;
switch (_that) {
case _ReservationRambleSummary() when $default != null:
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
case _ReservationRambleSummary() when $default != null:
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
case _ReservationRambleSummary():
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
case _ReservationRambleSummary() when $default != null:
return $default(_that.title,_that.date,_that.location);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReservationRambleSummary implements ReservationRambleSummary {
  const _ReservationRambleSummary({required this.title, @DateSerializer() this.date, this.location});
  factory _ReservationRambleSummary.fromJson(Map<String, dynamic> json) => _$ReservationRambleSummaryFromJson(json);

@override final  String title;
@override@DateSerializer() final  DateTime? date;
@override final  String? location;

/// Create a copy of ReservationRambleSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReservationRambleSummaryCopyWith<_ReservationRambleSummary> get copyWith => __$ReservationRambleSummaryCopyWithImpl<_ReservationRambleSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReservationRambleSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReservationRambleSummary&&(identical(other.title, title) || other.title == title)&&(identical(other.date, date) || other.date == date)&&(identical(other.location, location) || other.location == location));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,date,location);

@override
String toString() {
  return 'ReservationRambleSummary(title: $title, date: $date, location: $location)';
}


}

/// @nodoc
abstract mixin class _$ReservationRambleSummaryCopyWith<$Res> implements $ReservationRambleSummaryCopyWith<$Res> {
  factory _$ReservationRambleSummaryCopyWith(_ReservationRambleSummary value, $Res Function(_ReservationRambleSummary) _then) = __$ReservationRambleSummaryCopyWithImpl;
@override @useResult
$Res call({
 String title,@DateSerializer() DateTime? date, String? location
});




}
/// @nodoc
class __$ReservationRambleSummaryCopyWithImpl<$Res>
    implements _$ReservationRambleSummaryCopyWith<$Res> {
  __$ReservationRambleSummaryCopyWithImpl(this._self, this._then);

  final _ReservationRambleSummary _self;
  final $Res Function(_ReservationRambleSummary) _then;

/// Create a copy of ReservationRambleSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? date = freezed,Object? location = freezed,}) {
  return _then(_ReservationRambleSummary(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
