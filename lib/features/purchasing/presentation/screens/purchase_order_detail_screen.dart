import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_confirm_dialog.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/content_width.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../../auth/domain/models/user_role.dart';
import '../../../auth/presentation/providers/auth_controller.dart';
import '../../domain/models/purchase_order.dart';
import '../providers/purchase_order_list_provider.dart';
import '../widgets/purchase_order_card.dart';

/// Detail page of a purchase order with its approval flow.
class PurchaseOrderDetailScreen extends ConsumerWidget {
  const PurchaseOrderDetailScreen({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(purchaseOrderDetailProvider(orderId));
    final role = ref.watch(authControllerProvider).role ?? UserRole.sales;
    final userId = ref.watch(authControllerProvider).user?.id;

    final order = detailAsync.value?.order;
    final canApprove = role.canApproveOrders;
    final canReceive = role.canManageInventory;
    final isOwner = order != null && order.createdBy == userId;
    final canCancel =
        order != null &&
        (order.isDraft || order.isApproved) &&
        (canApprove || (role == UserRole.purchasing && isOwner));

    return Scaffold(
      appBar: AppBar(title: const Text('Detail purchase order')),
      body: switch (detailAsync.value) {
        null when detailAsync.hasError => AppErrorState(
          message: 'Purchase order tidak dapat dimuat.',
          onRetry: () => ref.invalidate(purchaseOrderDetailProvider(orderId)),
        ),
        null => const Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: AppShimmerList(itemCount: 5, itemHeight: 90),
        ),
        final PurchaseOrderDetail detail => _OrderBody(detail: detail),
      },
      bottomNavigationBar: order == null
          ? null
          : _ActionBar(
              order: order,
              canApprove: canApprove,
              canReceive: canReceive,
              canCancel: canCancel,
            ),
    );
  }
}

class _OrderBody extends StatelessWidget {
  const _OrderBody({required this.detail});

  final PurchaseOrderDetail detail;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final order = detail.order;

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
                      children: [
                        Expanded(
                          child: Text(
                            order.poNumber,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        StatusChip(
                          label: order.status.label,
                          color: purchaseOrderStatusColor(order.status, scheme),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      order.supplierName ?? 'Supplier tidak dikenal',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _InfoRow(
                      label: 'Dibuat',
                      value: order.createdAt == null
                          ? '-'
                          : DateFormatter.dateTime(order.createdAt!),
                    ),
                    if (order.approvedAt != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      _InfoRow(
                        label: 'Disetujui',
                        value: DateFormatter.dateTime(order.approvedAt!),
                      ),
                    ],
                    if (order.receivedAt != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      _InfoRow(
                        label: 'Diterima',
                        value: DateFormatter.dateTime(order.receivedAt!),
                      ),
                    ],
                    if (order.note != null && order.note!.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.md),
                      Text(order.note!, style: theme.textTheme.bodyMedium),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Item (${detail.items.length})',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              for (final item in detail.items) ...[
                _OrderItemTile(item: item),
                const SizedBox(height: AppSpacing.sm),
              ],
              const SizedBox(height: AppSpacing.sm),
              AppCard(
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Total',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    Text(
                      CurrencyFormatter.format(order.total),
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _OrderItemTile extends StatelessWidget {
  const _OrderItemTile({required this.item});

  final PurchaseOrderItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName ?? '-',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${item.productSku ?? '-'} • '
                  '${CurrencyFormatter.formatNumber(item.qty)} '
                  '${item.unit ?? ''} × ${CurrencyFormatter.format(item.price)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Text(
            CurrencyFormatter.format(item.subtotal),
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Text(
          '$label: ',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        Text(value, style: theme.textTheme.bodySmall),
      ],
    );
  }
}

class _ActionBar extends ConsumerWidget {
  const _ActionBar({
    required this.order,
    required this.canApprove,
    required this.canReceive,
    required this.canCancel,
  });

  final PurchaseOrder order;
  final bool canApprove;
  final bool canReceive;
  final bool canCancel;

  Future<void> _run(
    BuildContext context,
    WidgetRef ref, {
    required String title,
    required String message,
    required String confirmLabel,
    required IconData icon,
    required Future<void> Function() action,
    required String successMessage,
  }) async {
    final confirmed = await showConfirmDialog(
      context,
      title: title,
      message: message,
      confirmLabel: confirmLabel,
      destructive: false,
      icon: icon,
    );
    if (!confirmed || !context.mounted) return;

    try {
      await action();
      if (!context.mounted) return;
      AppSnackBar.showSuccess(context, successMessage);
    } catch (error) {
      if (!context.mounted) return;
      AppSnackBar.showError(context, error.toString());
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actions = ref.read(purchaseOrderActionsProvider);

    final List<Widget> buttons = [];

    if (order.isDraft && canApprove) {
      buttons.add(
        Expanded(
          child: FilledButton.icon(
            onPressed: () => _run(
              context,
              ref,
              title: 'Setujui purchase order?',
              message:
                  'Purchase order ${order.poNumber} akan disetujui dan siap '
                  'diterima oleh gudang.',
              confirmLabel: 'Setujui',
              icon: Icons.verified_outlined,
              successMessage: 'Purchase order disetujui.',
              action: () => actions.approvePurchaseOrder(order.id),
            ),
            icon: const Icon(Icons.verified_outlined),
            label: const Text('Setujui'),
          ),
        ),
      );
    }

    if (order.isApproved && canReceive) {
      buttons.add(
        Expanded(
          child: FilledButton.icon(
            onPressed: () => _run(
              context,
              ref,
              title: 'Terima barang?',
              message:
                  'Stok produk akan otomatis bertambah sesuai item purchase '
                  'order ${order.poNumber}.',
              confirmLabel: 'Terima',
              icon: Icons.inventory_rounded,
              successMessage: 'Barang diterima, stok sudah diperbarui.',
              action: () => actions.receivePurchaseOrder(order.id),
            ),
            icon: const Icon(Icons.inventory_rounded),
            label: const Text('Terima barang'),
          ),
        ),
      );
    }

    if (canCancel) {
      buttons.add(
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _run(
              context,
              ref,
              title: 'Batalkan purchase order?',
              message:
                  'Purchase order ${order.poNumber} akan dibatalkan dan tidak '
                  'dapat diproses lagi.',
              confirmLabel: 'Batalkan',
              icon: Icons.cancel_outlined,
              successMessage: 'Purchase order dibatalkan.',
              action: () => actions.cancelPurchaseOrder(order.id),
            ),
            icon: const Icon(Icons.cancel_outlined),
            label: const Text('Batalkan'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
          ),
        ),
      );
    }

    if (buttons.isEmpty) return const SizedBox.shrink();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            for (var index = 0; index < buttons.length; index++) ...[
              if (index > 0) const SizedBox(width: AppSpacing.md),
              buttons[index],
            ],
          ],
        ),
      ),
    );
  }
}
