// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'purchase_order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PurchaseOrder {

 String get id; String get poNumber; String get supplierId; String? get supplierName; PurchaseOrderStatus get status;@JsonKey(fromJson: jsonToDouble, toJson: doubleToJson) double get total; String? get note; String? get createdBy; DateTime? get approvedAt; DateTime? get receivedAt; DateTime? get createdAt; int get itemCount;
/// Create a copy of PurchaseOrder
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PurchaseOrderCopyWith<PurchaseOrder> get copyWith => _$PurchaseOrderCopyWithImpl<PurchaseOrder>(this as PurchaseOrder, _$identity);

  /// Serializes this PurchaseOrder to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PurchaseOrder&&(identical(other.id, id) || other.id == id)&&(identical(other.poNumber, poNumber) || other.poNumber == poNumber)&&(identical(other.supplierId, supplierId) || other.supplierId == supplierId)&&(identical(other.supplierName, supplierName) || other.supplierName == supplierName)&&(identical(other.status, status) || other.status == status)&&(identical(other.total, total) || other.total == total)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.approvedAt, approvedAt) || other.approvedAt == approvedAt)&&(identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.itemCount, itemCount) || other.itemCount == itemCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,poNumber,supplierId,supplierName,status,total,note,createdBy,approvedAt,receivedAt,createdAt,itemCount);

@override
String toString() {
  return 'PurchaseOrder(id: $id, poNumber: $poNumber, supplierId: $supplierId, supplierName: $supplierName, status: $status, total: $total, note: $note, createdBy: $createdBy, approvedAt: $approvedAt, receivedAt: $receivedAt, createdAt: $createdAt, itemCount: $itemCount)';
}


}

