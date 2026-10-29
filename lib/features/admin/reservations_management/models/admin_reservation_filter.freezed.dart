// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_reservation_filter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AdminReservationFilter {

 String? get search; int? get rambleId; int? get userId; String? get email; List<String>? get statuses; DateTime? get dateFrom; DateTime? get dateTo; String? get rambleTitle;
/// Create a copy of AdminReservationFilter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminReservationFilterCopyWith<AdminReservationFilter> get copyWith => _$AdminReservationFilterCopyWithImpl<AdminReservationFilter>(this as AdminReservationFilter, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminReservationFilter&&(identical(other.search, search) || other.search == search)&&(identical(other.rambleId, rambleId) || other.rambleId == rambleId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.email, email) || other.email == email)&&const DeepCollectionEquality().equals(other.statuses, statuses)&&(identical(other.dateFrom, dateFrom) || other.dateFrom == dateFrom)&&(identical(other.dateTo, dateTo) || other.dateTo == dateTo)&&(identical(other.rambleTitle, rambleTitle) || other.rambleTitle == rambleTitle));
}


@override
int get hashCode => Object.hash(runtimeType,search,rambleId,userId,email,const DeepCollectionEquality().hash(statuses),dateFrom,dateTo,rambleTitle);

@override
String toString() {
  return 'AdminReservationFilter(search: $search, rambleId: $rambleId, userId: $userId, email: $email, statuses: $statuses, dateFrom: $dateFrom, dateTo: $dateTo, rambleTitle: $rambleTitle)';
}


}

/// @nodoc
abstract mixin class $AdminReservationFilterCopyWith<$Res>  {
  factory $AdminReservationFilterCopyWith(AdminReservationFilter value, $Res Function(AdminReservationFilter) _then) = _$AdminReservationFilterCopyWithImpl;
@useResult
$Res call({
 String? search, int? rambleId, int? userId, String? email, List<String>? statuses, DateTime? dateFrom, DateTime? dateTo, String? rambleTitle
});




}
/// @nodoc
class _$AdminReservationFilterCopyWithImpl<$Res>
    implements $AdminReservationFilterCopyWith<$Res> {
  _$AdminReservationFilterCopyWithImpl(this._self, this._then);

  final AdminReservationFilter _self;
  final $Res Function(AdminReservationFilter) _then;

/// Create a copy of AdminReservationFilter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? search = freezed,Object? rambleId = freezed,Object? userId = freezed,Object? email = freezed,Object? statuses = freezed,Object? dateFrom = freezed,Object? dateTo = freezed,Object? rambleTitle = freezed,}) {
  return _then(_self.copyWith(
search: freezed == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String?,rambleId: freezed == rambleId ? _self.rambleId : rambleId // ignore: cast_nullable_to_non_nullable
as int?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,statuses: freezed == statuses ? _self.statuses : statuses // ignore: cast_nullable_to_non_nullable
as List<String>?,dateFrom: freezed == dateFrom ? _self.dateFrom : dateFrom // ignore: cast_nullable_to_non_nullable
as DateTime?,dateTo: freezed == dateTo ? _self.dateTo : dateTo // ignore: cast_nullable_to_non_nullable
as DateTime?,rambleTitle: freezed == rambleTitle ? _self.rambleTitle : rambleTitle // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminReservationFilter].
extension AdminReservationFilterPatterns on AdminReservationFilter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminReservationFilter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminReservationFilter() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminReservationFilter value)  $default,){
final _that = this;
switch (_that) {
case _AdminReservationFilter():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminReservationFilter value)?  $default,){
final _that = this;
switch (_that) {
case _AdminReservationFilter() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? search,  int? rambleId,  int? userId,  String? email,  List<String>? statuses,  DateTime? dateFrom,  DateTime? dateTo,  String? rambleTitle)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminReservationFilter() when $default != null:
return $default(_that.search,_that.rambleId,_that.userId,_that.email,_that.statuses,_that.dateFrom,_that.dateTo,_that.rambleTitle);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? search,  int? rambleId,  int? userId,  String? email,  List<String>? statuses,  DateTime? dateFrom,  DateTime? dateTo,  String? rambleTitle)  $default,) {final _that = this;
switch (_that) {
case _AdminReservationFilter():
return $default(_that.search,_that.rambleId,_that.userId,_that.email,_that.statuses,_that.dateFrom,_that.dateTo,_that.rambleTitle);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? search,  int? rambleId,  int? userId,  String? email,  List<String>? statuses,  DateTime? dateFrom,  DateTime? dateTo,  String? rambleTitle)?  $default,) {final _that = this;
switch (_that) {
case _AdminReservationFilter() when $default != null:
return $default(_that.search,_that.rambleId,_that.userId,_that.email,_that.statuses,_that.dateFrom,_that.dateTo,_that.rambleTitle);case _:
  return null;

}
}

}

