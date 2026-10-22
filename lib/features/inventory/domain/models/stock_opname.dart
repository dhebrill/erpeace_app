import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/json_converters.dart';

part 'stock_opname.freezed.dart';
part 'stock_opname.g.dart';

/// Status of a stock opname session.
///
/// The JSON values match the `stock_opname_status` enum of Postgres.
enum StockOpnameStatus {
  @JsonValue('draft')
  draft('Draf'),

  @JsonValue('finalized')
  finalized('Selesai'),

  @JsonValue('cancelled')
  cancelled('Dibatalkan');

  const StockOpnameStatus(this.label);

  /// Indonesian label shown in the UI.
  final String label;
}

/// A stock opname session stored in the `stock_opnames` table.
@freezed
abstract class StockOpname with _$StockOpname {
  const factory StockOpname({
    required String id,
    required String opnameNumber,
    @Default(StockOpnameStatus.draft) StockOpnameStatus status,
    String? note,
    String? createdBy,
    DateTime? finalizedAt,
    DateTime? createdAt,
    @Default(0) int itemCount,
  }) = _StockOpname;

  factory StockOpname.fromJson(Map<String, dynamic> json) =>
      _$StockOpnameFromJson(json);
}

/// Extra helpers of [StockOpname].
extension StockOpnameInfo on StockOpname {
  /// Whether the session can still be edited.
  bool get isDraft => status == StockOpnameStatus.draft;
}

/// A single counted line of a stock opname.
@freezed
abstract class StockOpnameItem with _$StockOpnameItem {
  const factory StockOpnameItem({
    required String id,
    required String opnameId,
    required String productId,
    String? productName,
    String? productSku,
    String? unit,
    @Default(0)
    @JsonKey(fromJson: jsonToDouble, toJson: doubleToJson)
    double systemQty,
    @Default(0)
    @JsonKey(fromJson: jsonToDouble, toJson: doubleToJson)
    double countedQty,
    @Default(0)
    @JsonKey(fromJson: jsonToDouble, toJson: doubleToJson)
    double difference,
  }) = _StockOpnameItem;

  factory StockOpnameItem.fromJson(Map<String, dynamic> json) =>
      _$StockOpnameItemFromJson(json);
}

/// Extra helpers of [StockOpnameItem].
extension StockOpnameItemInfo on StockOpnameItem {
  /// Whether the counted quantity differs from the system quantity.
  bool get hasDifference => difference != 0;
}

/// A stock opname together with its counted lines.
@freezed
abstract class StockOpnameDetail with _$StockOpnameDetail {
  const factory StockOpnameDetail({
    required StockOpname opname,
    @Default(<StockOpnameItem>[]) List<StockOpnameItem> items,
  }) = _StockOpnameDetail;

  factory StockOpnameDetail.fromJson(Map<String, dynamic> json) =>
      _$StockOpnameDetailFromJson(json);
}
