import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/error/error_handler.dart';
import '../../../core/error/failure.dart';
import '../../../core/providers/paginated_state.dart';
import '../domain/models/sales_order.dart';

/// Query of the sales order list.
class SalesOrderQuery {
  const SalesOrderQuery({this.status, this.customerId, this.search = ''});

  /// Selected status, `null` means "all statuses".
  final SalesOrderStatus? status;

  /// Selected customer, `null` means "all customers".
  final String? customerId;

  /// Free text search over the SO number.
  final String search;

  SalesOrderQuery copyWith({
    SalesOrderStatus? status,
    String? customerId,
    String? search,
    bool clearStatus = false,
    bool clearCustomer = false,
  }) {
    return SalesOrderQuery(
      status: clearStatus ? null : (status ?? this.status),
      customerId: clearCustomer ? null : (customerId ?? this.customerId),
      search: search ?? this.search,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SalesOrderQuery &&
        other.status == status &&
        other.customerId == customerId &&
        other.search == search;
  }

  @override
  int get hashCode => Object.hash(status, customerId, search);
}

/// Reads and writes the sales orders.
class SalesOrderRepository {
  SalesOrderRepository(this._client);

  final SupabaseClient _client;

  /// Loads one page of sales orders.
  Future<PaginatedResult<SalesOrder>> fetchSalesOrders({
    required SalesOrderQuery query,
    required int offset,
    required int limit,
  }) async {
    try {
      final builder = _client
          .from(AppConstants.tSalesOrders)
          .select('*, customers(name)');

      final status = query.status;
      if (status != null) {
        builder.eq('status', status.name);
      }
      final customerId = query.customerId;
      if (customerId != null) {
        builder.eq('customer_id', customerId);
      }
      final search = query.search.trim();
      if (search.isNotEmpty) {
        builder.ilike('so_number', '%${_sanitize(search)}%');
      }

      final rows = await builder
          .order('created_at', ascending: false)
          .range(offset, offset + limit);

      final hasMore = rows.length > limit;
      final items = rows
          .take(limit)
          .map((row) => _orderFromRow(Map<String, dynamic>.from(row)))
          .toList(growable: false);

      return PaginatedResult<SalesOrder>(
        items: items,
        hasMore: hasMore,
        total: items.length,
      );
    } catch (error) {
      throw ErrorHandler.map(error);
    }
  }

  /// Reads a sales order together with its lines.
  Future<SalesOrderDetail> fetchSalesOrderDetail(String id) async {
    try {
      final orderRow = await _client
          .from(AppConstants.tSalesOrders)
          .select('*, customers(name)')
          .eq('id', id)
          .single();

      final itemRows = await _client
          .from(AppConstants.tSalesOrderItems)
          .select(
            'id, sales_order_id, product_id, qty, price, subtotal, '
            'products(name, sku, unit, stock)',
          )
          .eq('sales_order_id', id)
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
            return SalesOrderItem.fromJson(map);
          })
          .toList(growable: false);

      return SalesOrderDetail(
        order: _orderFromRow(
          Map<String, dynamic>.from(orderRow),
        ).copyWith(itemCount: items.length),
        items: items,
      );
    } catch (error) {
      throw ErrorHandler.map(error);
    }
  }

  /// Creates a new sales order in `draft` status.
  Future<SalesOrder> createSalesOrder({
    required String customerId,
    String? note,
    required List<SalesOrderLine> items,
  }) async {
    if (items.isEmpty) {
      throw const Failure('Sales order harus memiliki minimal satu item.');
    }
    try {
      final rows = await _client.rpc(
        'create_sales_order',
        params: {
          'p_customer_id': customerId,
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
        throw const Failure('Sales order gagal dibuat.');
      }
      return _orderFromRow(row);
    } catch (error) {
      throw ErrorHandler.map(error);
    }
  }

  /// Approves a draft sales order.
  Future<SalesOrder> approveSalesOrder(String id) async {
    return _callOrder('approve_sales_order', {'p_so_id': id});
  }

  /// Cancels a sales order.
  Future<SalesOrder> cancelSalesOrder(String id) async {
    return _callOrder('cancel_sales_order', {'p_so_id': id});
  }

  /// Completes an approved sales order and decreases the product stock.
  Future<SalesOrder> completeSalesOrder(String id) async {
    return _callOrder('complete_sales_order', {'p_so_id': id});
  }

  Future<SalesOrder> _callOrder(
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

  SalesOrder _orderFromRow(Map<String, dynamic> row) {
    final customer = row['customers'];
    final customerName = customer is Map
        ? customer['name'] as String?
        : (customer is List && customer.isNotEmpty)
        ? (customer.first as Map)['name'] as String?
        : null;

    return SalesOrder.fromJson({...row, 'customer_name': customerName});
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
