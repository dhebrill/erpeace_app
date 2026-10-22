import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/purchase_order_repository.dart';
import '../../domain/models/purchase_order.dart';

/// Holds the current query of the purchase order list.
class PurchaseOrderQueryNotifier extends Notifier<PurchaseOrderQuery> {
  @override
  PurchaseOrderQuery build() => const PurchaseOrderQuery();

  void setSearch(String value) {
    final trimmed = value.trim();
    if (trimmed == state.search) return;
    state = state.copyWith(search: trimmed);
  }

  void setStatus(PurchaseOrderStatus? status) {
    if (status == null) {
      if (state.status == null) return;
      state = state.copyWith(clearStatus: true);
      return;
    }
    if (status == state.status) return;
    state = state.copyWith(status: status);
  }

  void setSupplier(String? supplierId) {
    if (supplierId == null) {
      if (state.supplierId == null) return;
      state = state.copyWith(clearSupplier: true);
      return;
    }
    if (supplierId == state.supplierId) return;
    state = state.copyWith(supplierId: supplierId);
  }

  void reset() => state = const PurchaseOrderQuery();
}

/// The query used by the purchase order list.
final purchaseOrderQueryProvider =
    NotifierProvider<PurchaseOrderQueryNotifier, PurchaseOrderQuery>(
      PurchaseOrderQueryNotifier.new,
    );