/// @nodoc


class _AdminReservationFilter extends AdminReservationFilter {
  const _AdminReservationFilter({this.search, this.rambleId, this.userId, this.email, final  List<String>? statuses, this.dateFrom, this.dateTo, this.rambleTitle}): _statuses = statuses,super._();
  

@override final  String? search;
@override final  int? rambleId;
@override final  int? userId;
@override final  String? email;
 final  List<String>? _statuses;
@override List<String>? get statuses {
  final value = _statuses;
  if (value == null) return null;
  if (_statuses is EqualUnmodifiableListView) return _statuses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  DateTime? dateFrom;
@override final  DateTime? dateTo;
@override final  String? rambleTitle;

/// Create a copy of AdminReservationFilter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminReservationFilterCopyWith<_AdminReservationFilter> get copyWith => __$AdminReservationFilterCopyWithImpl<_AdminReservationFilter>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminReservationFilter&&(identical(other.search, search) || other.search == search)&&(identical(other.rambleId, rambleId) || other.rambleId == rambleId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.email, email) || other.email == email)&&const DeepCollectionEquality().equals(other._statuses, _statuses)&&(identical(other.dateFrom, dateFrom) || other.dateFrom == dateFrom)&&(identical(other.dateTo, dateTo) || other.dateTo == dateTo)&&(identical(other.rambleTitle, rambleTitle) || other.rambleTitle == rambleTitle));
}


@override
int get hashCode => Object.hash(runtimeType,search,rambleId,userId,email,const DeepCollectionEquality().hash(_statuses),dateFrom,dateTo,rambleTitle);

@override
String toString() {
  return 'AdminReservationFilter(search: $search, rambleId: $rambleId, userId: $userId, email: $email, statuses: $statuses, dateFrom: $dateFrom, dateTo: $dateTo, rambleTitle: $rambleTitle)';
}


}

/// @nodoc
abstract mixin class _$AdminReservationFilterCopyWith<$Res> implements $AdminReservationFilterCopyWith<$Res> {
  factory _$AdminReservationFilterCopyWith(_AdminReservationFilter value, $Res Function(_AdminReservationFilter) _then) = __$AdminReservationFilterCopyWithImpl;
@override @useResult
$Res call({
 String? search, int? rambleId, int? userId, String? email, List<String>? statuses, DateTime? dateFrom, DateTime? dateTo, String? rambleTitle
});




}
/// @nodoc
class __$AdminReservationFilterCopyWithImpl<$Res>
    implements _$AdminReservationFilterCopyWith<$Res> {
  __$AdminReservationFilterCopyWithImpl(this._self, this._then);

  final _AdminReservationFilter _self;
  final $Res Function(_AdminReservationFilter) _then;

/// Create a copy of AdminReservationFilter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? search = freezed,Object? rambleId = freezed,Object? userId = freezed,Object? email = freezed,Object? statuses = freezed,Object? dateFrom = freezed,Object? dateTo = freezed,Object? rambleTitle = freezed,}) {
  return _then(_AdminReservationFilter(
search: freezed == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String?,rambleId: freezed == rambleId ? _self.rambleId : rambleId // ignore: cast_nullable_to_non_nullable
as int?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,statuses: freezed == statuses ? _self._statuses : statuses // ignore: cast_nullable_to_non_nullable
as List<String>?,dateFrom: freezed == dateFrom ? _self.dateFrom : dateFrom // ignore: cast_nullable_to_non_nullable
as DateTime?,dateTo: freezed == dateTo ? _self.dateTo : dateTo // ignore: cast_nullable_to_non_nullable
as DateTime?,rambleTitle: freezed == rambleTitle ? _self.rambleTitle : rambleTitle // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
