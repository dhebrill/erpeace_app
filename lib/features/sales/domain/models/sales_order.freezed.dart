// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sales_order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SalesOrder {

 String get id; String get soNumber; String get customerId; String? get customerName; SalesOrderStatus get status;@JsonKey(fromJson: jsonToDouble, toJson: doubleToJson) double get total; String? get note; String? get createdBy; DateTime? get approvedAt; DateTime? get completedAt; DateTime? get createdAt; int get itemCount;
/// Create a copy of SalesOrder
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SalesOrderCopyWith<SalesOrder> get copyWith => _$SalesOrderCopyWithImpl<SalesOrder>(this as SalesOrder, _$identity);

  /// Serializes this SalesOrder to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SalesOrder&&(identical(other.id, id) || other.id == id)&&(identical(other.soNumber, soNumber) || other.soNumber == soNumber)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.status, status) || other.status == status)&&(identical(other.total, total) || other.total == total)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.approvedAt, approvedAt) || other.approvedAt == approvedAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.itemCount, itemCount) || other.itemCount == itemCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,soNumber,customerId,customerName,status,total,note,createdBy,approvedAt,completedAt,createdAt,itemCount);

@override
String toString() {
  return 'SalesOrder(id: $id, soNumber: $soNumber, customerId: $customerId, customerName: $customerName, status: $status, total: $total, note: $note, createdBy: $createdBy, approvedAt: $approvedAt, completedAt: $completedAt, createdAt: $createdAt, itemCount: $itemCount)';
}


}

