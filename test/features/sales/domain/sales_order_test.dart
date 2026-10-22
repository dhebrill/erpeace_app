import 'package:erpeace_app/features/sales/domain/models/sales_order.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SalesOrder.fromJson', () {
    test('maps the snake_case columns of the database', () {
      final order = SalesOrder.fromJson({
        'id': 'so-1',
        'so_number': 'SO-202610-0001',
        'customer_id': 'customer-1',
        'customer_name': 'Toko Sumber Rejeki',
        'status': 'approved',
        'total': 150000,
        'created_at': '2026-10-01T10:00:00Z',
        'item_count': 2,
      });

      expect(order.id, 'so-1');
      expect(order.soNumber, 'SO-202610-0001');
      expect(order.customerId, 'customer-1');
      expect(order.customerName, 'Toko Sumber Rejeki');
      expect(order.status, SalesOrderStatus.approved);
      expect(order.total, 150000);
      expect(order.itemCount, 2);
      expect(order.createdAt, isNotNull);
    });

    test('accepts a floating total and defaults', () {
      final order = SalesOrder.fromJson({
        'id': 'so-2',
        'so_number': 'SO-2',
        'customer_id': 'c',
        'total': 12500.75,
      });

      expect(order.total, 12500.75);
      expect(order.status, SalesOrderStatus.draft);
      expect(order.itemCount, 0);
      expect(order.customerName, isNull);
    });

    test('maps every status value', () {
      final statuses = {
        'draft': SalesOrderStatus.draft,
        'approved': SalesOrderStatus.approved,
        'completed': SalesOrderStatus.completed,
        'cancelled': SalesOrderStatus.cancelled,
      };

      statuses.forEach((value, expected) {
        final order = SalesOrder.fromJson({
          'id': value,
          'so_number': value,
          'customer_id': 'c',
          'status': value,
        });
        expect(order.status, expected);
      });
    });
  });

  group('SalesOrderItem', () {
    test('parses numeric columns', () {
      final item = SalesOrderItem.fromJson({
        'id': 'item-1',
        'sales_order_id': 'so-1',
        'product_id': 'product-1',
        'qty': 3,
        'price': 2500.5,
        'subtotal': 7501.5,
      });

      expect(item.qty, 3);
      expect(item.price, 2500.5);
      expect(item.subtotal, 7501.5);
    });
  });

  group('SalesOrderLine', () {
    const line = SalesOrderLine(
      productId: 'product-1',
      productName: 'Gula Pasir',
      qty: 5,
      price: 1000,
      availableStock: 3,
    );

    test('computes the subtotal', () {
      expect(line.subtotal, 5000);
    });

    test('flags lines above the available stock', () {
      expect(line.exceedsStock, isTrue);
      expect(line.copyWith(qty: 2).exceedsStock, isFalse);
    });
  });

  group('status helpers', () {
    test('exposes readable labels', () {
      expect(SalesOrderStatus.draft.label, 'Draf');
      expect(SalesOrderStatus.completed.label, 'Selesai');
    });
  });
}
