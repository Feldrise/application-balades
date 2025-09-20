// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ramble.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Ramble {

 int get id; String get title; String get status; String? get description; String get type;@DateSerializer() DateTime? get date; String? get location;@JsonKey(name: 'meeting_point') String? get meetingPoint;@JsonKey(name: 'max_participants') int? get maxParticipants; List<RamblePrice> get prices; String get difficulty;@DurationSerializer()@JsonKey(name: 'estimated_duration') Duration? get estimatedDuration;@JsonKey(name: 'equipment_needed') String? get equipmentNeeded; String? get prerequisites;@JsonKey(name: 'cover_image') String? get coverImage;@JsonKey(name: 'additional_documents_url') String? get additionalDocumentsUrl; List<Guide> get guides;
/// Create a copy of Ramble
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RambleCopyWith<Ramble> get copyWith => _$RambleCopyWithImpl<Ramble>(this as Ramble, _$identity);

  /// Serializes this Ramble to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Ramble&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.status, status) || other.status == status)&&(identical(other.description, description) || other.description == description)&&(identical(other.type, type) || other.type == type)&&(identical(other.date, date) || other.date == date)&&(identical(other.location, location) || other.location == location)&&(identical(other.meetingPoint, meetingPoint) || other.meetingPoint == meetingPoint)&&(identical(other.maxParticipants, maxParticipants) || other.maxParticipants == maxParticipants)&&const DeepCollectionEquality().equals(other.prices, prices)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.estimatedDuration, estimatedDuration) || other.estimatedDuration == estimatedDuration)&&(identical(other.equipmentNeeded, equipmentNeeded) || other.equipmentNeeded == equipmentNeeded)&&(identical(other.prerequisites, prerequisites) || other.prerequisites == prerequisites)&&(identical(other.coverImage, coverImage) || other.coverImage == coverImage)&&(identical(other.additionalDocumentsUrl, additionalDocumentsUrl) || other.additionalDocumentsUrl == additionalDocumentsUrl)&&const DeepCollectionEquality().equals(other.guides, guides));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,status,description,type,date,location,meetingPoint,maxParticipants,const DeepCollectionEquality().hash(prices),difficulty,estimatedDuration,equipmentNeeded,prerequisites,coverImage,additionalDocumentsUrl,const DeepCollectionEquality().hash(guides));

@override
String toString() {
  return 'Ramble(id: $id, title: $title, status: $status, description: $description, type: $type, date: $date, location: $location, meetingPoint: $meetingPoint, maxParticipants: $maxParticipants, prices: $prices, difficulty: $difficulty, estimatedDuration: $estimatedDuration, equipmentNeeded: $equipmentNeeded, prerequisites: $prerequisites, coverImage: $coverImage, additionalDocumentsUrl: $additionalDocumentsUrl, guides: $guides)';
}


}

