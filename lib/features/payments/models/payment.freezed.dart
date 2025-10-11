// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Payment {

 int get id;@JsonKey(name: 'created_at')@DateSerializer() DateTime get createdAt;@JsonKey(name: 'updated_at')@DateSerializer() DateTime get updatedAt;@JsonKey(name: 'stripe_payment_intent_id') String get stripePaymentIntentId;@JsonKey(name: 'stripe_charge_id') String? get stripeChargeId; int get amount;// Amount in cents
 String get currency; PaymentStatus get status;@JsonKey(name: 'payment_method') String get paymentMethod;@JsonKey(name: 'registration_id') int? get registrationId;@JsonKey(name: 'group_id') int? get groupId;@JsonKey(name: 'payer_email') String get payerEmail;@JsonKey(name: 'payer_name') String get payerName;@JsonKey(name: 'guide_id') int get guideId;@JsonKey(name: 'paid_at')@DateSerializer() DateTime? get paidAt;@JsonKey(name: 'refunded_at')@DateSerializer() DateTime? get refundedAt;@JsonKey(name: 'refund_amount') int? get refundAmount; Registration? get registration;@JsonKey(name: 'group') RegistrationGroup? get group; Guide? get guide;
/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentCopyWith<Payment> get copyWith => _$PaymentCopyWithImpl<Payment>(this as Payment, _$identity);

  /// Serializes this Payment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Payment&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.stripePaymentIntentId, stripePaymentIntentId) || other.stripePaymentIntentId == stripePaymentIntentId)&&(identical(other.stripeChargeId, stripeChargeId) || other.stripeChargeId == stripeChargeId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.status, status) || other.status == status)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.registrationId, registrationId) || other.registrationId == registrationId)&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.payerEmail, payerEmail) || other.payerEmail == payerEmail)&&(identical(other.payerName, payerName) || other.payerName == payerName)&&(identical(other.guideId, guideId) || other.guideId == guideId)&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt)&&(identical(other.refundedAt, refundedAt) || other.refundedAt == refundedAt)&&(identical(other.refundAmount, refundAmount) || other.refundAmount == refundAmount)&&(identical(other.registration, registration) || other.registration == registration)&&(identical(other.group, group) || other.group == group)&&(identical(other.guide, guide) || other.guide == guide));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,createdAt,updatedAt,stripePaymentIntentId,stripeChargeId,amount,currency,status,paymentMethod,registrationId,groupId,payerEmail,payerName,guideId,paidAt,refundedAt,refundAmount,registration,group,guide]);

@override
String toString() {
  return 'Payment(id: $id, createdAt: $createdAt, updatedAt: $updatedAt, stripePaymentIntentId: $stripePaymentIntentId, stripeChargeId: $stripeChargeId, amount: $amount, currency: $currency, status: $status, paymentMethod: $paymentMethod, registrationId: $registrationId, groupId: $groupId, payerEmail: $payerEmail, payerName: $payerName, guideId: $guideId, paidAt: $paidAt, refundedAt: $refundedAt, refundAmount: $refundAmount, registration: $registration, group: $group, guide: $guide)';
}


}

/// @nodoc
abstract mixin class $PaymentCopyWith<$Res>  {
  factory $PaymentCopyWith(Payment value, $Res Function(Payment) _then) = _$PaymentCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'created_at')@DateSerializer() DateTime createdAt,@JsonKey(name: 'updated_at')@DateSerializer() DateTime updatedAt,@JsonKey(name: 'stripe_payment_intent_id') String stripePaymentIntentId,@JsonKey(name: 'stripe_charge_id') String? stripeChargeId, int amount, String currency, PaymentStatus status,@JsonKey(name: 'payment_method') String paymentMethod,@JsonKey(name: 'registration_id') int? registrationId,@JsonKey(name: 'group_id') int? groupId,@JsonKey(name: 'payer_email') String payerEmail,@JsonKey(name: 'payer_name') String payerName,@JsonKey(name: 'guide_id') int guideId,@JsonKey(name: 'paid_at')@DateSerializer() DateTime? paidAt,@JsonKey(name: 'refunded_at')@DateSerializer() DateTime? refundedAt,@JsonKey(name: 'refund_amount') int? refundAmount, Registration? registration,@JsonKey(name: 'group') RegistrationGroup? group, Guide? guide
});


$RegistrationCopyWith<$Res>? get registration;$RegistrationGroupCopyWith<$Res>? get group;$GuideCopyWith<$Res>? get guide;

}
/// @nodoc
class _$PaymentCopyWithImpl<$Res>
    implements $PaymentCopyWith<$Res> {
  _$PaymentCopyWithImpl(this._self, this._then);

  final Payment _self;
  final $Res Function(Payment) _then;

/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? createdAt = null,Object? updatedAt = null,Object? stripePaymentIntentId = null,Object? stripeChargeId = freezed,Object? amount = null,Object? currency = null,Object? status = null,Object? paymentMethod = null,Object? registrationId = freezed,Object? groupId = freezed,Object? payerEmail = null,Object? payerName = null,Object? guideId = null,Object? paidAt = freezed,Object? refundedAt = freezed,Object? refundAmount = freezed,Object? registration = freezed,Object? group = freezed,Object? guide = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,stripePaymentIntentId: null == stripePaymentIntentId ? _self.stripePaymentIntentId : stripePaymentIntentId // ignore: cast_nullable_to_non_nullable
as String,stripeChargeId: freezed == stripeChargeId ? _self.stripeChargeId : stripeChargeId // ignore: cast_nullable_to_non_nullable
as String?,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PaymentStatus,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String,registrationId: freezed == registrationId ? _self.registrationId : registrationId // ignore: cast_nullable_to_non_nullable
as int?,groupId: freezed == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as int?,payerEmail: null == payerEmail ? _self.payerEmail : payerEmail // ignore: cast_nullable_to_non_nullable
as String,payerName: null == payerName ? _self.payerName : payerName // ignore: cast_nullable_to_non_nullable
as String,guideId: null == guideId ? _self.guideId : guideId // ignore: cast_nullable_to_non_nullable
as int,paidAt: freezed == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as DateTime?,refundedAt: freezed == refundedAt ? _self.refundedAt : refundedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,refundAmount: freezed == refundAmount ? _self.refundAmount : refundAmount // ignore: cast_nullable_to_non_nullable
as int?,registration: freezed == registration ? _self.registration : registration // ignore: cast_nullable_to_non_nullable
as Registration?,group: freezed == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as RegistrationGroup?,guide: freezed == guide ? _self.guide : guide // ignore: cast_nullable_to_non_nullable
as Guide?,
  ));
}
/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RegistrationCopyWith<$Res>? get registration {
    if (_self.registration == null) {
    return null;
  }

  return $RegistrationCopyWith<$Res>(_self.registration!, (value) {
    return _then(_self.copyWith(registration: value));
  });
}/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RegistrationGroupCopyWith<$Res>? get group {
    if (_self.group == null) {
    return null;
  }

  return $RegistrationGroupCopyWith<$Res>(_self.group!, (value) {
    return _then(_self.copyWith(group: value));
  });
}/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GuideCopyWith<$Res>? get guide {
    if (_self.guide == null) {
    return null;
  }

  return $GuideCopyWith<$Res>(_self.guide!, (value) {
    return _then(_self.copyWith(guide: value));
  });
}
}


