// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bulk_action_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BulkActionResult {

@JsonKey(name: 'success_count') int get successCount;@JsonKey(name: 'failure_count') int get failureCount; List<BulkActionError> get errors; List<Registration> get updated;
/// Create a copy of BulkActionResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BulkActionResultCopyWith<BulkActionResult> get copyWith => _$BulkActionResultCopyWithImpl<BulkActionResult>(this as BulkActionResult, _$identity);

  /// Serializes this BulkActionResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BulkActionResult&&(identical(other.successCount, successCount) || other.successCount == successCount)&&(identical(other.failureCount, failureCount) || other.failureCount == failureCount)&&const DeepCollectionEquality().equals(other.errors, errors)&&const DeepCollectionEquality().equals(other.updated, updated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,successCount,failureCount,const DeepCollectionEquality().hash(errors),const DeepCollectionEquality().hash(updated));

@override
String toString() {
  return 'BulkActionResult(successCount: $successCount, failureCount: $failureCount, errors: $errors, updated: $updated)';
}


}

/// @nodoc
abstract mixin class $BulkActionResultCopyWith<$Res>  {
  factory $BulkActionResultCopyWith(BulkActionResult value, $Res Function(BulkActionResult) _then) = _$BulkActionResultCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'success_count') int successCount,@JsonKey(name: 'failure_count') int failureCount, List<BulkActionError> errors, List<Registration> updated
});




}
/// @nodoc
class _$BulkActionResultCopyWithImpl<$Res>
    implements $BulkActionResultCopyWith<$Res> {
  _$BulkActionResultCopyWithImpl(this._self, this._then);

  final BulkActionResult _self;
  final $Res Function(BulkActionResult) _then;

/// Create a copy of BulkActionResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? successCount = null,Object? failureCount = null,Object? errors = null,Object? updated = null,}) {
  return _then(_self.copyWith(
successCount: null == successCount ? _self.successCount : successCount // ignore: cast_nullable_to_non_nullable
as int,failureCount: null == failureCount ? _self.failureCount : failureCount // ignore: cast_nullable_to_non_nullable
as int,errors: null == errors ? _self.errors : errors // ignore: cast_nullable_to_non_nullable
as List<BulkActionError>,updated: null == updated ? _self.updated : updated // ignore: cast_nullable_to_non_nullable
as List<Registration>,
  ));
}

}


/// Adds pattern-matching-related methods to [BulkActionResult].
extension BulkActionResultPatterns on BulkActionResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BulkActionResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BulkActionResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BulkActionResult value)  $default,){
final _that = this;
switch (_that) {
case _BulkActionResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BulkActionResult value)?  $default,){
final _that = this;
switch (_that) {
case _BulkActionResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'success_count')  int successCount, @JsonKey(name: 'failure_count')  int failureCount,  List<BulkActionError> errors,  List<Registration> updated)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BulkActionResult() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'success_count')  int successCount, @JsonKey(name: 'failure_count')  int failureCount,  List<BulkActionError> errors,  List<Registration> updated)  $default,) {final _that = this;
switch (_that) {
case _BulkActionResult():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'success_count')  int successCount, @JsonKey(name: 'failure_count')  int failureCount,  List<BulkActionError> errors,  List<Registration> updated)?  $default,) {final _that = this;
switch (_that) {
case _BulkActionResult() when $default != null:
return $default(_that.successCount,_that.failureCount,_that.errors,_that.updated);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BulkActionResult implements BulkActionResult {
  const _BulkActionResult({@JsonKey(name: 'success_count') required this.successCount, @JsonKey(name: 'failure_count') required this.failureCount, required final  List<BulkActionError> errors, required final  List<Registration> updated}): _errors = errors,_updated = updated;
  factory _BulkActionResult.fromJson(Map<String, dynamic> json) => _$BulkActionResultFromJson(json);

@override@JsonKey(name: 'success_count') final  int successCount;
@override@JsonKey(name: 'failure_count') final  int failureCount;
 final  List<BulkActionError> _errors;
@override List<BulkActionError> get errors {
  if (_errors is EqualUnmodifiableListView) return _errors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_errors);
}

 final  List<Registration> _updated;
@override List<Registration> get updated {
  if (_updated is EqualUnmodifiableListView) return _updated;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_updated);
}


/// Create a copy of BulkActionResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BulkActionResultCopyWith<_BulkActionResult> get copyWith => __$BulkActionResultCopyWithImpl<_BulkActionResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BulkActionResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BulkActionResult&&(identical(other.successCount, successCount) || other.successCount == successCount)&&(identical(other.failureCount, failureCount) || other.failureCount == failureCount)&&const DeepCollectionEquality().equals(other._errors, _errors)&&const DeepCollectionEquality().equals(other._updated, _updated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,successCount,failureCount,const DeepCollectionEquality().hash(_errors),const DeepCollectionEquality().hash(_updated));

@override
String toString() {
  return 'BulkActionResult(successCount: $successCount, failureCount: $failureCount, errors: $errors, updated: $updated)';
}


}

