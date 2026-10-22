// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_opname.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StockOpname _$StockOpnameFromJson(Map<String, dynamic> json) => _StockOpname(
  id: json['id'] as String,
  opnameNumber: json['opname_number'] as String,
  status:
      $enumDecodeNullable(_$StockOpnameStatusEnumMap, json['status']) ??
      StockOpnameStatus.draft,
  note: json['note'] as String?,
  createdBy: json['created_by'] as String?,
  finalizedAt: json['finalized_at'] == null
      ? null
      : DateTime.parse(json['finalized_at'] as String),
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  itemCount: (json['item_count'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$StockOpnameToJson(_StockOpname instance) =>
    <String, dynamic>{
      'id': instance.id,
      'opname_number': instance.opnameNumber,
      'status': _$StockOpnameStatusEnumMap[instance.status]!,
      'note': instance.note,
      'created_by': instance.createdBy,
      'finalized_at': instance.finalizedAt?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
      'item_count': instance.itemCount,
    };

const _$StockOpnameStatusEnumMap = {
  StockOpnameStatus.draft: 'draft',
  StockOpnameStatus.finalized: 'finalized',
  StockOpnameStatus.cancelled: 'cancelled',
};

_StockOpnameItem _$StockOpnameItemFromJson(
  Map<String, dynamic> json,
) => _StockOpnameItem(
  id: json['id'] as String,
  opnameId: json['opname_id'] as String,
  productId: json['product_id'] as String,
  productName: json['product_name'] as String?,
  productSku: json['product_sku'] as String?,
  unit: json['unit'] as String?,
  systemQty: json['system_qty'] == null ? 0 : jsonToDouble(json['system_qty']),
  countedQty: json['counted_qty'] == null
      ? 0
      : jsonToDouble(json['counted_qty']),
  difference: json['difference'] == null ? 0 : jsonToDouble(json['difference']),
);

Map<String, dynamic> _$StockOpnameItemToJson(_StockOpnameItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'opname_id': instance.opnameId,
      'product_id': instance.productId,
      'product_name': instance.productName,
      'product_sku': instance.productSku,
      'unit': instance.unit,
      'system_qty': doubleToJson(instance.systemQty),
      'counted_qty': doubleToJson(instance.countedQty),
      'difference': doubleToJson(instance.difference),
    };

_StockOpnameDetail _$StockOpnameDetailFromJson(Map<String, dynamic> json) =>
    _StockOpnameDetail(
      opname: StockOpname.fromJson(json['opname'] as Map<String, dynamic>),
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => StockOpnameItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <StockOpnameItem>[],
    );

Map<String, dynamic> _$StockOpnameDetailToJson(_StockOpnameDetail instance) =>
    <String, dynamic>{'opname': instance.opname, 'items': instance.items};
