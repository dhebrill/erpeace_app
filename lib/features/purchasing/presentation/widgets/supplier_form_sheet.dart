import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/input_formatters.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../domain/models/supplier.dart';
import '../providers/purchase_order_list_provider.dart';

/// Opens the create / edit supplier sheet.
///
/// Returns the saved supplier, or `null` when the sheet was dismissed.
Future<Supplier?> showSupplierFormSheet(
  BuildContext context, {
  Supplier? supplier,
}) {
  return showModalBottomSheet<Supplier>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (context) => SupplierFormSheet(supplier: supplier),
  );
}

/// Form used to create and to update a supplier.
class SupplierFormSheet extends ConsumerStatefulWidget {
  const SupplierFormSheet({super.key, this.supplier});

  final Supplier? supplier;

  @override
  ConsumerState<SupplierFormSheet> createState() => _SupplierFormSheetState();
}

class _SupplierFormSheetState extends ConsumerState<SupplierFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _addressController;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final supplier = widget.supplier;
    _nameController = TextEditingController(text: supplier?.name ?? '');
    _phoneController = TextEditingController(text: supplier?.phone ?? '');
    _emailController = TextEditingController(text: supplier?.email ?? '');
    _addressController = TextEditingController(text: supplier?.address ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() => _isSaving = true);

    try {
      final created = await ref
          .read(purchaseOrderActionsProvider)
          .createSupplier(
            name: _nameController.text,
            phone: _phoneController.text,
            email: _emailController.text,
            address: _addressController.text,
          );
      if (!mounted) return;
      AppSnackBar.showSuccess(context, 'Supplier berhasil disimpan.');
      Navigator.of(context).pop(created);
    } catch (error) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      AppSnackBar.showError(context, error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.8,
        maxChildSize: 0.95,
        minChildSize: 0.5,
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
                          'Supplier baru',
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
                        controller: _nameController,
                        label: 'Nama supplier',
                        prefixIcon: Icons.local_shipping_outlined,
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.next,
                        validator: (value) =>
                            Validators.required(value, field: 'Nama supplier'),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      AppTextField(
                        controller: _phoneController,
                        label: 'Nomor telepon',
                        prefixIcon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        inputFormatters: [const DigitsOnlyTextInputFormatter()],
                        validator: Validators.phone,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      AppTextField(
                        controller: _emailController,
                        label: 'Email',
                        prefixIcon: Icons.mail_outline_rounded,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: Validators.optionalEmail,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      AppTextField(
                        controller: _addressController,
                        label: 'Alamat',
                        prefixIcon: Icons.place_outlined,
                        maxLines: 3,
                        minLines: 2,
                        textInputAction: TextInputAction.newline,
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
                            : const Text('Simpan supplier'),
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
