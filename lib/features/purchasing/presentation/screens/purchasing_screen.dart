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
import '../../domain/models/purchase_order.dart';
import '../../domain/models/supplier.dart';
import '../providers/purchase_order_list_provider.dart';
import '../providers/purchase_order_query_provider.dart';
import '../widgets/purchase_order_card.dart';
import '../widgets/purchase_order_form_sheet.dart';
import '../widgets/supplier_form_sheet.dart';

/// Purchasing module: purchase orders and their approval flow.
class PurchasingScreen extends ConsumerStatefulWidget {
  const PurchasingScreen({super.key});

  @override
  ConsumerState<PurchasingScreen> createState() => _PurchasingScreenState();
}

class _PurchasingScreenState extends ConsumerState<PurchasingScreen> {
  Future<void> _createOrder() async {
    final created = await showPurchaseOrderFormSheet(context);
    if (created == true && mounted) {
      ref.read(purchaseOrderListProvider.notifier).reload();
    }
  }

  @override
  Widget build(BuildContext context) {
    final role = ref.watch(authControllerProvider).role ?? UserRole.sales;
    final canManage = role.canManagePurchasing;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembelian'),
        actions: [
          IconButton(
            tooltip: 'Supplier',
            icon: const Icon(Icons.local_shipping_outlined),
            onPressed: () => showSupplierFormSheet(context),
          ),
          IconButton(
            tooltip: 'Muat ulang',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () =>
                ref.read(purchaseOrderListProvider.notifier).reload(),
          ),
        ],
      ),
      body: const _PurchaseOrderList(),
      floatingActionButton: canManage
          ? FloatingActionButton.extended(
              onPressed: _createOrder,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Purchase order'),
            )
          : null,
    );
  }
}

class _PurchaseOrderList extends ConsumerStatefulWidget {
  const _PurchaseOrderList();

  @override
  ConsumerState<_PurchaseOrderList> createState() => _PurchaseOrderListState();
}

class _PurchaseOrderListState extends ConsumerState<_PurchaseOrderList> {
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
      ref.read(purchaseOrderQueryProvider.notifier).setSearch(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final listState = ref.watch(purchaseOrderListProvider);
    final query = ref.watch(purchaseOrderQueryProvider);
    final suppliers =
        ref.watch(supplierListProvider).value ?? const <Supplier>[];

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
                  hintText: 'Cari nomor purchase order',
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
                              .read(purchaseOrderQueryProvider.notifier)
                              .setStatus(null),
                        ),
                      ),
                      for (final status in PurchaseOrderStatus.values)
                        Padding(
                          padding: const EdgeInsets.only(right: AppSpacing.sm),
                          child: FilterChip(
                            label: Text(status.label),
                            selected: query.status == status,
                            onSelected: (_) => ref
                                .read(purchaseOrderQueryProvider.notifier)
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
                          label: const Text('Semua supplier'),
                          selected: query.supplierId == null,
                          onSelected: (_) => ref
                              .read(purchaseOrderQueryProvider.notifier)
                              .setSupplier(null),
                        ),
                      ),
                      for (final supplier in suppliers)
                        Padding(
                          padding: const EdgeInsets.only(right: AppSpacing.sm),
                          child: FilterChip(
                            label: Text(supplier.name),
                            selected: query.supplierId == supplier.id,
                            onSelected: (_) => ref
                                .read(purchaseOrderQueryProvider.notifier)
                                .setSupplier(supplier.id),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(child: _PurchaseOrderBody(state: listState)),
      ],
    );
  }
}

class _PurchaseOrderBody extends ConsumerWidget {
  const _PurchaseOrderBody({required this.state});

  final PaginatedState<PurchaseOrder> state;

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
        onRetry: () => ref.read(purchaseOrderListProvider.notifier).reload(),
      );
    }

    if (state.isEmpty) {
      return AppEmptyState(
        title: 'Belum ada purchase order',
        message: 'Buat purchase order untuk memesan barang dari supplier.',
        icon: Icons.shopping_cart_outlined,
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(purchaseOrderListProvider.notifier).reload(),
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification.metrics.extentAfter < 320) {
            ref.read(purchaseOrderListProvider.notifier).loadMore();
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
              child: PurchaseOrderCard(
                order: order,
                onTap: () => GoRouter.of(
                  context,
                ).go(AppRoutes.purchaseOrderDetailPath(order.id)),
              ),
            );
          },
        ),
      ),
    );
  }
}
