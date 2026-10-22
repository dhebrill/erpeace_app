import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/providers/paginated_state.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_confirm_dialog.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_search_field.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/content_width.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../../auth/domain/models/user_role.dart';
import '../../../auth/presentation/providers/auth_controller.dart';
import '../../data/product_repository.dart';
import '../../domain/models/product.dart';
import '../../domain/models/stock_opname.dart';
import '../providers/inventory_actions.dart';
import '../providers/product_list_provider.dart';
import '../providers/product_query_provider.dart';
import '../providers/stock_opname_list_provider.dart';
import '../widgets/category_manager_sheet.dart';
import '../widgets/product_card.dart';
import '../widgets/product_form_sheet.dart';

/// Inventory module: product master data and stock opname sessions.
class InventoryScreen extends ConsumerStatefulWidget {
  const InventoryScreen({super.key});

  @override
  ConsumerState<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends ConsumerState<InventoryScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final role = ref.watch(authControllerProvider).role ?? UserRole.sales;
    final canManage = role.canManageInventory;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventori'),
        actions: [
          if (canManage)
            IconButton(
              tooltip: 'Kelola kategori',
              icon: const Icon(Icons.category_outlined),
              onPressed: () => showCategoryManagerSheet(context),
            ),
          IconButton(
            tooltip: 'Muat ulang',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              ref.read(productListProvider.notifier).reload();
              ref.read(stockOpnameListProvider.notifier).reload();
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Produk', icon: Icon(Icons.inventory_2_outlined)),
            Tab(text: 'Opname Stok', icon: Icon(Icons.fact_check_outlined)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [_ProductListTab(), _StockOpnameTab()],
      ),
      floatingActionButton: canManage && _tabController.index == 0
          ? FloatingActionButton.extended(
              onPressed: () => showProductFormSheet(context),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Produk'),
            )
          : null,
    );
  }
}

class _ProductListTab extends ConsumerStatefulWidget {
  const _ProductListTab();

  @override
  ConsumerState<_ProductListTab> createState() => _ProductListTabState();
}

class _ProductListTabState extends ConsumerState<_ProductListTab> {
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
      ref.read(productQueryProvider.notifier).setSearch(value);
    });
  }

  Future<void> _confirmDelete(Product product) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Hapus produk?',
      message: 'Produk "${product.name}" akan dihapus permanen dari daftar.',
    );
    if (!confirmed || !mounted) return;

    try {
      await ref.read(inventoryActionsProvider).deleteProduct(product.id);
      if (!mounted) return;
      AppSnackBar.showSuccess(context, 'Produk dihapus.');
    } catch (error) {
      if (!mounted) return;
      AppSnackBar.showError(context, error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final listState = ref.watch(productListProvider);
    final query = ref.watch(productQueryProvider);
    final categories = ref.watch(categoryListProvider);
    final role = ref.watch(authControllerProvider).role ?? UserRole.sales;
    final canManage = role.canManageInventory;

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
                  hintText: 'Cari nama atau SKU produk',
                ),
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  height: 36,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      for (final filter in ProductStockFilter.values)
                        Padding(
                          padding: const EdgeInsets.only(right: AppSpacing.sm),
                          child: FilterChip(
                            label: Text(filter.label),
                            selected: query.stockFilter == filter,
                            onSelected: (_) => ref
                                .read(productQueryProvider.notifier)
                                .setStockFilter(filter),
                          ),
                        ),
                      FilterChip(
                        label: const Text('Semua status'),
                        selected: query.includeInactive,
                        onSelected: (_) => ref
                            .read(productQueryProvider.notifier)
                            .setIncludeInactive(!query.includeInactive),
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
                          label: const Text('Semua kategori'),
                          selected: query.categoryId == null,
                          onSelected: (_) => ref
                              .read(productQueryProvider.notifier)
                              .setCategory(null),
                        ),
                      ),
                      for (final category in categories.value ?? const [])
                        Padding(
                          padding: const EdgeInsets.only(right: AppSpacing.sm),
                          child: FilterChip(
                            label: Text(category.name),
                            selected: query.categoryId == category.id,
                            onSelected: (_) => ref
                                .read(productQueryProvider.notifier)
                                .setCategory(category.id),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: _ProductListBody(
            state: listState,
            canManage: canManage,
            onEdit: (product) =>
                showProductFormSheet(context, product: product),
            onDelete: _confirmDelete,
          ),
        ),
      ],
    );
  }
}

class _ProductListBody extends ConsumerWidget {
  const _ProductListBody({
    required this.state,
    required this.canManage,
    required this.onEdit,
    required this.onDelete,
  });

