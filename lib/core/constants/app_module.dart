import 'package:flutter/material.dart';

import 'app_routes.dart';

/// A module (section) of the application.
enum AppModule {
  dashboard(
    path: AppRoutes.dashboard,
    label: 'Beranda',
    icon: Icons.space_dashboard_rounded,
    inNavigation: true,
  ),
  inventory(
    path: AppRoutes.inventory,
    label: 'Inventori',
    icon: Icons.inventory_2_rounded,
    inNavigation: true,
  ),
  purchasing(
    path: AppRoutes.purchasing,
    label: 'Pembelian',
    icon: Icons.shopping_cart_rounded,
    inNavigation: true,
  ),
  sales(
    path: AppRoutes.sales,
    label: 'Penjualan',
    icon: Icons.point_of_sale_rounded,
    inNavigation: true,
  ),
  settings(
    path: AppRoutes.settings,
    label: 'Pengaturan',
    icon: Icons.settings_rounded,
    inNavigation: true,
  ),
  admin(
    path: AppRoutes.admin,
    label: 'Panel Admin',
    icon: Icons.admin_panel_settings_rounded,
    inNavigation: false,
  );

  const AppModule({
    required this.path,
    required this.label,
    required this.icon,
    required this.inNavigation,
  });

  final String path;
  final String label;
  final IconData icon;

  /// Whether the module appears in the bottom navigation bar.
  final bool inNavigation;

  /// Finds the module owning the given [path] (longest prefix wins).
  static AppModule? fromPath(String path) {
    AppModule? match;
    for (final module in values) {
      if (path == module.path || path.startsWith('${module.path}/')) {
        if (match == null || module.path.length > match.path.length) {
          match = module;
        }
      }
    }
    return match;
  }
}
