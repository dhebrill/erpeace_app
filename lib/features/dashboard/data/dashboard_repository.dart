import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/error/error_handler.dart';
import '../../../core/utils/date_formatter.dart';
import '../../inventory/domain/models/product.dart';
import '../../purchasing/domain/models/purchase_order.dart';
import '../../sales/domain/models/sales_order.dart';

/// Aggregated numbers displayed on the dashboard.
class DashboardSnapshot {
  const DashboardSnapshot({
    required this.salesTotalThisMonth,
    required this.salesCountThisMonth,
    required this.purchaseTotalThisMonth,
    required this.purchaseCountThisMonth,
    required this.activeProductCount,
    required this.stockValue,
    required this.lowStockCount,
    required this.salesByDay,
    required this.salesStatusCounts,
    required this.recentSales,
    required this.recentPurchases,
    required this.lowStockProducts,
  });

  /// Total value of the sales orders created this month.
  final double salesTotalThisMonth;

  /// Number of sales orders created this month.
  final int salesCountThisMonth;

  /// Total value of the purchase orders created this month.
  final double purchaseTotalThisMonth;

  /// Number of purchase orders created this month.
  final int purchaseCountThisMonth;

  /// Number of active products.
  final int activeProductCount;

  /// Value of the stock, valued at the selling price.
  final double stockValue;

  /// Number of products below their minimum stock level.
  final int lowStockCount;

  /// Sales per day for the last seven days, oldest first.
  final List<DailySales> salesByDay;

  /// Number of sales orders per status.
  final Map<SalesOrderStatus, int> salesStatusCounts;

  /// The five latest sales orders.
  final List<SalesOrder> recentSales;

  /// The five latest purchase orders.
  final List<PurchaseOrder> recentPurchases;

  /// The products that need to be restocked.
  final List<Product> lowStockProducts;

  /// Number of sales orders that are not finished yet.
  int get pendingSalesCount =>
      (salesStatusCounts[SalesOrderStatus.draft] ?? 0) +
      (salesStatusCounts[SalesOrderStatus.approved] ?? 0);

  /// Gross profit estimated from the sales of the month.
  double get estimatedProfit => salesTotalThisMonth - purchaseTotalThisMonth;
}

/// Sales of a single day, used by the dashboard chart.
class DailySales {
  const DailySales({
    required this.date,
    required this.total,
    required this.count,
  });

  /// Day the sales belong to (without time).
  final DateTime date;

  /// Total value of the sales of that day.
  final double total;

  /// Number of sales orders of that day.
  final int count;

  /// Short label of the day, e.g. `5 Jan`.
  String get label => DateFormatter.dayMonth(date);
}

/// Reads the aggregated numbers of the dashboard.
class DashboardRepository {
  DashboardRepository(this._client);

  final SupabaseClient _client;