  final PaginatedState<Product> state;
  final bool canManage;
  final ValueChanged<Product> onEdit;
  final ValueChanged<Product> onDelete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (state.isLoading && state.items.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: AppShimmerList(itemCount: 6),
      );
    }

    if (state.errorMessage != null && state.items.isEmpty) {
      return AppErrorState(
        message: state.errorMessage!,
        onRetry: () => ref.read(productListProvider.notifier).reload(),
      );
    }

    if (state.isEmpty) {
      return AppEmptyState(
        title: 'Belum ada produk',
        message: 'Tambahkan produk pertama untuk mulai mengelola stok.',
        icon: Icons.inventory_2_outlined,
        actionLabel: canManage ? 'Tambah produk' : null,
        onAction: canManage ? () => showProductFormSheet(context) : null,
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(productListProvider.notifier).reload(),
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification.metrics.extentAfter < 320) {
            ref.read(productListProvider.notifier).loadMore();
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
            final product = state.items[index];
            return ContentWidth(
              child: ProductCard(
                product: product,
                onTap: () => GoRouter.of(
                  context,
                ).go(AppRoutes.productDetailPath(product.id)),
                onEdit: canManage ? () => onEdit(product) : null,
                onDelete: canManage ? () => onDelete(product) : null,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _StockOpnameTab extends ConsumerWidget {
  const _StockOpnameTab();

  Future<void> _createOpname(BuildContext context, WidgetRef ref) async {
    try {
      final opname = await ref
          .read(stockOpnameActionsProvider)
          .createOpname(note: null);
      if (!context.mounted) return;
      GoRouter.of(context).go(AppRoutes.stockOpnameDetailPath(opname.id));
    } catch (error) {
      if (!context.mounted) return;
      AppSnackBar.showError(context, error.toString());
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listState = ref.watch(stockOpnameListProvider);
    final query = ref.watch(stockOpnameQueryProvider);
    final role = ref.watch(authControllerProvider).role ?? UserRole.sales;
    final canManage = role.canManageInventory;

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
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 36,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: AppSpacing.sm),
                          child: FilterChip(
                            label: const Text('Semua'),
                            selected: query.status == null,
                            onSelected: (_) => ref
                                .read(stockOpnameQueryProvider.notifier)
                                .setStatus(null),
                          ),
                        ),
                        for (final status in StockOpnameStatus.values)
                          Padding(
                            padding: const EdgeInsets.only(
                              right: AppSpacing.sm,
                            ),
                            child: FilterChip(
                              label: Text(status.label),
                              selected: query.status == status,
                              onSelected: (_) => ref
                                  .read(stockOpnameQueryProvider.notifier)
                                  .setStatus(status),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                if (canManage) ...[
                  const SizedBox(width: AppSpacing.sm),
                  FilledButton.tonalIcon(
                    onPressed: () => _createOpname(context, ref),
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: const Text('Opname'),
                  ),
                ],
              ],
            ),
          ),
        ),
        Expanded(
          child: _StockOpnameBody(
            state: listState,
            canManage: canManage,
            onCreate: () => _createOpname(context, ref),
          ),
        ),
      ],
    );
  }
}

class _StockOpnameBody extends ConsumerWidget {
  const _StockOpnameBody({
    required this.state,
    required this.canManage,
    required this.onCreate,
  });

  final PaginatedState<StockOpname> state;
  final bool canManage;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (state.isLoading && state.items.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: AppShimmerList(itemCount: 4, itemHeight: 80),
      );
    }

    if (state.errorMessage != null && state.items.isEmpty) {
      return AppErrorState(
        message: state.errorMessage!,
        onRetry: () => ref.read(stockOpnameListProvider.notifier).reload(),
      );
    }

    if (state.isEmpty) {
      return AppEmptyState(
        title: 'Belum ada stock opname',
        message: 'Buat sesi opname untuk mencocokkan stok fisik dengan sistem.',
        icon: Icons.fact_check_outlined,
        actionLabel: canManage ? 'Buat opname' : null,
        onAction: canManage ? onCreate : null,
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(stockOpnameListProvider.notifier).reload(),
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification.metrics.extentAfter < 320) {
            ref.read(stockOpnameListProvider.notifier).loadMore();
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
            final opname = state.items[index];
            return ContentWidth(
              child: AppCard(
                onTap: () => GoRouter.of(
                  context,
                ).go(AppRoutes.stockOpnameDetailPath(opname.id)),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            opname.opnameNumber,
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            opname.createdAt == null
                                ? '-'
                                : DateFormatter.dateTime(opname.createdAt!),
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                          ),
                          if (opname.note != null &&
                              opname.note!.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              opname.note!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    StatusChip(
                      label: opname.status.label,
                      dense: true,
                      color: switch (opname.status) {
                        StockOpnameStatus.draft => Theme.of(
                          context,
                        ).colorScheme.primary,
                        StockOpnameStatus.finalized => Colors.green.shade700,
                        StockOpnameStatus.cancelled => Theme.of(
                          context,
                        ).colorScheme.error,
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