/// Adds pattern-matching-related methods to [Payment].
extension PaymentPatterns on Payment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Payment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Payment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Payment value)  $default,){
final _that = this;
switch (_that) {
case _Payment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Payment value)?  $default,){
final _that = this;
switch (_that) {
case _Payment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'created_at')@DateSerializer()  DateTime createdAt, @JsonKey(name: 'updated_at')@DateSerializer()  DateTime updatedAt, @JsonKey(name: 'stripe_payment_intent_id')  String stripePaymentIntentId, @JsonKey(name: 'stripe_charge_id')  String? stripeChargeId,  int amount,  String currency,  PaymentStatus status, @JsonKey(name: 'payment_method')  String paymentMethod, @JsonKey(name: 'registration_id')  int? registrationId, @JsonKey(name: 'group_id')  int? groupId, @JsonKey(name: 'payer_email')  String payerEmail, @JsonKey(name: 'payer_name')  String payerName, @JsonKey(name: 'guide_id')  int guideId, @JsonKey(name: 'paid_at')@DateSerializer()  DateTime? paidAt, @JsonKey(name: 'refunded_at')@DateSerializer()  DateTime? refundedAt, @JsonKey(name: 'refund_amount')  int? refundAmount,  Registration? registration, @JsonKey(name: 'group')  RegistrationGroup? group,  Guide? guide)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Payment() when $default != null:
return $default(_that.id,_that.createdAt,_that.updatedAt,_that.stripePaymentIntentId,_that.stripeChargeId,_that.amount,_that.currency,_that.status,_that.paymentMethod,_that.registrationId,_that.groupId,_that.payerEmail,_that.payerName,_that.guideId,_that.paidAt,_that.refundedAt,_that.refundAmount,_that.registration,_that.group,_that.guide);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'created_at')@DateSerializer()  DateTime createdAt, @JsonKey(name: 'updated_at')@DateSerializer()  DateTime updatedAt, @JsonKey(name: 'stripe_payment_intent_id')  String stripePaymentIntentId, @JsonKey(name: 'stripe_charge_id')  String? stripeChargeId,  int amount,  String currency,  PaymentStatus status, @JsonKey(name: 'payment_method')  String paymentMethod, @JsonKey(name: 'registration_id')  int? registrationId, @JsonKey(name: 'group_id')  int? groupId, @JsonKey(name: 'payer_email')  String payerEmail, @JsonKey(name: 'payer_name')  String payerName, @JsonKey(name: 'guide_id')  int guideId, @JsonKey(name: 'paid_at')@DateSerializer()  DateTime? paidAt, @JsonKey(name: 'refunded_at')@DateSerializer()  DateTime? refundedAt, @JsonKey(name: 'refund_amount')  int? refundAmount,  Registration? registration, @JsonKey(name: 'group')  RegistrationGroup? group,  Guide? guide)  $default,) {final _that = this;
switch (_that) {
case _Payment():
return $default(_that.id,_that.createdAt,_that.updatedAt,_that.stripePaymentIntentId,_that.stripeChargeId,_that.amount,_that.currency,_that.status,_that.paymentMethod,_that.registrationId,_that.groupId,_that.payerEmail,_that.payerName,_that.guideId,_that.paidAt,_that.refundedAt,_that.refundAmount,_that.registration,_that.group,_that.guide);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'created_at')@DateSerializer()  DateTime createdAt, @JsonKey(name: 'updated_at')@DateSerializer()  DateTime updatedAt, @JsonKey(name: 'stripe_payment_intent_id')  String stripePaymentIntentId, @JsonKey(name: 'stripe_charge_id')  String? stripeChargeId,  int amount,  String currency,  PaymentStatus status, @JsonKey(name: 'payment_method')  String paymentMethod, @JsonKey(name: 'registration_id')  int? registrationId, @JsonKey(name: 'group_id')  int? groupId, @JsonKey(name: 'payer_email')  String payerEmail, @JsonKey(name: 'payer_name')  String payerName, @JsonKey(name: 'guide_id')  int guideId, @JsonKey(name: 'paid_at')@DateSerializer()  DateTime? paidAt, @JsonKey(name: 'refunded_at')@DateSerializer()  DateTime? refundedAt, @JsonKey(name: 'refund_amount')  int? refundAmount,  Registration? registration, @JsonKey(name: 'group')  RegistrationGroup? group,  Guide? guide)?  $default,) {final _that = this;
switch (_that) {
case _Payment() when $default != null:
return $default(_that.id,_that.createdAt,_that.updatedAt,_that.stripePaymentIntentId,_that.stripeChargeId,_that.amount,_that.currency,_that.status,_that.paymentMethod,_that.registrationId,_that.groupId,_that.payerEmail,_that.payerName,_that.guideId,_that.paidAt,_that.refundedAt,_that.refundAmount,_that.registration,_that.group,_that.guide);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Payment implements Payment {
  const _Payment(this.id, {@JsonKey(name: 'created_at')@DateSerializer() required this.createdAt, @JsonKey(name: 'updated_at')@DateSerializer() required this.updatedAt, @JsonKey(name: 'stripe_payment_intent_id') required this.stripePaymentIntentId, @JsonKey(name: 'stripe_charge_id') this.stripeChargeId, required this.amount, required this.currency, required this.status, @JsonKey(name: 'payment_method') required this.paymentMethod, @JsonKey(name: 'registration_id') this.registrationId, @JsonKey(name: 'group_id') this.groupId, @JsonKey(name: 'payer_email') required this.payerEmail, @JsonKey(name: 'payer_name') required this.payerName, @JsonKey(name: 'guide_id') required this.guideId, @JsonKey(name: 'paid_at')@DateSerializer() this.paidAt, @JsonKey(name: 'refunded_at')@DateSerializer() this.refundedAt, @JsonKey(name: 'refund_amount') this.refundAmount, this.registration, @JsonKey(name: 'group') this.group, this.guide});
  factory _Payment.fromJson(Map<String, dynamic> json) => _$PaymentFromJson(json);

@override final  int id;
@override@JsonKey(name: 'created_at')@DateSerializer() final  DateTime createdAt;
@override@JsonKey(name: 'updated_at')@DateSerializer() final  DateTime updatedAt;
@override@JsonKey(name: 'stripe_payment_intent_id') final  String stripePaymentIntentId;
@override@JsonKey(name: 'stripe_charge_id') final  String? stripeChargeId;
@override final  int amount;
// Amount in cents
@override final  String currency;
@override final  PaymentStatus status;
@override@JsonKey(name: 'payment_method') final  String paymentMethod;
@override@JsonKey(name: 'registration_id') final  int? registrationId;
@override@JsonKey(name: 'group_id') final  int? groupId;
@override@JsonKey(name: 'payer_email') final  String payerEmail;
@override@JsonKey(name: 'payer_name') final  String payerName;
@override@JsonKey(name: 'guide_id') final  int guideId;
@override@JsonKey(name: 'paid_at')@DateSerializer() final  DateTime? paidAt;
@override@JsonKey(name: 'refunded_at')@DateSerializer() final  DateTime? refundedAt;
@override@JsonKey(name: 'refund_amount') final  int? refundAmount;
@override final  Registration? registration;
@override@JsonKey(name: 'group') final  RegistrationGroup? group;
@override final  Guide? guide;

/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaymentCopyWith<_Payment> get copyWith => __$PaymentCopyWithImpl<_Payment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaymentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Payment&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.stripePaymentIntentId, stripePaymentIntentId) || other.stripePaymentIntentId == stripePaymentIntentId)&&(identical(other.stripeChargeId, stripeChargeId) || other.stripeChargeId == stripeChargeId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.status, status) || other.status == status)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.registrationId, registrationId) || other.registrationId == registrationId)&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.payerEmail, payerEmail) || other.payerEmail == payerEmail)&&(identical(other.payerName, payerName) || other.payerName == payerName)&&(identical(other.guideId, guideId) || other.guideId == guideId)&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt)&&(identical(other.refundedAt, refundedAt) || other.refundedAt == refundedAt)&&(identical(other.refundAmount, refundAmount) || other.refundAmount == refundAmount)&&(identical(other.registration, registration) || other.registration == registration)&&(identical(other.group, group) || other.group == group)&&(identical(other.guide, guide) || other.guide == guide));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,createdAt,updatedAt,stripePaymentIntentId,stripeChargeId,amount,currency,status,paymentMethod,registrationId,groupId,payerEmail,payerName,guideId,paidAt,refundedAt,refundAmount,registration,group,guide]);

