import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/input_formatters.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../domain/models/customer.dart';
import '../providers/sales_order_list_provider.dart';

/// Opens the customer creation sheet.
///
/// Returns the saved customer, or `null` when the sheet was dismissed.
Future<Customer?> showCustomerFormSheet(BuildContext context) {
  return showModalBottomSheet<Customer>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (context) => const CustomerFormSheet(),
  );
}

/// Form used to create a customer.
class CustomerFormSheet extends ConsumerStatefulWidget {
  const CustomerFormSheet({super.key});

  @override
  ConsumerState<CustomerFormSheet> createState() => _CustomerFormSheetState();
}

class _CustomerFormSheetState extends ConsumerState<CustomerFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();

  bool _isSaving = false;

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
          .read(salesOrderActionsProvider)
          .createCustomer(
            name: _nameController.text,
            phone: _phoneController.text,
            email: _emailController.text,
            address: _addressController.text,
          );
      if (!mounted) return;
      AppSnackBar.showSuccess(context, 'Pelanggan berhasil disimpan.');
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
                          'Pelanggan baru',
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
                        label: 'Nama pelanggan',
                        prefixIcon: Icons.person_outline_rounded,
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.next,
                        validator: (value) =>
                            Validators.required(value, field: 'Nama pelanggan'),
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
                            : const Text('Simpan pelanggan'),
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
