// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stock_opname.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StockOpname {

 String get id; String get opnameNumber; StockOpnameStatus get status; String? get note; String? get createdBy; DateTime? get finalizedAt; DateTime? get createdAt; int get itemCount;
/// Create a copy of StockOpname
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StockOpnameCopyWith<StockOpname> get copyWith => _$StockOpnameCopyWithImpl<StockOpname>(this as StockOpname, _$identity);

  /// Serializes this StockOpname to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StockOpname&&(identical(other.id, id) || other.id == id)&&(identical(other.opnameNumber, opnameNumber) || other.opnameNumber == opnameNumber)&&(identical(other.status, status) || other.status == status)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.finalizedAt, finalizedAt) || other.finalizedAt == finalizedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.itemCount, itemCount) || other.itemCount == itemCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,opnameNumber,status,note,createdBy,finalizedAt,createdAt,itemCount);

@override
String toString() {
  return 'StockOpname(id: $id, opnameNumber: $opnameNumber, status: $status, note: $note, createdBy: $createdBy, finalizedAt: $finalizedAt, createdAt: $createdAt, itemCount: $itemCount)';
}


}

/// @nodoc
abstract mixin class $StockOpnameCopyWith<$Res>  {
  factory $StockOpnameCopyWith(StockOpname value, $Res Function(StockOpname) _then) = _$StockOpnameCopyWithImpl;
@useResult
$Res call({
 String id, String opnameNumber, StockOpnameStatus status, String? note, String? createdBy, DateTime? finalizedAt, DateTime? createdAt, int itemCount
});




}
/// @nodoc
class _$StockOpnameCopyWithImpl<$Res>
    implements $StockOpnameCopyWith<$Res> {
  _$StockOpnameCopyWithImpl(this._self, this._then);

  final StockOpname _self;
  final $Res Function(StockOpname) _then;

/// Create a copy of StockOpname
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? opnameNumber = null,Object? status = null,Object? note = freezed,Object? createdBy = freezed,Object? finalizedAt = freezed,Object? createdAt = freezed,Object? itemCount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,opnameNumber: null == opnameNumber ? _self.opnameNumber : opnameNumber // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as StockOpnameStatus,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,finalizedAt: freezed == finalizedAt ? _self.finalizedAt : finalizedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,itemCount: null == itemCount ? _self.itemCount : itemCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [StockOpname].
extension StockOpnamePatterns on StockOpname {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StockOpname value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StockOpname() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StockOpname value)  $default,){
final _that = this;
switch (_that) {
case _StockOpname():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StockOpname value)?  $default,){
final _that = this;
switch (_that) {
case _StockOpname() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String opnameNumber,  StockOpnameStatus status,  String? note,  String? createdBy,  DateTime? finalizedAt,  DateTime? createdAt,  int itemCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StockOpname() when $default != null:
return $default(_that.id,_that.opnameNumber,_that.status,_that.note,_that.createdBy,_that.finalizedAt,_that.createdAt,_that.itemCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String opnameNumber,  StockOpnameStatus status,  String? note,  String? createdBy,  DateTime? finalizedAt,  DateTime? createdAt,  int itemCount)  $default,) {final _that = this;
switch (_that) {
case _StockOpname():
return $default(_that.id,_that.opnameNumber,_that.status,_that.note,_that.createdBy,_that.finalizedAt,_that.createdAt,_that.itemCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String opnameNumber,  StockOpnameStatus status,  String? note,  String? createdBy,  DateTime? finalizedAt,  DateTime? createdAt,  int itemCount)?  $default,) {final _that = this;
switch (_that) {
case _StockOpname() when $default != null:
return $default(_that.id,_that.opnameNumber,_that.status,_that.note,_that.createdBy,_that.finalizedAt,_that.createdAt,_that.itemCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StockOpname implements StockOpname {
  const _StockOpname({required this.id, required this.opnameNumber, this.status = StockOpnameStatus.draft, this.note, this.createdBy, this.finalizedAt, this.createdAt, this.itemCount = 0});
  factory _StockOpname.fromJson(Map<String, dynamic> json) => _$StockOpnameFromJson(json);

@override final  String id;
@override final  String opnameNumber;
@override@JsonKey() final  StockOpnameStatus status;
@override final  String? note;
@override final  String? createdBy;
@override final  DateTime? finalizedAt;
@override final  DateTime? createdAt;
@override@JsonKey() final  int itemCount;

/// Create a copy of StockOpname
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StockOpnameCopyWith<_StockOpname> get copyWith => __$StockOpnameCopyWithImpl<_StockOpname>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StockOpnameToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StockOpname&&(identical(other.id, id) || other.id == id)&&(identical(other.opnameNumber, opnameNumber) || other.opnameNumber == opnameNumber)&&(identical(other.status, status) || other.status == status)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.finalizedAt, finalizedAt) || other.finalizedAt == finalizedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.itemCount, itemCount) || other.itemCount == itemCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,opnameNumber,status,note,createdBy,finalizedAt,createdAt,itemCount);

@override
String toString() {
  return 'StockOpname(id: $id, opnameNumber: $opnameNumber, status: $status, note: $note, createdBy: $createdBy, finalizedAt: $finalizedAt, createdAt: $createdAt, itemCount: $itemCount)';
}


}

/// @nodoc
abstract mixin class _$StockOpnameCopyWith<$Res> implements $StockOpnameCopyWith<$Res> {
  factory _$StockOpnameCopyWith(_StockOpname value, $Res Function(_StockOpname) _then) = __$StockOpnameCopyWithImpl;
@override @useResult
$Res call({
 String id, String opnameNumber, StockOpnameStatus status, String? note, String? createdBy, DateTime? finalizedAt, DateTime? createdAt, int itemCount
});




}
/// @nodoc
class __$StockOpnameCopyWithImpl<$Res>
    implements _$StockOpnameCopyWith<$Res> {
  __$StockOpnameCopyWithImpl(this._self, this._then);

  final _StockOpname _self;
  final $Res Function(_StockOpname) _then;

/// Create a copy of StockOpname
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? opnameNumber = null,Object? status = null,Object? note = freezed,Object? createdBy = freezed,Object? finalizedAt = freezed,Object? createdAt = freezed,Object? itemCount = null,}) {
  return _then(_StockOpname(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,opnameNumber: null == opnameNumber ? _self.opnameNumber : opnameNumber // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as StockOpnameStatus,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,finalizedAt: freezed == finalizedAt ? _self.finalizedAt : finalizedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,itemCount: null == itemCount ? _self.itemCount : itemCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$StockOpnameItem {

 String get id; String get opnameId; String get productId; String? get productName; String? get productSku; String? get unit;@JsonKey(fromJson: jsonToDouble, toJson: doubleToJson) double get systemQty;@JsonKey(fromJson: jsonToDouble, toJson: doubleToJson) double get countedQty;@JsonKey(fromJson: jsonToDouble, toJson: doubleToJson) double get difference;
/// Create a copy of StockOpnameItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StockOpnameItemCopyWith<StockOpnameItem> get copyWith => _$StockOpnameItemCopyWithImpl<StockOpnameItem>(this as StockOpnameItem, _$identity);

  /// Serializes this StockOpnameItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StockOpnameItem&&(identical(other.id, id) || other.id == id)&&(identical(other.opnameId, opnameId) || other.opnameId == opnameId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.productSku, productSku) || other.productSku == productSku)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.systemQty, systemQty) || other.systemQty == systemQty)&&(identical(other.countedQty, countedQty) || other.countedQty == countedQty)&&(identical(other.difference, difference) || other.difference == difference));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,opnameId,productId,productName,productSku,unit,systemQty,countedQty,difference);

@override
String toString() {
  return 'StockOpnameItem(id: $id, opnameId: $opnameId, productId: $productId, productName: $productName, productSku: $productSku, unit: $unit, systemQty: $systemQty, countedQty: $countedQty, difference: $difference)';
}


}

/// @nodoc
abstract mixin class $StockOpnameItemCopyWith<$Res>  {
  factory $StockOpnameItemCopyWith(StockOpnameItem value, $Res Function(StockOpnameItem) _then) = _$StockOpnameItemCopyWithImpl;
@useResult
$Res call({
 String id, String opnameId, String productId, String? productName, String? productSku, String? unit,@JsonKey(fromJson: jsonToDouble, toJson: doubleToJson) double systemQty,@JsonKey(fromJson: jsonToDouble, toJson: doubleToJson) double countedQty,@JsonKey(fromJson: jsonToDouble, toJson: doubleToJson) double difference
});




}
/// @nodoc
class _$StockOpnameItemCopyWithImpl<$Res>
    implements $StockOpnameItemCopyWith<$Res> {
  _$StockOpnameItemCopyWithImpl(this._self, this._then);

  final StockOpnameItem _self;
  final $Res Function(StockOpnameItem) _then;

/// Create a copy of StockOpnameItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? opnameId = null,Object? productId = null,Object? productName = freezed,Object? productSku = freezed,Object? unit = freezed,Object? systemQty = null,Object? countedQty = null,Object? difference = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,opnameId: null == opnameId ? _self.opnameId : opnameId // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,productName: freezed == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String?,productSku: freezed == productSku ? _self.productSku : productSku // ignore: cast_nullable_to_non_nullable
as String?,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String?,systemQty: null == systemQty ? _self.systemQty : systemQty // ignore: cast_nullable_to_non_nullable
as double,countedQty: null == countedQty ? _self.countedQty : countedQty // ignore: cast_nullable_to_non_nullable
as double,difference: null == difference ? _self.difference : difference // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [StockOpnameItem].
extension StockOpnameItemPatterns on StockOpnameItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StockOpnameItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StockOpnameItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StockOpnameItem value)  $default,){
final _that = this;
switch (_that) {
case _StockOpnameItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StockOpnameItem value)?  $default,){
final _that = this;
switch (_that) {
case _StockOpnameItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String opnameId,  String productId,  String? productName,  String? productSku,  String? unit, @JsonKey(fromJson: jsonToDouble, toJson: doubleToJson)  double systemQty, @JsonKey(fromJson: jsonToDouble, toJson: doubleToJson)  double countedQty, @JsonKey(fromJson: jsonToDouble, toJson: doubleToJson)  double difference)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StockOpnameItem() when $default != null:
return $default(_that.id,_that.opnameId,_that.productId,_that.productName,_that.productSku,_that.unit,_that.systemQty,_that.countedQty,_that.difference);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String opnameId,  String productId,  String? productName,  String? productSku,  String? unit, @JsonKey(fromJson: jsonToDouble, toJson: doubleToJson)  double systemQty, @JsonKey(fromJson: jsonToDouble, toJson: doubleToJson)  double countedQty, @JsonKey(fromJson: jsonToDouble, toJson: doubleToJson)  double difference)  $default,) {final _that = this;
switch (_that) {
case _StockOpnameItem():
return $default(_that.id,_that.opnameId,_that.productId,_that.productName,_that.productSku,_that.unit,_that.systemQty,_that.countedQty,_that.difference);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String opnameId,  String productId,  String? productName,  String? productSku,  String? unit, @JsonKey(fromJson: jsonToDouble, toJson: doubleToJson)  double systemQty, @JsonKey(fromJson: jsonToDouble, toJson: doubleToJson)  double countedQty, @JsonKey(fromJson: jsonToDouble, toJson: doubleToJson)  double difference)?  $default,) {final _that = this;
switch (_that) {
case _StockOpnameItem() when $default != null:
return $default(_that.id,_that.opnameId,_that.productId,_that.productName,_that.productSku,_that.unit,_that.systemQty,_that.countedQty,_that.difference);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StockOpnameItem implements StockOpnameItem {
  const _StockOpnameItem({required this.id, required this.opnameId, required this.productId, this.productName, this.productSku, this.unit, @JsonKey(fromJson: jsonToDouble, toJson: doubleToJson) this.systemQty = 0, @JsonKey(fromJson: jsonToDouble, toJson: doubleToJson) this.countedQty = 0, @JsonKey(fromJson: jsonToDouble, toJson: doubleToJson) this.difference = 0});
  factory _StockOpnameItem.fromJson(Map<String, dynamic> json) => _$StockOpnameItemFromJson(json);

@override final  String id;
@override final  String opnameId;
@override final  String productId;
@override final  String? productName;
@override final  String? productSku;
@override final  String? unit;
@override@JsonKey(fromJson: jsonToDouble, toJson: doubleToJson) final  double systemQty;
@override@JsonKey(fromJson: jsonToDouble, toJson: doubleToJson) final  double countedQty;
@override@JsonKey(fromJson: jsonToDouble, toJson: doubleToJson) final  double difference;

/// Create a copy of StockOpnameItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StockOpnameItemCopyWith<_StockOpnameItem> get copyWith => __$StockOpnameItemCopyWithImpl<_StockOpnameItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StockOpnameItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StockOpnameItem&&(identical(other.id, id) || other.id == id)&&(identical(other.opnameId, opnameId) || other.opnameId == opnameId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.productSku, productSku) || other.productSku == productSku)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.systemQty, systemQty) || other.systemQty == systemQty)&&(identical(other.countedQty, countedQty) || other.countedQty == countedQty)&&(identical(other.difference, difference) || other.difference == difference));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,opnameId,productId,productName,productSku,unit,systemQty,countedQty,difference);

@override
String toString() {
  return 'StockOpnameItem(id: $id, opnameId: $opnameId, productId: $productId, productName: $productName, productSku: $productSku, unit: $unit, systemQty: $systemQty, countedQty: $countedQty, difference: $difference)';
}


}

/// @nodoc
abstract mixin class _$StockOpnameItemCopyWith<$Res> implements $StockOpnameItemCopyWith<$Res> {
  factory _$StockOpnameItemCopyWith(_StockOpnameItem value, $Res Function(_StockOpnameItem) _then) = __$StockOpnameItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String opnameId, String productId, String? productName, String? productSku, String? unit,@JsonKey(fromJson: jsonToDouble, toJson: doubleToJson) double systemQty,@JsonKey(fromJson: jsonToDouble, toJson: doubleToJson) double countedQty,@JsonKey(fromJson: jsonToDouble, toJson: doubleToJson) double difference
});




}
/// @nodoc
class __$StockOpnameItemCopyWithImpl<$Res>
    implements _$StockOpnameItemCopyWith<$Res> {
  __$StockOpnameItemCopyWithImpl(this._self, this._then);

  final _StockOpnameItem _self;
  final $Res Function(_StockOpnameItem) _then;

/// Create a copy of StockOpnameItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? opnameId = null,Object? productId = null,Object? productName = freezed,Object? productSku = freezed,Object? unit = freezed,Object? systemQty = null,Object? countedQty = null,Object? difference = null,}) {
  return _then(_StockOpnameItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,opnameId: null == opnameId ? _self.opnameId : opnameId // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,productName: freezed == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String?,productSku: freezed == productSku ? _self.productSku : productSku // ignore: cast_nullable_to_non_nullable
as String?,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String?,systemQty: null == systemQty ? _self.systemQty : systemQty // ignore: cast_nullable_to_non_nullable
as double,countedQty: null == countedQty ? _self.countedQty : countedQty // ignore: cast_nullable_to_non_nullable
as double,difference: null == difference ? _self.difference : difference // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$StockOpnameDetail {

 StockOpname get opname; List<StockOpnameItem> get items;
/// Create a copy of StockOpnameDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StockOpnameDetailCopyWith<StockOpnameDetail> get copyWith => _$StockOpnameDetailCopyWithImpl<StockOpnameDetail>(this as StockOpnameDetail, _$identity);

  /// Serializes this StockOpnameDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StockOpnameDetail&&(identical(other.opname, opname) || other.opname == opname)&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,opname,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'StockOpnameDetail(opname: $opname, items: $items)';
}


}

/// @nodoc
abstract mixin class $StockOpnameDetailCopyWith<$Res>  {
  factory $StockOpnameDetailCopyWith(StockOpnameDetail value, $Res Function(StockOpnameDetail) _then) = _$StockOpnameDetailCopyWithImpl;
@useResult
$Res call({
 StockOpname opname, List<StockOpnameItem> items
});


$StockOpnameCopyWith<$Res> get opname;

}
/// @nodoc
class _$StockOpnameDetailCopyWithImpl<$Res>
    implements $StockOpnameDetailCopyWith<$Res> {
  _$StockOpnameDetailCopyWithImpl(this._self, this._then);

  final StockOpnameDetail _self;
  final $Res Function(StockOpnameDetail) _then;

/// Create a copy of StockOpnameDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? opname = null,Object? items = null,}) {
  return _then(_self.copyWith(
opname: null == opname ? _self.opname : opname // ignore: cast_nullable_to_non_nullable
as StockOpname,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<StockOpnameItem>,
  ));
}
/// Create a copy of StockOpnameDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StockOpnameCopyWith<$Res> get opname {
  
  return $StockOpnameCopyWith<$Res>(_self.opname, (value) {
    return _then(_self.copyWith(opname: value));
  });
}
}


