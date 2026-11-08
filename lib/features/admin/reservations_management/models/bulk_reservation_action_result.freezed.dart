// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bulk_reservation_action_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BulkReservationActionResult {

@JsonKey(name: 'success_count') int get successCount;@JsonKey(name: 'failure_count') int get failureCount;// The API omits the lists when they are empty
 List<BulkReservationActionError> get errors;// The reservations as saved, without the deleted ones
 List<Reservation> get updated;
/// Create a copy of BulkReservationActionResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BulkReservationActionResultCopyWith<BulkReservationActionResult> get copyWith => _$BulkReservationActionResultCopyWithImpl<BulkReservationActionResult>(this as BulkReservationActionResult, _$identity);

  /// Serializes this BulkReservationActionResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BulkReservationActionResult&&(identical(other.successCount, successCount) || other.successCount == successCount)&&(identical(other.failureCount, failureCount) || other.failureCount == failureCount)&&const DeepCollectionEquality().equals(other.errors, errors)&&const DeepCollectionEquality().equals(other.updated, updated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,successCount,failureCount,const DeepCollectionEquality().hash(errors),const DeepCollectionEquality().hash(updated));

@override
String toString() {
  return 'BulkReservationActionResult(successCount: $successCount, failureCount: $failureCount, errors: $errors, updated: $updated)';
}


}

/// @nodoc
abstract mixin class $BulkReservationActionResultCopyWith<$Res>  {
  factory $BulkReservationActionResultCopyWith(BulkReservationActionResult value, $Res Function(BulkReservationActionResult) _then) = _$BulkReservationActionResultCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'success_count') int successCount,@JsonKey(name: 'failure_count') int failureCount, List<BulkReservationActionError> errors, List<Reservation> updated
});




}
/// @nodoc
class _$BulkReservationActionResultCopyWithImpl<$Res>
    implements $BulkReservationActionResultCopyWith<$Res> {
  _$BulkReservationActionResultCopyWithImpl(this._self, this._then);

  final BulkReservationActionResult _self;
  final $Res Function(BulkReservationActionResult) _then;

/// Create a copy of BulkReservationActionResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? successCount = null,Object? failureCount = null,Object? errors = null,Object? updated = null,}) {
  return _then(_self.copyWith(
successCount: null == successCount ? _self.successCount : successCount // ignore: cast_nullable_to_non_nullable
as int,failureCount: null == failureCount ? _self.failureCount : failureCount // ignore: cast_nullable_to_non_nullable
as int,errors: null == errors ? _self.errors : errors // ignore: cast_nullable_to_non_nullable
as List<BulkReservationActionError>,updated: null == updated ? _self.updated : updated // ignore: cast_nullable_to_non_nullable
as List<Reservation>,
  ));
}

}


