// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SalesOrder _$SalesOrderFromJson(Map<String, dynamic> json) => _SalesOrder(
  id: json['id'] as String,
  soNumber: json['so_number'] as String,
  customerId: json['customer_id'] as String,
  customerName: json['customer_name'] as String?,
  status:
      $enumDecodeNullable(_$SalesOrderStatusEnumMap, json['status']) ??
      SalesOrderStatus.draft,
  total: json['total'] == null ? 0 : jsonToDouble(json['total']),
  note: json['note'] as String?,
  createdBy: json['created_by'] as String?,
  approvedAt: json['approved_at'] == null
      ? null
      : DateTime.parse(json['approved_at'] as String),
  completedAt: json['completed_at'] == null
      ? null
      : DateTime.parse(json['completed_at'] as String),
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  itemCount: (json['item_count'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$SalesOrderToJson(_SalesOrder instance) =>
    <String, dynamic>{
      'id': instance.id,
      'so_number': instance.soNumber,
      'customer_id': instance.customerId,
      'customer_name': instance.customerName,
      'status': _$SalesOrderStatusEnumMap[instance.status]!,
      'total': doubleToJson(instance.total),
      'note': instance.note,
      'created_by': instance.createdBy,
      'approved_at': instance.approvedAt?.toIso8601String(),
      'completed_at': instance.completedAt?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
      'item_count': instance.itemCount,
    };

const _$SalesOrderStatusEnumMap = {
  SalesOrderStatus.draft: 'draft',
  SalesOrderStatus.approved: 'approved',
  SalesOrderStatus.completed: 'completed',
  SalesOrderStatus.cancelled: 'cancelled',
};

_SalesOrderItem _$SalesOrderItemFromJson(Map<String, dynamic> json) =>
    _SalesOrderItem(
      id: json['id'] as String,
      salesOrderId: json['sales_order_id'] as String,
      productId: json['product_id'] as String,
      productName: json['product_name'] as String?,
      productSku: json['product_sku'] as String?,
      unit: json['unit'] as String?,
      qty: json['qty'] == null ? 0 : jsonToDouble(json['qty']),
      price: json['price'] == null ? 0 : jsonToDouble(json['price']),
      subtotal: json['subtotal'] == null ? 0 : jsonToDouble(json['subtotal']),
    );

Map<String, dynamic> _$SalesOrderItemToJson(_SalesOrderItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sales_order_id': instance.salesOrderId,
      'product_id': instance.productId,
      'product_name': instance.productName,
      'product_sku': instance.productSku,
      'unit': instance.unit,
      'qty': doubleToJson(instance.qty),
      'price': doubleToJson(instance.price),
      'subtotal': doubleToJson(instance.subtotal),
    };

_SalesOrderDetail _$SalesOrderDetailFromJson(Map<String, dynamic> json) =>
    _SalesOrderDetail(
      order: SalesOrder.fromJson(json['order'] as Map<String, dynamic>),
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => SalesOrderItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <SalesOrderItem>[],
    );

Map<String, dynamic> _$SalesOrderDetailToJson(_SalesOrderDetail instance) =>
    <String, dynamic>{'order': instance.order, 'items': instance.items};
