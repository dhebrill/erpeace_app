import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/product_repository.dart';

/// Holds the current query of the product list.
class ProductQueryNotifier extends Notifier<ProductQuery> {
  @override
  ProductQuery build() => const ProductQuery();

  void setSearch(String value) {
    if (value == state.search) return;
    state = state.copyWith(search: value);
  }

  void setCategory(String? categoryId) {
    if (categoryId == null) {
      if (state.categoryId == null) return;
      state = state.copyWith(clearCategory: true);
      return;
    }
    if (categoryId == state.categoryId) return;
    state = state.copyWith(categoryId: categoryId);
  }

  void setStockFilter(ProductStockFilter filter) {
    if (filter == state.stockFilter) return;
    state = state.copyWith(stockFilter: filter);
  }

  void setIncludeInactive(bool value) {
    if (value == state.includeInactive) return;
    state = state.copyWith(includeInactive: value);
  }

  void reset() => state = const ProductQuery();
}

/// The query used by the product list.
final productQueryProvider =
    NotifierProvider<ProductQueryNotifier, ProductQuery>(
      ProductQueryNotifier.new,
    );
