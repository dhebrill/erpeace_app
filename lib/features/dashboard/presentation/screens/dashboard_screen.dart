import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../../../core/widgets/content_width.dart';
import '../../../../core/widgets/stat_card.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../../auth/domain/models/user_role.dart';
import '../../../auth/presentation/providers/auth_controller.dart';
import '../../data/dashboard_repository.dart';
import '../../../inventory/domain/models/product.dart';
import '../../../purchasing/presentation/widgets/purchase_order_card.dart';
import '../../../sales/presentation/widgets/sales_order_card.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/sales_bar_chart.dart';

/// Landing screen of the application.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardProvider);
    final auth = ref.watch(authControllerProvider);
    final role = auth.role ?? UserRole.sales;

    final canSeeSales = role.canManageSales;
    final canSeePurchasing =
        role.canManagePurchasing || role == UserRole.warehouse;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Beranda'),
        actions: [
          IconButton(
            tooltip: 'Muat ulang',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => ref.invalidate(dashboardProvider),
          ),
        ],
      ),
      body: switch (dashboardAsync.value) {
        null when dashboardAsync.hasError => AppErrorState(
          message: 'Data beranda tidak dapat dimuat.',
          onRetry: () => ref.invalidate(dashboardProvider),
        ),
        null => const _DashboardSkeleton(),
        final DashboardSnapshot snapshot => RefreshIndicator(
          onRefresh: () async => ref.invalidate(dashboardProvider),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.xxxl,
            ),
            children: [
              ContentWidth(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _Greeting(name: auth.displayName, role: role),
                    const SizedBox(height: AppSpacing.lg),
                    _KpiGrid(
                      snapshot: snapshot,
                      canSeeSales: canSeeSales,
                      canSeePurchasing: canSeePurchasing,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    if (canSeeSales) ...[
                      AppSectionHeader(
                        title: 'Penjualan 7 hari terakhir',
                        subtitle: snapshot.salesTotalThisMonth > 0
                            ? 'Total bulan ini ${CurrencyFormatter.format(snapshot.salesTotalThisMonth)}'
                            : null,
                        padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      ),
                      AppCard(child: SalesBarChart(days: snapshot.salesByDay)),
                      const SizedBox(height: AppSpacing.lg),
                    ],
                    _StatusSummary(
                      snapshot: snapshot,
                      canSeeSales: canSeeSales,
                    ),
                    if (canSeeSales && snapshot.recentSales.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.lg),
                      AppSectionHeader(
                        title: 'Penjualan terbaru',
                        actionLabel: 'Lihat semua',
                        onAction: () =>
                            GoRouter.of(context).go(AppRoutes.sales),
                        padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      ),
                      for (final order in snapshot.recentSales) ...[
                        SalesOrderCard(
                          order: order,
                          onTap: () => GoRouter.of(
                            context,
                          ).go(AppRoutes.salesOrderDetailPath(order.id)),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                      ],
                    ],
                    if (canSeePurchasing &&
                        snapshot.recentPurchases.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.lg),
                      AppSectionHeader(
                        title: 'Pembelian terbaru',
                        actionLabel: 'Lihat semua',
                        onAction: () =>
                            GoRouter.of(context).go(AppRoutes.purchasing),
                        padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      ),
                      for (final order in snapshot.recentPurchases) ...[
                        PurchaseOrderCard(
                          order: order,
                          onTap: () => GoRouter.of(
                            context,
                          ).go(AppRoutes.purchaseOrderDetailPath(order.id)),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                      ],
                    ],
                    if (snapshot.lowStockProducts.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.lg),
                      AppSectionHeader(
                        title: 'Stok menipis',
                        actionLabel: 'Lihat semua',
                        onAction: () =>
                            GoRouter.of(context).go(AppRoutes.inventory),
                        padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      ),
                      for (final product in snapshot.lowStockProducts) ...[
                        _LowStockTile(product: product),
                        const SizedBox(height: AppSpacing.sm),
                      ],
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      },
    );
  }
}

class _Greeting extends StatelessWidget {
  const _Greeting({required this.name, required this.role});

  final String name;
  final UserRole role;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Halo, $name',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.6,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${role.label} • ${DateFormatter.relativeDay(DateTime.now())}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            color: scheme.primaryContainer.withValues(alpha: 0.6),
          ),
          child: Icon(
            Icons.inventory_2_rounded,
            color: scheme.onPrimaryContainer,
            size: 22,
          ),
        ),
      ],
    );
  }
}