/// Adds pattern-matching-related methods to [StockOpnameDetail].
extension StockOpnameDetailPatterns on StockOpnameDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StockOpnameDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StockOpnameDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StockOpnameDetail value)  $default,){
final _that = this;
switch (_that) {
case _StockOpnameDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StockOpnameDetail value)?  $default,){
final _that = this;
switch (_that) {
case _StockOpnameDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( StockOpname opname,  List<StockOpnameItem> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StockOpnameDetail() when $default != null:
return $default(_that.opname,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( StockOpname opname,  List<StockOpnameItem> items)  $default,) {final _that = this;
switch (_that) {
case _StockOpnameDetail():
return $default(_that.opname,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( StockOpname opname,  List<StockOpnameItem> items)?  $default,) {final _that = this;
switch (_that) {
case _StockOpnameDetail() when $default != null:
return $default(_that.opname,_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StockOpnameDetail implements StockOpnameDetail {
  const _StockOpnameDetail({required this.opname, final  List<StockOpnameItem> items = const <StockOpnameItem>[]}): _items = items;
  factory _StockOpnameDetail.fromJson(Map<String, dynamic> json) => _$StockOpnameDetailFromJson(json);

@override final  StockOpname opname;
 final  List<StockOpnameItem> _items;
@override@JsonKey() List<StockOpnameItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of StockOpnameDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StockOpnameDetailCopyWith<_StockOpnameDetail> get copyWith => __$StockOpnameDetailCopyWithImpl<_StockOpnameDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StockOpnameDetailToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StockOpnameDetail&&(identical(other.opname, opname) || other.opname == opname)&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,opname,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'StockOpnameDetail(opname: $opname, items: $items)';
}


}

/// @nodoc
abstract mixin class _$StockOpnameDetailCopyWith<$Res> implements $StockOpnameDetailCopyWith<$Res> {
  factory _$StockOpnameDetailCopyWith(_StockOpnameDetail value, $Res Function(_StockOpnameDetail) _then) = __$StockOpnameDetailCopyWithImpl;
@override @useResult
$Res call({
 StockOpname opname, List<StockOpnameItem> items
});


@override $StockOpnameCopyWith<$Res> get opname;

}
/// @nodoc
class __$StockOpnameDetailCopyWithImpl<$Res>
    implements _$StockOpnameDetailCopyWith<$Res> {
  __$StockOpnameDetailCopyWithImpl(this._self, this._then);

  final _StockOpnameDetail _self;
  final $Res Function(_StockOpnameDetail) _then;

/// Create a copy of StockOpnameDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? opname = null,Object? items = null,}) {
  return _then(_StockOpnameDetail(
opname: null == opname ? _self.opname : opname // ignore: cast_nullable_to_non_nullable
as StockOpname,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<StockOpnameItem>,
  ));
}

/// Create a copy of StockOpnameDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StockOpnameCopyWith<$Res> get opname {
  
  return $StockOpnameCopyWith<$Res>(_self.opname, (value) {
    return _then(_self.copyWith(opname: value));
  });
}
}

// dart format on