@override
String toString() {
  return 'Payment(id: $id, createdAt: $createdAt, updatedAt: $updatedAt, stripePaymentIntentId: $stripePaymentIntentId, stripeChargeId: $stripeChargeId, amount: $amount, currency: $currency, status: $status, paymentMethod: $paymentMethod, registrationId: $registrationId, groupId: $groupId, payerEmail: $payerEmail, payerName: $payerName, guideId: $guideId, paidAt: $paidAt, refundedAt: $refundedAt, refundAmount: $refundAmount, registration: $registration, group: $group, guide: $guide)';
}


}

/// @nodoc
abstract mixin class _$PaymentCopyWith<$Res> implements $PaymentCopyWith<$Res> {
  factory _$PaymentCopyWith(_Payment value, $Res Function(_Payment) _then) = __$PaymentCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'created_at')@DateSerializer() DateTime createdAt,@JsonKey(name: 'updated_at')@DateSerializer() DateTime updatedAt,@JsonKey(name: 'stripe_payment_intent_id') String stripePaymentIntentId,@JsonKey(name: 'stripe_charge_id') String? stripeChargeId, int amount, String currency, PaymentStatus status,@JsonKey(name: 'payment_method') String paymentMethod,@JsonKey(name: 'registration_id') int? registrationId,@JsonKey(name: 'group_id') int? groupId,@JsonKey(name: 'payer_email') String payerEmail,@JsonKey(name: 'payer_name') String payerName,@JsonKey(name: 'guide_id') int guideId,@JsonKey(name: 'paid_at')@DateSerializer() DateTime? paidAt,@JsonKey(name: 'refunded_at')@DateSerializer() DateTime? refundedAt,@JsonKey(name: 'refund_amount') int? refundAmount, Registration? registration,@JsonKey(name: 'group') RegistrationGroup? group, Guide? guide
});


@override $RegistrationCopyWith<$Res>? get registration;@override $RegistrationGroupCopyWith<$Res>? get group;@override $GuideCopyWith<$Res>? get guide;

}
/// @nodoc
class __$PaymentCopyWithImpl<$Res>
    implements _$PaymentCopyWith<$Res> {
  __$PaymentCopyWithImpl(this._self, this._then);

  final _Payment _self;
  final $Res Function(_Payment) _then;

/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? createdAt = null,Object? updatedAt = null,Object? stripePaymentIntentId = null,Object? stripeChargeId = freezed,Object? amount = null,Object? currency = null,Object? status = null,Object? paymentMethod = null,Object? registrationId = freezed,Object? groupId = freezed,Object? payerEmail = null,Object? payerName = null,Object? guideId = null,Object? paidAt = freezed,Object? refundedAt = freezed,Object? refundAmount = freezed,Object? registration = freezed,Object? group = freezed,Object? guide = freezed,}) {
  return _then(_Payment(
null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,stripePaymentIntentId: null == stripePaymentIntentId ? _self.stripePaymentIntentId : stripePaymentIntentId // ignore: cast_nullable_to_non_nullable
as String,stripeChargeId: freezed == stripeChargeId ? _self.stripeChargeId : stripeChargeId // ignore: cast_nullable_to_non_nullable
as String?,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PaymentStatus,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String,registrationId: freezed == registrationId ? _self.registrationId : registrationId // ignore: cast_nullable_to_non_nullable
as int?,groupId: freezed == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as int?,payerEmail: null == payerEmail ? _self.payerEmail : payerEmail // ignore: cast_nullable_to_non_nullable
as String,payerName: null == payerName ? _self.payerName : payerName // ignore: cast_nullable_to_non_nullable
as String,guideId: null == guideId ? _self.guideId : guideId // ignore: cast_nullable_to_non_nullable
as int,paidAt: freezed == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as DateTime?,refundedAt: freezed == refundedAt ? _self.refundedAt : refundedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,refundAmount: freezed == refundAmount ? _self.refundAmount : refundAmount // ignore: cast_nullable_to_non_nullable
as int?,registration: freezed == registration ? _self.registration : registration // ignore: cast_nullable_to_non_nullable
as Registration?,group: freezed == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as RegistrationGroup?,guide: freezed == guide ? _self.guide : guide // ignore: cast_nullable_to_non_nullable
as Guide?,
  ));
}

/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RegistrationCopyWith<$Res>? get registration {
    if (_self.registration == null) {
    return null;
  }

  return $RegistrationCopyWith<$Res>(_self.registration!, (value) {
    return _then(_self.copyWith(registration: value));
  });
}/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RegistrationGroupCopyWith<$Res>? get group {
    if (_self.group == null) {
    return null;
  }

  return $RegistrationGroupCopyWith<$Res>(_self.group!, (value) {
    return _then(_self.copyWith(group: value));
  });
}/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GuideCopyWith<$Res>? get guide {
    if (_self.guide == null) {
    return null;
  }

  return $GuideCopyWith<$Res>(_self.guide!, (value) {
    return _then(_self.copyWith(guide: value));
  });
}
}


/// @nodoc
mixin _$RegistrationGroup {

 int get id;@JsonKey(name: 'created_at')@DateSerializer() DateTime get createdAt;@JsonKey(name: 'updated_at')@DateSerializer() DateTime get updatedAt;@JsonKey(name: 'primary_email') String get primaryEmail; String get status;@JsonKey(name: 'registration_date')@DateSerializer() DateTime get registrationDate;@JsonKey(name: 'confirmation_date')@DateSerializer() DateTime? get confirmationDate;@JsonKey(name: 'confirmation_deadline')@DateSerializer() DateTime? get confirmationDeadline;@JsonKey(name: 'cancellation_date')@DateSerializer() DateTime? get cancellationDate;@JsonKey(name: 'cancellation_reason') String? get cancellationReason;@JsonKey(name: 'ramble_id') int get rambleId; List<Registration> get registrations;@JsonKey(name: 'participant_count') int get participantCount;
/// Create a copy of RegistrationGroup
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RegistrationGroupCopyWith<RegistrationGroup> get copyWith => _$RegistrationGroupCopyWithImpl<RegistrationGroup>(this as RegistrationGroup, _$identity);

  /// Serializes this RegistrationGroup to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RegistrationGroup&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.primaryEmail, primaryEmail) || other.primaryEmail == primaryEmail)&&(identical(other.status, status) || other.status == status)&&(identical(other.registrationDate, registrationDate) || other.registrationDate == registrationDate)&&(identical(other.confirmationDate, confirmationDate) || other.confirmationDate == confirmationDate)&&(identical(other.confirmationDeadline, confirmationDeadline) || other.confirmationDeadline == confirmationDeadline)&&(identical(other.cancellationDate, cancellationDate) || other.cancellationDate == cancellationDate)&&(identical(other.cancellationReason, cancellationReason) || other.cancellationReason == cancellationReason)&&(identical(other.rambleId, rambleId) || other.rambleId == rambleId)&&const DeepCollectionEquality().equals(other.registrations, registrations)&&(identical(other.participantCount, participantCount) || other.participantCount == participantCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,createdAt,updatedAt,primaryEmail,status,registrationDate,confirmationDate,confirmationDeadline,cancellationDate,cancellationReason,rambleId,const DeepCollectionEquality().hash(registrations),participantCount);

@override
String toString() {
  return 'RegistrationGroup(id: $id, createdAt: $createdAt, updatedAt: $updatedAt, primaryEmail: $primaryEmail, status: $status, registrationDate: $registrationDate, confirmationDate: $confirmationDate, confirmationDeadline: $confirmationDeadline, cancellationDate: $cancellationDate, cancellationReason: $cancellationReason, rambleId: $rambleId, registrations: $registrations, participantCount: $participantCount)';
}


}

