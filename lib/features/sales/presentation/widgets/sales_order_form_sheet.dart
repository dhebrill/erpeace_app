import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/input_formatters.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_confirm_dialog.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../inventory/domain/models/product.dart';
import '../../../inventory/presentation/providers/product_list_provider.dart';
import '../../domain/models/customer.dart';
import '../../domain/models/sales_order.dart';
import '../providers/sales_order_list_provider.dart';
import 'customer_form_sheet.dart';

/// Opens the sales order creation sheet.
///
/// Returns `true` when the order was created.
Future<bool?> showSalesOrderFormSheet(BuildContext context) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (context) => const SalesOrderFormSheet(),
  );
}

/// Draft of a single sales order line.
class _LineDraft {
  _LineDraft() : qtyController = TextEditingController(text: '1');

  Product? product;
  final TextEditingController qtyController;
  final TextEditingController priceController = TextEditingController();

  double get qty => CurrencyFormatter.tryParseQuantity(qtyController.text) ?? 0;

  double get price => CurrencyFormatter.tryParse(priceController.text) ?? 0;

  double get subtotal => qty * price;

  /// Estimated profit of the line, based on the buying price of the product.
  double get profit => qty * (price - (product?.buyPrice ?? 0));

  bool get exceedsStock => product != null && qty > product!.stock;

  void dispose() {
    qtyController.dispose();
    priceController.dispose();
  }
}

/// Form used to create a sales order.
class SalesOrderFormSheet extends ConsumerStatefulWidget {
  const SalesOrderFormSheet({super.key});

  @override
  ConsumerState<SalesOrderFormSheet> createState() =>
      _SalesOrderFormSheetState();
}

