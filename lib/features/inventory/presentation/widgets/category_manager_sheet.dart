import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_confirm_dialog.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../providers/inventory_actions.dart';
import '../providers/product_list_provider.dart';

/// Opens the category management sheet.
Future<void> showCategoryManagerSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (context) => const CategoryManagerSheet(),
  );
}

/// Lets the user create and delete product categories.
class CategoryManagerSheet extends ConsumerStatefulWidget {
  const CategoryManagerSheet({super.key});

  @override
  ConsumerState<CategoryManagerSheet> createState() =>
      _CategoryManagerSheetState();
}

class _CategoryManagerSheetState extends ConsumerState<CategoryManagerSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _create() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    try {
      await ref
          .read(inventoryActionsProvider)
          .createCategory(_nameController.text);
      _nameController.clear();
      if (!mounted) return;
      AppSnackBar.showSuccess(context, 'Kategori ditambahkan.');
    } catch (error) {
      if (!mounted) return;
      AppSnackBar.showError(context, error.toString());
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _delete(String id, String name) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Hapus kategori?',
      message:
          'Kategori "$name" akan dihapus. Produk di dalamnya tetap tersimpan '
          'tanpa kategori.',
      confirmLabel: 'Hapus',
    );
    if (!confirmed || !mounted) return;

    try {
      await ref.read(inventoryActionsProvider).deleteCategory(id);
      if (!mounted) return;
      AppSnackBar.showSuccess(context, 'Kategori dihapus.');
    } catch (error) {
      if (!mounted) return;
      AppSnackBar.showError(context, error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categories = ref.watch(categoryListProvider);

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.8,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (context, scrollController) {
        return Column(
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
                      'Kelola kategori',
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
                  AppSpacing.xxxl,
                ),
                children: [
                  Form(
                    key: _formKey,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: AppTextField(
                            controller: _nameController,
                            label: 'Nama kategori',
                            hint: 'Elektronik',
                            prefixIcon: Icons.category_outlined,
                            textCapitalization: TextCapitalization.words,
                            textInputAction: TextInputAction.done,
                            onSubmitted: (_) => _create(),
                            validator: (value) =>
                                value == null || value.trim().isEmpty
                                ? 'Nama kategori wajib diisi'
                                : null,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: FilledButton(
                            onPressed: _isSaving ? null : _create,
                            style: FilledButton.styleFrom(
                              minimumSize: const Size(52, 52),
                              padding: EdgeInsets.zero,
                            ),
                            child: _isSaving
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(Icons.add_rounded),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  ...switch (categories.value) {
                    null => [
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: AppSpacing.xl,
                          ),
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ],
                    final list when list.isEmpty => [
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: AppSpacing.xl,
                          ),
                          child: Text('Belum ada kategori.'),
                        ),
                      ),
                    ],
                    final list => [
                      for (final category in list)
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.folder_outlined),
                          title: Text(category.name),
                          trailing: IconButton(
                            tooltip: 'Hapus kategori',
                            icon: const Icon(Icons.delete_outline_rounded),
                            onPressed: () =>
                                _delete(category.id, category.name),
                          ),
                        ),
                    ],
                  },
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