/// Adds pattern-matching-related methods to [BulkReservationActionResult].
extension BulkReservationActionResultPatterns on BulkReservationActionResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BulkReservationActionResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BulkReservationActionResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BulkReservationActionResult value)  $default,){
final _that = this;
switch (_that) {
case _BulkReservationActionResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BulkReservationActionResult value)?  $default,){
final _that = this;
switch (_that) {
case _BulkReservationActionResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'success_count')  int successCount, @JsonKey(name: 'failure_count')  int failureCount,  List<BulkReservationActionError> errors,  List<Reservation> updated)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BulkReservationActionResult() when $default != null:
return $default(_that.successCount,_that.failureCount,_that.errors,_that.updated);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'success_count')  int successCount, @JsonKey(name: 'failure_count')  int failureCount,  List<BulkReservationActionError> errors,  List<Reservation> updated)  $default,) {final _that = this;
switch (_that) {
case _BulkReservationActionResult():
return $default(_that.successCount,_that.failureCount,_that.errors,_that.updated);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'success_count')  int successCount, @JsonKey(name: 'failure_count')  int failureCount,  List<BulkReservationActionError> errors,  List<Reservation> updated)?  $default,) {final _that = this;
switch (_that) {
case _BulkReservationActionResult() when $default != null:
return $default(_that.successCount,_that.failureCount,_that.errors,_that.updated);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BulkReservationActionResult implements BulkReservationActionResult {
  const _BulkReservationActionResult({@JsonKey(name: 'success_count') required this.successCount, @JsonKey(name: 'failure_count') required this.failureCount, final  List<BulkReservationActionError> errors = const <BulkReservationActionError>[], final  List<Reservation> updated = const <Reservation>[]}): _errors = errors,_updated = updated;
  factory _BulkReservationActionResult.fromJson(Map<String, dynamic> json) => _$BulkReservationActionResultFromJson(json);

@override@JsonKey(name: 'success_count') final  int successCount;
@override@JsonKey(name: 'failure_count') final  int failureCount;
// The API omits the lists when they are empty
 final  List<BulkReservationActionError> _errors;
// The API omits the lists when they are empty
@override@JsonKey() List<BulkReservationActionError> get errors {
  if (_errors is EqualUnmodifiableListView) return _errors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_errors);
}

// The reservations as saved, without the deleted ones
 final  List<Reservation> _updated;
// The reservations as saved, without the deleted ones
@override@JsonKey() List<Reservation> get updated {
  if (_updated is EqualUnmodifiableListView) return _updated;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_updated);
}


/// Create a copy of BulkReservationActionResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BulkReservationActionResultCopyWith<_BulkReservationActionResult> get copyWith => __$BulkReservationActionResultCopyWithImpl<_BulkReservationActionResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BulkReservationActionResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BulkReservationActionResult&&(identical(other.successCount, successCount) || other.successCount == successCount)&&(identical(other.failureCount, failureCount) || other.failureCount == failureCount)&&const DeepCollectionEquality().equals(other._errors, _errors)&&const DeepCollectionEquality().equals(other._updated, _updated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,successCount,failureCount,const DeepCollectionEquality().hash(_errors),const DeepCollectionEquality().hash(_updated));

@override
String toString() {
  return 'BulkReservationActionResult(successCount: $successCount, failureCount: $failureCount, errors: $errors, updated: $updated)';
}


}

/// @nodoc
abstract mixin class _$BulkReservationActionResultCopyWith<$Res> implements $BulkReservationActionResultCopyWith<$Res> {
  factory _$BulkReservationActionResultCopyWith(_BulkReservationActionResult value, $Res Function(_BulkReservationActionResult) _then) = __$BulkReservationActionResultCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'success_count') int successCount,@JsonKey(name: 'failure_count') int failureCount, List<BulkReservationActionError> errors, List<Reservation> updated
});




}
/// @nodoc
class __$BulkReservationActionResultCopyWithImpl<$Res>
    implements _$BulkReservationActionResultCopyWith<$Res> {
  __$BulkReservationActionResultCopyWithImpl(this._self, this._then);

  final _BulkReservationActionResult _self;
  final $Res Function(_BulkReservationActionResult) _then;

/// Create a copy of BulkReservationActionResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? successCount = null,Object? failureCount = null,Object? errors = null,Object? updated = null,}) {
  return _then(_BulkReservationActionResult(
successCount: null == successCount ? _self.successCount : successCount // ignore: cast_nullable_to_non_nullable
as int,failureCount: null == failureCount ? _self.failureCount : failureCount // ignore: cast_nullable_to_non_nullable
as int,errors: null == errors ? _self._errors : errors // ignore: cast_nullable_to_non_nullable
as List<BulkReservationActionError>,updated: null == updated ? _self._updated : updated // ignore: cast_nullable_to_non_nullable
as List<Reservation>,
  ));
}


}


