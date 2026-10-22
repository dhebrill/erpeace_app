import 'package:flutter/foundation.dart' show VoidCallback;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/paginated_notifier.dart';
import '../../../../core/providers/paginated_state.dart';
import '../../data/customer_repository.dart';
import '../../data/sales_order_repository.dart';
import '../../domain/models/customer.dart';
import '../../domain/models/sales_order.dart';
import 'customer_repository_provider.dart';
import 'sales_order_query_provider.dart';
import 'sales_order_repository_provider.dart';

/// Loads the paginated sales order list.
class SalesOrderListNotifier
    extends PaginatedNotifier<SalesOrder, SalesOrderQuery> {
  @override
  NotifierProvider<Notifier<SalesOrderQuery>, SalesOrderQuery>
  get queryProvider => salesOrderQueryProvider;

  @override
  Future<PaginatedResult<SalesOrder>> fetchPage(
    SalesOrderQuery query,
    int offset,
    int limit,
  ) {
    return ref
        .read(salesOrderRepositoryProvider)
        .fetchSalesOrders(query: query, offset: offset, limit: limit);
  }
}

/// The paginated sales order list.
final salesOrderListProvider =
    NotifierProvider<SalesOrderListNotifier, PaginatedState<SalesOrder>>(
      SalesOrderListNotifier.new,
    );

/// Reads a sales order together with its lines.
final salesOrderDetailProvider =
    FutureProvider.family<SalesOrderDetail, String>((ref, id) {
      return ref.watch(salesOrderRepositoryProvider).fetchSalesOrderDetail(id);
    });

/// Reads every customer.
final customerListProvider = FutureProvider<List<Customer>>((ref) {
  return ref.watch(customerRepositoryProvider).fetchCustomers();
});

/// Mutations of the sales module.
class SalesOrderActions {
  SalesOrderActions({
    required this.repository,
    required this.customerRepository,
    required this.onChanged,
  });

  final SalesOrderRepository repository;
  final CustomerRepository customerRepository;
  final VoidCallback onChanged;

  Future<SalesOrder> createSalesOrder({
    required String customerId,
    String? note,
    required List<SalesOrderLine> items,
  }) async {
    final order = await repository.createSalesOrder(
      customerId: customerId,
      note: note,
      items: items,
    );
    onChanged();
    return order;
  }

  Future<SalesOrder> approveSalesOrder(String id) async {
    final order = await repository.approveSalesOrder(id);
    onChanged();
    return order;
  }

  Future<SalesOrder> cancelSalesOrder(String id) async {
    final order = await repository.cancelSalesOrder(id);
    onChanged();
    return order;
  }

  Future<SalesOrder> completeSalesOrder(String id) async {
    final order = await repository.completeSalesOrder(id);
    onChanged();
    return order;
  }

  Future<Customer> createCustomer({
    required String name,
    String? phone,
    String? email,
    String? address,
  }) async {
    final customer = await customerRepository.createCustomer(
      name: name,
      phone: phone,
      email: email,
      address: address,
    );
    onChanged();
    return customer;
  }

  Future<void> deleteCustomer(String id) async {
    await customerRepository.deleteCustomer(id);
    onChanged();
  }
}

/// Provides the [SalesOrderActions].
final salesOrderActionsProvider = Provider<SalesOrderActions>((ref) {
  return SalesOrderActions(
    repository: ref.watch(salesOrderRepositoryProvider),
    customerRepository: ref.watch(customerRepositoryProvider),
    onChanged: () {
      ref.invalidate(salesOrderListProvider);
      ref.invalidate(salesOrderDetailProvider);
      ref.invalidate(customerListProvider);
    },
  );
});
