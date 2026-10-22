import 'package:erpeace_app/features/inventory/domain/models/product.dart';
import 'package:erpeace_app/features/purchasing/domain/models/purchase_order.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Product.fromJson', () {
    test('maps the database columns and defaults', () {
      final product = Product.fromJson({
        'id': 'product-1',
        'sku': 'GLA-001',
        'name': 'Gula Pasir 1kg',
        'unit': 'karung',
        'stock': 10,
        'min_stock': 5,
        'buy_price': 12000,
        'sell_price': 15000,
        'is_active': true,
      });

      expect(product.sku, 'GLA-001');
      expect(product.unit, 'karung');
      expect(product.stock, 10);
      expect(product.minStock, 5);
      expect(product.sellPrice, 15000);
      expect(product.isActive, isTrue);
      expect(product.categoryId, isNull);
    });

    test('defaults missing optional values', () {
      final product = Product.fromJson({
        'id': 'product-2',
        'sku': 'SKU-2',
        'name': 'Produk B',
      });

      expect(product.unit, 'pcs');
      expect(product.stock, 0);
      expect(product.minStock, 0);
      expect(product.isActive, isTrue);
    });

    test('resolves the embedded category', () {
      final product = Product.fromRow({
        'id': 'product-3',
        'sku': 'SKU-3',
        'name': 'Produk C',
        'categories': {'name': 'Minuman'},
      });

      expect(product.categoryName, 'Minuman');
    });
  });

  group('ProductStockInfo', () {
    test('detects low and out of stock products', () {
      final low = Product.fromJson({
        'id': 'p1',
        'sku': 'S1',
        'name': 'Rendah',
        'stock': 5,
        'min_stock': 5,
        'sell_price': 10000,
      });
      final healthy = Product.fromJson({
        'id': 'p2',
        'sku': 'S2',
        'name': 'Aman',
        'stock': 20,
        'min_stock': 5,
      });
      final empty = Product.fromJson({
        'id': 'p3',
        'sku': 'S3',
        'name': 'Habis',
        'stock': 0,
        'min_stock': 5,
      });

      expect(low.isLowStock, isTrue);
      expect(low.stockValue, 50000);
      expect(healthy.isLowStock, isFalse);
      expect(empty.isOutOfStock, isTrue);
    });

    test('ignores the minimum when it is zero', () {
      final product = Product.fromJson({
        'id': 'p4',
        'sku': 'S4',
        'name': 'Tanpa minimum',
        'stock': 0,
        'min_stock': 0,
      });

      expect(product.isLowStock, isFalse);
    });
  });

  group('PurchaseOrder.fromJson', () {
    test('maps the database columns', () {
      final order = PurchaseOrder.fromJson({
        'id': 'po-1',
        'po_number': 'PO-202610-0001',
        'supplier_id': 'supplier-1',
        'supplier_name': 'PT Sumber Makmur',
        'status': 'received',
        'total': 500000,
        'item_count': 3,
      });

      expect(order.poNumber, 'PO-202610-0001');
      expect(order.supplierName, 'PT Sumber Makmur');
      expect(order.status, PurchaseOrderStatus.received);
      expect(order.total, 500000);
      expect(order.itemCount, 3);
      expect(order.isReceived, isTrue);
    });
  });

  group('PurchaseOrderLine', () {
    test('computes the subtotal', () {
      const line = PurchaseOrderLine(
        productId: 'p1',
        productName: 'Kopi',
        qty: 4,
        price: 25000,
      );

      expect(line.subtotal, 100000);
    });
  });
}
