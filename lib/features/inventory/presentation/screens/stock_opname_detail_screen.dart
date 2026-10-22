import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_confirm_dialog.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/content_width.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../../auth/domain/models/user_role.dart';
import '../../../auth/presentation/providers/auth_controller.dart';
import '../../domain/models/stock_opname.dart';
import '../providers/stock_opname_list_provider.dart';

/// Detail page of a stock opname session.
class StockOpnameDetailScreen extends ConsumerStatefulWidget {
  const StockOpnameDetailScreen({super.key, required this.opnameId});

  final String opnameId;

  @override
  ConsumerState<StockOpnameDetailScreen> createState() =>
      _StockOpnameDetailScreenState();
}

class _StockOpnameDetailScreenState
    extends ConsumerState<StockOpnameDetailScreen> {
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, double> _lastSaved = {};
  final Set<String> _saving = {};

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  TextEditingController _controllerFor(StockOpnameItem item) {
    return _controllers.putIfAbsent(
      item.id,
      () => TextEditingController(
        text: CurrencyFormatter.formatEditable(item.countedQty),
      ),
    );
  }

  Future<void> _saveCount(StockOpnameItem item) async {
    final controller = _controllerFor(item);
    final raw = controller.text.trim();
    final parsed = CurrencyFormatter.tryParse(raw) ?? 0;

    if (parsed == item.countedQty) return;
    if (_lastSaved[item.id] == parsed) return;
    _lastSaved[item.id] = parsed;

    setState(() => _saving.add(item.id));
    try {
      await ref.read(stockOpnameActionsProvider).setCount(item.id, parsed);
      if (!mounted) return;
      AppSnackBar.showSuccess(context, 'Jumlah ${item.productName} disimpan.');
    } catch (error) {
      _lastSaved.remove(item.id);
      if (!mounted) return;
      controller.text = CurrencyFormatter.formatEditable(item.countedQty);
      AppSnackBar.showError(context, error.toString());
    } finally {
      if (mounted) setState(() => _saving.remove(item.id));
    }
  }

  Future<void> _finalize(StockOpname opname) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Finalisasi stock opname?',
      message:
          'Selisih stok akan langsung adjusting ke data stok produk dan '
          'tidak dapat diubah lagi.',
      confirmLabel: 'Finalisasi',
      destructive: false,
      icon: Icons.fact_check_rounded,
    );
    if (!confirmed || !mounted) return;

    try {
      await ref.read(stockOpnameActionsProvider).finalizeOpname(opname.id);
      if (!mounted) return;
      AppSnackBar.showSuccess(
        context,
        'Stock opname difinalisasi. Stok produk telah disesuaikan.',
      );
    } catch (error) {
      if (!mounted) return;
      AppSnackBar.showError(context, error.toString());
    }
  }

  Future<void> _cancel(StockOpname opname) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Batalkan stock opname?',
      message:
          'Sesi ${opname.opnameNumber} akan dibatalkan dan tidak dapat '
          'digunakan kembali.',
      confirmLabel: 'Batalkan',
    );
    if (!confirmed || !mounted) return;

    try {
      await ref.read(stockOpnameActionsProvider).cancelOpname(opname.id);
      if (!mounted) return;
      AppSnackBar.showSuccess(context, 'Stock opname dibatalkan.');
    } catch (error) {
      if (!mounted) return;
      AppSnackBar.showError(context, error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final detailAsync = ref.watch(stockOpnameDetailProvider(widget.opnameId));
    final role = ref.watch(authControllerProvider).role ?? UserRole.sales;
    final canManage = role.canManageInventory;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail opname'),
        actions: [
          if (canManage && (detailAsync.value?.opname.isDraft ?? false))
            IconButton(
              tooltip: 'Batalkan opname',
              icon: const Icon(Icons.cancel_outlined),
              onPressed: () => _cancel(detailAsync.value!.opname),
            ),
        ],
      ),
      body: switch (detailAsync.value) {
        null when detailAsync.hasError => AppErrorState(
          message: 'Stock opname tidak dapat dimuat.',
          onRetry: () =>
              ref.invalidate(stockOpnameDetailProvider(widget.opnameId)),
        ),
        null => const Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: AppShimmerList(itemCount: 6, itemHeight: 84),
        ),
        final StockOpnameDetail detail => _detailBody(detail, canManage),
      },
      bottomNavigationBar:
          (detailAsync.value?.opname.isDraft ?? false) && canManage
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: FilledButton.icon(
                  onPressed: () => _finalize(detailAsync.value!.opname),
                  icon: const Icon(Icons.check_circle_outline_rounded),
                  label: const Text('Finalisasi stock opname'),
                ),
              ),
            )
          : null,
    );
  }

  Widget _detailBody(StockOpnameDetail detail, bool canManage) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final opname = detail.opname;
    final differences = detail.items.where((item) => item.hasDifference).length;

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
                            opname.opnameNumber,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        StatusChip(
                          label: opname.status.label,
                          color: switch (opname.status) {
                            StockOpnameStatus.draft => scheme.primary,
                            StockOpnameStatus.finalized =>
                              Colors.green.shade700,
                            StockOpnameStatus.cancelled => scheme.error,
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      opname.createdAt == null
                          ? '-'
                          : 'Dibuat ${DateFormatter.dateTime(opname.createdAt!)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    if (opname.note != null && opname.note!.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Text(opname.note!, style: theme.textTheme.bodyMedium),
                    ],
                    const SizedBox(height: AppSpacing.lg),
                    Row(
                      children: [
                        Expanded(
                          child: _Summary(
                            label: 'Total item',
                            value: '${detail.items.length}',
                            color: scheme.primary,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: _Summary(
                            label: 'Selisih',
                            value: '$differences',
                            color: differences > 0
                                ? Colors.orange.shade700
                                : Colors.green.shade700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              if (detail.items.isEmpty)
                const AppEmptyState(
                  title: 'Tidak ada item',
                  message: 'Sesi opname ini tidak memiliki produk.',
                  icon: Icons.inventory_2_outlined,
                  compact: true,
                )
              else
                for (final item in detail.items) ...[
                  _OpnameItemTile(
                    item: item,
                    controller: _controllerFor(item),
                    isSaving: _saving.contains(item.id),
                    isEditable: canManage && opname.isDraft,
                    onSubmit: () => _saveCount(item),
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
            ],
          ),
        ),
      ],
    );
  }
}

class _OpnameItemTile extends StatelessWidget {
  const _OpnameItemTile({
    required this.item,
    required this.controller,
    required this.isSaving,
    required this.isEditable,
    required this.onSubmit,
  });

  final StockOpnameItem item;
  final TextEditingController controller;
  final bool isSaving;
  final bool isEditable;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final hasDifference = item.hasDifference;
    final differenceColor = hasDifference
        ? (item.difference < 0 ? scheme.error : Colors.orange.shade700)
        : Colors.green.shade700;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.productName ?? '-',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${item.productSku ?? '-'} • Sistem: '
                      '${CurrencyFormatter.formatNumber(item.systemQty)} '
                      '${item.unit ?? ''}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (hasDifference)
                StatusChip(
                  label:
                      '${item.difference > 0 ? '+' : ''}'
                      '${CurrencyFormatter.formatNumber(item.difference)}',
                  dense: true,
                  color: differenceColor,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Jumlah hasil hitung fisik',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ),
              SizedBox(
                width: 130,
                child: TextField(
                  controller: controller,
                  enabled: isEditable,
                  textAlign: TextAlign.end,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                  ],
                  onSubmitted: (_) => onSubmit(),
                  onTapOutside: (_) {
                    FocusScope.of(context).unfocus();
                    onSubmit();
                  },
                  decoration: InputDecoration(
                    isDense: true,
                    counterText: '',
                    suffixText: item.unit,
                    suffixIcon: isSaving
                        ? const Padding(
                            padding: EdgeInsets.all(10),
                            child: SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                        : null,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Summary extends StatelessWidget {
  const _Summary({
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