/// @nodoc
abstract mixin class $PurchaseOrderCopyWith<$Res>  {
  factory $PurchaseOrderCopyWith(PurchaseOrder value, $Res Function(PurchaseOrder) _then) = _$PurchaseOrderCopyWithImpl;
@useResult
$Res call({
 String id, String poNumber, String supplierId, String? supplierName, PurchaseOrderStatus status,@JsonKey(fromJson: jsonToDouble, toJson: doubleToJson) double total, String? note, String? createdBy, DateTime? approvedAt, DateTime? receivedAt, DateTime? createdAt, int itemCount
});




}
/// @nodoc
class _$PurchaseOrderCopyWithImpl<$Res>
    implements $PurchaseOrderCopyWith<$Res> {
  _$PurchaseOrderCopyWithImpl(this._self, this._then);

  final PurchaseOrder _self;
  final $Res Function(PurchaseOrder) _then;

/// Create a copy of PurchaseOrder
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? poNumber = null,Object? supplierId = null,Object? supplierName = freezed,Object? status = null,Object? total = null,Object? note = freezed,Object? createdBy = freezed,Object? approvedAt = freezed,Object? receivedAt = freezed,Object? createdAt = freezed,Object? itemCount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,poNumber: null == poNumber ? _self.poNumber : poNumber // ignore: cast_nullable_to_non_nullable
as String,supplierId: null == supplierId ? _self.supplierId : supplierId // ignore: cast_nullable_to_non_nullable
as String,supplierName: freezed == supplierName ? _self.supplierName : supplierName // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PurchaseOrderStatus,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as double,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,approvedAt: freezed == approvedAt ? _self.approvedAt : approvedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,receivedAt: freezed == receivedAt ? _self.receivedAt : receivedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,itemCount: null == itemCount ? _self.itemCount : itemCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PurchaseOrder].
extension PurchaseOrderPatterns on PurchaseOrder {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PurchaseOrder value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PurchaseOrder() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PurchaseOrder value)  $default,){
final _that = this;
switch (_that) {
case _PurchaseOrder():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PurchaseOrder value)?  $default,){
final _that = this;
switch (_that) {
case _PurchaseOrder() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String poNumber,  String supplierId,  String? supplierName,  PurchaseOrderStatus status, @JsonKey(fromJson: jsonToDouble, toJson: doubleToJson)  double total,  String? note,  String? createdBy,  DateTime? approvedAt,  DateTime? receivedAt,  DateTime? createdAt,  int itemCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PurchaseOrder() when $default != null:
return $default(_that.id,_that.poNumber,_that.supplierId,_that.supplierName,_that.status,_that.total,_that.note,_that.createdBy,_that.approvedAt,_that.receivedAt,_that.createdAt,_that.itemCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String poNumber,  String supplierId,  String? supplierName,  PurchaseOrderStatus status, @JsonKey(fromJson: jsonToDouble, toJson: doubleToJson)  double total,  String? note,  String? createdBy,  DateTime? approvedAt,  DateTime? receivedAt,  DateTime? createdAt,  int itemCount)  $default,) {final _that = this;
switch (_that) {
case _PurchaseOrder():
return $default(_that.id,_that.poNumber,_that.supplierId,_that.supplierName,_that.status,_that.total,_that.note,_that.createdBy,_that.approvedAt,_that.receivedAt,_that.createdAt,_that.itemCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String poNumber,  String supplierId,  String? supplierName,  PurchaseOrderStatus status, @JsonKey(fromJson: jsonToDouble, toJson: doubleToJson)  double total,  String? note,  String? createdBy,  DateTime? approvedAt,  DateTime? receivedAt,  DateTime? createdAt,  int itemCount)?  $default,) {final _that = this;
switch (_that) {
case _PurchaseOrder() when $default != null:
return $default(_that.id,_that.poNumber,_that.supplierId,_that.supplierName,_that.status,_that.total,_that.note,_that.createdBy,_that.approvedAt,_that.receivedAt,_that.createdAt,_that.itemCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PurchaseOrder implements PurchaseOrder {
  const _PurchaseOrder({required this.id, required this.poNumber, required this.supplierId, this.supplierName, this.status = PurchaseOrderStatus.draft, @JsonKey(fromJson: jsonToDouble, toJson: doubleToJson) this.total = 0, this.note, this.createdBy, this.approvedAt, this.receivedAt, this.createdAt, this.itemCount = 0});
  factory _PurchaseOrder.fromJson(Map<String, dynamic> json) => _$PurchaseOrderFromJson(json);

@override final  String id;
@override final  String poNumber;
@override final  String supplierId;
@override final  String? supplierName;
@override@JsonKey() final  PurchaseOrderStatus status;
@override@JsonKey(fromJson: jsonToDouble, toJson: doubleToJson) final  double total;
@override final  String? note;
@override final  String? createdBy;
@override final  DateTime? approvedAt;
@override final  DateTime? receivedAt;
@override final  DateTime? createdAt;
@override@JsonKey() final  int itemCount;

/// Create a copy of PurchaseOrder
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PurchaseOrderCopyWith<_PurchaseOrder> get copyWith => __$PurchaseOrderCopyWithImpl<_PurchaseOrder>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PurchaseOrderToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PurchaseOrder&&(identical(other.id, id) || other.id == id)&&(identical(other.poNumber, poNumber) || other.poNumber == poNumber)&&(identical(other.supplierId, supplierId) || other.supplierId == supplierId)&&(identical(other.supplierName, supplierName) || other.supplierName == supplierName)&&(identical(other.status, status) || other.status == status)&&(identical(other.total, total) || other.total == total)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.approvedAt, approvedAt) || other.approvedAt == approvedAt)&&(identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.itemCount, itemCount) || other.itemCount == itemCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,poNumber,supplierId,supplierName,status,total,note,createdBy,approvedAt,receivedAt,createdAt,itemCount);

@override
String toString() {
  return 'PurchaseOrder(id: $id, poNumber: $poNumber, supplierId: $supplierId, supplierName: $supplierName, status: $status, total: $total, note: $note, createdBy: $createdBy, approvedAt: $approvedAt, receivedAt: $receivedAt, createdAt: $createdAt, itemCount: $itemCount)';
}


}

/// @nodoc
abstract mixin class _$PurchaseOrderCopyWith<$Res> implements $PurchaseOrderCopyWith<$Res> {
  factory _$PurchaseOrderCopyWith(_PurchaseOrder value, $Res Function(_PurchaseOrder) _then) = __$PurchaseOrderCopyWithImpl;
@override @useResult
$Res call({
 String id, String poNumber, String supplierId, String? supplierName, PurchaseOrderStatus status,@JsonKey(fromJson: jsonToDouble, toJson: doubleToJson) double total, String? note, String? createdBy, DateTime? approvedAt, DateTime? receivedAt, DateTime? createdAt, int itemCount
});




}
/// @nodoc
class __$PurchaseOrderCopyWithImpl<$Res>
    implements _$PurchaseOrderCopyWith<$Res> {
  __$PurchaseOrderCopyWithImpl(this._self, this._then);

  final _PurchaseOrder _self;
  final $Res Function(_PurchaseOrder) _then;

/// Create a copy of PurchaseOrder
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? poNumber = null,Object? supplierId = null,Object? supplierName = freezed,Object? status = null,Object? total = null,Object? note = freezed,Object? createdBy = freezed,Object? approvedAt = freezed,Object? receivedAt = freezed,Object? createdAt = freezed,Object? itemCount = null,}) {
  return _then(_PurchaseOrder(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,poNumber: null == poNumber ? _self.poNumber : poNumber // ignore: cast_nullable_to_non_nullable
as String,supplierId: null == supplierId ? _self.supplierId : supplierId // ignore: cast_nullable_to_non_nullable
as String,supplierName: freezed == supplierName ? _self.supplierName : supplierName // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PurchaseOrderStatus,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as double,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,approvedAt: freezed == approvedAt ? _self.approvedAt : approvedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,receivedAt: freezed == receivedAt ? _self.receivedAt : receivedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,itemCount: null == itemCount ? _self.itemCount : itemCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$PurchaseOrderItem {

 String get id; String get purchaseOrderId; String get productId; String? get productName; String? get productSku; String? get unit;@JsonKey(fromJson: jsonToDouble, toJson: doubleToJson) double get qty;@JsonKey(fromJson: jsonToDouble, toJson: doubleToJson) double get price;@JsonKey(fromJson: jsonToDouble, toJson: doubleToJson) double get subtotal;
/// Create a copy of PurchaseOrderItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PurchaseOrderItemCopyWith<PurchaseOrderItem> get copyWith => _$PurchaseOrderItemCopyWithImpl<PurchaseOrderItem>(this as PurchaseOrderItem, _$identity);

  /// Serializes this PurchaseOrderItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PurchaseOrderItem&&(identical(other.id, id) || other.id == id)&&(identical(other.purchaseOrderId, purchaseOrderId) || other.purchaseOrderId == purchaseOrderId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.productSku, productSku) || other.productSku == productSku)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.qty, qty) || other.qty == qty)&&(identical(other.price, price) || other.price == price)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,purchaseOrderId,productId,productName,productSku,unit,qty,price,subtotal);

@override
String toString() {
  return 'PurchaseOrderItem(id: $id, purchaseOrderId: $purchaseOrderId, productId: $productId, productName: $productName, productSku: $productSku, unit: $unit, qty: $qty, price: $price, subtotal: $subtotal)';
}


}

/// @nodoc
abstract mixin class $PurchaseOrderItemCopyWith<$Res>  {
  factory $PurchaseOrderItemCopyWith(PurchaseOrderItem value, $Res Function(PurchaseOrderItem) _then) = _$PurchaseOrderItemCopyWithImpl;
@useResult
$Res call({
 String id, String purchaseOrderId, String productId, String? productName, String? productSku, String? unit,@JsonKey(fromJson: jsonToDouble, toJson: doubleToJson) double qty,@JsonKey(fromJson: jsonToDouble, toJson: doubleToJson) double price,@JsonKey(fromJson: jsonToDouble, toJson: doubleToJson) double subtotal
});




}
/// @nodoc
class _$PurchaseOrderItemCopyWithImpl<$Res>
    implements $PurchaseOrderItemCopyWith<$Res> {
  _$PurchaseOrderItemCopyWithImpl(this._self, this._then);

  final PurchaseOrderItem _self;
  final $Res Function(PurchaseOrderItem) _then;

/// Create a copy of PurchaseOrderItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? purchaseOrderId = null,Object? productId = null,Object? productName = freezed,Object? productSku = freezed,Object? unit = freezed,Object? qty = null,Object? price = null,Object? subtotal = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,purchaseOrderId: null == purchaseOrderId ? _self.purchaseOrderId : purchaseOrderId // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,productName: freezed == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String?,productSku: freezed == productSku ? _self.productSku : productSku // ignore: cast_nullable_to_non_nullable
as String?,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String?,qty: null == qty ? _self.qty : qty // ignore: cast_nullable_to_non_nullable
as double,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [PurchaseOrderItem].
extension PurchaseOrderItemPatterns on PurchaseOrderItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PurchaseOrderItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PurchaseOrderItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PurchaseOrderItem value)  $default,){
final _that = this;
switch (_that) {
case _PurchaseOrderItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PurchaseOrderItem value)?  $default,){
final _that = this;
switch (_that) {
case _PurchaseOrderItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String purchaseOrderId,  String productId,  String? productName,  String? productSku,  String? unit, @JsonKey(fromJson: jsonToDouble, toJson: doubleToJson)  double qty, @JsonKey(fromJson: jsonToDouble, toJson: doubleToJson)  double price, @JsonKey(fromJson: jsonToDouble, toJson: doubleToJson)  double subtotal)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PurchaseOrderItem() when $default != null:
return $default(_that.id,_that.purchaseOrderId,_that.productId,_that.productName,_that.productSku,_that.unit,_that.qty,_that.price,_that.subtotal);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String purchaseOrderId,  String productId,  String? productName,  String? productSku,  String? unit, @JsonKey(fromJson: jsonToDouble, toJson: doubleToJson)  double qty, @JsonKey(fromJson: jsonToDouble, toJson: doubleToJson)  double price, @JsonKey(fromJson: jsonToDouble, toJson: doubleToJson)  double subtotal)  $default,) {final _that = this;
switch (_that) {
case _PurchaseOrderItem():
return $default(_that.id,_that.purchaseOrderId,_that.productId,_that.productName,_that.productSku,_that.unit,_that.qty,_that.price,_that.subtotal);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String purchaseOrderId,  String productId,  String? productName,  String? productSku,  String? unit, @JsonKey(fromJson: jsonToDouble, toJson: doubleToJson)  double qty, @JsonKey(fromJson: jsonToDouble, toJson: doubleToJson)  double price, @JsonKey(fromJson: jsonToDouble, toJson: doubleToJson)  double subtotal)?  $default,) {final _that = this;
switch (_that) {
case _PurchaseOrderItem() when $default != null:
return $default(_that.id,_that.purchaseOrderId,_that.productId,_that.productName,_that.productSku,_that.unit,_that.qty,_that.price,_that.subtotal);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PurchaseOrderItem implements PurchaseOrderItem {
  const _PurchaseOrderItem({required this.id, required this.purchaseOrderId, required this.productId, this.productName, this.productSku, this.unit, @JsonKey(fromJson: jsonToDouble, toJson: doubleToJson) this.qty = 0, @JsonKey(fromJson: jsonToDouble, toJson: doubleToJson) this.price = 0, @JsonKey(fromJson: jsonToDouble, toJson: doubleToJson) this.subtotal = 0});
  factory _PurchaseOrderItem.fromJson(Map<String, dynamic> json) => _$PurchaseOrderItemFromJson(json);

@override final  String id;
@override final  String purchaseOrderId;
@override final  String productId;
@override final  String? productName;
@override final  String? productSku;
@override final  String? unit;
@override@JsonKey(fromJson: jsonToDouble, toJson: doubleToJson) final  double qty;
@override@JsonKey(fromJson: jsonToDouble, toJson: doubleToJson) final  double price;
@override@JsonKey(fromJson: jsonToDouble, toJson: doubleToJson) final  double subtotal;

/// Create a copy of PurchaseOrderItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PurchaseOrderItemCopyWith<_PurchaseOrderItem> get copyWith => __$PurchaseOrderItemCopyWithImpl<_PurchaseOrderItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PurchaseOrderItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PurchaseOrderItem&&(identical(other.id, id) || other.id == id)&&(identical(other.purchaseOrderId, purchaseOrderId) || other.purchaseOrderId == purchaseOrderId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.productSku, productSku) || other.productSku == productSku)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.qty, qty) || other.qty == qty)&&(identical(other.price, price) || other.price == price)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,purchaseOrderId,productId,productName,productSku,unit,qty,price,subtotal);

@override
String toString() {
  return 'PurchaseOrderItem(id: $id, purchaseOrderId: $purchaseOrderId, productId: $productId, productName: $productName, productSku: $productSku, unit: $unit, qty: $qty, price: $price, subtotal: $subtotal)';
}


}

/// @nodoc
abstract mixin class _$PurchaseOrderItemCopyWith<$Res> implements $PurchaseOrderItemCopyWith<$Res> {
  factory _$PurchaseOrderItemCopyWith(_PurchaseOrderItem value, $Res Function(_PurchaseOrderItem) _then) = __$PurchaseOrderItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String purchaseOrderId, String productId, String? productName, String? productSku, String? unit,@JsonKey(fromJson: jsonToDouble, toJson: doubleToJson) double qty,@JsonKey(fromJson: jsonToDouble, toJson: doubleToJson) double price,@JsonKey(fromJson: jsonToDouble, toJson: doubleToJson) double subtotal
});




}
/// @nodoc
class __$PurchaseOrderItemCopyWithImpl<$Res>
    implements _$PurchaseOrderItemCopyWith<$Res> {
  __$PurchaseOrderItemCopyWithImpl(this._self, this._then);

  final _PurchaseOrderItem _self;
  final $Res Function(_PurchaseOrderItem) _then;

/// Create a copy of PurchaseOrderItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? purchaseOrderId = null,Object? productId = null,Object? productName = freezed,Object? productSku = freezed,Object? unit = freezed,Object? qty = null,Object? price = null,Object? subtotal = null,}) {
  return _then(_PurchaseOrderItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,purchaseOrderId: null == purchaseOrderId ? _self.purchaseOrderId : purchaseOrderId // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,productName: freezed == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String?,productSku: freezed == productSku ? _self.productSku : productSku // ignore: cast_nullable_to_non_nullable
as String?,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String?,qty: null == qty ? _self.qty : qty // ignore: cast_nullable_to_non_nullable
as double,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$PurchaseOrderDetail {

 PurchaseOrder get order; List<PurchaseOrderItem> get items;
/// Create a copy of PurchaseOrderDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PurchaseOrderDetailCopyWith<PurchaseOrderDetail> get copyWith => _$PurchaseOrderDetailCopyWithImpl<PurchaseOrderDetail>(this as PurchaseOrderDetail, _$identity);

  /// Serializes this PurchaseOrderDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PurchaseOrderDetail&&(identical(other.order, order) || other.order == order)&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,order,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'PurchaseOrderDetail(order: $order, items: $items)';
}


}

/// @nodoc
abstract mixin class $PurchaseOrderDetailCopyWith<$Res>  {
  factory $PurchaseOrderDetailCopyWith(PurchaseOrderDetail value, $Res Function(PurchaseOrderDetail) _then) = _$PurchaseOrderDetailCopyWithImpl;
@useResult
$Res call({
 PurchaseOrder order, List<PurchaseOrderItem> items
});


$PurchaseOrderCopyWith<$Res> get order;

}
/// @nodoc
class _$PurchaseOrderDetailCopyWithImpl<$Res>
    implements $PurchaseOrderDetailCopyWith<$Res> {
  _$PurchaseOrderDetailCopyWithImpl(this._self, this._then);

  final PurchaseOrderDetail _self;
  final $Res Function(PurchaseOrderDetail) _then;

/// Create a copy of PurchaseOrderDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? order = null,Object? items = null,}) {
  return _then(_self.copyWith(
order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as PurchaseOrder,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<PurchaseOrderItem>,
  ));
}
/// Create a copy of PurchaseOrderDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PurchaseOrderCopyWith<$Res> get order {
  
  return $PurchaseOrderCopyWith<$Res>(_self.order, (value) {
    return _then(_self.copyWith(order: value));
  });
}
}


