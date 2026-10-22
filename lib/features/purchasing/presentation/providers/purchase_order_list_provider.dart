import 'package:flutter/foundation.dart' show VoidCallback;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/paginated_notifier.dart';
import '../../../../core/providers/paginated_state.dart';
import '../../data/purchase_order_repository.dart';
import '../../data/supplier_repository.dart';
import '../../domain/models/purchase_order.dart';
import '../../domain/models/supplier.dart';
import 'purchase_order_query_provider.dart';
import 'purchase_order_repository_provider.dart';
import 'supplier_repository_provider.dart';

/// Loads the paginated purchase order list.
class PurchaseOrderListNotifier
    extends PaginatedNotifier<PurchaseOrder, PurchaseOrderQuery> {
  @override
  NotifierProvider<Notifier<PurchaseOrderQuery>, PurchaseOrderQuery>
  get queryProvider => purchaseOrderQueryProvider;

  @override
  Future<PaginatedResult<PurchaseOrder>> fetchPage(
    PurchaseOrderQuery query,
    int offset,
    int limit,
  ) {
    return ref
        .read(purchaseOrderRepositoryProvider)
        .fetchPurchaseOrders(query: query, offset: offset, limit: limit);
  }
}

/// The paginated purchase order list.
final purchaseOrderListProvider =
    NotifierProvider<PurchaseOrderListNotifier, PaginatedState<PurchaseOrder>>(
      PurchaseOrderListNotifier.new,
    );

/// Reads a purchase order together with its lines.
final purchaseOrderDetailProvider =
    FutureProvider.family<PurchaseOrderDetail, String>((ref, id) {
      return ref
          .watch(purchaseOrderRepositoryProvider)
          .fetchPurchaseOrderDetail(id);
    });

/// Reads every supplier.
final supplierListProvider = FutureProvider<List<Supplier>>((ref) {
  return ref.watch(supplierRepositoryProvider).fetchSuppliers();
});

/// Mutations of the purchasing module.
class PurchaseOrderActions {
  PurchaseOrderActions({
    required this.repository,
    required this.supplierRepository,
    required this.onChanged,
  });

  final PurchaseOrderRepository repository;
  final SupplierRepository supplierRepository;
  final VoidCallback onChanged;

  Future<PurchaseOrder> createPurchaseOrder({
    required String supplierId,
    String? note,
    required List<PurchaseOrderLine> items,
  }) async {
    final order = await repository.createPurchaseOrder(
      supplierId: supplierId,
      note: note,
      items: items,
    );
    onChanged();
    return order;
  }

  Future<PurchaseOrder> approvePurchaseOrder(String id) async {
    final order = await repository.approvePurchaseOrder(id);
    onChanged();
    return order;
  }

  Future<PurchaseOrder> cancelPurchaseOrder(String id) async {
    final order = await repository.cancelPurchaseOrder(id);
    onChanged();
    return order;
  }

  Future<PurchaseOrder> receivePurchaseOrder(String id) async {
    final order = await repository.receivePurchaseOrder(id);
    onChanged();
    return order;
  }

  Future<Supplier> createSupplier({
    required String name,
    String? phone,
    String? email,
    String? address,
  }) async {
    final supplier = await supplierRepository.createSupplier(
      name: name,
      phone: phone,
      email: email,
      address: address,
    );
    onChanged();
    return supplier;
  }

  Future<void> deleteSupplier(String id) async {
    await supplierRepository.deleteSupplier(id);
    onChanged();
  }
}

/// Provides the [PurchaseOrderActions].
final purchaseOrderActionsProvider = Provider<PurchaseOrderActions>((ref) {
  return PurchaseOrderActions(
    repository: ref.watch(purchaseOrderRepositoryProvider),
    supplierRepository: ref.watch(supplierRepositoryProvider),
    onChanged: () {
      ref.invalidate(purchaseOrderListProvider);
      ref.invalidate(purchaseOrderDetailProvider);
      ref.invalidate(supplierListProvider);
    },
  );
});
