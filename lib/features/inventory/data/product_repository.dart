import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/error/error_handler.dart';
import '../../../core/error/failure.dart';
import '../../../core/providers/paginated_state.dart';
import '../domain/models/category.dart';
import '../domain/models/product.dart';
import '../domain/models/stock_movement.dart';

/// Filter applied on top of the stock level of a product.
enum ProductStockFilter {
  all('Semua'),
  low('Stok Menipis'),
  out('Stok Habis'),
  available('Stok Tersedia');

  const ProductStockFilter(this.label);

  /// Indonesian label shown in the UI.
  final String label;
}

/// Query used to load the product list.
class ProductQuery {
  const ProductQuery({
    this.search = '',
    this.categoryId,
    this.stockFilter = ProductStockFilter.all,
    this.includeInactive = false,
  });

  final String search;
  final String? categoryId;
  final ProductStockFilter stockFilter;
  final bool includeInactive;

  ProductQuery copyWith({
    String? search,
    String? categoryId,
    ProductStockFilter? stockFilter,
    bool? includeInactive,
    bool clearCategory = false,
  }) {
    return ProductQuery(
      search: search ?? this.search,
      categoryId: clearCategory ? null : (categoryId ?? this.categoryId),
      stockFilter: stockFilter ?? this.stockFilter,
      includeInactive: includeInactive ?? this.includeInactive,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ProductQuery &&
        other.search == search &&
        other.categoryId == categoryId &&
        other.stockFilter == stockFilter &&
        other.includeInactive == includeInactive;
  }

  @override
  int get hashCode =>
      Object.hash(search, categoryId, stockFilter, includeInactive);
}

/// Reads and writes products, categories and the stock journal.
class ProductRepository {
  ProductRepository(this._client);

  final SupabaseClient _client;

  /// Loads one page of products.
  Future<PaginatedResult<Product>> fetchProducts({
    required ProductQuery query,
    required int offset,
    required int limit,
  }) async {
    try {
      final builder = _client
          .from(AppConstants.tProducts)
          .select('*, categories(name)');

      if (!query.includeInactive) {
        builder.eq('is_active', true);
      }
      final categoryId = query.categoryId;
      if (categoryId != null) {
        builder.eq('category_id', categoryId);
      }

      final search = query.search.trim();
      if (search.isNotEmpty) {
        final term = _sanitize(search);
        builder.or('name.ilike.*$term*,sku.ilike.*$term*');
      }

      switch (query.stockFilter) {
        case ProductStockFilter.low:
          builder.eq('is_low_stock', true);
        case ProductStockFilter.out:
          builder.lte('stock', 0);
        case ProductStockFilter.available:
          builder.gt('stock', 0);
        case ProductStockFilter.all:
          break;
      }

      final rows = await builder
          .order('name', ascending: true)
          .range(offset, offset + limit);

      final hasMore = rows.length > limit;
      final items = rows
          .take(limit)
          .map((row) => Product.fromRow(Map<String, dynamic>.from(row)))
          .toList(growable: false);

      return PaginatedResult<Product>(
        items: items,
        hasMore: hasMore,
        total: items.length,
      );
    } catch (error) {
      throw ErrorHandler.map(error);
    }
  }

  /// Reads a single product.
  Future<Product?> fetchProduct(String id) async {
    try {
      final row = await _client
          .from(AppConstants.tProducts)
          .select('*, categories(name)')
          .eq('id', id)
          .maybeSingle();

      if (row == null) return null;
      return Product.fromRow(Map<String, dynamic>.from(row));
    } catch (error) {
      throw ErrorHandler.map(error);
    }
  }

  /// Creates a new product.
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
    try {
      final row = await _client
          .from(AppConstants.tProducts)
          .insert({
            'sku': sku.trim().toUpperCase(),
            'name': name.trim(),
            'category_id': categoryId,
            'unit': unit.trim(),
            'buy_price': buyPrice,
            'sell_price': sellPrice,
            'stock': stock,
            'min_stock': minStock,
            'is_active': isActive,
          })
          .select('*, categories(name)')
          .single();

      return Product.fromRow(Map<String, dynamic>.from(row));
    } catch (error) {
      throw ErrorHandler.map(error);
    }
  }

  /// Updates an existing product.
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
    bool clearCategory = false,
  }) async {
    try {
      final row = await _client
          .from(AppConstants.tProducts)
          .update({
            'sku': sku.trim().toUpperCase(),
            'name': name.trim(),
            'category_id': clearCategory ? null : categoryId,
            'unit': unit.trim(),
            'buy_price': buyPrice,
            'sell_price': sellPrice,
            'min_stock': minStock,
            'is_active': isActive,
          })
          .eq('id', id)
          .select('*, categories(name)')
          .single();

      return Product.fromRow(Map<String, dynamic>.from(row));
    } catch (error) {
      throw ErrorHandler.map(error);
    }
  }

  /// Deletes a product.
  Future<void> deleteProduct(String id) async {
    try {
      await _client.from(AppConstants.tProducts).delete().eq('id', id);
    } catch (error) {
      throw ErrorHandler.map(error);
    }
  }

  /// Reads every category, ordered by name.
  Future<List<Category>> fetchCategories() async {
    try {
      final rows = await _client
          .from(AppConstants.tCategories)
          .select('id, name, created_at')
          .order('name', ascending: true);

      return rows
          .map((row) => Category.fromJson(Map<String, dynamic>.from(row)))
          .toList(growable: false);
    } catch (error) {
      throw ErrorHandler.map(error);
    }
  }

  /// Creates a new category.
  Future<Category> createCategory(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      throw const Failure('Nama kategori wajib diisi.');
    }
    try {
      final row = await _client
          .from(AppConstants.tCategories)
          .insert({'name': trimmed})
          .select('id, name, created_at')
          .single();

      return Category.fromJson(Map<String, dynamic>.from(row));
    } catch (error) {
      throw ErrorHandler.map(error);
    }
  }

  /// Deletes a category.
  Future<void> deleteCategory(String id) async {
    try {
      await _client.from(AppConstants.tCategories).delete().eq('id', id);
    } catch (error) {
      throw ErrorHandler.map(error);
    }
  }

  /// Reads the stock journal of a product, newest first.
  Future<List<StockMovement>> fetchStockHistory(
    String productId, {
    int limit = 50,
  }) async {
    try {
      final rows = await _client
          .from(AppConstants.tStockMovements)
          .select(
            'id, product_id, type, quantity, reference_type, reference_id, '
            'note, created_by, created_at',
          )
          .eq('product_id', productId)
          .order('created_at', ascending: false)
          .limit(limit);

      return rows
          .map((row) => StockMovement.fromJson(Map<String, dynamic>.from(row)))
          .toList(growable: false);
    } catch (error) {
      throw ErrorHandler.map(error);
    }
  }

  /// Reads every product that dropped below its minimum stock level.
  Future<List<Product>> fetchLowStockProducts({int limit = 20}) async {
    try {
      final rows = await _client
          .from(AppConstants.tProducts)
          .select('*, categories(name)')
          .eq('is_active', true)
          .eq('is_low_stock', true)
          .order('stock', ascending: true)
          .limit(limit);

      return rows
          .map((row) => Product.fromRow(Map<String, dynamic>.from(row)))
          .toList(growable: false);
    } catch (error) {
      throw ErrorHandler.map(error);
    }
  }

  /// Removes characters that would break a PostgREST filter expression.
  String _sanitize(String value) {
    return value
        .replaceAll(RegExp(r'[,()%*]'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }
}