class _KpiGrid extends StatelessWidget {
  const _KpiGrid({
    required this.snapshot,
    required this.canSeeSales,
    required this.canSeePurchasing,
  });

  final DashboardSnapshot snapshot;
  final bool canSeeSales;
  final bool canSeePurchasing;

  @override
  Widget build(BuildContext context) {
    final cards = <Widget>[];

    if (canSeeSales) {
      cards.add(
        StatCard(
          label: 'Penjualan bulan ini',
          value: CurrencyFormatter.formatCompact(snapshot.salesTotalThisMonth),
          caption: '${snapshot.salesCountThisMonth} sales order',
          icon: Icons.trending_up_rounded,
          color: Colors.green.shade700,
          onTap: () => GoRouter.of(context).go(AppRoutes.sales),
        ),
      );
    }

    if (canSeePurchasing) {
      cards.add(
        StatCard(
          label: 'Pembelian bulan ini',
          value: CurrencyFormatter.formatCompact(
            snapshot.purchaseTotalThisMonth,
          ),
          caption: '${snapshot.purchaseCountThisMonth} purchase order',
          icon: Icons.shopping_bag_outlined,
          color: Colors.blue.shade700,
          onTap: () => GoRouter.of(context).go(AppRoutes.purchasing),
        ),
      );
    }

    cards.add(
      StatCard(
        label: 'Nilai stok',
        value: CurrencyFormatter.formatCompact(snapshot.stockValue),
        caption: '${snapshot.activeProductCount} produk aktif',
        icon: Icons.warehouse_outlined,
        onTap: () => GoRouter.of(context).go(AppRoutes.inventory),
      ),
    );

    cards.add(
      StatCard(
        label: 'Stok menipis',
        value: '${snapshot.lowStockCount}',
        caption: 'produk perlu dibeli',
        icon: Icons.warning_amber_rounded,
        color: snapshot.lowStockCount > 0
            ? Colors.orange.shade700
            : Colors.green.shade700,
        onTap: () => GoRouter.of(context).go(AppRoutes.inventory),
      ),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth > 520 ? 4 : 2;
        final spacing = AppSpacing.md;
        final itemWidth =
            (constraints.maxWidth - spacing * (columns - 1)) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final card in cards) SizedBox(width: itemWidth, child: card),
          ],
        );
      },
    );
  }
}

class _StatusSummary extends StatelessWidget {
  const _StatusSummary({required this.snapshot, required this.canSeeSales});

  final DashboardSnapshot snapshot;
  final bool canSeeSales;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final chips = <Widget>[];

    if (canSeeSales) {
      for (final entry in snapshot.salesStatusCounts.entries) {
        chips.add(
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: StatusChip(
              label: '${entry.key.label} ${entry.value}',
              color: salesOrderStatusColor(entry.key, scheme),
            ),
          ),
        );
      }
      chips.add(
        Padding(
          padding: const EdgeInsets.only(right: AppSpacing.sm),
          child: StatusChip(
            label: 'Belum selesai ${snapshot.pendingSalesCount}',
            color: scheme.primary,
            icon: Icons.pending_actions_rounded,
          ),
        ),
      );
    }

    if (chips.isEmpty) return const SizedBox.shrink();

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Status penjualan bulan ini',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: chips,
          ),
        ],
      ),
    );
  }
}

class _LowStockTile extends StatelessWidget {
  const _LowStockTile({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return AppCard(
      onTap: () =>
          GoRouter.of(context).go(AppRoutes.productDetailPath(product.id)),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              color: Colors.orange.shade700.withValues(alpha: 0.12),
            ),
            child: Icon(
              Icons.trending_down_rounded,
              size: 18,
              color: Colors.orange.shade700,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Sisa ${CurrencyFormatter.formatNumber(product.stock)}'
                  ' • minimum ${CurrencyFormatter.formatNumber(product.minStock)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded),
        ],
      ),
    );
  }
}

class _DashboardSkeleton extends StatelessWidget {
  const _DashboardSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppShimmer(child: SizedBox(height: 56)),
          SizedBox(height: AppSpacing.lg),
          AppShimmer(child: SizedBox(height: 120)),
          SizedBox(height: AppSpacing.lg),
          AppShimmer(child: SizedBox(height: 180)),
        ],
      ),
    );
  }
}