/// @nodoc
abstract mixin class $SalesOrderCopyWith<$Res>  {
  factory $SalesOrderCopyWith(SalesOrder value, $Res Function(SalesOrder) _then) = _$SalesOrderCopyWithImpl;
@useResult
$Res call({
 String id, String soNumber, String customerId, String? customerName, SalesOrderStatus status,@JsonKey(fromJson: jsonToDouble, toJson: doubleToJson) double total, String? note, String? createdBy, DateTime? approvedAt, DateTime? completedAt, DateTime? createdAt, int itemCount
});




}
/// @nodoc
class _$SalesOrderCopyWithImpl<$Res>
    implements $SalesOrderCopyWith<$Res> {
  _$SalesOrderCopyWithImpl(this._self, this._then);

  final SalesOrder _self;
  final $Res Function(SalesOrder) _then;

/// Create a copy of SalesOrder
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? soNumber = null,Object? customerId = null,Object? customerName = freezed,Object? status = null,Object? total = null,Object? note = freezed,Object? createdBy = freezed,Object? approvedAt = freezed,Object? completedAt = freezed,Object? createdAt = freezed,Object? itemCount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,soNumber: null == soNumber ? _self.soNumber : soNumber // ignore: cast_nullable_to_non_nullable
as String,customerId: null == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String,customerName: freezed == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SalesOrderStatus,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as double,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,approvedAt: freezed == approvedAt ? _self.approvedAt : approvedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,itemCount: null == itemCount ? _self.itemCount : itemCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SalesOrder].
extension SalesOrderPatterns on SalesOrder {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SalesOrder value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SalesOrder() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SalesOrder value)  $default,){
final _that = this;
switch (_that) {
case _SalesOrder():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SalesOrder value)?  $default,){
final _that = this;
switch (_that) {
case _SalesOrder() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String soNumber,  String customerId,  String? customerName,  SalesOrderStatus status, @JsonKey(fromJson: jsonToDouble, toJson: doubleToJson)  double total,  String? note,  String? createdBy,  DateTime? approvedAt,  DateTime? completedAt,  DateTime? createdAt,  int itemCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SalesOrder() when $default != null:
return $default(_that.id,_that.soNumber,_that.customerId,_that.customerName,_that.status,_that.total,_that.note,_that.createdBy,_that.approvedAt,_that.completedAt,_that.createdAt,_that.itemCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String soNumber,  String customerId,  String? customerName,  SalesOrderStatus status, @JsonKey(fromJson: jsonToDouble, toJson: doubleToJson)  double total,  String? note,  String? createdBy,  DateTime? approvedAt,  DateTime? completedAt,  DateTime? createdAt,  int itemCount)  $default,) {final _that = this;
switch (_that) {
case _SalesOrder():
return $default(_that.id,_that.soNumber,_that.customerId,_that.customerName,_that.status,_that.total,_that.note,_that.createdBy,_that.approvedAt,_that.completedAt,_that.createdAt,_that.itemCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String soNumber,  String customerId,  String? customerName,  SalesOrderStatus status, @JsonKey(fromJson: jsonToDouble, toJson: doubleToJson)  double total,  String? note,  String? createdBy,  DateTime? approvedAt,  DateTime? completedAt,  DateTime? createdAt,  int itemCount)?  $default,) {final _that = this;
switch (_that) {
case _SalesOrder() when $default != null:
return $default(_that.id,_that.soNumber,_that.customerId,_that.customerName,_that.status,_that.total,_that.note,_that.createdBy,_that.approvedAt,_that.completedAt,_that.createdAt,_that.itemCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SalesOrder implements SalesOrder {
  const _SalesOrder({required this.id, required this.soNumber, required this.customerId, this.customerName, this.status = SalesOrderStatus.draft, @JsonKey(fromJson: jsonToDouble, toJson: doubleToJson) this.total = 0, this.note, this.createdBy, this.approvedAt, this.completedAt, this.createdAt, this.itemCount = 0});
  factory _SalesOrder.fromJson(Map<String, dynamic> json) => _$SalesOrderFromJson(json);

@override final  String id;
@override final  String soNumber;
@override final  String customerId;
@override final  String? customerName;
@override@JsonKey() final  SalesOrderStatus status;
@override@JsonKey(fromJson: jsonToDouble, toJson: doubleToJson) final  double total;
@override final  String? note;
@override final  String? createdBy;
@override final  DateTime? approvedAt;
@override final  DateTime? completedAt;
@override final  DateTime? createdAt;
@override@JsonKey() final  int itemCount;

/// Create a copy of SalesOrder
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SalesOrderCopyWith<_SalesOrder> get copyWith => __$SalesOrderCopyWithImpl<_SalesOrder>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SalesOrderToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SalesOrder&&(identical(other.id, id) || other.id == id)&&(identical(other.soNumber, soNumber) || other.soNumber == soNumber)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.status, status) || other.status == status)&&(identical(other.total, total) || other.total == total)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.approvedAt, approvedAt) || other.approvedAt == approvedAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.itemCount, itemCount) || other.itemCount == itemCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,soNumber,customerId,customerName,status,total,note,createdBy,approvedAt,completedAt,createdAt,itemCount);

@override
String toString() {
  return 'SalesOrder(id: $id, soNumber: $soNumber, customerId: $customerId, customerName: $customerName, status: $status, total: $total, note: $note, createdBy: $createdBy, approvedAt: $approvedAt, completedAt: $completedAt, createdAt: $createdAt, itemCount: $itemCount)';
}


}

