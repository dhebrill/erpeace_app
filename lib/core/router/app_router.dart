import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/domain/models/user_role.dart';
import '../../features/auth/presentation/providers/auth_controller.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/pending_approval_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/admin/presentation/screens/admin_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/inventory/presentation/screens/inventory_screen.dart';
import '../../features/inventory/presentation/screens/product_detail_screen.dart';
import '../../features/inventory/presentation/screens/product_stock_history_screen.dart';
import '../../features/inventory/presentation/screens/stock_opname_detail_screen.dart';
import '../../features/purchasing/presentation/screens/purchase_order_detail_screen.dart';
import '../../features/purchasing/presentation/screens/purchasing_screen.dart';
import '../../features/sales/presentation/screens/sales_order_detail_screen.dart';
import '../../features/sales/presentation/screens/sales_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../constants/app_module.dart';
import '../constants/app_routes.dart';
import 'app_shell.dart';

const Set<String> _publicPaths = {
  AppRoutes.login,
  AppRoutes.register,
  AppRoutes.forgotPassword,
};

/// Application router with authentication and role based guards.
final routerProvider = Provider<GoRouter>((ref) {
  final refresh = ValueNotifier<int>(0);
  ref.listen<AuthState>(authControllerProvider, (previous, next) {
    refresh.value++;
  });
  ref.onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: refresh,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const _SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.pendingApproval,
        builder: (context, state) => const PendingApprovalScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.dashboard,
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: AppRoutes.inventory,
            builder: (context, state) => const InventoryScreen(),
          ),
          GoRoute(
            path: '${AppRoutes.inventory}/product/:id',
            builder: (context, state) => ProductDetailScreen(
              productId: state.pathParameters['id'] ?? '',
            ),
          ),
          GoRoute(
            path: '${AppRoutes.inventory}/product/:id/stock',
            builder: (context, state) => ProductStockHistoryScreen(
              productId: state.pathParameters['id'] ?? '',
            ),
          ),
          GoRoute(
            path: '${AppRoutes.inventory}/opname/:id',
            builder: (context, state) => StockOpnameDetailScreen(
              opnameId: state.pathParameters['id'] ?? '',
            ),
          ),
          GoRoute(
            path: AppRoutes.purchasing,
            builder: (context, state) => const PurchasingScreen(),
          ),
          GoRoute(
            path: '${AppRoutes.purchasing}/order/:id',
            builder: (context, state) => PurchaseOrderDetailScreen(
              orderId: state.pathParameters['id'] ?? '',
            ),
          ),
          GoRoute(
            path: AppRoutes.sales,
            builder: (context, state) => const SalesScreen(),
          ),
          GoRoute(
            path: '${AppRoutes.sales}/order/:id',
            builder: (context, state) => SalesOrderDetailScreen(
              orderId: state.pathParameters['id'] ?? '',
            ),
          ),
          GoRoute(
            path: AppRoutes.settings,
            builder: (context, state) => const SettingsScreen(),
          ),
          GoRoute(
            path: AppRoutes.admin,
            builder: (context, state) => const AdminScreen(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => _RouteErrorScreen(error: state.error),
    redirect: (context, state) {
      final auth = ref.read(authControllerProvider);
      final path = state.uri.path;

      switch (auth.status) {
        case AuthStatus.unknown:
          return path == AppRoutes.splash ? null : AppRoutes.splash;
        case AuthStatus.unauthenticated:
          return _publicPaths.contains(path) ? null : AppRoutes.login;
        case AuthStatus.awaitingApproval:
          return path == AppRoutes.pendingApproval
              ? null
              : AppRoutes.pendingApproval;
        case AuthStatus.authenticated:
          if (_publicPaths.contains(path) ||
              path == AppRoutes.splash ||
              path == AppRoutes.pendingApproval) {
            return AppRoutes.dashboard;
          }
          final module = AppModule.fromPath(path);
          final role = auth.role ?? UserRole.sales;
          if (module != null && !role.canAccess(module)) {
            return AppRoutes.dashboard;
          }
          return null;
      }
    },
  );
});

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(26),
                gradient: LinearGradient(
                  colors: [
                    scheme.primary,
                    scheme.primary.withValues(alpha: 0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Icon(
                Icons.inventory_2_rounded,
                color: Colors.white,
                size: 42,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'ERPeace',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: -0.6,
              ),
            ),
            const SizedBox(height: 24),
            const SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(strokeWidth: 2.6),
            ),
          ],
        ),
      ),
    );
  }
}

class _RouteErrorScreen extends StatelessWidget {
  const _RouteErrorScreen({this.error});

  final Exception? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Halaman tidak ditemukan')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.explore_off_rounded, size: 56),
              const SizedBox(height: 16),
              const Text(
                'Halaman yang Anda tuju tidak tersedia.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () => GoRouter.of(context).go(AppRoutes.dashboard),
                child: const Text('Kembali ke Beranda'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
