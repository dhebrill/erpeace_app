import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/providers/paginated_state.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_search_field.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../../../core/widgets/content_width.dart';
import '../../../auth/domain/models/user_role.dart';
import '../../../auth/presentation/providers/auth_controller.dart';
import '../../domain/models/customer.dart';
import '../../domain/models/sales_order.dart';
import '../providers/sales_order_list_provider.dart';
import '../providers/sales_order_query_provider.dart';
import '../widgets/customer_form_sheet.dart';
import '../widgets/sales_order_card.dart';
import '../widgets/sales_order_form_sheet.dart';

/// Sales module: sales orders and their delivery flow.
class SalesScreen extends ConsumerStatefulWidget {
  const SalesScreen({super.key});

  @override
  ConsumerState<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends ConsumerState<SalesScreen> {
  Future<void> _createOrder() async {
    final created = await showSalesOrderFormSheet(context);
    if (created == true && mounted) {
      ref.read(salesOrderListProvider.notifier).reload();
    }
  }

  @override
  Widget build(BuildContext context) {
    final role = ref.watch(authControllerProvider).role ?? UserRole.sales;
    final canManage = role.canManageSales;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Penjualan'),
        actions: [
          IconButton(
            tooltip: 'Pelanggan',
            icon: const Icon(Icons.people_outline_rounded),
            onPressed: () => showCustomerFormSheet(context),
          ),
          IconButton(
            tooltip: 'Muat ulang',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => ref.read(salesOrderListProvider.notifier).reload(),
          ),
        ],
      ),
      body: const _SalesOrderList(),
      floatingActionButton: canManage
          ? FloatingActionButton.extended(
              onPressed: _createOrder,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Sales order'),
            )
          : null,
    );
  }
}

class _SalesOrderList extends ConsumerStatefulWidget {
  const _SalesOrderList();

  @override
  ConsumerState<_SalesOrderList> createState() => _SalesOrderListState();
}

class _SalesOrderListState extends ConsumerState<_SalesOrderList> {
  final _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(AppConstants.searchDebounce, () {
      if (!mounted) return;
      ref.read(salesOrderQueryProvider.notifier).setSearch(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final listState = ref.watch(salesOrderListProvider);
    final query = ref.watch(salesOrderQueryProvider);
    final customers =
        ref.watch(customerListProvider).value ?? const <Customer>[];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.sm,
          ),
          child: ContentWidth(
            child: Column(
              children: [
                AppSearchField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  hintText: 'Cari nomor sales order',
                ),
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  height: 36,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: AppSpacing.sm),
                        child: FilterChip(
                          label: const Text('Semua status'),
                          selected: query.status == null,
                          onSelected: (_) => ref
                              .read(salesOrderQueryProvider.notifier)
                              .setStatus(null),
                        ),
                      ),
                      for (final status in SalesOrderStatus.values)
                        Padding(
                          padding: const EdgeInsets.only(right: AppSpacing.sm),
                          child: FilterChip(
                            label: Text(status.label),
                            selected: query.status == status,
                            onSelected: (_) => ref
                                .read(salesOrderQueryProvider.notifier)
                                .setStatus(status),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                SizedBox(
                  height: 36,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: AppSpacing.sm),
                        child: FilterChip(
                          label: const Text('Semua pelanggan'),
                          selected: query.customerId == null,
                          onSelected: (_) => ref
                              .read(salesOrderQueryProvider.notifier)
                              .setCustomer(null),
                        ),
                      ),
                      for (final customer in customers)
                        Padding(
                          padding: const EdgeInsets.only(right: AppSpacing.sm),
                          child: FilterChip(
                            label: Text(customer.name),
                            selected: query.customerId == customer.id,
                            onSelected: (_) => ref
                                .read(salesOrderQueryProvider.notifier)
                                .setCustomer(customer.id),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(child: _SalesOrderBody(state: listState)),
      ],
    );
  }
}

class _SalesOrderBody extends ConsumerWidget {
  const _SalesOrderBody({required this.state});

  final PaginatedState<SalesOrder> state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (state.isLoading && state.items.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: AppShimmerList(itemCount: 6, itemHeight: 96),
      );
    }

    if (state.errorMessage != null && state.items.isEmpty) {
      return AppErrorState(
        message: state.errorMessage!,
        onRetry: () => ref.read(salesOrderListProvider.notifier).reload(),
      );
    }

    if (state.isEmpty) {
      return const AppEmptyState(
        title: 'Belum ada sales order',
        message: 'Buat sales order untuk mencatat penjualan ke pelanggan.',
        icon: Icons.point_of_sale_outlined,
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(salesOrderListProvider.notifier).reload(),
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification.metrics.extentAfter < 320) {
            ref.read(salesOrderListProvider.notifier).loadMore();
          }
          return false;
        },
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.sm,
            AppSpacing.lg,
            AppSpacing.xxxl,
          ),
          itemCount: state.items.length + (state.hasMore ? 1 : 0),
          separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
          itemBuilder: (context, index) {
            if (index >= state.items.length) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            final order = state.items[index];
            return ContentWidth(
              child: SalesOrderCard(
                order: order,
                onTap: () => GoRouter.of(
                  context,
                ).go(AppRoutes.salesOrderDetailPath(order.id)),
              ),
            );
          },
        ),
      ),
    );
  }
}
