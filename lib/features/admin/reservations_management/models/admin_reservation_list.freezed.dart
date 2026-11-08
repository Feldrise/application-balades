// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_reservation_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AdminReservationList {

 List<Reservation> get reservations; int get total; int get page;@JsonKey(name: 'per_page') int get perPage;@JsonKey(name: 'total_pages') int get totalPages;
/// Create a copy of AdminReservationList
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminReservationListCopyWith<AdminReservationList> get copyWith => _$AdminReservationListCopyWithImpl<AdminReservationList>(this as AdminReservationList, _$identity);

  /// Serializes this AdminReservationList to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminReservationList&&const DeepCollectionEquality().equals(other.reservations, reservations)&&(identical(other.total, total) || other.total == total)&&(identical(other.page, page) || other.page == page)&&(identical(other.perPage, perPage) || other.perPage == perPage)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(reservations),total,page,perPage,totalPages);

@override
String toString() {
  return 'AdminReservationList(reservations: $reservations, total: $total, page: $page, perPage: $perPage, totalPages: $totalPages)';
}


}

/// @nodoc
abstract mixin class $AdminReservationListCopyWith<$Res>  {
  factory $AdminReservationListCopyWith(AdminReservationList value, $Res Function(AdminReservationList) _then) = _$AdminReservationListCopyWithImpl;
@useResult
$Res call({
 List<Reservation> reservations, int total, int page,@JsonKey(name: 'per_page') int perPage,@JsonKey(name: 'total_pages') int totalPages
});




}
/// @nodoc
class _$AdminReservationListCopyWithImpl<$Res>
    implements $AdminReservationListCopyWith<$Res> {
  _$AdminReservationListCopyWithImpl(this._self, this._then);

  final AdminReservationList _self;
  final $Res Function(AdminReservationList) _then;

/// Create a copy of AdminReservationList
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? reservations = null,Object? total = null,Object? page = null,Object? perPage = null,Object? totalPages = null,}) {
  return _then(_self.copyWith(
reservations: null == reservations ? _self.reservations : reservations // ignore: cast_nullable_to_non_nullable
as List<Reservation>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,perPage: null == perPage ? _self.perPage : perPage // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminReservationList].
extension AdminReservationListPatterns on AdminReservationList {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminReservationList value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminReservationList() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminReservationList value)  $default,){
final _that = this;
switch (_that) {
case _AdminReservationList():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminReservationList value)?  $default,){
final _that = this;
switch (_that) {
case _AdminReservationList() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Reservation> reservations,  int total,  int page, @JsonKey(name: 'per_page')  int perPage, @JsonKey(name: 'total_pages')  int totalPages)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminReservationList() when $default != null:
return $default(_that.reservations,_that.total,_that.page,_that.perPage,_that.totalPages);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Reservation> reservations,  int total,  int page, @JsonKey(name: 'per_page')  int perPage, @JsonKey(name: 'total_pages')  int totalPages)  $default,) {final _that = this;
switch (_that) {
case _AdminReservationList():
return $default(_that.reservations,_that.total,_that.page,_that.perPage,_that.totalPages);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Reservation> reservations,  int total,  int page, @JsonKey(name: 'per_page')  int perPage, @JsonKey(name: 'total_pages')  int totalPages)?  $default,) {final _that = this;
switch (_that) {
case _AdminReservationList() when $default != null:
return $default(_that.reservations,_that.total,_that.page,_that.perPage,_that.totalPages);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminReservationList implements AdminReservationList {
  const _AdminReservationList({required final  List<Reservation> reservations, required this.total, required this.page, @JsonKey(name: 'per_page') required this.perPage, @JsonKey(name: 'total_pages') required this.totalPages}): _reservations = reservations;
  factory _AdminReservationList.fromJson(Map<String, dynamic> json) => _$AdminReservationListFromJson(json);

 final  List<Reservation> _reservations;
@override List<Reservation> get reservations {
  if (_reservations is EqualUnmodifiableListView) return _reservations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_reservations);
}

@override final  int total;
@override final  int page;
@override@JsonKey(name: 'per_page') final  int perPage;
@override@JsonKey(name: 'total_pages') final  int totalPages;

/// Create a copy of AdminReservationList
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminReservationListCopyWith<_AdminReservationList> get copyWith => __$AdminReservationListCopyWithImpl<_AdminReservationList>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminReservationListToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminReservationList&&const DeepCollectionEquality().equals(other._reservations, _reservations)&&(identical(other.total, total) || other.total == total)&&(identical(other.page, page) || other.page == page)&&(identical(other.perPage, perPage) || other.perPage == perPage)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_reservations),total,page,perPage,totalPages);

@override
String toString() {
  return 'AdminReservationList(reservations: $reservations, total: $total, page: $page, perPage: $perPage, totalPages: $totalPages)';
}


}

/// @nodoc
abstract mixin class _$AdminReservationListCopyWith<$Res> implements $AdminReservationListCopyWith<$Res> {
  factory _$AdminReservationListCopyWith(_AdminReservationList value, $Res Function(_AdminReservationList) _then) = __$AdminReservationListCopyWithImpl;
@override @useResult
$Res call({
 List<Reservation> reservations, int total, int page,@JsonKey(name: 'per_page') int perPage,@JsonKey(name: 'total_pages') int totalPages
});




}
/// @nodoc
class __$AdminReservationListCopyWithImpl<$Res>
    implements _$AdminReservationListCopyWith<$Res> {
  __$AdminReservationListCopyWithImpl(this._self, this._then);

  final _AdminReservationList _self;
  final $Res Function(_AdminReservationList) _then;

/// Create a copy of AdminReservationList
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? reservations = null,Object? total = null,Object? page = null,Object? perPage = null,Object? totalPages = null,}) {
  return _then(_AdminReservationList(
reservations: null == reservations ? _self._reservations : reservations // ignore: cast_nullable_to_non_nullable
as List<Reservation>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,perPage: null == perPage ? _self.perPage : perPage // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
