import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/input_formatters.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../inventory/domain/models/product.dart';
import '../../../inventory/presentation/providers/product_list_provider.dart';
import '../../domain/models/purchase_order.dart';
import '../../domain/models/supplier.dart';
import '../providers/purchase_order_list_provider.dart';
import 'supplier_form_sheet.dart';

/// Opens the purchase order creation sheet.
///
/// Returns `true` when the order was created.
Future<bool?> showPurchaseOrderFormSheet(BuildContext context) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (context) => const PurchaseOrderFormSheet(),
  );
}

/// Draft of a single purchase order line.
class _LineDraft {
  _LineDraft() : qtyController = TextEditingController(text: '1');

  Product? product;
  final TextEditingController qtyController;
  final TextEditingController priceController = TextEditingController();

  double get qty => CurrencyFormatter.tryParseQuantity(qtyController.text) ?? 0;

  double get price => CurrencyFormatter.tryParse(priceController.text) ?? 0;

  double get subtotal => qty * price;

  void dispose() {
    qtyController.dispose();
    priceController.dispose();
  }
}

/// Form used to create a purchase order.
class PurchaseOrderFormSheet extends ConsumerStatefulWidget {
  const PurchaseOrderFormSheet({super.key});

  @override
  ConsumerState<PurchaseOrderFormSheet> createState() =>
      _PurchaseOrderFormSheetState();
}

class _PurchaseOrderFormSheetState
    extends ConsumerState<PurchaseOrderFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _noteController = TextEditingController();
  final List<_LineDraft> _lines = [_LineDraft()];

  String? _supplierId;
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
          : CurrencyFormatter.formatEditable(product.buyPrice);
    });
  }

  Future<void> _addSupplier() async {
    final created = await showSupplierFormSheet(context);
    if (created == null || !mounted) return;
    setState(() => _supplierId = created.id);
  }

  Future<void> _save() async {
    final isValid = _formKey.currentState!.validate();
    final hasItems = _lines.any(
      (line) => line.product != null && line.qty > 0 && line.price >= 0,
    );
    if (!isValid) return;
    if (!hasItems) {
      AppSnackBar.showError(
        context,
        'Tambahkan minimal satu item dengan jumlah lebih dari 0.',
      );
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() => _isSaving = true);

    try {
      await ref
          .read(purchaseOrderActionsProvider)
          .createPurchaseOrder(
            supplierId: _supplierId!,
            note: _noteController.text.trim().isEmpty
                ? null
                : _noteController.text.trim(),
            items: [
              for (final line in _lines)
                if (line.product != null && line.qty > 0)
                  PurchaseOrderLine(
                    productId: line.product!.id,
                    productName: line.product!.name,
                    productSku: line.product!.sku,
                    unit: line.product!.unit,
                    qty: line.qty,
                    price: line.price,
                  ),
            ],
          );
      if (!mounted) return;
      AppSnackBar.showSuccess(context, 'Purchase order berhasil dibuat.');
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
    final suppliers =
        ref.watch(supplierListProvider).value ?? const <Supplier>[];
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
                          'Purchase order baru',
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
                        initialValue: _supplierId,
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText: 'Supplier',
                          prefixIcon: const Icon(
                            Icons.local_shipping_outlined,
                            size: 20,
                          ),
                          suffixIcon: IconButton(
                            tooltip: 'Tambah supplier',
                            icon: const Icon(Icons.add_rounded),
                            onPressed: _addSupplier,
                          ),
                        ),
                        items: [
                          for (final supplier in suppliers)
                            DropdownMenuItem(
                              value: supplier.id,
                              child: Text(
                                supplier.name,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                        ],
                        onChanged: (value) =>
                            setState(() => _supplierId = value),
                        validator: (value) =>
                            value == null ? 'Supplier wajib dipilih' : null,
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
                              'Item purchase order',
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
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Total purchase order',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                            Text(
                              CurrencyFormatter.format(_total),
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
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
                            : const Text('Simpan purchase order'),
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
                    '${product.name} (${product.sku})',
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
                  prefixIcon: Icons.sell_outlined,
                  keyboardType: TextInputType.number,
                  inputFormatters: [const RupiahTextInputFormatter()],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