/// @nodoc
mixin _$BulkReservationActionError {

@JsonKey(name: 'reservation_id') int get reservationId; String get error;
/// Create a copy of BulkReservationActionError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BulkReservationActionErrorCopyWith<BulkReservationActionError> get copyWith => _$BulkReservationActionErrorCopyWithImpl<BulkReservationActionError>(this as BulkReservationActionError, _$identity);

  /// Serializes this BulkReservationActionError to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BulkReservationActionError&&(identical(other.reservationId, reservationId) || other.reservationId == reservationId)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,reservationId,error);

@override
String toString() {
  return 'BulkReservationActionError(reservationId: $reservationId, error: $error)';
}


}

/// @nodoc
abstract mixin class $BulkReservationActionErrorCopyWith<$Res>  {
  factory $BulkReservationActionErrorCopyWith(BulkReservationActionError value, $Res Function(BulkReservationActionError) _then) = _$BulkReservationActionErrorCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'reservation_id') int reservationId, String error
});




}
/// @nodoc
class _$BulkReservationActionErrorCopyWithImpl<$Res>
    implements $BulkReservationActionErrorCopyWith<$Res> {
  _$BulkReservationActionErrorCopyWithImpl(this._self, this._then);

  final BulkReservationActionError _self;
  final $Res Function(BulkReservationActionError) _then;

/// Create a copy of BulkReservationActionError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? reservationId = null,Object? error = null,}) {
  return _then(_self.copyWith(
reservationId: null == reservationId ? _self.reservationId : reservationId // ignore: cast_nullable_to_non_nullable
as int,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [BulkReservationActionError].
extension BulkReservationActionErrorPatterns on BulkReservationActionError {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BulkReservationActionError value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BulkReservationActionError() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BulkReservationActionError value)  $default,){
final _that = this;
switch (_that) {
case _BulkReservationActionError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BulkReservationActionError value)?  $default,){
final _that = this;
switch (_that) {
case _BulkReservationActionError() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'reservation_id')  int reservationId,  String error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BulkReservationActionError() when $default != null:
return $default(_that.reservationId,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'reservation_id')  int reservationId,  String error)  $default,) {final _that = this;
switch (_that) {
case _BulkReservationActionError():
return $default(_that.reservationId,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'reservation_id')  int reservationId,  String error)?  $default,) {final _that = this;
switch (_that) {
case _BulkReservationActionError() when $default != null:
return $default(_that.reservationId,_that.error);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BulkReservationActionError implements BulkReservationActionError {
  const _BulkReservationActionError({@JsonKey(name: 'reservation_id') required this.reservationId, required this.error});
  factory _BulkReservationActionError.fromJson(Map<String, dynamic> json) => _$BulkReservationActionErrorFromJson(json);

@override@JsonKey(name: 'reservation_id') final  int reservationId;
@override final  String error;

/// Create a copy of BulkReservationActionError
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BulkReservationActionErrorCopyWith<_BulkReservationActionError> get copyWith => __$BulkReservationActionErrorCopyWithImpl<_BulkReservationActionError>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BulkReservationActionErrorToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BulkReservationActionError&&(identical(other.reservationId, reservationId) || other.reservationId == reservationId)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,reservationId,error);

@override
String toString() {
  return 'BulkReservationActionError(reservationId: $reservationId, error: $error)';
}


}

/// @nodoc
abstract mixin class _$BulkReservationActionErrorCopyWith<$Res> implements $BulkReservationActionErrorCopyWith<$Res> {
  factory _$BulkReservationActionErrorCopyWith(_BulkReservationActionError value, $Res Function(_BulkReservationActionError) _then) = __$BulkReservationActionErrorCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'reservation_id') int reservationId, String error
});




}
/// @nodoc
class __$BulkReservationActionErrorCopyWithImpl<$Res>
    implements _$BulkReservationActionErrorCopyWith<$Res> {
  __$BulkReservationActionErrorCopyWithImpl(this._self, this._then);

  final _BulkReservationActionError _self;
  final $Res Function(_BulkReservationActionError) _then;

/// Create a copy of BulkReservationActionError
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? reservationId = null,Object? error = null,}) {
  return _then(_BulkReservationActionError(
reservationId: null == reservationId ? _self.reservationId : reservationId // ignore: cast_nullable_to_non_nullable
as int,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
