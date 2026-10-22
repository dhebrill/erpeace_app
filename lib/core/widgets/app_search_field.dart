import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

/// Rounded search field with a clear button.
class AppSearchField extends StatelessWidget {
  const AppSearchField({
    super.key,
    required this.controller,
    required this.onChanged,
    this.hintText = 'Cari...',
    this.onSubmitted,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final ValueChanged<String>? onSubmitted;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        return TextField(
          controller: controller,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: const Icon(Icons.search_rounded, size: 20),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            suffixIcon: value.text.isEmpty
                ? null
                : IconButton(
                    icon: const Icon(Icons.close_rounded, size: 18),
                    onPressed: () {
                      controller.clear();
                      onChanged('');
                    },
                    tooltip: 'Hapus pencarian',
                  ),
          ),
        );
      },
    );
  }
}
