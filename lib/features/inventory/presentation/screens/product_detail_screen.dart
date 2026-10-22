import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_confirm_dialog.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/content_width.dart';
import '../../../auth/domain/models/user_role.dart';
import '../../../auth/presentation/providers/auth_controller.dart';
import '../../domain/models/product.dart';
import '../providers/inventory_actions.dart';
import '../providers/product_list_provider.dart';
import '../widgets/product_card.dart';
import '../widgets/product_form_sheet.dart';

/// Detail page of a single product.
class ProductDetailScreen extends ConsumerWidget {
  const ProductDetailScreen({super.key, required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsync = ref.watch(productDetailProvider(productId));
    final role = ref.watch(authControllerProvider).role ?? UserRole.sales;
    final canManage = role.canManageInventory;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail produk'),
        actions: [
          if (canManage)
            productAsync.value == null
                ? const SizedBox.shrink()
                : IconButton(
                    tooltip: 'Ubah produk',
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: () async {
                      final saved = await showProductFormSheet(
                        context,
                        product: productAsync.value,
                      );
                      if (saved == true && context.mounted) {
                        ref.invalidate(productDetailProvider(productId));
                      }
                    },
                  ),
        ],
      ),
      body: switch (productAsync.value) {
        null when productAsync.hasError => AppErrorState(
          message: 'Produk tidak dapat dimuat.',
          onRetry: () => ref.invalidate(productDetailProvider(productId)),
        ),
        null => const _ProductDetailSkeleton(),
        final Product product => _ProductDetailBody(
          product: product,
          canManage: canManage,
        ),
      },
    );
  }
}

class _ProductDetailBody extends ConsumerWidget {
  const _ProductDetailBody({required this.product, required this.canManage});

  final Product product;
  final bool canManage;

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Hapus produk?',
      message: 'Produk "${product.name}" akan dihapus permanen dari daftar.',
    );
    if (!confirmed || !context.mounted) return;

    try {
      await ref.read(inventoryActionsProvider).deleteProduct(product.id);
      if (!context.mounted) return;
      AppSnackBar.showSuccess(context, 'Produk dihapus.');
      GoRouter.of(context).go(AppRoutes.inventory);
    } catch (error) {
      if (!context.mounted) return;
      AppSnackBar.showError(context, error.toString());
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return ListView(
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
              AppCard(
                elevated: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.4,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                'SKU ${product.sku}'
                                '${product.categoryName != null ? ' • ${product.categoryName}' : ''}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: scheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        StockBadge(product: product),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Row(
                      children: [
                        Expanded(
                          child: _Metric(
                            label: 'Stok saat ini',
                            value:
                                '${CurrencyFormatter.formatNumber(product.stock)} ${product.unit}',
                            color: product.isLowStock
                                ? Colors.orange.shade700
                                : scheme.primary,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: _Metric(
                            label: 'Stok minimum',
                            value:
                                '${CurrencyFormatter.formatNumber(product.minStock)} ${product.unit}',
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              AppSectionHeader(
                title: 'Harga',
                padding: const EdgeInsets.symmetric(
                  horizontal: 0,
                  vertical: AppSpacing.md,
                ),
              ),
              AppCard(
                child: Column(
                  children: [
                    _PriceRow(
                      label: 'Harga beli',
                      value: CurrencyFormatter.format(product.buyPrice),
                    ),
                    const Divider(height: AppSpacing.xl),
                    _PriceRow(
                      label: 'Harga jual',
                      value: CurrencyFormatter.format(product.sellPrice),
                    ),
                    const Divider(height: AppSpacing.xl),
                    _PriceRow(
                      label: 'Nilai stok (harga jual)',
                      value: CurrencyFormatter.format(product.stockValue),
                    ),
                    if (product.buyPrice > 0) ...[
                      const Divider(height: AppSpacing.xl),
                      _PriceRow(
                        label: 'Potensi laba per unit',
                        value: CurrencyFormatter.format(
                          product.sellPrice - product.buyPrice,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              AppCard(
                onTap: () => GoRouter.of(
                  context,
                ).go(AppRoutes.productStockHistoryPath(product.id)),
                child: Row(
                  children: [
                    Icon(Icons.history_rounded, color: scheme.primary),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Riwayat stok',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            'Lihat seluruh pergerakan stok produk ini.',
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
              ),
              if (product.createdAt != null) ...[
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Dibuat pada ${DateFormatter.dateTime(product.createdAt!)}',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
              if (canManage) ...[
                const SizedBox(height: AppSpacing.xl),
                OutlinedButton.icon(
                  onPressed: () => _delete(context, ref),
                  icon: const Icon(Icons.delete_outline_rounded),
                  label: const Text('Hapus produk'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: scheme.error,
                    side: BorderSide(
                      color: scheme.error.withValues(alpha: 0.4),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _ProductDetailSkeleton extends StatelessWidget {
  const _ProductDetailSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          AppShimmer(
            child: SizedBox(
              height: 160,
              width: double.infinity,
              child: _SkeletonBox(),
            ),
          ),
          SizedBox(height: AppSpacing.lg),
          AppShimmer(
            child: SizedBox(
              height: 220,
              width: double.infinity,
              child: _SkeletonBox(),
            ),
          ),
        ],
      ),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  const _SkeletonBox();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
    );
  }
}