/// @nodoc
abstract mixin class $RambleCopyWith<$Res>  {
  factory $RambleCopyWith(Ramble value, $Res Function(Ramble) _then) = _$RambleCopyWithImpl;
@useResult
$Res call({
 int id, String title, String status, String? description, String type,@DateSerializer() DateTime? date, String? location,@JsonKey(name: 'meeting_point') String? meetingPoint,@JsonKey(name: 'max_participants') int? maxParticipants, List<RamblePrice> prices, String difficulty,@DurationSerializer()@JsonKey(name: 'estimated_duration') Duration? estimatedDuration,@JsonKey(name: 'equipment_needed') String? equipmentNeeded, String? prerequisites,@JsonKey(name: 'cover_image') String? coverImage,@JsonKey(name: 'additional_documents_url') String? additionalDocumentsUrl, List<Guide> guides
});




}
/// @nodoc
class _$RambleCopyWithImpl<$Res>
    implements $RambleCopyWith<$Res> {
  _$RambleCopyWithImpl(this._self, this._then);

  final Ramble _self;
  final $Res Function(Ramble) _then;

/// Create a copy of Ramble
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? status = null,Object? description = freezed,Object? type = null,Object? date = freezed,Object? location = freezed,Object? meetingPoint = freezed,Object? maxParticipants = freezed,Object? prices = null,Object? difficulty = null,Object? estimatedDuration = freezed,Object? equipmentNeeded = freezed,Object? prerequisites = freezed,Object? coverImage = freezed,Object? additionalDocumentsUrl = freezed,Object? guides = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,meetingPoint: freezed == meetingPoint ? _self.meetingPoint : meetingPoint // ignore: cast_nullable_to_non_nullable
as String?,maxParticipants: freezed == maxParticipants ? _self.maxParticipants : maxParticipants // ignore: cast_nullable_to_non_nullable
as int?,prices: null == prices ? _self.prices : prices // ignore: cast_nullable_to_non_nullable
as List<RamblePrice>,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as String,estimatedDuration: freezed == estimatedDuration ? _self.estimatedDuration : estimatedDuration // ignore: cast_nullable_to_non_nullable
as Duration?,equipmentNeeded: freezed == equipmentNeeded ? _self.equipmentNeeded : equipmentNeeded // ignore: cast_nullable_to_non_nullable
as String?,prerequisites: freezed == prerequisites ? _self.prerequisites : prerequisites // ignore: cast_nullable_to_non_nullable
as String?,coverImage: freezed == coverImage ? _self.coverImage : coverImage // ignore: cast_nullable_to_non_nullable
as String?,additionalDocumentsUrl: freezed == additionalDocumentsUrl ? _self.additionalDocumentsUrl : additionalDocumentsUrl // ignore: cast_nullable_to_non_nullable
as String?,guides: null == guides ? _self.guides : guides // ignore: cast_nullable_to_non_nullable
as List<Guide>,
  ));
}

}


