import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../data/dashboard_repository.dart';

/// Simple bar chart showing the sales of the last seven days.
class SalesBarChart extends StatelessWidget {
  const SalesBarChart({super.key, required this.days, this.height = 140});

  final List<DailySales> days;
  final double height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    if (days.isEmpty) {
      return SizedBox(
        height: height,
        child: Center(
          child: Text(
            'Belum ada data penjualan.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

    final maxValue = days.fold<double>(
      0,
      (max, day) => day.total > max ? day.total : max,
    );
    final maxTotal = maxValue <= 0 ? 1.0 : maxValue;
    final barMaxHeight = height - 34;

    return SizedBox(
      height: height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final day in days)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (day.total > 0)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          CurrencyFormatter.formatCompact(day.total),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                            fontSize: 9,
                          ),
                        ),
                      ),
                    Container(
                      height: (day.total / maxTotal) * barMaxHeight,
                      constraints: const BoxConstraints(minHeight: 4),
                      decoration: BoxDecoration(
                        color: day.total > 0
                            ? scheme.primary
                            : scheme.outlineVariant,
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusSm,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      day.label,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                        fontSize: 9,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
