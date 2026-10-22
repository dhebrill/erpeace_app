// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Product {

 String get id; String get sku; String get name; String? get categoryId; String? get categoryName; String get unit;@JsonKey(fromJson: jsonToDouble, toJson: doubleToJson) double get buyPrice;@JsonKey(fromJson: jsonToDouble, toJson: doubleToJson) double get sellPrice;@JsonKey(fromJson: jsonToDouble, toJson: doubleToJson) double get stock;@JsonKey(fromJson: jsonToDouble, toJson: doubleToJson) double get minStock; String? get imageUrl; bool get isActive; DateTime? get createdAt;
/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductCopyWith<Product> get copyWith => _$ProductCopyWithImpl<Product>(this as Product, _$identity);

  /// Serializes this Product to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Product&&(identical(other.id, id) || other.id == id)&&(identical(other.sku, sku) || other.sku == sku)&&(identical(other.name, name) || other.name == name)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.buyPrice, buyPrice) || other.buyPrice == buyPrice)&&(identical(other.sellPrice, sellPrice) || other.sellPrice == sellPrice)&&(identical(other.stock, stock) || other.stock == stock)&&(identical(other.minStock, minStock) || other.minStock == minStock)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sku,name,categoryId,categoryName,unit,buyPrice,sellPrice,stock,minStock,imageUrl,isActive,createdAt);