/// @nodoc
abstract mixin class _$BulkActionResultCopyWith<$Res> implements $BulkActionResultCopyWith<$Res> {
  factory _$BulkActionResultCopyWith(_BulkActionResult value, $Res Function(_BulkActionResult) _then) = __$BulkActionResultCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'success_count') int successCount,@JsonKey(name: 'failure_count') int failureCount, List<BulkActionError> errors, List<Registration> updated
});




}
/// @nodoc
class __$BulkActionResultCopyWithImpl<$Res>
    implements _$BulkActionResultCopyWith<$Res> {
  __$BulkActionResultCopyWithImpl(this._self, this._then);

  final _BulkActionResult _self;
  final $Res Function(_BulkActionResult) _then;

/// Create a copy of BulkActionResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? successCount = null,Object? failureCount = null,Object? errors = null,Object? updated = null,}) {
  return _then(_BulkActionResult(
successCount: null == successCount ? _self.successCount : successCount // ignore: cast_nullable_to_non_nullable
as int,failureCount: null == failureCount ? _self.failureCount : failureCount // ignore: cast_nullable_to_non_nullable
as int,errors: null == errors ? _self._errors : errors // ignore: cast_nullable_to_non_nullable
as List<BulkActionError>,updated: null == updated ? _self._updated : updated // ignore: cast_nullable_to_non_nullable
as List<Registration>,
  ));
}


}


/// @nodoc
mixin _$BulkActionError {

@JsonKey(name: 'registration_id') int get registrationId; String get error;
/// Create a copy of BulkActionError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BulkActionErrorCopyWith<BulkActionError> get copyWith => _$BulkActionErrorCopyWithImpl<BulkActionError>(this as BulkActionError, _$identity);

  /// Serializes this BulkActionError to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BulkActionError&&(identical(other.registrationId, registrationId) || other.registrationId == registrationId)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,registrationId,error);

@override
String toString() {
  return 'BulkActionError(registrationId: $registrationId, error: $error)';
}


}

/// @nodoc
abstract mixin class $BulkActionErrorCopyWith<$Res>  {
  factory $BulkActionErrorCopyWith(BulkActionError value, $Res Function(BulkActionError) _then) = _$BulkActionErrorCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'registration_id') int registrationId, String error
});




}
/// @nodoc
class _$BulkActionErrorCopyWithImpl<$Res>
    implements $BulkActionErrorCopyWith<$Res> {
  _$BulkActionErrorCopyWithImpl(this._self, this._then);

  final BulkActionError _self;
  final $Res Function(BulkActionError) _then;

/// Create a copy of BulkActionError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? registrationId = null,Object? error = null,}) {
  return _then(_self.copyWith(
registrationId: null == registrationId ? _self.registrationId : registrationId // ignore: cast_nullable_to_non_nullable
as int,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [BulkActionError].
extension BulkActionErrorPatterns on BulkActionError {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BulkActionError value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BulkActionError() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BulkActionError value)  $default,){
final _that = this;
switch (_that) {
case _BulkActionError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BulkActionError value)?  $default,){
final _that = this;
switch (_that) {
case _BulkActionError() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'registration_id')  int registrationId,  String error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BulkActionError() when $default != null:
return $default(_that.registrationId,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'registration_id')  int registrationId,  String error)  $default,) {final _that = this;
switch (_that) {
case _BulkActionError():
return $default(_that.registrationId,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'registration_id')  int registrationId,  String error)?  $default,) {final _that = this;
switch (_that) {
case _BulkActionError() when $default != null:
return $default(_that.registrationId,_that.error);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BulkActionError implements BulkActionError {
  const _BulkActionError({@JsonKey(name: 'registration_id') required this.registrationId, required this.error});
  factory _BulkActionError.fromJson(Map<String, dynamic> json) => _$BulkActionErrorFromJson(json);

@override@JsonKey(name: 'registration_id') final  int registrationId;
@override final  String error;

/// Create a copy of BulkActionError
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BulkActionErrorCopyWith<_BulkActionError> get copyWith => __$BulkActionErrorCopyWithImpl<_BulkActionError>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BulkActionErrorToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BulkActionError&&(identical(other.registrationId, registrationId) || other.registrationId == registrationId)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,registrationId,error);

@override
String toString() {
  return 'BulkActionError(registrationId: $registrationId, error: $error)';
}


}

/// @nodoc
abstract mixin class _$BulkActionErrorCopyWith<$Res> implements $BulkActionErrorCopyWith<$Res> {
  factory _$BulkActionErrorCopyWith(_BulkActionError value, $Res Function(_BulkActionError) _then) = __$BulkActionErrorCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'registration_id') int registrationId, String error
});




}
/// @nodoc
class __$BulkActionErrorCopyWithImpl<$Res>
    implements _$BulkActionErrorCopyWith<$Res> {
  __$BulkActionErrorCopyWithImpl(this._self, this._then);

  final _BulkActionError _self;
  final $Res Function(_BulkActionError) _then;

/// Create a copy of BulkActionError
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? registrationId = null,Object? error = null,}) {
  return _then(_BulkActionError(
registrationId: null == registrationId ? _self.registrationId : registrationId // ignore: cast_nullable_to_non_nullable
as int,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