/// Adds pattern-matching-related methods to [Ramble].
extension RamblePatterns on Ramble {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Ramble value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Ramble() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Ramble value)  $default,){
final _that = this;
switch (_that) {
case _Ramble():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Ramble value)?  $default,){
final _that = this;
switch (_that) {
case _Ramble() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String title,  String status,  String? description,  String type, @DateSerializer()  DateTime? date,  String? location, @JsonKey(name: 'meeting_point')  String? meetingPoint, @JsonKey(name: 'max_participants')  int? maxParticipants,  List<RamblePrice> prices,  String difficulty, @DurationSerializer()@JsonKey(name: 'estimated_duration')  Duration? estimatedDuration, @JsonKey(name: 'equipment_needed')  String? equipmentNeeded,  String? prerequisites, @JsonKey(name: 'cover_image')  String? coverImage, @JsonKey(name: 'additional_documents_url')  String? additionalDocumentsUrl,  List<Guide> guides)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Ramble() when $default != null:
return $default(_that.id,_that.title,_that.status,_that.description,_that.type,_that.date,_that.location,_that.meetingPoint,_that.maxParticipants,_that.prices,_that.difficulty,_that.estimatedDuration,_that.equipmentNeeded,_that.prerequisites,_that.coverImage,_that.additionalDocumentsUrl,_that.guides);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String title,  String status,  String? description,  String type, @DateSerializer()  DateTime? date,  String? location, @JsonKey(name: 'meeting_point')  String? meetingPoint, @JsonKey(name: 'max_participants')  int? maxParticipants,  List<RamblePrice> prices,  String difficulty, @DurationSerializer()@JsonKey(name: 'estimated_duration')  Duration? estimatedDuration, @JsonKey(name: 'equipment_needed')  String? equipmentNeeded,  String? prerequisites, @JsonKey(name: 'cover_image')  String? coverImage, @JsonKey(name: 'additional_documents_url')  String? additionalDocumentsUrl,  List<Guide> guides)  $default,) {final _that = this;
switch (_that) {
case _Ramble():
return $default(_that.id,_that.title,_that.status,_that.description,_that.type,_that.date,_that.location,_that.meetingPoint,_that.maxParticipants,_that.prices,_that.difficulty,_that.estimatedDuration,_that.equipmentNeeded,_that.prerequisites,_that.coverImage,_that.additionalDocumentsUrl,_that.guides);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String title,  String status,  String? description,  String type, @DateSerializer()  DateTime? date,  String? location, @JsonKey(name: 'meeting_point')  String? meetingPoint, @JsonKey(name: 'max_participants')  int? maxParticipants,  List<RamblePrice> prices,  String difficulty, @DurationSerializer()@JsonKey(name: 'estimated_duration')  Duration? estimatedDuration, @JsonKey(name: 'equipment_needed')  String? equipmentNeeded,  String? prerequisites, @JsonKey(name: 'cover_image')  String? coverImage, @JsonKey(name: 'additional_documents_url')  String? additionalDocumentsUrl,  List<Guide> guides)?  $default,) {final _that = this;
switch (_that) {
case _Ramble() when $default != null:
return $default(_that.id,_that.title,_that.status,_that.description,_that.type,_that.date,_that.location,_that.meetingPoint,_that.maxParticipants,_that.prices,_that.difficulty,_that.estimatedDuration,_that.equipmentNeeded,_that.prerequisites,_that.coverImage,_that.additionalDocumentsUrl,_that.guides);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Ramble implements Ramble {
  const _Ramble(this.id, {required this.title, required this.status, this.description, required this.type, @DateSerializer() this.date, this.location, @JsonKey(name: 'meeting_point') this.meetingPoint, @JsonKey(name: 'max_participants') this.maxParticipants, final  List<RamblePrice> prices = const <RamblePrice>[], required this.difficulty, @DurationSerializer()@JsonKey(name: 'estimated_duration') this.estimatedDuration, @JsonKey(name: 'equipment_needed') this.equipmentNeeded, this.prerequisites, @JsonKey(name: 'cover_image') this.coverImage, @JsonKey(name: 'additional_documents_url') this.additionalDocumentsUrl, final  List<Guide> guides = const <Guide>[]}): _prices = prices,_guides = guides;
  factory _Ramble.fromJson(Map<String, dynamic> json) => _$RambleFromJson(json);

@override final  int id;
@override final  String title;
@override final  String status;
@override final  String? description;
@override final  String type;
@override@DateSerializer() final  DateTime? date;
@override final  String? location;
@override@JsonKey(name: 'meeting_point') final  String? meetingPoint;
@override@JsonKey(name: 'max_participants') final  int? maxParticipants;
 final  List<RamblePrice> _prices;
@override@JsonKey() List<RamblePrice> get prices {
  if (_prices is EqualUnmodifiableListView) return _prices;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_prices);
}

@override final  String difficulty;
@override@DurationSerializer()@JsonKey(name: 'estimated_duration') final  Duration? estimatedDuration;
@override@JsonKey(name: 'equipment_needed') final  String? equipmentNeeded;
@override final  String? prerequisites;
@override@JsonKey(name: 'cover_image') final  String? coverImage;
@override@JsonKey(name: 'additional_documents_url') final  String? additionalDocumentsUrl;
 final  List<Guide> _guides;
@override@JsonKey() List<Guide> get guides {
  if (_guides is EqualUnmodifiableListView) return _guides;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_guides);
}


/// Create a copy of Ramble
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RambleCopyWith<_Ramble> get copyWith => __$RambleCopyWithImpl<_Ramble>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RambleToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Ramble&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.status, status) || other.status == status)&&(identical(other.description, description) || other.description == description)&&(identical(other.type, type) || other.type == type)&&(identical(other.date, date) || other.date == date)&&(identical(other.location, location) || other.location == location)&&(identical(other.meetingPoint, meetingPoint) || other.meetingPoint == meetingPoint)&&(identical(other.maxParticipants, maxParticipants) || other.maxParticipants == maxParticipants)&&const DeepCollectionEquality().equals(other._prices, _prices)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.estimatedDuration, estimatedDuration) || other.estimatedDuration == estimatedDuration)&&(identical(other.equipmentNeeded, equipmentNeeded) || other.equipmentNeeded == equipmentNeeded)&&(identical(other.prerequisites, prerequisites) || other.prerequisites == prerequisites)&&(identical(other.coverImage, coverImage) || other.coverImage == coverImage)&&(identical(other.additionalDocumentsUrl, additionalDocumentsUrl) || other.additionalDocumentsUrl == additionalDocumentsUrl)&&const DeepCollectionEquality().equals(other._guides, _guides));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,status,description,type,date,location,meetingPoint,maxParticipants,const DeepCollectionEquality().hash(_prices),difficulty,estimatedDuration,equipmentNeeded,prerequisites,coverImage,additionalDocumentsUrl,const DeepCollectionEquality().hash(_guides));

