import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/json_converters.dart';

part 'sales_order.freezed.dart';
part 'sales_order.g.dart';

/// Status of a sales order.
///
/// The JSON values match the `sales_order_status` enum of Postgres.
enum SalesOrderStatus {
  @JsonValue('draft')
  draft('Draf'),

  @JsonValue('approved')
  approved('Disetujui'),

  @JsonValue('completed')
  completed('Selesai'),

  @JsonValue('cancelled')
  cancelled('Dibatalkan');

  const SalesOrderStatus(this.label);

  /// Indonesian label shown in the UI.
  final String label;
}

/// A sales order of the `sales_orders` table.
@freezed
abstract class SalesOrder with _$SalesOrder {
  const factory SalesOrder({
    required String id,
    required String soNumber,
    required String customerId,
    String? customerName,
    @Default(SalesOrderStatus.draft) SalesOrderStatus status,
    @Default(0)
    @JsonKey(fromJson: jsonToDouble, toJson: doubleToJson)
    double total,
    String? note,
    String? createdBy,
    DateTime? approvedAt,
    DateTime? completedAt,
    DateTime? createdAt,
    @Default(0) int itemCount,
  }) = _SalesOrder;

  factory SalesOrder.fromJson(Map<String, dynamic> json) =>
      _$SalesOrderFromJson(json);
}

/// Extra helpers of [SalesOrder].
extension SalesOrderInfo on SalesOrder {
  /// Whether the order can still be approved.
  bool get isDraft => status == SalesOrderStatus.draft;

  /// Whether the order is waiting to be delivered.
  bool get isApproved => status == SalesOrderStatus.approved;

  /// Whether the goods have already been delivered.
  bool get isCompleted => status == SalesOrderStatus.completed;

  /// Whether the order has been cancelled.
  bool get isCancelled => status == SalesOrderStatus.cancelled;
}

/// A single line of a sales order.
@freezed
abstract class SalesOrderItem with _$SalesOrderItem {
  const factory SalesOrderItem({
    required String id,
    required String salesOrderId,
    required String productId,
    String? productName,
    String? productSku,
    String? unit,
    @Default(0)
    @JsonKey(fromJson: jsonToDouble, toJson: doubleToJson)
    double qty,
    @Default(0)
    @JsonKey(fromJson: jsonToDouble, toJson: doubleToJson)
    double price,
    @Default(0)
    @JsonKey(fromJson: jsonToDouble, toJson: doubleToJson)
    double subtotal,
  }) = _SalesOrderItem;

  factory SalesOrderItem.fromJson(Map<String, dynamic> json) =>
      _$SalesOrderItemFromJson(json);
}

/// A sales order together with its lines.
@freezed
abstract class SalesOrderDetail with _$SalesOrderDetail {
  const factory SalesOrderDetail({
    required SalesOrder order,
    @Default(<SalesOrderItem>[]) List<SalesOrderItem> items,
  }) = _SalesOrderDetail;

  factory SalesOrderDetail.fromJson(Map<String, dynamic> json) =>
      _$SalesOrderDetailFromJson(json);
}

/// A line of a sales order that is being composed.
class SalesOrderLine {
  const SalesOrderLine({
    required this.productId,
    required this.productName,
    required this.qty,
    required this.price,
    this.unit,
    this.productSku,
    this.availableStock = 0,
  });

  /// Identifier of the ordered product.
  final String productId;

  /// Name of the ordered product.
  final String productName;

  /// SKU of the ordered product.
  final String? productSku;

  /// Unit of the ordered product.
  final String? unit;

  /// Ordered quantity.
  final double qty;

  /// Price per unit.
  final double price;

  /// Stock currently available for the product.
  final double availableStock;

  /// Quantity multiplied by price.
  double get subtotal => qty * price;

  /// Whether the ordered quantity exceeds the available stock.
  bool get exceedsStock => qty > availableStock;

  /// Returns a copy with the given values replaced.
  SalesOrderLine copyWith({double? qty, double? price}) {
    return SalesOrderLine(
      productId: productId,
      productName: productName,
      productSku: productSku,
      unit: unit,
      qty: qty ?? this.qty,
      price: price ?? this.price,
      availableStock: availableStock,
    );
  }
}
