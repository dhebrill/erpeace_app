/// Every named route used by the application.
abstract final class AppRoutes {
  const AppRoutes._();

  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String pendingApproval = '/pending-approval';

  static const String dashboard = '/dashboard';
  static const String inventory = '/inventory';
  static const String purchasing = '/purchasing';
  static const String sales = '/sales';
  static const String settings = '/settings';
  static const String admin = '/admin';

  // Sub routes
  static const String productDetail = '/inventory/product/:id';
  static const String productStockHistory = '/inventory/product/:id/stock';
  static const String purchaseOrderDetail = '/purchasing/order/:id';
  static const String salesOrderDetail = '/sales/order/:id';
  static const String stockOpnameDetail = '/inventory/opname/:id';

  static String productDetailPath(String id) => '/inventory/product/$id';

  static String productStockHistoryPath(String id) =>
      '/inventory/product/$id/stock';

  static String purchaseOrderDetailPath(String id) => '/purchasing/order/$id';

  static String salesOrderDetailPath(String id) => '/sales/order/$id';

  static String stockOpnameDetailPath(String id) => '/inventory/opname/$id';
}
