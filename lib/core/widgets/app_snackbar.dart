import 'package:flutter/material.dart';

/// Snackbar helpers with consistent styling.
abstract final class AppSnackBar {
  const AppSnackBar._();

  static void showSuccess(BuildContext context, String message) {
    _show(context, message, Icons.check_circle_rounded, Colors.green.shade700);
  }

  static void showError(BuildContext context, String message) {
    _show(context, message, Icons.error_rounded, Colors.red.shade700);
  }

  static void showInfo(BuildContext context, String message) {
    final scheme = Theme.of(context).colorScheme;
    _show(context, message, Icons.info_rounded, scheme.primary);
  }

  static void _show(
    BuildContext context,
    String message,
    IconData icon,
    Color color,
  ) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 12),
              Expanded(child: Text(message)),
            ],
          ),
          duration: const Duration(seconds: 3),
        ),
      );
  }
}