@override
String toString() {
  return 'Product(id: $id, sku: $sku, name: $name, categoryId: $categoryId, categoryName: $categoryName, unit: $unit, buyPrice: $buyPrice, sellPrice: $sellPrice, stock: $stock, minStock: $minStock, imageUrl: $imageUrl, isActive: $isActive, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $ProductCopyWith<$Res>  {
  factory $ProductCopyWith(Product value, $Res Function(Product) _then) = _$ProductCopyWithImpl;
@useResult
$Res call({
 String id, String sku, String name, String? categoryId, String? categoryName, String unit,@JsonKey(fromJson: jsonToDouble, toJson: doubleToJson) double buyPrice,@JsonKey(fromJson: jsonToDouble, toJson: doubleToJson) double sellPrice,@JsonKey(fromJson: jsonToDouble, toJson: doubleToJson) double stock,@JsonKey(fromJson: jsonToDouble, toJson: doubleToJson) double minStock, String? imageUrl, bool isActive, DateTime? createdAt
});




}
/// @nodoc
class _$ProductCopyWithImpl<$Res>
    implements $ProductCopyWith<$Res> {
  _$ProductCopyWithImpl(this._self, this._then);

  final Product _self;
  final $Res Function(Product) _then;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? sku = null,Object? name = null,Object? categoryId = freezed,Object? categoryName = freezed,Object? unit = null,Object? buyPrice = null,Object? sellPrice = null,Object? stock = null,Object? minStock = null,Object? imageUrl = freezed,Object? isActive = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sku: null == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,categoryName: freezed == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String?,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,buyPrice: null == buyPrice ? _self.buyPrice : buyPrice // ignore: cast_nullable_to_non_nullable
as double,sellPrice: null == sellPrice ? _self.sellPrice : sellPrice // ignore: cast_nullable_to_non_nullable
as double,stock: null == stock ? _self.stock : stock // ignore: cast_nullable_to_non_nullable
as double,minStock: null == minStock ? _self.minStock : minStock // ignore: cast_nullable_to_non_nullable
as double,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Product].
extension ProductPatterns on Product {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Product value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Product() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Product value)  $default,){
final _that = this;
switch (_that) {
case _Product():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Product value)?  $default,){
final _that = this;
switch (_that) {
case _Product() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String sku,  String name,  String? categoryId,  String? categoryName,  String unit, @JsonKey(fromJson: jsonToDouble, toJson: doubleToJson)  double buyPrice, @JsonKey(fromJson: jsonToDouble, toJson: doubleToJson)  double sellPrice, @JsonKey(fromJson: jsonToDouble, toJson: doubleToJson)  double stock, @JsonKey(fromJson: jsonToDouble, toJson: doubleToJson)  double minStock,  String? imageUrl,  bool isActive,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that.id,_that.sku,_that.name,_that.categoryId,_that.categoryName,_that.unit,_that.buyPrice,_that.sellPrice,_that.stock,_that.minStock,_that.imageUrl,_that.isActive,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String sku,  String name,  String? categoryId,  String? categoryName,  String unit, @JsonKey(fromJson: jsonToDouble, toJson: doubleToJson)  double buyPrice, @JsonKey(fromJson: jsonToDouble, toJson: doubleToJson)  double sellPrice, @JsonKey(fromJson: jsonToDouble, toJson: doubleToJson)  double stock, @JsonKey(fromJson: jsonToDouble, toJson: doubleToJson)  double minStock,  String? imageUrl,  bool isActive,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _Product():
return $default(_that.id,_that.sku,_that.name,_that.categoryId,_that.categoryName,_that.unit,_that.buyPrice,_that.sellPrice,_that.stock,_that.minStock,_that.imageUrl,_that.isActive,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String sku,  String name,  String? categoryId,  String? categoryName,  String unit, @JsonKey(fromJson: jsonToDouble, toJson: doubleToJson)  double buyPrice, @JsonKey(fromJson: jsonToDouble, toJson: doubleToJson)  double sellPrice, @JsonKey(fromJson: jsonToDouble, toJson: doubleToJson)  double stock, @JsonKey(fromJson: jsonToDouble, toJson: doubleToJson)  double minStock,  String? imageUrl,  bool isActive,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that.id,_that.sku,_that.name,_that.categoryId,_that.categoryName,_that.unit,_that.buyPrice,_that.sellPrice,_that.stock,_that.minStock,_that.imageUrl,_that.isActive,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Product implements Product {
  const _Product({required this.id, required this.sku, required this.name, this.categoryId, this.categoryName, this.unit = 'pcs', @JsonKey(fromJson: jsonToDouble, toJson: doubleToJson) this.buyPrice = 0, @JsonKey(fromJson: jsonToDouble, toJson: doubleToJson) this.sellPrice = 0, @JsonKey(fromJson: jsonToDouble, toJson: doubleToJson) this.stock = 0, @JsonKey(fromJson: jsonToDouble, toJson: doubleToJson) this.minStock = 0, this.imageUrl, this.isActive = true, this.createdAt});
  factory _Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

@override final  String id;
@override final  String sku;
@override final  String name;
@override final  String? categoryId;
@override final  String? categoryName;
@override@JsonKey() final  String unit;
@override@JsonKey(fromJson: jsonToDouble, toJson: doubleToJson) final  double buyPrice;
@override@JsonKey(fromJson: jsonToDouble, toJson: doubleToJson) final  double sellPrice;
@override@JsonKey(fromJson: jsonToDouble, toJson: doubleToJson) final  double stock;
@override@JsonKey(fromJson: jsonToDouble, toJson: doubleToJson) final  double minStock;
@override final  String? imageUrl;
@override@JsonKey() final  bool isActive;
@override final  DateTime? createdAt;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductCopyWith<_Product> get copyWith => __$ProductCopyWithImpl<_Product>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Product&&(identical(other.id, id) || other.id == id)&&(identical(other.sku, sku) || other.sku == sku)&&(identical(other.name, name) || other.name == name)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.buyPrice, buyPrice) || other.buyPrice == buyPrice)&&(identical(other.sellPrice, sellPrice) || other.sellPrice == sellPrice)&&(identical(other.stock, stock) || other.stock == stock)&&(identical(other.minStock, minStock) || other.minStock == minStock)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sku,name,categoryId,categoryName,unit,buyPrice,sellPrice,stock,minStock,imageUrl,isActive,createdAt);

@override
String toString() {
  return 'Product(id: $id, sku: $sku, name: $name, categoryId: $categoryId, categoryName: $categoryName, unit: $unit, buyPrice: $buyPrice, sellPrice: $sellPrice, stock: $stock, minStock: $minStock, imageUrl: $imageUrl, isActive: $isActive, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ProductCopyWith<$Res> implements $ProductCopyWith<$Res> {
  factory _$ProductCopyWith(_Product value, $Res Function(_Product) _then) = __$ProductCopyWithImpl;
@override @useResult
$Res call({
 String id, String sku, String name, String? categoryId, String? categoryName, String unit,@JsonKey(fromJson: jsonToDouble, toJson: doubleToJson) double buyPrice,@JsonKey(fromJson: jsonToDouble, toJson: doubleToJson) double sellPrice,@JsonKey(fromJson: jsonToDouble, toJson: doubleToJson) double stock,@JsonKey(fromJson: jsonToDouble, toJson: doubleToJson) double minStock, String? imageUrl, bool isActive, DateTime? createdAt
});




}
/// @nodoc
class __$ProductCopyWithImpl<$Res>
    implements _$ProductCopyWith<$Res> {
  __$ProductCopyWithImpl(this._self, this._then);

  final _Product _self;
  final $Res Function(_Product) _then;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? sku = null,Object? name = null,Object? categoryId = freezed,Object? categoryName = freezed,Object? unit = null,Object? buyPrice = null,Object? sellPrice = null,Object? stock = null,Object? minStock = null,Object? imageUrl = freezed,Object? isActive = null,Object? createdAt = freezed,}) {
  return _then(_Product(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sku: null == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,categoryName: freezed == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String?,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,buyPrice: null == buyPrice ? _self.buyPrice : buyPrice // ignore: cast_nullable_to_non_nullable
as double,sellPrice: null == sellPrice ? _self.sellPrice : sellPrice // ignore: cast_nullable_to_non_nullable
as double,stock: null == stock ? _self.stock : stock // ignore: cast_nullable_to_non_nullable
as double,minStock: null == minStock ? _self.minStock : minStock // ignore: cast_nullable_to_non_nullable
as double,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