@override
String toString() {
  return 'Ramble(id: $id, title: $title, status: $status, description: $description, type: $type, date: $date, location: $location, meetingPoint: $meetingPoint, maxParticipants: $maxParticipants, prices: $prices, difficulty: $difficulty, estimatedDuration: $estimatedDuration, equipmentNeeded: $equipmentNeeded, prerequisites: $prerequisites, coverImage: $coverImage, additionalDocumentsUrl: $additionalDocumentsUrl, guides: $guides)';
}


}

/// @nodoc
abstract mixin class _$RambleCopyWith<$Res> implements $RambleCopyWith<$Res> {
  factory _$RambleCopyWith(_Ramble value, $Res Function(_Ramble) _then) = __$RambleCopyWithImpl;
@override @useResult
$Res call({
 int id, String title, String status, String? description, String type,@DateSerializer() DateTime? date, String? location,@JsonKey(name: 'meeting_point') String? meetingPoint,@JsonKey(name: 'max_participants') int? maxParticipants, List<RamblePrice> prices, String difficulty,@DurationSerializer()@JsonKey(name: 'estimated_duration') Duration? estimatedDuration,@JsonKey(name: 'equipment_needed') String? equipmentNeeded, String? prerequisites,@JsonKey(name: 'cover_image') String? coverImage,@JsonKey(name: 'additional_documents_url') String? additionalDocumentsUrl, List<Guide> guides
});




}
/// @nodoc
class __$RambleCopyWithImpl<$Res>
    implements _$RambleCopyWith<$Res> {
  __$RambleCopyWithImpl(this._self, this._then);

  final _Ramble _self;
  final $Res Function(_Ramble) _then;

/// Create a copy of Ramble
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? status = null,Object? description = freezed,Object? type = null,Object? date = freezed,Object? location = freezed,Object? meetingPoint = freezed,Object? maxParticipants = freezed,Object? prices = null,Object? difficulty = null,Object? estimatedDuration = freezed,Object? equipmentNeeded = freezed,Object? prerequisites = freezed,Object? coverImage = freezed,Object? additionalDocumentsUrl = freezed,Object? guides = null,}) {
  return _then(_Ramble(
null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,meetingPoint: freezed == meetingPoint ? _self.meetingPoint : meetingPoint // ignore: cast_nullable_to_non_nullable
as String?,maxParticipants: freezed == maxParticipants ? _self.maxParticipants : maxParticipants // ignore: cast_nullable_to_non_nullable
as int?,prices: null == prices ? _self._prices : prices // ignore: cast_nullable_to_non_nullable
as List<RamblePrice>,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as String,estimatedDuration: freezed == estimatedDuration ? _self.estimatedDuration : estimatedDuration // ignore: cast_nullable_to_non_nullable
as Duration?,equipmentNeeded: freezed == equipmentNeeded ? _self.equipmentNeeded : equipmentNeeded // ignore: cast_nullable_to_non_nullable
as String?,prerequisites: freezed == prerequisites ? _self.prerequisites : prerequisites // ignore: cast_nullable_to_non_nullable
as String?,coverImage: freezed == coverImage ? _self.coverImage : coverImage // ignore: cast_nullable_to_non_nullable
as String?,additionalDocumentsUrl: freezed == additionalDocumentsUrl ? _self.additionalDocumentsUrl : additionalDocumentsUrl // ignore: cast_nullable_to_non_nullable
as String?,guides: null == guides ? _self._guides : guides // ignore: cast_nullable_to_non_nullable
as List<Guide>,
  ));
}


}


