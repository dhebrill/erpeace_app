import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/json_converters.dart';

part 'stock_movement.freezed.dart';
part 'stock_movement.g.dart';

/// Type of a stock movement.
///
/// The JSON values match the `stock_movement_type` enum of Postgres.
enum StockMovementType {
  @JsonValue('in')
  stockIn('Masuk', Icons.arrow_downward_rounded),

  @JsonValue('out')
  stockOut('Keluar', Icons.arrow_upward_rounded),

  @JsonValue('adjustment')
  adjustment('Penyesuaian', Icons.tune_rounded),

  @JsonValue('opname')
  opname('Opname', Icons.fact_check_outlined);

  const StockMovementType(this.label, this.icon);

  /// Indonesian label shown in the UI.
  final String label;

  /// Icon representing the movement.
  final IconData icon;

  /// Whether the movement increases the stock.
  bool get isPositive => this == stockIn || this == adjustment;
}

/// A single row of the `stock_movements` journal.
@freezed
abstract class StockMovement with _$StockMovement {
  const factory StockMovement({
    required String id,
    required String productId,
    required StockMovementType type,
    @Default(0)
    @JsonKey(fromJson: jsonToDouble, toJson: doubleToJson)
    double quantity,
    String? referenceType,
    String? referenceId,
    String? note,
    String? createdBy,
    DateTime? createdAt,
  }) = _StockMovement;

  factory StockMovement.fromJson(Map<String, dynamic> json) =>
      _$StockMovementFromJson(json);
}

/// Extra helpers of [StockMovement].
extension StockMovementInfo on StockMovement {
  /// The quantity signed according to the movement type.
  double get signedQuantity =>
      type == StockMovementType.stockOut ? -quantity : quantity;
}
