import 'package:flutter/foundation.dart' show VoidCallback;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/product_repository.dart';
import '../../domain/models/category.dart';
import '../../domain/models/product.dart';
import 'product_list_provider.dart';
import 'product_repository_provider.dart';

/// Mutations of the inventory module.
///
/// Every action refreshes the affected lists so the UI never shows stale
/// data after a write.
class InventoryActions {
  InventoryActions({required this.repository, required this.onChanged});

  final ProductRepository repository;
  final VoidCallback onChanged;

  Future<Product> createProduct({
    required String sku,
    required String name,
    String? categoryId,
    required String unit,
    required double buyPrice,
    required double sellPrice,
    required double stock,
    required double minStock,
    bool isActive = true,
  }) async {
    final product = await repository.createProduct(
      sku: sku,
      name: name,
      categoryId: categoryId,
      unit: unit,
      buyPrice: buyPrice,
      sellPrice: sellPrice,
      stock: stock,
      minStock: minStock,
      isActive: isActive,
    );
    onChanged();
    return product;
  }

  Future<Product> updateProduct(
    String id, {
    required String sku,
    required String name,
    String? categoryId,
    required String unit,
    required double buyPrice,
    required double sellPrice,
    required double minStock,
    required bool isActive,
  }) async {
    final product = await repository.updateProduct(
      id,
      sku: sku,
      name: name,
      categoryId: categoryId,
      unit: unit,
      buyPrice: buyPrice,
      sellPrice: sellPrice,
      minStock: minStock,
      isActive: isActive,
      clearCategory: categoryId == null,
    );
    onChanged();
    return product;
  }

  Future<void> deleteProduct(String id) async {
    await repository.deleteProduct(id);
    onChanged();
  }

  Future<Category> createCategory(String name) async {
    final category = await repository.createCategory(name);
    onChanged();
    return category;
  }

  Future<void> deleteCategory(String id) async {
    await repository.deleteCategory(id);
    onChanged();
  }
}

/// Provides the [InventoryActions].
final inventoryActionsProvider = Provider<InventoryActions>((ref) {
  return InventoryActions(
    repository: ref.watch(productRepositoryProvider),
    onChanged: () {
      ref.invalidate(productListProvider);
      ref.invalidate(productDetailProvider);
      ref.invalidate(categoryListProvider);
      ref.invalidate(lowStockProductsProvider);
    },
  );
});