/// @nodoc
mixin _$RamblePrice {

 String get label; double get amount;
/// Create a copy of RamblePrice
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RamblePriceCopyWith<RamblePrice> get copyWith => _$RamblePriceCopyWithImpl<RamblePrice>(this as RamblePrice, _$identity);

  /// Serializes this RamblePrice to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RamblePrice&&(identical(other.label, label) || other.label == label)&&(identical(other.amount, amount) || other.amount == amount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,label,amount);

@override
String toString() {
  return 'RamblePrice(label: $label, amount: $amount)';
}


}

/// @nodoc
abstract mixin class $RamblePriceCopyWith<$Res>  {
  factory $RamblePriceCopyWith(RamblePrice value, $Res Function(RamblePrice) _then) = _$RamblePriceCopyWithImpl;
@useResult
$Res call({
 String label, double amount
});




}
/// @nodoc
class _$RamblePriceCopyWithImpl<$Res>
    implements $RamblePriceCopyWith<$Res> {
  _$RamblePriceCopyWithImpl(this._self, this._then);

  final RamblePrice _self;
  final $Res Function(RamblePrice) _then;

/// Create a copy of RamblePrice
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? label = null,Object? amount = null,}) {
  return _then(_self.copyWith(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [RamblePrice].
extension RamblePricePatterns on RamblePrice {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RamblePrice value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RamblePrice() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RamblePrice value)  $default,){
final _that = this;
switch (_that) {
case _RamblePrice():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RamblePrice value)?  $default,){
final _that = this;
switch (_that) {
case _RamblePrice() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String label,  double amount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RamblePrice() when $default != null:
return $default(_that.label,_that.amount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String label,  double amount)  $default,) {final _that = this;
switch (_that) {
case _RamblePrice():
return $default(_that.label,_that.amount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String label,  double amount)?  $default,) {final _that = this;
switch (_that) {
case _RamblePrice() when $default != null:
return $default(_that.label,_that.amount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RamblePrice implements RamblePrice {
  const _RamblePrice({required this.label, required this.amount});
  factory _RamblePrice.fromJson(Map<String, dynamic> json) => _$RamblePriceFromJson(json);

@override final  String label;
@override final  double amount;

/// Create a copy of RamblePrice
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RamblePriceCopyWith<_RamblePrice> get copyWith => __$RamblePriceCopyWithImpl<_RamblePrice>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RamblePriceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RamblePrice&&(identical(other.label, label) || other.label == label)&&(identical(other.amount, amount) || other.amount == amount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,label,amount);

@override
String toString() {
  return 'RamblePrice(label: $label, amount: $amount)';
}


}

/// @nodoc
abstract mixin class _$RamblePriceCopyWith<$Res> implements $RamblePriceCopyWith<$Res> {
  factory _$RamblePriceCopyWith(_RamblePrice value, $Res Function(_RamblePrice) _then) = __$RamblePriceCopyWithImpl;
@override @useResult
$Res call({
 String label, double amount
});




}
/// @nodoc
class __$RamblePriceCopyWithImpl<$Res>
    implements _$RamblePriceCopyWith<$Res> {
  __$RamblePriceCopyWithImpl(this._self, this._then);

  final _RamblePrice _self;
  final $Res Function(_RamblePrice) _then;

/// Create a copy of RamblePrice
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? label = null,Object? amount = null,}) {
  return _then(_RamblePrice(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