/// @nodoc
abstract mixin class $RegistrationGroupCopyWith<$Res>  {
  factory $RegistrationGroupCopyWith(RegistrationGroup value, $Res Function(RegistrationGroup) _then) = _$RegistrationGroupCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'created_at')@DateSerializer() DateTime createdAt,@JsonKey(name: 'updated_at')@DateSerializer() DateTime updatedAt,@JsonKey(name: 'primary_email') String primaryEmail, String status,@JsonKey(name: 'registration_date')@DateSerializer() DateTime registrationDate,@JsonKey(name: 'confirmation_date')@DateSerializer() DateTime? confirmationDate,@JsonKey(name: 'confirmation_deadline')@DateSerializer() DateTime? confirmationDeadline,@JsonKey(name: 'cancellation_date')@DateSerializer() DateTime? cancellationDate,@JsonKey(name: 'cancellation_reason') String? cancellationReason,@JsonKey(name: 'ramble_id') int rambleId, List<Registration> registrations,@JsonKey(name: 'participant_count') int participantCount
});




}
/// @nodoc
class _$RegistrationGroupCopyWithImpl<$Res>
    implements $RegistrationGroupCopyWith<$Res> {
  _$RegistrationGroupCopyWithImpl(this._self, this._then);

  final RegistrationGroup _self;
  final $Res Function(RegistrationGroup) _then;

/// Create a copy of RegistrationGroup
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? createdAt = null,Object? updatedAt = null,Object? primaryEmail = null,Object? status = null,Object? registrationDate = null,Object? confirmationDate = freezed,Object? confirmationDeadline = freezed,Object? cancellationDate = freezed,Object? cancellationReason = freezed,Object? rambleId = null,Object? registrations = null,Object? participantCount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,primaryEmail: null == primaryEmail ? _self.primaryEmail : primaryEmail // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,registrationDate: null == registrationDate ? _self.registrationDate : registrationDate // ignore: cast_nullable_to_non_nullable
as DateTime,confirmationDate: freezed == confirmationDate ? _self.confirmationDate : confirmationDate // ignore: cast_nullable_to_non_nullable
as DateTime?,confirmationDeadline: freezed == confirmationDeadline ? _self.confirmationDeadline : confirmationDeadline // ignore: cast_nullable_to_non_nullable
as DateTime?,cancellationDate: freezed == cancellationDate ? _self.cancellationDate : cancellationDate // ignore: cast_nullable_to_non_nullable
as DateTime?,cancellationReason: freezed == cancellationReason ? _self.cancellationReason : cancellationReason // ignore: cast_nullable_to_non_nullable
as String?,rambleId: null == rambleId ? _self.rambleId : rambleId // ignore: cast_nullable_to_non_nullable
as int,registrations: null == registrations ? _self.registrations : registrations // ignore: cast_nullable_to_non_nullable
as List<Registration>,participantCount: null == participantCount ? _self.participantCount : participantCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [RegistrationGroup].
extension RegistrationGroupPatterns on RegistrationGroup {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RegistrationGroup value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RegistrationGroup() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RegistrationGroup value)  $default,){
final _that = this;
switch (_that) {
case _RegistrationGroup():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RegistrationGroup value)?  $default,){
final _that = this;
switch (_that) {
case _RegistrationGroup() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'created_at')@DateSerializer()  DateTime createdAt, @JsonKey(name: 'updated_at')@DateSerializer()  DateTime updatedAt, @JsonKey(name: 'primary_email')  String primaryEmail,  String status, @JsonKey(name: 'registration_date')@DateSerializer()  DateTime registrationDate, @JsonKey(name: 'confirmation_date')@DateSerializer()  DateTime? confirmationDate, @JsonKey(name: 'confirmation_deadline')@DateSerializer()  DateTime? confirmationDeadline, @JsonKey(name: 'cancellation_date')@DateSerializer()  DateTime? cancellationDate, @JsonKey(name: 'cancellation_reason')  String? cancellationReason, @JsonKey(name: 'ramble_id')  int rambleId,  List<Registration> registrations, @JsonKey(name: 'participant_count')  int participantCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RegistrationGroup() when $default != null:
return $default(_that.id,_that.createdAt,_that.updatedAt,_that.primaryEmail,_that.status,_that.registrationDate,_that.confirmationDate,_that.confirmationDeadline,_that.cancellationDate,_that.cancellationReason,_that.rambleId,_that.registrations,_that.participantCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'created_at')@DateSerializer()  DateTime createdAt, @JsonKey(name: 'updated_at')@DateSerializer()  DateTime updatedAt, @JsonKey(name: 'primary_email')  String primaryEmail,  String status, @JsonKey(name: 'registration_date')@DateSerializer()  DateTime registrationDate, @JsonKey(name: 'confirmation_date')@DateSerializer()  DateTime? confirmationDate, @JsonKey(name: 'confirmation_deadline')@DateSerializer()  DateTime? confirmationDeadline, @JsonKey(name: 'cancellation_date')@DateSerializer()  DateTime? cancellationDate, @JsonKey(name: 'cancellation_reason')  String? cancellationReason, @JsonKey(name: 'ramble_id')  int rambleId,  List<Registration> registrations, @JsonKey(name: 'participant_count')  int participantCount)  $default,) {final _that = this;
switch (_that) {
case _RegistrationGroup():
return $default(_that.id,_that.createdAt,_that.updatedAt,_that.primaryEmail,_that.status,_that.registrationDate,_that.confirmationDate,_that.confirmationDeadline,_that.cancellationDate,_that.cancellationReason,_that.rambleId,_that.registrations,_that.participantCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'created_at')@DateSerializer()  DateTime createdAt, @JsonKey(name: 'updated_at')@DateSerializer()  DateTime updatedAt, @JsonKey(name: 'primary_email')  String primaryEmail,  String status, @JsonKey(name: 'registration_date')@DateSerializer()  DateTime registrationDate, @JsonKey(name: 'confirmation_date')@DateSerializer()  DateTime? confirmationDate, @JsonKey(name: 'confirmation_deadline')@DateSerializer()  DateTime? confirmationDeadline, @JsonKey(name: 'cancellation_date')@DateSerializer()  DateTime? cancellationDate, @JsonKey(name: 'cancellation_reason')  String? cancellationReason, @JsonKey(name: 'ramble_id')  int rambleId,  List<Registration> registrations, @JsonKey(name: 'participant_count')  int participantCount)?  $default,) {final _that = this;
switch (_that) {
case _RegistrationGroup() when $default != null:
return $default(_that.id,_that.createdAt,_that.updatedAt,_that.primaryEmail,_that.status,_that.registrationDate,_that.confirmationDate,_that.confirmationDeadline,_that.cancellationDate,_that.cancellationReason,_that.rambleId,_that.registrations,_that.participantCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RegistrationGroup implements RegistrationGroup {
  const _RegistrationGroup(this.id, {@JsonKey(name: 'created_at')@DateSerializer() required this.createdAt, @JsonKey(name: 'updated_at')@DateSerializer() required this.updatedAt, @JsonKey(name: 'primary_email') required this.primaryEmail, required this.status, @JsonKey(name: 'registration_date')@DateSerializer() required this.registrationDate, @JsonKey(name: 'confirmation_date')@DateSerializer() this.confirmationDate, @JsonKey(name: 'confirmation_deadline')@DateSerializer() this.confirmationDeadline, @JsonKey(name: 'cancellation_date')@DateSerializer() this.cancellationDate, @JsonKey(name: 'cancellation_reason') this.cancellationReason, @JsonKey(name: 'ramble_id') required this.rambleId, final  List<Registration> registrations = const <Registration>[], @JsonKey(name: 'participant_count') required this.participantCount}): _registrations = registrations;
  factory _RegistrationGroup.fromJson(Map<String, dynamic> json) => _$RegistrationGroupFromJson(json);

@override final  int id;
@override@JsonKey(name: 'created_at')@DateSerializer() final  DateTime createdAt;
@override@JsonKey(name: 'updated_at')@DateSerializer() final  DateTime updatedAt;
@override@JsonKey(name: 'primary_email') final  String primaryEmail;
@override final  String status;
@override@JsonKey(name: 'registration_date')@DateSerializer() final  DateTime registrationDate;
@override@JsonKey(name: 'confirmation_date')@DateSerializer() final  DateTime? confirmationDate;
@override@JsonKey(name: 'confirmation_deadline')@DateSerializer() final  DateTime? confirmationDeadline;
@override@JsonKey(name: 'cancellation_date')@DateSerializer() final  DateTime? cancellationDate;
@override@JsonKey(name: 'cancellation_reason') final  String? cancellationReason;
@override@JsonKey(name: 'ramble_id') final  int rambleId;
 final  List<Registration> _registrations;
@override@JsonKey() List<Registration> get registrations {
  if (_registrations is EqualUnmodifiableListView) return _registrations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_registrations);
}

@override@JsonKey(name: 'participant_count') final  int participantCount;

/// Create a copy of RegistrationGroup
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RegistrationGroupCopyWith<_RegistrationGroup> get copyWith => __$RegistrationGroupCopyWithImpl<_RegistrationGroup>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RegistrationGroupToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RegistrationGroup&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.primaryEmail, primaryEmail) || other.primaryEmail == primaryEmail)&&(identical(other.status, status) || other.status == status)&&(identical(other.registrationDate, registrationDate) || other.registrationDate == registrationDate)&&(identical(other.confirmationDate, confirmationDate) || other.confirmationDate == confirmationDate)&&(identical(other.confirmationDeadline, confirmationDeadline) || other.confirmationDeadline == confirmationDeadline)&&(identical(other.cancellationDate, cancellationDate) || other.cancellationDate == cancellationDate)&&(identical(other.cancellationReason, cancellationReason) || other.cancellationReason == cancellationReason)&&(identical(other.rambleId, rambleId) || other.rambleId == rambleId)&&const DeepCollectionEquality().equals(other._registrations, _registrations)&&(identical(other.participantCount, participantCount) || other.participantCount == participantCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,createdAt,updatedAt,primaryEmail,status,registrationDate,confirmationDate,confirmationDeadline,cancellationDate,cancellationReason,rambleId,const DeepCollectionEquality().hash(_registrations),participantCount);

@override
String toString() {
  return 'RegistrationGroup(id: $id, createdAt: $createdAt, updatedAt: $updatedAt, primaryEmail: $primaryEmail, status: $status, registrationDate: $registrationDate, confirmationDate: $confirmationDate, confirmationDeadline: $confirmationDeadline, cancellationDate: $cancellationDate, cancellationReason: $cancellationReason, rambleId: $rambleId, registrations: $registrations, participantCount: $participantCount)';
}


}