class _SalesOrderFormSheetState extends ConsumerState<SalesOrderFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _noteController = TextEditingController();
  final List<_LineDraft> _lines = [_LineDraft()];

  String? _customerId;
  bool _isSaving = false;

  @override
  void dispose() {
    _noteController.dispose();
    for (final line in _lines) {
      line.dispose();
    }
    super.dispose();
  }

  double get _total => _lines.fold(0, (sum, line) => sum + line.subtotal);

  double get _profit => _lines.fold(0, (sum, line) => sum + line.profit);

  void _addLine() {
    setState(() => _lines.add(_LineDraft()));
  }

  void _removeLine(int index) {
    setState(() {
      _lines.removeAt(index).dispose();
    });
  }

  void _selectProduct(int index, Product? product) {
    final line = _lines[index];
    setState(() {
      line.product = product;
      line.priceController.text = product == null
          ? ''
          : CurrencyFormatter.formatEditable(product.sellPrice);
    });
  }

  Future<void> _addCustomer() async {
    final created = await showCustomerFormSheet(context);
    if (created == null || !mounted) return;
    setState(() => _customerId = created.id);
  }

  Future<void> _save() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;

    final usable = _lines
        .where((line) => line.product != null && line.qty > 0)
        .toList(growable: false);
    if (usable.isEmpty) {
      AppSnackBar.showError(
        context,
        'Tambahkan minimal satu item dengan jumlah lebih dari 0.',
      );
      return;
    }

    final overStock = usable.where((line) => line.exceedsStock).toList();
    if (overStock.isNotEmpty) {
      final confirmed = await showConfirmDialog(
        context,
        title: 'Stok tidak mencukupi?',
        message:
            'Jumlah ${overStock.first.product!.name} melebihi stok yang tersedia '
            '(${CurrencyFormatter.formatNumber(overStock.first.product!.stock)}). '
            'Pesanan tetap dibuat tetapi tidak dapat diselesaikan sebelum stok '
            'cukup.',
        confirmLabel: 'Lanjutkan',
        destructive: false,
        icon: Icons.warning_amber_rounded,
      );
      if (!confirmed || !mounted) return;
    }

    FocusScope.of(context).unfocus();
    setState(() => _isSaving = true);

    try {
      await ref
          .read(salesOrderActionsProvider)
          .createSalesOrder(
            customerId: _customerId!,
            note: _noteController.text.trim().isEmpty
                ? null
                : _noteController.text.trim(),
            items: [
              for (final line in usable)
                SalesOrderLine(
                  productId: line.product!.id,
                  productName: line.product!.name,
                  productSku: line.product!.sku,
                  unit: line.product!.unit,
                  qty: line.qty,
                  price: line.price,
                  availableStock: line.product!.stock,
                ),
            ],
          );
      if (!mounted) return;
      AppSnackBar.showSuccess(context, 'Sales order berhasil dibuat.');
      Navigator.of(context).pop(true);
    } catch (error) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      AppSnackBar.showError(context, error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customers =
        ref.watch(customerListProvider).value ?? const <Customer>[];
    final products =
        ref.watch(activeProductListProvider).value ?? const <Product>[];

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.9,
        maxChildSize: 0.95,
        minChildSize: 0.6,
        builder: (context, scrollController) {
          return Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.xxl,
                    0,
                    AppSpacing.xxl,
                    AppSpacing.md,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Sales order baru',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () => Navigator.of(context).pop(),
                        tooltip: 'Tutup',
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.xxl,
                      AppSpacing.xl,
                      AppSpacing.xxl,
                      AppSpacing.xxl,
                    ),
                    children: [
                      DropdownButtonFormField<String>(
                        initialValue: _customerId,
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText: 'Pelanggan',
                          prefixIcon: const Icon(
                            Icons.person_outline_rounded,
                            size: 20,
                          ),
                          suffixIcon: IconButton(
                            tooltip: 'Tambah pelanggan',
                            icon: const Icon(Icons.add_rounded),
                            onPressed: _addCustomer,
                          ),
                        ),
                        items: [
                          for (final customer in customers)
                            DropdownMenuItem(
                              value: customer.id,
                              child: Text(
                                customer.name,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                        ],
                        onChanged: (value) =>
                            setState(() => _customerId = value),
                        validator: (value) =>
                            value == null ? 'Pelanggan wajib dipilih' : null,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      AppTextField(
                        controller: _noteController,
                        label: 'Catatan',
                        prefixIcon: Icons.notes_rounded,
                        maxLines: 2,
                        minLines: 1,
                        textInputAction: TextInputAction.newline,
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Item sales order',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          Text(
                            '${_lines.length} baris',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      for (var index = 0; index < _lines.length; index++) ...[
                        _OrderLineTile(
                          key: ValueKey(index),
                          index: index,
                          draft: _lines[index],
                          products: products,
                          canRemove: _lines.length > 1,
                          onProductChanged: (product) =>
                              _selectProduct(index, product),
                          onRemove: () => _removeLine(index),
                        ),
                        const SizedBox(height: AppSpacing.md),
                      ],
                      OutlinedButton.icon(
                        onPressed: _addLine,
                        icon: const Icon(Icons.add_rounded, size: 18),
                        label: const Text('Tambah item'),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      AppCard(
                        child: Column(
                          children: [
                            _SummaryRow(
                              label: 'Total penjualan',
                              value: CurrencyFormatter.format(_total),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            _SummaryRow(
                              label: 'Estimasi laba',
                              value: CurrencyFormatter.format(_profit),
                              valueColor: _profit >= 0
                                  ? Colors.green.shade700
                                  : theme.colorScheme.error,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      FilledButton(
                        onPressed: _isSaving ? null : _save,
                        child: _isSaving
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.4,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('Simpan sales order'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}

class _OrderLineTile extends StatelessWidget {
  const _OrderLineTile({
    super.key,
    required this.index,
    required this.draft,
    required this.products,
    required this.canRemove,
    required this.onProductChanged,
    required this.onRemove,
  });

  final int index;
  final _LineDraft draft;
  final List<Product> products;
  final bool canRemove;
  final ValueChanged<Product?> onProductChanged;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Item ${index + 1}',
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              if (canRemove)
                IconButton(
                  tooltip: 'Hapus item',
                  visualDensity: VisualDensity.compact,
                  icon: Icon(
                    Icons.delete_outline_rounded,
                    size: 20,
                    color: scheme.error,
                  ),
                  onPressed: onRemove,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          DropdownButtonFormField<String>(
            key: ValueKey('product-$index-${draft.product?.id}'),
            initialValue: draft.product?.id,
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'Produk',
              prefixIcon: Icon(Icons.inventory_2_outlined, size: 20),
            ),
            items: [
              for (final product in products)
                DropdownMenuItem(
                  value: product.id,
                  child: Text(
                    '${product.name} (${product.sku}) • stok '
                    '${CurrencyFormatter.formatNumber(product.stock)}',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
            onChanged: (productId) {
              if (productId == null) {
                onProductChanged(null);
                return;
              }
              for (final product in products) {
                if (product.id == productId) {
                  onProductChanged(product);
                  return;
                }
              }
            },
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: draft.qtyController,
                  label: 'Jumlah',
                  prefixIcon: Icons.numbers_rounded,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [const DecimalTextInputFormatter()],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: AppTextField(
                  controller: draft.priceController,
                  label: 'Harga satuan',
                  prefixIcon: Icons.local_offer_outlined,
                  keyboardType: TextInputType.number,
                  inputFormatters: [const RupiahTextInputFormatter()],
                ),
              ),
            ],
          ),
          if (draft.product != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Stok tersedia: ${CurrencyFormatter.formatNumber(draft.product!.stock)} '
              '${draft.product!.unit}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: draft.exceedsStock
                    ? scheme.error
                    : scheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