/// Adds pattern-matching-related methods to [PurchaseOrderDetail].
extension PurchaseOrderDetailPatterns on PurchaseOrderDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PurchaseOrderDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PurchaseOrderDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PurchaseOrderDetail value)  $default,){
final _that = this;
switch (_that) {
case _PurchaseOrderDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PurchaseOrderDetail value)?  $default,){
final _that = this;
switch (_that) {
case _PurchaseOrderDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PurchaseOrder order,  List<PurchaseOrderItem> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PurchaseOrderDetail() when $default != null:
return $default(_that.order,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PurchaseOrder order,  List<PurchaseOrderItem> items)  $default,) {final _that = this;
switch (_that) {
case _PurchaseOrderDetail():
return $default(_that.order,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PurchaseOrder order,  List<PurchaseOrderItem> items)?  $default,) {final _that = this;
switch (_that) {
case _PurchaseOrderDetail() when $default != null:
return $default(_that.order,_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PurchaseOrderDetail implements PurchaseOrderDetail {
  const _PurchaseOrderDetail({required this.order, final  List<PurchaseOrderItem> items = const <PurchaseOrderItem>[]}): _items = items;
  factory _PurchaseOrderDetail.fromJson(Map<String, dynamic> json) => _$PurchaseOrderDetailFromJson(json);

@override final  PurchaseOrder order;
 final  List<PurchaseOrderItem> _items;
@override@JsonKey() List<PurchaseOrderItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of PurchaseOrderDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PurchaseOrderDetailCopyWith<_PurchaseOrderDetail> get copyWith => __$PurchaseOrderDetailCopyWithImpl<_PurchaseOrderDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PurchaseOrderDetailToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PurchaseOrderDetail&&(identical(other.order, order) || other.order == order)&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,order,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'PurchaseOrderDetail(order: $order, items: $items)';
}


}

/// @nodoc
abstract mixin class _$PurchaseOrderDetailCopyWith<$Res> implements $PurchaseOrderDetailCopyWith<$Res> {
  factory _$PurchaseOrderDetailCopyWith(_PurchaseOrderDetail value, $Res Function(_PurchaseOrderDetail) _then) = __$PurchaseOrderDetailCopyWithImpl;
@override @useResult
$Res call({
 PurchaseOrder order, List<PurchaseOrderItem> items
});


@override $PurchaseOrderCopyWith<$Res> get order;

}
/// @nodoc
class __$PurchaseOrderDetailCopyWithImpl<$Res>
    implements _$PurchaseOrderDetailCopyWith<$Res> {
  __$PurchaseOrderDetailCopyWithImpl(this._self, this._then);

  final _PurchaseOrderDetail _self;
  final $Res Function(_PurchaseOrderDetail) _then;

/// Create a copy of PurchaseOrderDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? order = null,Object? items = null,}) {
  return _then(_PurchaseOrderDetail(
order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as PurchaseOrder,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<PurchaseOrderItem>,
  ));
}

/// Create a copy of PurchaseOrderDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PurchaseOrderCopyWith<$Res> get order {
  
  return $PurchaseOrderCopyWith<$Res>(_self.order, (value) {
    return _then(_self.copyWith(order: value));
  });
}
}

// dart format on
