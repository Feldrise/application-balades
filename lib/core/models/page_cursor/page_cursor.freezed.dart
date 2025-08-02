// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'page_cursor.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PageCursor<T> {

 String get cursor; T get node;
/// Create a copy of PageCursor
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PageCursorCopyWith<T, PageCursor<T>> get copyWith => _$PageCursorCopyWithImpl<T, PageCursor<T>>(this as PageCursor<T>, _$identity);

  /// Serializes this PageCursor to a JSON map.
  Map<String, dynamic> toJson(Object? Function(T) toJsonT);


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PageCursor<T>&&(identical(other.cursor, cursor) || other.cursor == cursor)&&const DeepCollectionEquality().equals(other.node, node));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,cursor,const DeepCollectionEquality().hash(node));

@override
String toString() {
  return 'PageCursor<$T>(cursor: $cursor, node: $node)';
}


}

/// @nodoc
abstract mixin class $PageCursorCopyWith<T,$Res>  {
  factory $PageCursorCopyWith(PageCursor<T> value, $Res Function(PageCursor<T>) _then) = _$PageCursorCopyWithImpl;
@useResult
$Res call({
 String cursor, T node
});




}
/// @nodoc
class _$PageCursorCopyWithImpl<T,$Res>
    implements $PageCursorCopyWith<T, $Res> {
  _$PageCursorCopyWithImpl(this._self, this._then);

  final PageCursor<T> _self;
  final $Res Function(PageCursor<T>) _then;

/// Create a copy of PageCursor
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? cursor = null,Object? node = freezed,}) {
  return _then(_self.copyWith(
cursor: null == cursor ? _self.cursor : cursor // ignore: cast_nullable_to_non_nullable
as String,node: freezed == node ? _self.node : node // ignore: cast_nullable_to_non_nullable
as T,
  ));
}

}


/// Adds pattern-matching-related methods to [PageCursor].
extension PageCursorPatterns<T> on PageCursor<T> {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PageCursor<T> value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PageCursor() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PageCursor<T> value)  $default,){
final _that = this;
switch (_that) {
case _PageCursor():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PageCursor<T> value)?  $default,){
final _that = this;
switch (_that) {
case _PageCursor() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String cursor,  T node)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PageCursor() when $default != null:
return $default(_that.cursor,_that.node);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String cursor,  T node)  $default,) {final _that = this;
switch (_that) {
case _PageCursor():
return $default(_that.cursor,_that.node);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String cursor,  T node)?  $default,) {final _that = this;
switch (_that) {
case _PageCursor() when $default != null:
return $default(_that.cursor,_that.node);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable(genericArgumentFactories: true)

class _PageCursor<T> implements PageCursor<T> {
  const _PageCursor({required this.cursor, required this.node});
  factory _PageCursor.fromJson(Map<String, dynamic> json,T Function(Object?) fromJsonT) => _$PageCursorFromJson(json,fromJsonT);

@override final  String cursor;
@override final  T node;

/// Create a copy of PageCursor
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PageCursorCopyWith<T, _PageCursor<T>> get copyWith => __$PageCursorCopyWithImpl<T, _PageCursor<T>>(this, _$identity);

@override
Map<String, dynamic> toJson(Object? Function(T) toJsonT) {
  return _$PageCursorToJson<T>(this, toJsonT);
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PageCursor<T>&&(identical(other.cursor, cursor) || other.cursor == cursor)&&const DeepCollectionEquality().equals(other.node, node));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,cursor,const DeepCollectionEquality().hash(node));

@override
String toString() {
  return 'PageCursor<$T>(cursor: $cursor, node: $node)';
}


}

/// @nodoc
abstract mixin class _$PageCursorCopyWith<T,$Res> implements $PageCursorCopyWith<T, $Res> {
  factory _$PageCursorCopyWith(_PageCursor<T> value, $Res Function(_PageCursor<T>) _then) = __$PageCursorCopyWithImpl;
@override @useResult
$Res call({
 String cursor, T node
});




}
/// @nodoc
class __$PageCursorCopyWithImpl<T,$Res>
    implements _$PageCursorCopyWith<T, $Res> {
  __$PageCursorCopyWithImpl(this._self, this._then);

  final _PageCursor<T> _self;
  final $Res Function(_PageCursor<T>) _then;

/// Create a copy of PageCursor
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cursor = null,Object? node = freezed,}) {
  return _then(_PageCursor<T>(
cursor: null == cursor ? _self.cursor : cursor // ignore: cast_nullable_to_non_nullable
as String,node: freezed == node ? _self.node : node // ignore: cast_nullable_to_non_nullable
as T,
  ));
}


}

// dart format on
