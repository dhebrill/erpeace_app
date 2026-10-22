import 'package:json_annotation/json_annotation.dart';

import '../../../../core/constants/app_module.dart';

/// Role of a user inside ERPeace.
///
/// The enum names match the values stored in the Postgres `app_role` enum.
enum UserRole {
  @JsonValue('admin')
  admin('Admin'),

  @JsonValue('manager')
  manager('Manager'),

  @JsonValue('warehouse')
  warehouse('Gudang'),

  @JsonValue('sales')
  sales('Penjualan'),

  @JsonValue('purchasing')
  purchasing('Pembelian');

  const UserRole(this.label);

  /// Indonesian label shown in the UI.
  final String label;

  static UserRole fromValue(String? value) {
    return UserRole.values.firstWhere(
      (role) => role.name == value,
      orElse: () => UserRole.sales,
    );
  }

  bool get isAdmin => this == UserRole.admin;

  bool get canApproveOrders =>
      this == UserRole.admin || this == UserRole.manager;

  bool get canManageInventory =>
      this == UserRole.admin ||
      this == UserRole.manager ||
      this == UserRole.warehouse;

  bool get canManagePurchasing =>
      this == UserRole.admin ||
      this == UserRole.manager ||
      this == UserRole.purchasing;

  bool get canManageSales =>
      this == UserRole.admin ||
      this == UserRole.manager ||
      this == UserRole.sales;

  /// Whether the role may open the given module.
  bool canAccess(AppModule module) {
    switch (module) {
      case AppModule.dashboard:
      case AppModule.settings:
        return true;
      case AppModule.inventory:
        return canManageInventory;
      case AppModule.purchasing:
        return canManagePurchasing;
      case AppModule.sales:
        return canManageSales;
      case AppModule.admin:
        return isAdmin;
    }
  }
}

/// Extra helpers of [UserRole].
extension UserRoleInfo on UserRole {
  /// Short description of the permissions of the role.
  String get description {
    switch (this) {
      case UserRole.admin:
        return 'Akses penuh, termasuk kelola pengguna';
      case UserRole.manager:
        return 'Melihat semua data dan menyetujui order';
      case UserRole.warehouse:
        return 'Mengelola produk, stok, dan opname';
      case UserRole.sales:
        return 'Mengelola pelanggan dan sales order';
      case UserRole.purchasing:
        return 'Mengelola supplier dan purchase order';
    }
  }
}