/// @nodoc
abstract mixin class _$SalesOrderCopyWith<$Res> implements $SalesOrderCopyWith<$Res> {
  factory _$SalesOrderCopyWith(_SalesOrder value, $Res Function(_SalesOrder) _then) = __$SalesOrderCopyWithImpl;
@override @useResult
$Res call({
 String id, String soNumber, String customerId, String? customerName, SalesOrderStatus status,@JsonKey(fromJson: jsonToDouble, toJson: doubleToJson) double total, String? note, String? createdBy, DateTime? approvedAt, DateTime? completedAt, DateTime? createdAt, int itemCount
});




}
/// @nodoc
class __$SalesOrderCopyWithImpl<$Res>
    implements _$SalesOrderCopyWith<$Res> {
  __$SalesOrderCopyWithImpl(this._self, this._then);

  final _SalesOrder _self;
  final $Res Function(_SalesOrder) _then;

/// Create a copy of SalesOrder
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? soNumber = null,Object? customerId = null,Object? customerName = freezed,Object? status = null,Object? total = null,Object? note = freezed,Object? createdBy = freezed,Object? approvedAt = freezed,Object? completedAt = freezed,Object? createdAt = freezed,Object? itemCount = null,}) {
  return _then(_SalesOrder(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,soNumber: null == soNumber ? _self.soNumber : soNumber // ignore: cast_nullable_to_non_nullable
as String,customerId: null == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String,customerName: freezed == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SalesOrderStatus,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as double,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,approvedAt: freezed == approvedAt ? _self.approvedAt : approvedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,itemCount: null == itemCount ? _self.itemCount : itemCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$SalesOrderItem {

 String get id; String get salesOrderId; String get productId; String? get productName; String? get productSku; String? get unit;@JsonKey(fromJson: jsonToDouble, toJson: doubleToJson) double get qty;@JsonKey(fromJson: jsonToDouble, toJson: doubleToJson) double get price;@JsonKey(fromJson: jsonToDouble, toJson: doubleToJson) double get subtotal;
/// Create a copy of SalesOrderItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SalesOrderItemCopyWith<SalesOrderItem> get copyWith => _$SalesOrderItemCopyWithImpl<SalesOrderItem>(this as SalesOrderItem, _$identity);

  /// Serializes this SalesOrderItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SalesOrderItem&&(identical(other.id, id) || other.id == id)&&(identical(other.salesOrderId, salesOrderId) || other.salesOrderId == salesOrderId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.productSku, productSku) || other.productSku == productSku)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.qty, qty) || other.qty == qty)&&(identical(other.price, price) || other.price == price)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,salesOrderId,productId,productName,productSku,unit,qty,price,subtotal);

@override
String toString() {
  return 'SalesOrderItem(id: $id, salesOrderId: $salesOrderId, productId: $productId, productName: $productName, productSku: $productSku, unit: $unit, qty: $qty, price: $price, subtotal: $subtotal)';
}


}

/// @nodoc
abstract mixin class $SalesOrderItemCopyWith<$Res>  {
  factory $SalesOrderItemCopyWith(SalesOrderItem value, $Res Function(SalesOrderItem) _then) = _$SalesOrderItemCopyWithImpl;
@useResult
$Res call({
 String id, String salesOrderId, String productId, String? productName, String? productSku, String? unit,@JsonKey(fromJson: jsonToDouble, toJson: doubleToJson) double qty,@JsonKey(fromJson: jsonToDouble, toJson: doubleToJson) double price,@JsonKey(fromJson: jsonToDouble, toJson: doubleToJson) double subtotal
});




}
/// @nodoc
class _$SalesOrderItemCopyWithImpl<$Res>
    implements $SalesOrderItemCopyWith<$Res> {
  _$SalesOrderItemCopyWithImpl(this._self, this._then);

  final SalesOrderItem _self;
  final $Res Function(SalesOrderItem) _then;

/// Create a copy of SalesOrderItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? salesOrderId = null,Object? productId = null,Object? productName = freezed,Object? productSku = freezed,Object? unit = freezed,Object? qty = null,Object? price = null,Object? subtotal = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,salesOrderId: null == salesOrderId ? _self.salesOrderId : salesOrderId // ignore: cast_nullable_to_non_nullable
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


/// Adds pattern-matching-related methods to [SalesOrderItem].
extension SalesOrderItemPatterns on SalesOrderItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SalesOrderItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SalesOrderItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SalesOrderItem value)  $default,){
final _that = this;
switch (_that) {
case _SalesOrderItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SalesOrderItem value)?  $default,){
final _that = this;
switch (_that) {
case _SalesOrderItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String salesOrderId,  String productId,  String? productName,  String? productSku,  String? unit, @JsonKey(fromJson: jsonToDouble, toJson: doubleToJson)  double qty, @JsonKey(fromJson: jsonToDouble, toJson: doubleToJson)  double price, @JsonKey(fromJson: jsonToDouble, toJson: doubleToJson)  double subtotal)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SalesOrderItem() when $default != null:
return $default(_that.id,_that.salesOrderId,_that.productId,_that.productName,_that.productSku,_that.unit,_that.qty,_that.price,_that.subtotal);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String salesOrderId,  String productId,  String? productName,  String? productSku,  String? unit, @JsonKey(fromJson: jsonToDouble, toJson: doubleToJson)  double qty, @JsonKey(fromJson: jsonToDouble, toJson: doubleToJson)  double price, @JsonKey(fromJson: jsonToDouble, toJson: doubleToJson)  double subtotal)  $default,) {final _that = this;
switch (_that) {
case _SalesOrderItem():
return $default(_that.id,_that.salesOrderId,_that.productId,_that.productName,_that.productSku,_that.unit,_that.qty,_that.price,_that.subtotal);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String salesOrderId,  String productId,  String? productName,  String? productSku,  String? unit, @JsonKey(fromJson: jsonToDouble, toJson: doubleToJson)  double qty, @JsonKey(fromJson: jsonToDouble, toJson: doubleToJson)  double price, @JsonKey(fromJson: jsonToDouble, toJson: doubleToJson)  double subtotal)?  $default,) {final _that = this;
switch (_that) {
case _SalesOrderItem() when $default != null:
return $default(_that.id,_that.salesOrderId,_that.productId,_that.productName,_that.productSku,_that.unit,_that.qty,_that.price,_that.subtotal);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SalesOrderItem implements SalesOrderItem {
  const _SalesOrderItem({required this.id, required this.salesOrderId, required this.productId, this.productName, this.productSku, this.unit, @JsonKey(fromJson: jsonToDouble, toJson: doubleToJson) this.qty = 0, @JsonKey(fromJson: jsonToDouble, toJson: doubleToJson) this.price = 0, @JsonKey(fromJson: jsonToDouble, toJson: doubleToJson) this.subtotal = 0});
  factory _SalesOrderItem.fromJson(Map<String, dynamic> json) => _$SalesOrderItemFromJson(json);

@override final  String id;
@override final  String salesOrderId;
@override final  String productId;
@override final  String? productName;
@override final  String? productSku;
@override final  String? unit;
@override@JsonKey(fromJson: jsonToDouble, toJson: doubleToJson) final  double qty;
@override@JsonKey(fromJson: jsonToDouble, toJson: doubleToJson) final  double price;
@override@JsonKey(fromJson: jsonToDouble, toJson: doubleToJson) final  double subtotal;

/// Create a copy of SalesOrderItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SalesOrderItemCopyWith<_SalesOrderItem> get copyWith => __$SalesOrderItemCopyWithImpl<_SalesOrderItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SalesOrderItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SalesOrderItem&&(identical(other.id, id) || other.id == id)&&(identical(other.salesOrderId, salesOrderId) || other.salesOrderId == salesOrderId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.productSku, productSku) || other.productSku == productSku)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.qty, qty) || other.qty == qty)&&(identical(other.price, price) || other.price == price)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,salesOrderId,productId,productName,productSku,unit,qty,price,subtotal);

@override
String toString() {
  return 'SalesOrderItem(id: $id, salesOrderId: $salesOrderId, productId: $productId, productName: $productName, productSku: $productSku, unit: $unit, qty: $qty, price: $price, subtotal: $subtotal)';
}


}

/// @nodoc
abstract mixin class _$SalesOrderItemCopyWith<$Res> implements $SalesOrderItemCopyWith<$Res> {
  factory _$SalesOrderItemCopyWith(_SalesOrderItem value, $Res Function(_SalesOrderItem) _then) = __$SalesOrderItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String salesOrderId, String productId, String? productName, String? productSku, String? unit,@JsonKey(fromJson: jsonToDouble, toJson: doubleToJson) double qty,@JsonKey(fromJson: jsonToDouble, toJson: doubleToJson) double price,@JsonKey(fromJson: jsonToDouble, toJson: doubleToJson) double subtotal
});




}
/// @nodoc
class __$SalesOrderItemCopyWithImpl<$Res>
    implements _$SalesOrderItemCopyWith<$Res> {
  __$SalesOrderItemCopyWithImpl(this._self, this._then);

  final _SalesOrderItem _self;
  final $Res Function(_SalesOrderItem) _then;

/// Create a copy of SalesOrderItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? salesOrderId = null,Object? productId = null,Object? productName = freezed,Object? productSku = freezed,Object? unit = freezed,Object? qty = null,Object? price = null,Object? subtotal = null,}) {
  return _then(_SalesOrderItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,salesOrderId: null == salesOrderId ? _self.salesOrderId : salesOrderId // ignore: cast_nullable_to_non_nullable
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
mixin _$SalesOrderDetail {

 SalesOrder get order; List<SalesOrderItem> get items;
/// Create a copy of SalesOrderDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SalesOrderDetailCopyWith<SalesOrderDetail> get copyWith => _$SalesOrderDetailCopyWithImpl<SalesOrderDetail>(this as SalesOrderDetail, _$identity);

  /// Serializes this SalesOrderDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SalesOrderDetail&&(identical(other.order, order) || other.order == order)&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,order,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'SalesOrderDetail(order: $order, items: $items)';
}


}

/// @nodoc
abstract mixin class $SalesOrderDetailCopyWith<$Res>  {
  factory $SalesOrderDetailCopyWith(SalesOrderDetail value, $Res Function(SalesOrderDetail) _then) = _$SalesOrderDetailCopyWithImpl;
@useResult
$Res call({
 SalesOrder order, List<SalesOrderItem> items
});


$SalesOrderCopyWith<$Res> get order;

}
/// @nodoc
class _$SalesOrderDetailCopyWithImpl<$Res>
    implements $SalesOrderDetailCopyWith<$Res> {
  _$SalesOrderDetailCopyWithImpl(this._self, this._then);

  final SalesOrderDetail _self;
  final $Res Function(SalesOrderDetail) _then;

/// Create a copy of SalesOrderDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? order = null,Object? items = null,}) {
  return _then(_self.copyWith(
order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as SalesOrder,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<SalesOrderItem>,
  ));
}
/// Create a copy of SalesOrderDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SalesOrderCopyWith<$Res> get order {
  
  return $SalesOrderCopyWith<$Res>(_self.order, (value) {
    return _then(_self.copyWith(order: value));
  });
}
}


