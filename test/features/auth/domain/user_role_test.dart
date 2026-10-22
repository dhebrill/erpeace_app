import 'package:erpeace_app/core/constants/app_module.dart';
import 'package:erpeace_app/features/auth/domain/models/user_role.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserRole.fromValue', () {
    test('maps the stored values', () {
      expect(UserRole.fromValue('admin'), UserRole.admin);
      expect(UserRole.fromValue('manager'), UserRole.manager);
      expect(UserRole.fromValue('warehouse'), UserRole.warehouse);
      expect(UserRole.fromValue('sales'), UserRole.sales);
      expect(UserRole.fromValue('purchasing'), UserRole.purchasing);
    });

    test('falls back to sales for unknown values', () {
      expect(UserRole.fromValue(null), UserRole.sales);
      expect(UserRole.fromValue('unknown'), UserRole.sales);
    });
  });

  group('permissions', () {
    test('only admins and managers approve orders', () {
      expect(UserRole.admin.canApproveOrders, isTrue);
      expect(UserRole.manager.canApproveOrders, isTrue);
      expect(UserRole.sales.canApproveOrders, isFalse);
      expect(UserRole.warehouse.canApproveOrders, isFalse);
      expect(UserRole.purchasing.canApproveOrders, isFalse);
    });

    test('only admins manage users', () {
      expect(UserRole.admin.isAdmin, isTrue);
      for (final role in UserRole.values.where((r) => r != UserRole.admin)) {
        expect(role.isAdmin, isFalse);
      }
    });

    test('module access is role based', () {
      expect(UserRole.sales.canAccess(AppModule.sales), isTrue);
      expect(UserRole.sales.canAccess(AppModule.inventory), isFalse);
      expect(UserRole.warehouse.canAccess(AppModule.inventory), isTrue);
      expect(UserRole.warehouse.canAccess(AppModule.purchasing), isFalse);
      expect(UserRole.purchasing.canAccess(AppModule.purchasing), isTrue);
      expect(UserRole.admin.canAccess(AppModule.admin), isTrue);
      expect(UserRole.manager.canAccess(AppModule.admin), isFalse);
      expect(UserRole.manager.canAccess(AppModule.dashboard), isTrue);
      expect(UserRole.sales.canAccess(AppModule.settings), isTrue);
    });

    test('every role has a description', () {
      for (final role in UserRole.values) {
        expect(role.description, isNotEmpty);
      }
    });
  });
}
