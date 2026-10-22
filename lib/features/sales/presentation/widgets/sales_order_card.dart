import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../domain/models/sales_order.dart';

/// Returns the color used to render a sales order status.
Color salesOrderStatusColor(SalesOrderStatus status, ColorScheme scheme) {
  switch (status) {
    case SalesOrderStatus.draft:
      return scheme.primary;
    case SalesOrderStatus.approved:
      return Colors.blue.shade700;
    case SalesOrderStatus.completed:
      return Colors.green.shade700;
    case SalesOrderStatus.cancelled:
      return scheme.error;
  }
}

/// Card that summarises a sales order inside the list.
class SalesOrderCard extends StatelessWidget {
  const SalesOrderCard({
    super.key,
    required this.order,
    this.onTap,
    this.trailing,
  });

  final SalesOrder order;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return AppCard(
      onTap: onTap,
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
                      order.soNumber,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      order.customerName ?? 'Pelanggan tidak dikenal',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              StatusChip(
                label: order.status.label,
                dense: true,
                color: salesOrderStatusColor(order.status, scheme),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: Text(
                  CurrencyFormatter.format(order.total),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                '${order.itemCount} item'
                '${order.createdAt == null ? '' : ' • ${DateFormatter.date(order.createdAt!)}'}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: AppSpacing.sm),
                trailing!,
              ],
            ],
          ),
        ],
      ),
    );
  }
}
