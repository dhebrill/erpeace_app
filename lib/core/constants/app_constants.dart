/// Global application constants.
abstract final class AppConstants {
  const AppConstants._();

  static const String appName = 'ERPeace';
  static const String appTagline = 'ERP ringkas untuk UMKM Indonesia';

  /// Number of rows fetched per page for every paginated list.
  static const int pageSize = 20;

  /// Maximum width used by centred content on tablets / desktop.
  static const double maxContentWidth = 720;

  /// Minimum quantity allowed for a transaction line.
  static const double minQuantity = 0.01;

  /// Default debounce duration for search fields.
  static const Duration searchDebounce = Duration(milliseconds: 350);

  /// Supabase table names, kept in one place to avoid typos.
  static const String tProfiles = 'profiles';
  static const String tCategories = 'categories';
  static const String tProducts = 'products';
  static const String tStockMovements = 'stock_movements';
  static const String tStockOpnames = 'stock_opnames';
  static const String tStockOpnameItems = 'stock_opname_items';
  static const String tSuppliers = 'suppliers';
  static const String tCustomers = 'customers';
  static const String tPurchaseOrders = 'purchase_orders';
  static const String tPurchaseOrderItems = 'purchase_order_items';
  static const String tSalesOrders = 'sales_orders';
  static const String tSalesOrderItems = 'sales_order_items';
}