  /// Builds the dashboard snapshot.
  Future<DashboardSnapshot> load() async {
    try {
      final now = DateTime.now();
      final monthStart = DateTime(now.year, now.month);
      final weekStart = DateTime(
        now.year,
        now.month,
        now.day,
      ).subtract(const Duration(days: 6));

      final results = await Future.wait([
        _client
            .from(AppConstants.tSalesOrders)
            .select(
              'id, so_number, customer_id, status, total, created_at, '
              'customers(name), sales_order_items(count)',
            )
            .gte('created_at', monthStart.toIso8601String())
            .order('created_at', ascending: false),
        _client
            .from(AppConstants.tPurchaseOrders)
            .select(
              'id, po_number, supplier_id, status, total, created_at, '
              'suppliers(name), purchase_order_items(count)',
            )
            .gte('created_at', monthStart.toIso8601String())
            .order('created_at', ascending: false),
        _client
            .from(AppConstants.tSalesOrders)
            .select(
              'id, so_number, customer_id, status, total, created_at, '
              'customers(name), sales_order_items(count)',
            )
            .gte('created_at', weekStart.toIso8601String())
            .order('created_at', ascending: false),
        _client
            .from(AppConstants.tSalesOrders)
            .select(
              'id, so_number, customer_id, status, total, created_at, '
              'customers(name), sales_order_items(count)',
            )
            .order('created_at', ascending: false)
            .limit(5),
        _client
            .from(AppConstants.tPurchaseOrders)
            .select(
              'id, po_number, supplier_id, status, total, created_at, '
              'suppliers(name), purchase_order_items(count)',
            )
            .order('created_at', ascending: false)
            .limit(5),
        _client
            .from(AppConstants.tProducts)
            .select(
              'id, sku, name, unit, stock, min_stock, buy_price, sell_price, '
              'is_active',
            )
            .eq('is_active', true)
            .limit(500),
      ]);

      final monthSales = _toOrders(results[0]);
      final monthPurchases = _toPurchases(results[1]);
      final weekSales = _toOrders(results[2]);
      final recentSales = _toOrders(results[3]);
      final recentPurchases = _toPurchases(results[4]);
      final products = _toProducts(results[5]);

      final salesTotal = monthSales.fold<double>(
        0,
        (sum, order) => sum + order.total,
      );
      final purchaseTotal = monthPurchases.fold<double>(
        0,
        (sum, order) => sum + order.total,
      );

      final statusCounts = <SalesOrderStatus, int>{};
      for (final order in monthSales) {
        statusCounts[order.status] = (statusCounts[order.status] ?? 0) + 1;
      }

      return DashboardSnapshot(
        salesTotalThisMonth: salesTotal,
        salesCountThisMonth: monthSales.length,
        purchaseTotalThisMonth: purchaseTotal,
        purchaseCountThisMonth: monthPurchases.length,
        activeProductCount: products.length,
        stockValue: products.fold<double>(
          0,
          (sum, product) => sum + product.stockValue,
        ),
        lowStockCount: products.where((product) => product.isLowStock).length,
        salesByDay: _groupByDay(weekSales),
        salesStatusCounts: statusCounts,
        recentSales: recentSales,
        recentPurchases: recentPurchases,
        lowStockProducts: products
            .where((product) => product.isLowStock)
            .take(5)
            .toList(growable: false),
      );
    } catch (error) {
      throw ErrorHandler.map(error);
    }
  }

  List<SalesOrder> _toOrders(List<Map<String, dynamic>> rows) {
    return rows
        .map((row) {
          final customer = row['customers'];
          final customerName = customer is Map
              ? customer['name'] as String?
              : (customer is List && customer.isNotEmpty)
              ? (customer.first as Map)['name'] as String?
              : null;

          return SalesOrder.fromJson({
            ...row,
            'customer_name': customerName,
            'item_count': _itemCount(row['sales_order_items']),
          });
        })
        .toList(growable: false);
  }

  List<PurchaseOrder> _toPurchases(List<Map<String, dynamic>> rows) {
    return rows
        .map((row) {
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
        })
        .toList(growable: false);
  }

  /// Reads the line count of an embedded `..._items(count)` select.
  int _itemCount(dynamic embedded) {
    if (embedded is! List || embedded.isEmpty) return 0;
    final first = embedded.first;
    if (first is! Map) return 0;
    final count = first['count'];
    return count is num ? count.toInt() : 0;
  }

  List<Product> _toProducts(List<Map<String, dynamic>> rows) {
    return rows
        .map((row) => Product.fromJson(Map<String, dynamic>.from(row)))
        .toList(growable: false);
  }

  List<DailySales> _groupByDay(List<SalesOrder> orders) {
    final now = DateTime.now();
    final days = List<DailySales>.generate(7, (index) {
      final date = DateTime(
        now.year,
        now.month,
        now.day,
      ).subtract(Duration(days: 6 - index));
      return DailySales(date: date, total: 0, count: 0);
    });

    for (final order in orders) {
      final createdAt = order.createdAt;
      if (createdAt == null) continue;
      final local = createdAt.toLocal();
      final date = DateTime(local.year, local.month, local.day);
      final index = days.indexWhere((day) => day.date == date);
      if (index == -1) continue;
      final day = days[index];
      days[index] = DailySales(
        date: day.date,
        total: day.total + order.total,
        count: day.count + 1,
      );
    }

    return days;
  }
}
