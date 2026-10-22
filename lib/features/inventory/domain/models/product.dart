import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/json_converters.dart';

part 'product.freezed.dart';
part 'product.g.dart';

/// A product stored in the `products` table.
@freezed
abstract class Product with _$Product {
  const factory Product({
    required String id,
    required String sku,
    required String name,
    String? categoryId,
    String? categoryName,
    @Default('pcs') String unit,
    @Default(0)
    @JsonKey(fromJson: jsonToDouble, toJson: doubleToJson)
    double buyPrice,
    @Default(0)
    @JsonKey(fromJson: jsonToDouble, toJson: doubleToJson)
    double sellPrice,
    @Default(0)
    @JsonKey(fromJson: jsonToDouble, toJson: doubleToJson)
    double stock,
    @Default(0)
    @JsonKey(fromJson: jsonToDouble, toJson: doubleToJson)
    double minStock,
    String? imageUrl,
    @Default(true) bool isActive,
    DateTime? createdAt,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  /// Builds a product from a database row, resolving the embedded category.
  factory Product.fromRow(Map<String, dynamic> row) {
    final category = row['categories'];
    final categoryName = category is Map
        ? category['name'] as String?
        : (category is List && category.isNotEmpty)
        ? (category.first as Map)['name'] as String?
        : null;

    return Product.fromJson({...row, 'category_name': categoryName});
  }
}

/// Extra helpers of [Product].
extension ProductStockInfo on Product {
  /// Whether the stock dropped to (or below) the minimum level.
  bool get isLowStock => minStock > 0 && stock <= minStock;

  /// Whether there is no stock left at all.
  bool get isOutOfStock => stock <= 0;

  /// Expected revenue if the whole stock is sold.
  double get stockValue => stock * sellPrice;
}
