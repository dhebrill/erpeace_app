import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/error/error_handler.dart';
import '../../../core/error/failure.dart';
import '../../../core/providers/paginated_state.dart';
import '../domain/models/stock_opname.dart';

/// Reads and writes the stock opname sessions.
class StockOpnameRepository {
  StockOpnameRepository(this._client);

  final SupabaseClient _client;

  /// Loads one page of stock opname sessions.
  Future<PaginatedResult<StockOpname>> fetchOpnames({
    required int offset,
    required int limit,
    StockOpnameStatus? status,
  }) async {
    try {
      final builder = _client.from(AppConstants.tStockOpnames).select('*');
      if (status != null) {
        builder.eq('status', status.name);
      }

      final rows = await builder
          .order('created_at', ascending: false)
          .range(offset, offset + limit);

      final hasMore = rows.length > limit;
      final items = rows
          .take(limit)
          .map((row) => StockOpname.fromJson(Map<String, dynamic>.from(row)))
          .toList(growable: false);

      return PaginatedResult<StockOpname>(
        items: items,
        hasMore: hasMore,
        total: items.length,
      );
    } catch (error) {
      throw ErrorHandler.map(error);
    }
  }

  /// Reads a session together with its counted lines.
  Future<StockOpnameDetail> fetchOpnameDetail(String id) async {
    try {
      final opnameRow = await _client
          .from(AppConstants.tStockOpnames)
          .select('*')
          .eq('id', id)
          .single();

      final itemRows = await _client
          .from(AppConstants.tStockOpnameItems)
          .select(
            'id, opname_id, product_id, system_qty, counted_qty, difference, '
            'products(name, sku, unit)',
          )
          .eq('opname_id', id)
          .order('id', ascending: true);

      final items = itemRows
          .map((row) {
            final product = row['products'];
            final map = Map<String, dynamic>.from(row);
            if (product is Map) {
              map['product_name'] = product['name'];
              map['product_sku'] = product['sku'];
              map['unit'] = product['unit'];
            }
            return StockOpnameItem.fromJson(map);
          })
          .toList(growable: false);

      return StockOpnameDetail(
        opname: StockOpname.fromJson(
          Map<String, dynamic>.from(opnameRow),
        ).copyWith(itemCount: items.length),
        items: items,
      );
    } catch (error) {
      throw ErrorHandler.map(error);
    }
  }

  /// Starts a new stock opname session.
  Future<StockOpname> createOpname({
    String? note,
    List<String>? productIds,
  }) async {
    try {
      final rows = await _client.rpc(
        'create_stock_opname',
        params: {'p_note': note, 'p_product_ids': productIds},
      );

      final row = _firstRow(rows);
      if (row == null) {
        throw ErrorHandler.map(const Failure('Stock opname gagal dibuat.'));
      }
      return StockOpname.fromJson(Map<String, dynamic>.from(row));
    } catch (error) {
      throw ErrorHandler.map(error);
    }
  }

  /// Stores the counted quantity of a single line.
  Future<StockOpnameItem> setCount(String itemId, double countedQty) async {
    try {
      final rows = await _client.rpc(
        'set_stock_opname_item_count',
        params: {'p_item_id': itemId, 'p_counted_qty': countedQty},
      );

      final row = _firstRow(rows);
      if (row == null) {
        throw ErrorHandler.map(const Failure('Jumlah tersimpan gagal.'));
      }
      return StockOpnameItem.fromJson(Map<String, dynamic>.from(row));
    } catch (error) {
      throw ErrorHandler.map(error);
    }
  }

  /// Finalizes the session and writes the stock adjustments.
  Future<StockOpname> finalizeOpname(String id) async {
    try {
      final rows = await _client.rpc(
        'finalize_stock_opname',
        params: {'p_opname_id': id},
      );

      final row = _firstRow(rows);
      if (row == null) {
        throw ErrorHandler.map(
          const Failure('Stock opname gagal difinalisasi.'),
        );
      }
      return StockOpname.fromJson(Map<String, dynamic>.from(row));
    } catch (error) {
      throw ErrorHandler.map(error);
    }
  }

  /// Cancels the session.
  Future<StockOpname> cancelOpname(String id) async {
    try {
      final rows = await _client.rpc(
        'cancel_stock_opname',
        params: {'p_opname_id': id},
      );

      final row = _firstRow(rows);
      if (row == null) {
        throw ErrorHandler.map(const Failure('Stock opname gagal dibatalkan.'));
      }
      return StockOpname.fromJson(Map<String, dynamic>.from(row));
    } catch (error) {
      throw ErrorHandler.map(error);
    }
  }

  Map<String, dynamic>? _firstRow(dynamic rows) {
    if (rows is List && rows.isNotEmpty && rows.first is Map) {
      return Map<String, dynamic>.from(rows.first as Map);
    }
    if (rows is Map) {
      return Map<String, dynamic>.from(rows);
    }
    return null;
  }
}
