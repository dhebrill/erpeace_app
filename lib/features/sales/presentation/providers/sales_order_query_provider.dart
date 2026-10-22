import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/sales_order_repository.dart';
import '../../domain/models/sales_order.dart';

/// Holds the current query of the sales order list.
class SalesOrderQueryNotifier extends Notifier<SalesOrderQuery> {
  @override
  SalesOrderQuery build() => const SalesOrderQuery();

  void setSearch(String value) {
    final trimmed = value.trim();
    if (trimmed == state.search) return;
    state = state.copyWith(search: trimmed);
  }

  void setStatus(SalesOrderStatus? status) {
    if (status == null) {
      if (state.status == null) return;
      state = state.copyWith(clearStatus: true);
      return;
    }
    if (status == state.status) return;
    state = state.copyWith(status: status);
  }

  void setCustomer(String? customerId) {
    if (customerId == null) {
      if (state.customerId == null) return;
      state = state.copyWith(clearCustomer: true);
      return;
    }
    if (customerId == state.customerId) return;
    state = state.copyWith(customerId: customerId);
  }

  void reset() => state = const SalesOrderQuery();
}

/// The query used by the sales order list.
final salesOrderQueryProvider =
    NotifierProvider<SalesOrderQueryNotifier, SalesOrderQuery>(
      SalesOrderQueryNotifier.new,
    );
