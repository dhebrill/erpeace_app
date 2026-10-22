// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_movement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StockMovement _$StockMovementFromJson(Map<String, dynamic> json) =>
    _StockMovement(
      id: json['id'] as String,
      productId: json['product_id'] as String,
      type: $enumDecode(_$StockMovementTypeEnumMap, json['type']),
      quantity: json['quantity'] == null ? 0 : jsonToDouble(json['quantity']),
      referenceType: json['reference_type'] as String?,
      referenceId: json['reference_id'] as String?,
      note: json['note'] as String?,
      createdBy: json['created_by'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$StockMovementToJson(_StockMovement instance) =>
    <String, dynamic>{
      'id': instance.id,
      'product_id': instance.productId,
      'type': _$StockMovementTypeEnumMap[instance.type]!,
      'quantity': doubleToJson(instance.quantity),
      'reference_type': instance.referenceType,
      'reference_id': instance.referenceId,
      'note': instance.note,
      'created_by': instance.createdBy,
      'created_at': instance.createdAt?.toIso8601String(),
    };

const _$StockMovementTypeEnumMap = {
  StockMovementType.stockIn: 'in',
  StockMovementType.stockOut: 'out',
  StockMovementType.adjustment: 'adjustment',
  StockMovementType.opname: 'opname',
};
