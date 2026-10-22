import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/paginated_notifier.dart';
import '../../../../core/providers/paginated_state.dart';
import '../../data/product_repository.dart';
import '../../domain/models/category.dart';
import '../../domain/models/product.dart';
import '../../domain/models/stock_movement.dart';
import 'product_query_provider.dart';
import 'product_repository_provider.dart';

/// Loads the paginated product list.
class ProductListNotifier extends PaginatedNotifier<Product, ProductQuery> {
  @override
  NotifierProvider<Notifier<ProductQuery>, ProductQuery> get queryProvider =>
      productQueryProvider;

  @override
  Future<PaginatedResult<Product>> fetchPage(
    ProductQuery query,
    int offset,
    int limit,
  ) {
    return ref
        .read(productRepositoryProvider)
        .fetchProducts(query: query, offset: offset, limit: limit);
  }
}

/// The paginated product list.
final productListProvider =
    NotifierProvider<ProductListNotifier, PaginatedState<Product>>(
      ProductListNotifier.new,
    );

/// Reads a single product.
final productDetailProvider = FutureProvider.family<Product?, String>((
  ref,
  id,
) {
  return ref.watch(productRepositoryProvider).fetchProduct(id);
});

/// Reads every category.
final categoryListProvider = FutureProvider<List<Category>>((ref) {
  return ref.watch(productRepositoryProvider).fetchCategories();
});

/// Reads the stock journal of a product.
final productStockHistoryProvider =
    FutureProvider.family<List<StockMovement>, String>((ref, productId) {
      return ref.watch(productRepositoryProvider).fetchStockHistory(productId);
    });

/// Reads the products that dropped below their minimum stock level.
final lowStockProductsProvider = FutureProvider<List<Product>>((ref) {
  return ref.watch(productRepositoryProvider).fetchLowStockProducts();
});

/// Reads every active product, used by the purchase and sales order pickers.
final activeProductListProvider = FutureProvider<List<Product>>((ref) {
  return ref.watch(productRepositoryProvider).fetchActiveProducts();
});
