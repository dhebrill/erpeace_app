import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/error/error_handler.dart';
import '../../../core/error/failure.dart';
import '../../../core/providers/paginated_state.dart';
import '../domain/models/purchase_order.dart';

/// Query of the purchase order list.
class PurchaseOrderQuery {
  const PurchaseOrderQuery({this.status, this.supplierId, this.search = ''});

  /// Selected status, `null` means "all statuses".
  final PurchaseOrderStatus? status;

  /// Selected supplier, `null` means "all suppliers".
  final String? supplierId;

  /// Free text search over the PO number.
  final String search;

  PurchaseOrderQuery copyWith({
    PurchaseOrderStatus? status,
    String? supplierId,
    String? search,
    bool clearStatus = false,
    bool clearSupplier = false,
  }) {
    return PurchaseOrderQuery(
      status: clearStatus ? null : (status ?? this.status),
      supplierId: clearSupplier ? null : (supplierId ?? this.supplierId),
      search: search ?? this.search,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is PurchaseOrderQuery &&
        other.status == status &&
        other.supplierId == supplierId &&
        other.search == search;
  }

  @override
  int get hashCode => Object.hash(status, supplierId, search);
}

/// Reads and writes the purchase orders.
class PurchaseOrderRepository {
  PurchaseOrderRepository(this._client);

  final SupabaseClient _client;

  /// Loads one page of purchase orders.
  Future<PaginatedResult<PurchaseOrder>> fetchPurchaseOrders({
    required PurchaseOrderQuery query,
    required int offset,
    required int limit,
  }) async {
    try {
      final builder = _client
          .from(AppConstants.tPurchaseOrders)
          .select('*, suppliers(name), purchase_order_items(count)');

      final status = query.status;
      if (status != null) {
        builder.eq('status', status.name);
      }
      final supplierId = query.supplierId;
      if (supplierId != null) {
        builder.eq('supplier_id', supplierId);
      }
      final search = query.search.trim();
      if (search.isNotEmpty) {
        builder.ilike('po_number', '%${_sanitize(search)}%');
      }

      final rows = await builder
          .order('created_at', ascending: false)
          .range(offset, offset + limit);

      final hasMore = rows.length > limit;
      final items = rows
          .take(limit)
          .map((row) => _orderFromRow(Map<String, dynamic>.from(row)))
          .toList(growable: false);

      return PaginatedResult<PurchaseOrder>(
        items: items,
        hasMore: hasMore,
        total: items.length,
      );
    } catch (error) {
      throw ErrorHandler.map(error);
    }
  }

  /// Reads a purchase order together with its lines.
  Future<PurchaseOrderDetail> fetchPurchaseOrderDetail(String id) async {
    try {
      final orderRow = await _client
          .from(AppConstants.tPurchaseOrders)
          .select('*, suppliers(name), purchase_order_items(count)')
          .eq('id', id)
          .single();

      final itemRows = await _client
          .from(AppConstants.tPurchaseOrderItems)
          .select(
            'id, purchase_order_id, product_id, qty, price, subtotal, '
            'products(name, sku, unit)',
          )
          .eq('purchase_order_id', id)
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
            return PurchaseOrderItem.fromJson(map);
          })
          .toList(growable: false);

      return PurchaseOrderDetail(
        order: _orderFromRow(
          Map<String, dynamic>.from(orderRow),
        ).copyWith(itemCount: items.length),
        items: items,
      );
    } catch (error) {
      throw ErrorHandler.map(error);
    }
  }

  /// Creates a new purchase order in `draft` status.
  Future<PurchaseOrder> createPurchaseOrder({
    required String supplierId,
    String? note,
    required List<PurchaseOrderLine> items,
  }) async {
    if (items.isEmpty) {
      throw const Failure('Purchase order harus memiliki minimal satu item.');
    }
    try {
      final rows = await _client.rpc(
        'create_purchase_order',
        params: {
          'p_supplier_id': supplierId,
          'p_note': note,
          'p_items': [
            for (final line in items)
              {
                'product_id': line.productId,
                'qty': line.qty,
                'price': line.price,
              },
          ],
        },
      );

      final row = _firstRow(rows);
      if (row == null) {
        throw const Failure('Purchase order gagal dibuat.');
      }
      return _orderFromRow(row);
    } catch (error) {
      throw ErrorHandler.map(error);
    }
  }

  /// Approves a draft purchase order.
  Future<PurchaseOrder> approvePurchaseOrder(String id) async {
    return _callOrder('approve_purchase_order', {'p_po_id': id});
  }

  /// Cancels a purchase order.
  Future<PurchaseOrder> cancelPurchaseOrder(String id) async {
    return _callOrder('cancel_purchase_order', {'p_po_id': id});
  }

  /// Receives an approved purchase order and increases the product stock.
  Future<PurchaseOrder> receivePurchaseOrder(String id) async {
    return _callOrder('receive_purchase_order', {'p_po_id': id});
  }

  Future<PurchaseOrder> _callOrder(
    String function,
    Map<String, Object?> params,
  ) async {
    try {
      final rows = await _client.rpc(function, params: params);
      final row = _firstRow(rows);
      if (row == null) {
        throw const Failure('Permintaan gagal diproses.');
      }
      return _orderFromRow(row);
    } catch (error) {
      throw ErrorHandler.map(error);
    }
  }

  PurchaseOrder _orderFromRow(Map<String, dynamic> row) {
    final supplier = row['suppliers'];
    final supplierName = supplier is Map
        ? supplier['name'] as String?
        : (supplier is List && supplier.isNotEmpty)
        ? (supplier.first as Map)['name'] as String?
        : null;

    return PurchaseOrder.fromJson({
      ...row,
      'supplier_name': supplierName,
      'item_count': _itemCount(row['purchase_order_items']),
    });
  }

  /// Reads the line count of an embedded `purchase_order_items(count)` select.
  int _itemCount(dynamic embedded) {
    if (embedded is! List || embedded.isEmpty) return 0;
    final first = embedded.first;
    if (first is! Map) return 0;
    final count = first['count'];
    return count is num ? count.toInt() : 0;
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

  String _sanitize(String value) {
    return value
        .replaceAll(RegExp(r'[,()%*]'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }
}
