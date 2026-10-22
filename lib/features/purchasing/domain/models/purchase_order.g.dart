// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PurchaseOrder _$PurchaseOrderFromJson(Map<String, dynamic> json) =>
    _PurchaseOrder(
      id: json['id'] as String,
      poNumber: json['po_number'] as String,
      supplierId: json['supplier_id'] as String,
      supplierName: json['supplier_name'] as String?,
      status:
          $enumDecodeNullable(_$PurchaseOrderStatusEnumMap, json['status']) ??
          PurchaseOrderStatus.draft,
      total: json['total'] == null ? 0 : jsonToDouble(json['total']),
      note: json['note'] as String?,
      createdBy: json['created_by'] as String?,
      approvedAt: json['approved_at'] == null
          ? null
          : DateTime.parse(json['approved_at'] as String),
      receivedAt: json['received_at'] == null
          ? null
          : DateTime.parse(json['received_at'] as String),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      itemCount: (json['item_count'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$PurchaseOrderToJson(_PurchaseOrder instance) =>
    <String, dynamic>{
      'id': instance.id,
      'po_number': instance.poNumber,
      'supplier_id': instance.supplierId,
      'supplier_name': instance.supplierName,
      'status': _$PurchaseOrderStatusEnumMap[instance.status]!,
      'total': doubleToJson(instance.total),
      'note': instance.note,
      'created_by': instance.createdBy,
      'approved_at': instance.approvedAt?.toIso8601String(),
      'received_at': instance.receivedAt?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
      'item_count': instance.itemCount,
    };

const _$PurchaseOrderStatusEnumMap = {
  PurchaseOrderStatus.draft: 'draft',
  PurchaseOrderStatus.approved: 'approved',
  PurchaseOrderStatus.received: 'received',
  PurchaseOrderStatus.cancelled: 'cancelled',
};

_PurchaseOrderItem _$PurchaseOrderItemFromJson(Map<String, dynamic> json) =>
    _PurchaseOrderItem(
      id: json['id'] as String,
      purchaseOrderId: json['purchase_order_id'] as String,
      productId: json['product_id'] as String,
      productName: json['product_name'] as String?,
      productSku: json['product_sku'] as String?,
      unit: json['unit'] as String?,
      qty: json['qty'] == null ? 0 : jsonToDouble(json['qty']),
      price: json['price'] == null ? 0 : jsonToDouble(json['price']),
      subtotal: json['subtotal'] == null ? 0 : jsonToDouble(json['subtotal']),
    );

Map<String, dynamic> _$PurchaseOrderItemToJson(_PurchaseOrderItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'purchase_order_id': instance.purchaseOrderId,
      'product_id': instance.productId,
      'product_name': instance.productName,
      'product_sku': instance.productSku,
      'unit': instance.unit,
      'qty': doubleToJson(instance.qty),
      'price': doubleToJson(instance.price),
      'subtotal': doubleToJson(instance.subtotal),
    };

_PurchaseOrderDetail _$PurchaseOrderDetailFromJson(Map<String, dynamic> json) =>
    _PurchaseOrderDetail(
      order: PurchaseOrder.fromJson(json['order'] as Map<String, dynamic>),
      items:
          (json['items'] as List<dynamic>?)
              ?.map(
                (e) => PurchaseOrderItem.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const <PurchaseOrderItem>[],
    );

Map<String, dynamic> _$PurchaseOrderDetailToJson(
  _PurchaseOrderDetail instance,
) => <String, dynamic>{'order': instance.order, 'items': instance.items};