/// Adds pattern-matching-related methods to [SalesOrderDetail].
extension SalesOrderDetailPatterns on SalesOrderDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SalesOrderDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SalesOrderDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SalesOrderDetail value)  $default,){
final _that = this;
switch (_that) {
case _SalesOrderDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SalesOrderDetail value)?  $default,){
final _that = this;
switch (_that) {
case _SalesOrderDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SalesOrder order,  List<SalesOrderItem> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SalesOrderDetail() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SalesOrder order,  List<SalesOrderItem> items)  $default,) {final _that = this;
switch (_that) {
case _SalesOrderDetail():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SalesOrder order,  List<SalesOrderItem> items)?  $default,) {final _that = this;
switch (_that) {
case _SalesOrderDetail() when $default != null:
return $default(_that.order,_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SalesOrderDetail implements SalesOrderDetail {
  const _SalesOrderDetail({required this.order, final  List<SalesOrderItem> items = const <SalesOrderItem>[]}): _items = items;
  factory _SalesOrderDetail.fromJson(Map<String, dynamic> json) => _$SalesOrderDetailFromJson(json);

@override final  SalesOrder order;
 final  List<SalesOrderItem> _items;
@override@JsonKey() List<SalesOrderItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of SalesOrderDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SalesOrderDetailCopyWith<_SalesOrderDetail> get copyWith => __$SalesOrderDetailCopyWithImpl<_SalesOrderDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SalesOrderDetailToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SalesOrderDetail&&(identical(other.order, order) || other.order == order)&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,order,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'SalesOrderDetail(order: $order, items: $items)';
}


}

/// @nodoc
abstract mixin class _$SalesOrderDetailCopyWith<$Res> implements $SalesOrderDetailCopyWith<$Res> {
  factory _$SalesOrderDetailCopyWith(_SalesOrderDetail value, $Res Function(_SalesOrderDetail) _then) = __$SalesOrderDetailCopyWithImpl;
@override @useResult
$Res call({
 SalesOrder order, List<SalesOrderItem> items
});


@override $SalesOrderCopyWith<$Res> get order;

}
/// @nodoc
class __$SalesOrderDetailCopyWithImpl<$Res>
    implements _$SalesOrderDetailCopyWith<$Res> {
  __$SalesOrderDetailCopyWithImpl(this._self, this._then);

  final _SalesOrderDetail _self;
  final $Res Function(_SalesOrderDetail) _then;

/// Create a copy of SalesOrderDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? order = null,Object? items = null,}) {
  return _then(_SalesOrderDetail(
order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as SalesOrder,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<SalesOrderItem>,
  ));
}

/// Create a copy of SalesOrderDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SalesOrderCopyWith<$Res> get order {
  
  return $SalesOrderCopyWith<$Res>(_self.order, (value) {
    return _then(_self.copyWith(order: value));
  });
}
}

// dart format on
