// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Product _$ProductFromJson(Map<String, dynamic> json) => _Product(
  id: json['id'] as String,
  sku: json['sku'] as String,
  name: json['name'] as String,
  categoryId: json['category_id'] as String?,
  categoryName: json['category_name'] as String?,
  unit: json['unit'] as String? ?? 'pcs',
  buyPrice: json['buy_price'] == null ? 0 : jsonToDouble(json['buy_price']),
  sellPrice: json['sell_price'] == null ? 0 : jsonToDouble(json['sell_price']),
  stock: json['stock'] == null ? 0 : jsonToDouble(json['stock']),
  minStock: json['min_stock'] == null ? 0 : jsonToDouble(json['min_stock']),
  imageUrl: json['image_url'] as String?,
  isActive: json['is_active'] as bool? ?? true,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$ProductToJson(_Product instance) => <String, dynamic>{
  'id': instance.id,
  'sku': instance.sku,
  'name': instance.name,
  'category_id': instance.categoryId,
  'category_name': instance.categoryName,
  'unit': instance.unit,
  'buy_price': doubleToJson(instance.buyPrice),
  'sell_price': doubleToJson(instance.sellPrice),
  'stock': doubleToJson(instance.stock),
  'min_stock': doubleToJson(instance.minStock),
  'image_url': instance.imageUrl,
  'is_active': instance.isActive,
  'created_at': instance.createdAt?.toIso8601String(),
};
