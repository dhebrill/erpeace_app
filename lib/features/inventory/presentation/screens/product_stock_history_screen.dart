import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../../../core/widgets/content_width.dart';
import '../../domain/models/stock_movement.dart';
import '../providers/product_list_provider.dart';

/// Journal of every stock change of a single product.
class ProductStockHistoryScreen extends ConsumerWidget {
  const ProductStockHistoryScreen({super.key, required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movements = ref.watch(productStockHistoryProvider(productId));

    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat stok')),
      body: switch (movements.value) {
        null when movements.hasError => AppErrorState(
          message: 'Riwayat stok tidak dapat dimuat.',
          onRetry: () => ref.invalidate(productStockHistoryProvider(productId)),
        ),
        null => const Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: AppShimmerList(itemCount: 5, itemHeight: 76),
        ),
        final List<StockMovement> list when list.isEmpty => const AppEmptyState(
          title: 'Belum ada pergerakan stok',
          message: 'Riwayat stok produk ini masih kosong.',
          icon: Icons.history_toggle_off_rounded,
        ),
        final List<StockMovement> list => RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(productStockHistoryProvider(productId));
          },
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.xxxl,
            ),
            itemCount: list.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, index) =>
                ContentWidth(child: _MovementTile(movement: list[index])),
          ),
        ),
      },
    );
  }
}

class _MovementTile extends StatelessWidget {
  const _MovementTile({required this.movement});

  final StockMovement movement;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isNegative =
        movement.quantity < 0 || movement.type == StockMovementType.stockOut;
    final color = isNegative ? scheme.error : Colors.green.shade700;

    return AppCard(
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              color: color.withValues(alpha: 0.12),
            ),
            child: Icon(movement.type.icon, size: 20, color: color),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movement.type.label,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  movement.note ?? _referenceLabel(movement),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                if (movement.createdAt != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    DateFormatter.dateTime(movement.createdAt!),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            '${isNegative ? '-' : '+'}${CurrencyFormatter.formatNumber(movement.quantity.abs())}',
            style: theme.textTheme.titleSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  String _referenceLabel(StockMovement movement) {
    switch (movement.referenceType) {
      case 'purchase_order':
        return 'Penerimaan pembelian';
      case 'sales_order':
        return 'Penjualan';
      case 'stock_opname':
        return 'Stock opname';
      case 'opening':
        return 'Saldo awal';
      default:
        return 'Perubahan stok';
    }
  }
}
