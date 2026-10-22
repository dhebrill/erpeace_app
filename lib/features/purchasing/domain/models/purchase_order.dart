import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/json_converters.dart';

part 'purchase_order.freezed.dart';
part 'purchase_order.g.dart';

/// Status of a purchase order.
///
/// The JSON values match the `purchase_order_status` enum of Postgres.
enum PurchaseOrderStatus {
  @JsonValue('draft')
  draft('Draf'),

  @JsonValue('approved')
  approved('Disetujui'),

  @JsonValue('received')
  received('Diterima'),

  @JsonValue('cancelled')
  cancelled('Dibatalkan');

  const PurchaseOrderStatus(this.label);

  /// Indonesian label shown in the UI.
  final String label;
}

/// A purchase order of the `purchase_orders` table.
@freezed
abstract class PurchaseOrder with _$PurchaseOrder {
  const factory PurchaseOrder({
    required String id,
    required String poNumber,
    required String supplierId,
    String? supplierName,
    @Default(PurchaseOrderStatus.draft) PurchaseOrderStatus status,
    @Default(0)
    @JsonKey(fromJson: jsonToDouble, toJson: doubleToJson)
    double total,
    String? note,
    String? createdBy,
    DateTime? approvedAt,
    DateTime? receivedAt,
    DateTime? createdAt,
    @Default(0) int itemCount,
  }) = _PurchaseOrder;

  factory PurchaseOrder.fromJson(Map<String, dynamic> json) =>
      _$PurchaseOrderFromJson(json);
}

/// Extra helpers of [PurchaseOrder].
extension PurchaseOrderInfo on PurchaseOrder {
  /// Whether the order can still be approved.
  bool get isDraft => status == PurchaseOrderStatus.draft;

  /// Whether the order has been approved and waits for the goods.
  bool get isApproved => status == PurchaseOrderStatus.approved;

  /// Whether the goods have already been received.
  bool get isReceived => status == PurchaseOrderStatus.received;

  /// Whether the order has been cancelled.
  bool get isCancelled => status == PurchaseOrderStatus.cancelled;
}

/// A single line of a purchase order.
@freezed
abstract class PurchaseOrderItem with _$PurchaseOrderItem {
  const factory PurchaseOrderItem({
    required String id,
    required String purchaseOrderId,
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
  }) = _PurchaseOrderItem;

  factory PurchaseOrderItem.fromJson(Map<String, dynamic> json) =>
      _$PurchaseOrderItemFromJson(json);
}

/// A purchase order together with its lines.
@freezed
abstract class PurchaseOrderDetail with _$PurchaseOrderDetail {
  const factory PurchaseOrderDetail({
    required PurchaseOrder order,
    @Default(<PurchaseOrderItem>[]) List<PurchaseOrderItem> items,
  }) = _PurchaseOrderDetail;

  factory PurchaseOrderDetail.fromJson(Map<String, dynamic> json) =>
      _$PurchaseOrderDetailFromJson(json);
}

/// A line of a purchase order that is being composed.
class PurchaseOrderLine {
  const PurchaseOrderLine({
    required this.productId,
    required this.productName,
    required this.qty,
    required this.price,
    this.unit,
    this.productSku,
  });

  /// Identifier of the ordered product.
  final String productId;

  /// Name of the ordered product, used for the summary in the UI.
  final String productName;

  /// SKU of the ordered product.
  final String? productSku;

  /// Unit of the ordered product.
  final String? unit;

  /// Ordered quantity.
  final double qty;

  /// Price per unit.
  final double price;

  /// Quantity multiplied by price.
  double get subtotal => qty * price;

  /// Returns a copy with the given values replaced.
  PurchaseOrderLine copyWith({double? qty, double? price}) {
    return PurchaseOrderLine(
      productId: productId,
      productName: productName,
      productSku: productSku,
      unit: unit,
      qty: qty ?? this.qty,
      price: price ?? this.price,
    );
  }
}