/// @nodoc
abstract mixin class _$RegistrationGroupCopyWith<$Res> implements $RegistrationGroupCopyWith<$Res> {
  factory _$RegistrationGroupCopyWith(_RegistrationGroup value, $Res Function(_RegistrationGroup) _then) = __$RegistrationGroupCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'created_at')@DateSerializer() DateTime createdAt,@JsonKey(name: 'updated_at')@DateSerializer() DateTime updatedAt,@JsonKey(name: 'primary_email') String primaryEmail, String status,@JsonKey(name: 'registration_date')@DateSerializer() DateTime registrationDate,@JsonKey(name: 'confirmation_date')@DateSerializer() DateTime? confirmationDate,@JsonKey(name: 'confirmation_deadline')@DateSerializer() DateTime? confirmationDeadline,@JsonKey(name: 'cancellation_date')@DateSerializer() DateTime? cancellationDate,@JsonKey(name: 'cancellation_reason') String? cancellationReason,@JsonKey(name: 'ramble_id') int rambleId, List<Registration> registrations,@JsonKey(name: 'participant_count') int participantCount
});




}
/// @nodoc
class __$RegistrationGroupCopyWithImpl<$Res>
    implements _$RegistrationGroupCopyWith<$Res> {
  __$RegistrationGroupCopyWithImpl(this._self, this._then);

  final _RegistrationGroup _self;
  final $Res Function(_RegistrationGroup) _then;

/// Create a copy of RegistrationGroup
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? createdAt = null,Object? updatedAt = null,Object? primaryEmail = null,Object? status = null,Object? registrationDate = null,Object? confirmationDate = freezed,Object? confirmationDeadline = freezed,Object? cancellationDate = freezed,Object? cancellationReason = freezed,Object? rambleId = null,Object? registrations = null,Object? participantCount = null,}) {
  return _then(_RegistrationGroup(
null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,primaryEmail: null == primaryEmail ? _self.primaryEmail : primaryEmail // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,registrationDate: null == registrationDate ? _self.registrationDate : registrationDate // ignore: cast_nullable_to_non_nullable
as DateTime,confirmationDate: freezed == confirmationDate ? _self.confirmationDate : confirmationDate // ignore: cast_nullable_to_non_nullable
as DateTime?,confirmationDeadline: freezed == confirmationDeadline ? _self.confirmationDeadline : confirmationDeadline // ignore: cast_nullable_to_non_nullable
as DateTime?,cancellationDate: freezed == cancellationDate ? _self.cancellationDate : cancellationDate // ignore: cast_nullable_to_non_nullable
as DateTime?,cancellationReason: freezed == cancellationReason ? _self.cancellationReason : cancellationReason // ignore: cast_nullable_to_non_nullable
as String?,rambleId: null == rambleId ? _self.rambleId : rambleId // ignore: cast_nullable_to_non_nullable
as int,registrations: null == registrations ? _self._registrations : registrations // ignore: cast_nullable_to_non_nullable
as List<Registration>,participantCount: null == participantCount ? _self.participantCount : participantCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$PaymentCreationRequest {

@JsonKey(name: 'registration_id') int? get registrationId;@JsonKey(name: 'group_id') int? get groupId;@JsonKey(name: 'price_label') String? get priceLabel;// Deprecated: for backward compatibility
@JsonKey(name: 'price_selections') List<PriceSelection>? get priceSelections;// For group payments with multiple prices
@JsonKey(name: 'payer_email') String get payerEmail;@JsonKey(name: 'payer_name') String get payerName;@JsonKey(name: 'return_url') String get returnUrl;
/// Create a copy of PaymentCreationRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentCreationRequestCopyWith<PaymentCreationRequest> get copyWith => _$PaymentCreationRequestCopyWithImpl<PaymentCreationRequest>(this as PaymentCreationRequest, _$identity);

  /// Serializes this PaymentCreationRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaymentCreationRequest&&(identical(other.registrationId, registrationId) || other.registrationId == registrationId)&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.priceLabel, priceLabel) || other.priceLabel == priceLabel)&&const DeepCollectionEquality().equals(other.priceSelections, priceSelections)&&(identical(other.payerEmail, payerEmail) || other.payerEmail == payerEmail)&&(identical(other.payerName, payerName) || other.payerName == payerName)&&(identical(other.returnUrl, returnUrl) || other.returnUrl == returnUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,registrationId,groupId,priceLabel,const DeepCollectionEquality().hash(priceSelections),payerEmail,payerName,returnUrl);

@override
String toString() {
  return 'PaymentCreationRequest(registrationId: $registrationId, groupId: $groupId, priceLabel: $priceLabel, priceSelections: $priceSelections, payerEmail: $payerEmail, payerName: $payerName, returnUrl: $returnUrl)';
}


}

/// @nodoc
abstract mixin class $PaymentCreationRequestCopyWith<$Res>  {
  factory $PaymentCreationRequestCopyWith(PaymentCreationRequest value, $Res Function(PaymentCreationRequest) _then) = _$PaymentCreationRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'registration_id') int? registrationId,@JsonKey(name: 'group_id') int? groupId,@JsonKey(name: 'price_label') String? priceLabel,@JsonKey(name: 'price_selections') List<PriceSelection>? priceSelections,@JsonKey(name: 'payer_email') String payerEmail,@JsonKey(name: 'payer_name') String payerName,@JsonKey(name: 'return_url') String returnUrl
});




}
/// @nodoc
class _$PaymentCreationRequestCopyWithImpl<$Res>
    implements $PaymentCreationRequestCopyWith<$Res> {
  _$PaymentCreationRequestCopyWithImpl(this._self, this._then);

  final PaymentCreationRequest _self;
  final $Res Function(PaymentCreationRequest) _then;

/// Create a copy of PaymentCreationRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? registrationId = freezed,Object? groupId = freezed,Object? priceLabel = freezed,Object? priceSelections = freezed,Object? payerEmail = null,Object? payerName = null,Object? returnUrl = null,}) {
  return _then(_self.copyWith(
registrationId: freezed == registrationId ? _self.registrationId : registrationId // ignore: cast_nullable_to_non_nullable
as int?,groupId: freezed == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as int?,priceLabel: freezed == priceLabel ? _self.priceLabel : priceLabel // ignore: cast_nullable_to_non_nullable
as String?,priceSelections: freezed == priceSelections ? _self.priceSelections : priceSelections // ignore: cast_nullable_to_non_nullable
as List<PriceSelection>?,payerEmail: null == payerEmail ? _self.payerEmail : payerEmail // ignore: cast_nullable_to_non_nullable
as String,payerName: null == payerName ? _self.payerName : payerName // ignore: cast_nullable_to_non_nullable
as String,returnUrl: null == returnUrl ? _self.returnUrl : returnUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PaymentCreationRequest].
extension PaymentCreationRequestPatterns on PaymentCreationRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaymentCreationRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaymentCreationRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaymentCreationRequest value)  $default,){
final _that = this;
switch (_that) {
case _PaymentCreationRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaymentCreationRequest value)?  $default,){
final _that = this;
switch (_that) {
case _PaymentCreationRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'registration_id')  int? registrationId, @JsonKey(name: 'group_id')  int? groupId, @JsonKey(name: 'price_label')  String? priceLabel, @JsonKey(name: 'price_selections')  List<PriceSelection>? priceSelections, @JsonKey(name: 'payer_email')  String payerEmail, @JsonKey(name: 'payer_name')  String payerName, @JsonKey(name: 'return_url')  String returnUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaymentCreationRequest() when $default != null:
return $default(_that.registrationId,_that.groupId,_that.priceLabel,_that.priceSelections,_that.payerEmail,_that.payerName,_that.returnUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'registration_id')  int? registrationId, @JsonKey(name: 'group_id')  int? groupId, @JsonKey(name: 'price_label')  String? priceLabel, @JsonKey(name: 'price_selections')  List<PriceSelection>? priceSelections, @JsonKey(name: 'payer_email')  String payerEmail, @JsonKey(name: 'payer_name')  String payerName, @JsonKey(name: 'return_url')  String returnUrl)  $default,) {final _that = this;
switch (_that) {
case _PaymentCreationRequest():
return $default(_that.registrationId,_that.groupId,_that.priceLabel,_that.priceSelections,_that.payerEmail,_that.payerName,_that.returnUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'registration_id')  int? registrationId, @JsonKey(name: 'group_id')  int? groupId, @JsonKey(name: 'price_label')  String? priceLabel, @JsonKey(name: 'price_selections')  List<PriceSelection>? priceSelections, @JsonKey(name: 'payer_email')  String payerEmail, @JsonKey(name: 'payer_name')  String payerName, @JsonKey(name: 'return_url')  String returnUrl)?  $default,) {final _that = this;
switch (_that) {
case _PaymentCreationRequest() when $default != null:
return $default(_that.registrationId,_that.groupId,_that.priceLabel,_that.priceSelections,_that.payerEmail,_that.payerName,_that.returnUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PaymentCreationRequest implements PaymentCreationRequest {
  const _PaymentCreationRequest({@JsonKey(name: 'registration_id') this.registrationId, @JsonKey(name: 'group_id') this.groupId, @JsonKey(name: 'price_label') this.priceLabel, @JsonKey(name: 'price_selections') final  List<PriceSelection>? priceSelections, @JsonKey(name: 'payer_email') required this.payerEmail, @JsonKey(name: 'payer_name') required this.payerName, @JsonKey(name: 'return_url') required this.returnUrl}): _priceSelections = priceSelections;
  factory _PaymentCreationRequest.fromJson(Map<String, dynamic> json) => _$PaymentCreationRequestFromJson(json);

@override@JsonKey(name: 'registration_id') final  int? registrationId;
@override@JsonKey(name: 'group_id') final  int? groupId;
@override@JsonKey(name: 'price_label') final  String? priceLabel;
// Deprecated: for backward compatibility
 final  List<PriceSelection>? _priceSelections;
// Deprecated: for backward compatibility
@override@JsonKey(name: 'price_selections') List<PriceSelection>? get priceSelections {
  final value = _priceSelections;
  if (value == null) return null;
  if (_priceSelections is EqualUnmodifiableListView) return _priceSelections;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

// For group payments with multiple prices
@override@JsonKey(name: 'payer_email') final  String payerEmail;
@override@JsonKey(name: 'payer_name') final  String payerName;
@override@JsonKey(name: 'return_url') final  String returnUrl;

/// Create a copy of PaymentCreationRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaymentCreationRequestCopyWith<_PaymentCreationRequest> get copyWith => __$PaymentCreationRequestCopyWithImpl<_PaymentCreationRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaymentCreationRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaymentCreationRequest&&(identical(other.registrationId, registrationId) || other.registrationId == registrationId)&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.priceLabel, priceLabel) || other.priceLabel == priceLabel)&&const DeepCollectionEquality().equals(other._priceSelections, _priceSelections)&&(identical(other.payerEmail, payerEmail) || other.payerEmail == payerEmail)&&(identical(other.payerName, payerName) || other.payerName == payerName)&&(identical(other.returnUrl, returnUrl) || other.returnUrl == returnUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,registrationId,groupId,priceLabel,const DeepCollectionEquality().hash(_priceSelections),payerEmail,payerName,returnUrl);

@override
String toString() {
  return 'PaymentCreationRequest(registrationId: $registrationId, groupId: $groupId, priceLabel: $priceLabel, priceSelections: $priceSelections, payerEmail: $payerEmail, payerName: $payerName, returnUrl: $returnUrl)';
}


}

/// @nodoc
abstract mixin class _$PaymentCreationRequestCopyWith<$Res> implements $PaymentCreationRequestCopyWith<$Res> {
  factory _$PaymentCreationRequestCopyWith(_PaymentCreationRequest value, $Res Function(_PaymentCreationRequest) _then) = __$PaymentCreationRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'registration_id') int? registrationId,@JsonKey(name: 'group_id') int? groupId,@JsonKey(name: 'price_label') String? priceLabel,@JsonKey(name: 'price_selections') List<PriceSelection>? priceSelections,@JsonKey(name: 'payer_email') String payerEmail,@JsonKey(name: 'payer_name') String payerName,@JsonKey(name: 'return_url') String returnUrl
});




}
/// @nodoc
class __$PaymentCreationRequestCopyWithImpl<$Res>
    implements _$PaymentCreationRequestCopyWith<$Res> {
  __$PaymentCreationRequestCopyWithImpl(this._self, this._then);

  final _PaymentCreationRequest _self;
  final $Res Function(_PaymentCreationRequest) _then;

/// Create a copy of PaymentCreationRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? registrationId = freezed,Object? groupId = freezed,Object? priceLabel = freezed,Object? priceSelections = freezed,Object? payerEmail = null,Object? payerName = null,Object? returnUrl = null,}) {
  return _then(_PaymentCreationRequest(
registrationId: freezed == registrationId ? _self.registrationId : registrationId // ignore: cast_nullable_to_non_nullable
as int?,groupId: freezed == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as int?,priceLabel: freezed == priceLabel ? _self.priceLabel : priceLabel // ignore: cast_nullable_to_non_nullable
as String?,priceSelections: freezed == priceSelections ? _self._priceSelections : priceSelections // ignore: cast_nullable_to_non_nullable
as List<PriceSelection>?,payerEmail: null == payerEmail ? _self.payerEmail : payerEmail // ignore: cast_nullable_to_non_nullable
as String,payerName: null == payerName ? _self.payerName : payerName // ignore: cast_nullable_to_non_nullable
as String,returnUrl: null == returnUrl ? _self.returnUrl : returnUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$PriceSelection {

@JsonKey(name: 'price_label') String get priceLabel; int get quantity;
/// Create a copy of PriceSelection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PriceSelectionCopyWith<PriceSelection> get copyWith => _$PriceSelectionCopyWithImpl<PriceSelection>(this as PriceSelection, _$identity);

  /// Serializes this PriceSelection to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PriceSelection&&(identical(other.priceLabel, priceLabel) || other.priceLabel == priceLabel)&&(identical(other.quantity, quantity) || other.quantity == quantity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,priceLabel,quantity);

@override
String toString() {
  return 'PriceSelection(priceLabel: $priceLabel, quantity: $quantity)';
}


}

/// @nodoc
abstract mixin class $PriceSelectionCopyWith<$Res>  {
  factory $PriceSelectionCopyWith(PriceSelection value, $Res Function(PriceSelection) _then) = _$PriceSelectionCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'price_label') String priceLabel, int quantity
});




}
/// @nodoc
class _$PriceSelectionCopyWithImpl<$Res>
    implements $PriceSelectionCopyWith<$Res> {
  _$PriceSelectionCopyWithImpl(this._self, this._then);

  final PriceSelection _self;
  final $Res Function(PriceSelection) _then;

/// Create a copy of PriceSelection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? priceLabel = null,Object? quantity = null,}) {
  return _then(_self.copyWith(
priceLabel: null == priceLabel ? _self.priceLabel : priceLabel // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PriceSelection].
extension PriceSelectionPatterns on PriceSelection {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PriceSelection value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PriceSelection() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PriceSelection value)  $default,){
final _that = this;
switch (_that) {
case _PriceSelection():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PriceSelection value)?  $default,){
final _that = this;
switch (_that) {
case _PriceSelection() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'price_label')  String priceLabel,  int quantity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PriceSelection() when $default != null:
return $default(_that.priceLabel,_that.quantity);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'price_label')  String priceLabel,  int quantity)  $default,) {final _that = this;
switch (_that) {
case _PriceSelection():
return $default(_that.priceLabel,_that.quantity);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'price_label')  String priceLabel,  int quantity)?  $default,) {final _that = this;
switch (_that) {
case _PriceSelection() when $default != null:
return $default(_that.priceLabel,_that.quantity);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PriceSelection implements PriceSelection {
  const _PriceSelection({@JsonKey(name: 'price_label') required this.priceLabel, required this.quantity});
  factory _PriceSelection.fromJson(Map<String, dynamic> json) => _$PriceSelectionFromJson(json);

@override@JsonKey(name: 'price_label') final  String priceLabel;
@override final  int quantity;

/// Create a copy of PriceSelection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PriceSelectionCopyWith<_PriceSelection> get copyWith => __$PriceSelectionCopyWithImpl<_PriceSelection>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PriceSelectionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PriceSelection&&(identical(other.priceLabel, priceLabel) || other.priceLabel == priceLabel)&&(identical(other.quantity, quantity) || other.quantity == quantity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,priceLabel,quantity);

@override
String toString() {
  return 'PriceSelection(priceLabel: $priceLabel, quantity: $quantity)';
}


}

/// @nodoc
abstract mixin class _$PriceSelectionCopyWith<$Res> implements $PriceSelectionCopyWith<$Res> {
  factory _$PriceSelectionCopyWith(_PriceSelection value, $Res Function(_PriceSelection) _then) = __$PriceSelectionCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'price_label') String priceLabel, int quantity
});




}
/// @nodoc
class __$PriceSelectionCopyWithImpl<$Res>
    implements _$PriceSelectionCopyWith<$Res> {
  __$PriceSelectionCopyWithImpl(this._self, this._then);

  final _PriceSelection _self;
  final $Res Function(_PriceSelection) _then;

/// Create a copy of PriceSelection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? priceLabel = null,Object? quantity = null,}) {
  return _then(_PriceSelection(
priceLabel: null == priceLabel ? _self.priceLabel : priceLabel // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$PaymentCreationResponse {

 Payment get payment;@JsonKey(name: 'client_secret') String get clientSecret;@JsonKey(name: 'publishable_key') String get publishableKey;
/// Create a copy of PaymentCreationResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentCreationResponseCopyWith<PaymentCreationResponse> get copyWith => _$PaymentCreationResponseCopyWithImpl<PaymentCreationResponse>(this as PaymentCreationResponse, _$identity);

  /// Serializes this PaymentCreationResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaymentCreationResponse&&(identical(other.payment, payment) || other.payment == payment)&&(identical(other.clientSecret, clientSecret) || other.clientSecret == clientSecret)&&(identical(other.publishableKey, publishableKey) || other.publishableKey == publishableKey));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,payment,clientSecret,publishableKey);

@override
String toString() {
  return 'PaymentCreationResponse(payment: $payment, clientSecret: $clientSecret, publishableKey: $publishableKey)';
}


}

/// @nodoc
abstract mixin class $PaymentCreationResponseCopyWith<$Res>  {
  factory $PaymentCreationResponseCopyWith(PaymentCreationResponse value, $Res Function(PaymentCreationResponse) _then) = _$PaymentCreationResponseCopyWithImpl;
@useResult
$Res call({
 Payment payment,@JsonKey(name: 'client_secret') String clientSecret,@JsonKey(name: 'publishable_key') String publishableKey
});


$PaymentCopyWith<$Res> get payment;

}
/// @nodoc
class _$PaymentCreationResponseCopyWithImpl<$Res>
    implements $PaymentCreationResponseCopyWith<$Res> {
  _$PaymentCreationResponseCopyWithImpl(this._self, this._then);

  final PaymentCreationResponse _self;
  final $Res Function(PaymentCreationResponse) _then;

/// Create a copy of PaymentCreationResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? payment = null,Object? clientSecret = null,Object? publishableKey = null,}) {
  return _then(_self.copyWith(
payment: null == payment ? _self.payment : payment // ignore: cast_nullable_to_non_nullable
as Payment,clientSecret: null == clientSecret ? _self.clientSecret : clientSecret // ignore: cast_nullable_to_non_nullable
as String,publishableKey: null == publishableKey ? _self.publishableKey : publishableKey // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of PaymentCreationResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PaymentCopyWith<$Res> get payment {
  
  return $PaymentCopyWith<$Res>(_self.payment, (value) {
    return _then(_self.copyWith(payment: value));
  });
}
}


/// Adds pattern-matching-related methods to [PaymentCreationResponse].
extension PaymentCreationResponsePatterns on PaymentCreationResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaymentCreationResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaymentCreationResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaymentCreationResponse value)  $default,){
final _that = this;
switch (_that) {
case _PaymentCreationResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaymentCreationResponse value)?  $default,){
final _that = this;
switch (_that) {
case _PaymentCreationResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Payment payment, @JsonKey(name: 'client_secret')  String clientSecret, @JsonKey(name: 'publishable_key')  String publishableKey)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaymentCreationResponse() when $default != null:
return $default(_that.payment,_that.clientSecret,_that.publishableKey);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Payment payment, @JsonKey(name: 'client_secret')  String clientSecret, @JsonKey(name: 'publishable_key')  String publishableKey)  $default,) {final _that = this;
switch (_that) {
case _PaymentCreationResponse():
return $default(_that.payment,_that.clientSecret,_that.publishableKey);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Payment payment, @JsonKey(name: 'client_secret')  String clientSecret, @JsonKey(name: 'publishable_key')  String publishableKey)?  $default,) {final _that = this;
switch (_that) {
case _PaymentCreationResponse() when $default != null:
return $default(_that.payment,_that.clientSecret,_that.publishableKey);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PaymentCreationResponse implements PaymentCreationResponse {
  const _PaymentCreationResponse({required this.payment, @JsonKey(name: 'client_secret') required this.clientSecret, @JsonKey(name: 'publishable_key') required this.publishableKey});
  factory _PaymentCreationResponse.fromJson(Map<String, dynamic> json) => _$PaymentCreationResponseFromJson(json);

@override final  Payment payment;
@override@JsonKey(name: 'client_secret') final  String clientSecret;
@override@JsonKey(name: 'publishable_key') final  String publishableKey;

/// Create a copy of PaymentCreationResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaymentCreationResponseCopyWith<_PaymentCreationResponse> get copyWith => __$PaymentCreationResponseCopyWithImpl<_PaymentCreationResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaymentCreationResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaymentCreationResponse&&(identical(other.payment, payment) || other.payment == payment)&&(identical(other.clientSecret, clientSecret) || other.clientSecret == clientSecret)&&(identical(other.publishableKey, publishableKey) || other.publishableKey == publishableKey));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,payment,clientSecret,publishableKey);

@override
String toString() {
  return 'PaymentCreationResponse(payment: $payment, clientSecret: $clientSecret, publishableKey: $publishableKey)';
}


}

/// @nodoc
abstract mixin class _$PaymentCreationResponseCopyWith<$Res> implements $PaymentCreationResponseCopyWith<$Res> {
  factory _$PaymentCreationResponseCopyWith(_PaymentCreationResponse value, $Res Function(_PaymentCreationResponse) _then) = __$PaymentCreationResponseCopyWithImpl;
@override @useResult
$Res call({
 Payment payment,@JsonKey(name: 'client_secret') String clientSecret,@JsonKey(name: 'publishable_key') String publishableKey
});


@override $PaymentCopyWith<$Res> get payment;

}
/// @nodoc
class __$PaymentCreationResponseCopyWithImpl<$Res>
    implements _$PaymentCreationResponseCopyWith<$Res> {
  __$PaymentCreationResponseCopyWithImpl(this._self, this._then);

  final _PaymentCreationResponse _self;
  final $Res Function(_PaymentCreationResponse) _then;

/// Create a copy of PaymentCreationResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? payment = null,Object? clientSecret = null,Object? publishableKey = null,}) {
  return _then(_PaymentCreationResponse(
payment: null == payment ? _self.payment : payment // ignore: cast_nullable_to_non_nullable
as Payment,clientSecret: null == clientSecret ? _self.clientSecret : clientSecret // ignore: cast_nullable_to_non_nullable
as String,publishableKey: null == publishableKey ? _self.publishableKey : publishableKey // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of PaymentCreationResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PaymentCopyWith<$Res> get payment {
  
  return $PaymentCopyWith<$Res>(_self.payment, (value) {
    return _then(_self.copyWith(payment: value));
  });
}
}


/// @nodoc
mixin _$RefundRequest {

 int? get amount;// Amount in cents, null for full refund
 String? get reason;
/// Create a copy of RefundRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RefundRequestCopyWith<RefundRequest> get copyWith => _$RefundRequestCopyWithImpl<RefundRequest>(this as RefundRequest, _$identity);

  /// Serializes this RefundRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RefundRequest&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,amount,reason);

@override
String toString() {
  return 'RefundRequest(amount: $amount, reason: $reason)';
}


}

/// @nodoc
abstract mixin class $RefundRequestCopyWith<$Res>  {
  factory $RefundRequestCopyWith(RefundRequest value, $Res Function(RefundRequest) _then) = _$RefundRequestCopyWithImpl;
@useResult
$Res call({
 int? amount, String? reason
});




}
/// @nodoc
class _$RefundRequestCopyWithImpl<$Res>
    implements $RefundRequestCopyWith<$Res> {
  _$RefundRequestCopyWithImpl(this._self, this._then);

  final RefundRequest _self;
  final $Res Function(RefundRequest) _then;

/// Create a copy of RefundRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? amount = freezed,Object? reason = freezed,}) {
  return _then(_self.copyWith(
amount: freezed == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int?,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [RefundRequest].
extension RefundRequestPatterns on RefundRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RefundRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RefundRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RefundRequest value)  $default,){
final _that = this;
switch (_that) {
case _RefundRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RefundRequest value)?  $default,){
final _that = this;
switch (_that) {
case _RefundRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? amount,  String? reason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RefundRequest() when $default != null:
return $default(_that.amount,_that.reason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? amount,  String? reason)  $default,) {final _that = this;
switch (_that) {
case _RefundRequest():
return $default(_that.amount,_that.reason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? amount,  String? reason)?  $default,) {final _that = this;
switch (_that) {
case _RefundRequest() when $default != null:
return $default(_that.amount,_that.reason);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RefundRequest implements RefundRequest {
  const _RefundRequest({this.amount, this.reason});
  factory _RefundRequest.fromJson(Map<String, dynamic> json) => _$RefundRequestFromJson(json);

@override final  int? amount;
// Amount in cents, null for full refund
@override final  String? reason;

/// Create a copy of RefundRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RefundRequestCopyWith<_RefundRequest> get copyWith => __$RefundRequestCopyWithImpl<_RefundRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RefundRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RefundRequest&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,amount,reason);

@override
String toString() {
  return 'RefundRequest(amount: $amount, reason: $reason)';
}


}

/// @nodoc
abstract mixin class _$RefundRequestCopyWith<$Res> implements $RefundRequestCopyWith<$Res> {
  factory _$RefundRequestCopyWith(_RefundRequest value, $Res Function(_RefundRequest) _then) = __$RefundRequestCopyWithImpl;
@override @useResult
$Res call({
 int? amount, String? reason
});




}
/// @nodoc
class __$RefundRequestCopyWithImpl<$Res>
    implements _$RefundRequestCopyWith<$Res> {
  __$RefundRequestCopyWithImpl(this._self, this._then);

  final _RefundRequest _self;
  final $Res Function(_RefundRequest) _then;

/// Create a copy of RefundRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? amount = freezed,Object? reason = freezed,}) {
  return _then(_RefundRequest(
amount: freezed == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int?,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
