import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/input_formatters.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../domain/models/category.dart';
import '../../domain/models/product.dart';
import '../providers/inventory_actions.dart';
import '../providers/product_list_provider.dart';

/// Units offered for a product.
const List<String> productUnits = [
  'pcs',
  'box',
  'rim',
  'pak',
  'lusin',
  'kg',
  'gram',
  'liter',
  'botol',
  'sachet',
];

/// Opens the create / edit product sheet.
///
/// Returns `true` when the product was saved.
Future<bool?> showProductFormSheet(BuildContext context, {Product? product}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (context) => ProductFormSheet(product: product),
  );
}

/// Form used to create and to update a product.
class ProductFormSheet extends ConsumerStatefulWidget {
  const ProductFormSheet({super.key, this.product});

  final Product? product;

  @override
  ConsumerState<ProductFormSheet> createState() => _ProductFormSheetState();
}

class _ProductFormSheetState extends ConsumerState<ProductFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _skuController;
  late final TextEditingController _nameController;
  late final TextEditingController _buyPriceController;
  late final TextEditingController _sellPriceController;
  late final TextEditingController _stockController;
  late final TextEditingController _minStockController;

  String? _categoryId;
  String _unit = 'pcs';
  bool _isActive = true;
  bool _isSaving = false;

  bool get _isEditing => widget.product != null;

  @override
  void initState() {
    super.initState();
    final product = widget.product;
    _skuController = TextEditingController(text: product?.sku ?? '');
    _nameController = TextEditingController(text: product?.name ?? '');
    _buyPriceController = TextEditingController(
      text: CurrencyFormatter.formatEditable(product?.buyPrice ?? 0),
    );
    _sellPriceController = TextEditingController(
      text: CurrencyFormatter.formatEditable(product?.sellPrice ?? 0),
    );
    _stockController = TextEditingController(
      text: CurrencyFormatter.formatEditable(product?.stock ?? 0),
    );
    _minStockController = TextEditingController(
      text: CurrencyFormatter.formatEditable(product?.minStock ?? 0),
    );
    _categoryId = product?.categoryId;
    _unit = product?.unit ?? 'pcs';
    _isActive = product?.isActive ?? true;
  }

  @override
  void dispose() {
    _skuController.dispose();
    _nameController.dispose();
    _buyPriceController.dispose();
    _sellPriceController.dispose();
    _stockController.dispose();
    _minStockController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() => _isSaving = true);

    final actions = ref.read(inventoryActionsProvider);
    final buyPrice = CurrencyFormatter.tryParse(_buyPriceController.text) ?? 0;
    final sellPrice =
        CurrencyFormatter.tryParse(_sellPriceController.text) ?? 0;
    final minStock = CurrencyFormatter.tryParse(_minStockController.text) ?? 0;

    try {
      if (_isEditing) {
        await actions.updateProduct(
          widget.product!.id,
          sku: _skuController.text,
          name: _nameController.text,
          categoryId: _categoryId,
          unit: _unit,
          buyPrice: buyPrice,
          sellPrice: sellPrice,
          minStock: minStock,
          isActive: _isActive,
        );
      } else {
        final stock = CurrencyFormatter.tryParse(_stockController.text) ?? 0;
        await actions.createProduct(
          sku: _skuController.text,
          name: _nameController.text,
          categoryId: _categoryId,
          unit: _unit,
          buyPrice: buyPrice,
          sellPrice: sellPrice,
          stock: stock,
          minStock: minStock,
          isActive: _isActive,
        );
      }

      if (!mounted) return;
      AppSnackBar.showSuccess(
        context,
        _isEditing
            ? 'Produk berhasil diperbarui.'
            : 'Produk berhasil ditambahkan.',
      );
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
    final categories = ref.watch(categoryListProvider);

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
                          _isEditing ? 'Ubah produk' : 'Produk baru',
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
                      AppTextField(
                        controller: _skuController,
                        label: 'Kode SKU',
                        hint: 'ELK-001',
                        prefixIcon: Icons.qr_code_2_rounded,
                        textCapitalization: TextCapitalization.characters,
                        textInputAction: TextInputAction.next,
                        validator: (value) =>
                            Validators.required(value, field: 'Kode SKU'),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      AppTextField(
                        controller: _nameController,
                        label: 'Nama produk',
                        prefixIcon: Icons.inventory_2_outlined,
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.next,
                        validator: (value) =>
                            Validators.required(value, field: 'Nama produk'),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      _CategoryDropdown(
                        categories: categories,
                        selectedId: _categoryId,
                        onChanged: (value) =>
                            setState(() => _categoryId = value),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      DropdownButtonFormField<String>(
                        initialValue: _unit,
                        decoration: const InputDecoration(
                          labelText: 'Satuan',
                          prefixIcon: Icon(Icons.straighten_rounded, size: 20),
                        ),
                        items: [
                          for (final unit in productUnits)
                            DropdownMenuItem(value: unit, child: Text(unit)),
                        ],
                        onChanged: (value) {
                          if (value != null) setState(() => _unit = value);
                        },
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Row(
                        children: [
                          Expanded(
                            child: AppTextField(
                              controller: _buyPriceController,
                              label: 'Harga beli',
                              prefixIcon: Icons.sell_outlined,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              inputFormatters: [
                                const RupiahTextInputFormatter(),
                              ],
                              validator: (value) =>
                                  Validators.nonNegativeNumber(
                                    value,
                                    field: 'Harga beli',
                                  ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: AppTextField(
                              controller: _sellPriceController,
                              label: 'Harga jual',
                              prefixIcon: Icons.local_offer_outlined,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              inputFormatters: [
                                const RupiahTextInputFormatter(),
                              ],
                              validator: (value) =>
                                  Validators.nonNegativeNumber(
                                    value,
                                    field: 'Harga jual',
                                  ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Row(
                        children: [
                          Expanded(
                            child: AppTextField(
                              controller: _minStockController,
                              label: 'Stok minimum',
                              prefixIcon: Icons.trending_down_rounded,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              inputFormatters: [
                                const RupiahTextInputFormatter(),
                              ],
                              validator: (value) =>
                                  Validators.nonNegativeNumber(
                                    value,
                                    field: 'Stok minimum',
                                  ),
                            ),
                          ),
                          if (!_isEditing) ...[
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: AppTextField(
                                controller: _stockController,
                                label: 'Stok awal',
                                prefixIcon: Icons.inventory_outlined,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                inputFormatters: [
                                  const RupiahTextInputFormatter(),
                                ],
                                validator: (value) =>
                                    Validators.nonNegativeNumber(
                                      value,
                                      field: 'Stok awal',
                                    ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      SwitchListTile(
                        value: _isActive,
                        onChanged: (value) => setState(() => _isActive = value),
                        title: const Text('Produk aktif'),
                        subtitle: const Text(
                          'Produk nonaktif disembunyikan dari daftar utama.',
                        ),
                        contentPadding: EdgeInsets.zero,
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
                            : Text(
                                _isEditing
                                    ? 'Simpan perubahan'
                                    : 'Simpan produk',
                              ),
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

class _CategoryDropdown extends StatelessWidget {
  const _CategoryDropdown({
    required this.categories,
    required this.selectedId,
    required this.onChanged,
  });

  final AsyncValue<List<Category>> categories;
  final String? selectedId;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final items = categories.value ?? const <Category>[];

    return DropdownButtonFormField<String?>(
      initialValue: selectedId,
      decoration: const InputDecoration(
        labelText: 'Kategori',
        prefixIcon: Icon(Icons.category_outlined, size: 20),
      ),
      items: [
        const DropdownMenuItem<String?>(
          value: null,
          child: Text('Tanpa kategori'),
        ),
        for (final category in items)
          DropdownMenuItem<String?>(
            value: category.id,
            child: Text(category.name),
          ),
      ],
      onChanged: onChanged,
    );
  }
}
