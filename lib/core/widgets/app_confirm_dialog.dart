import 'package:flutter/material.dart';

/// Confirmation dialog used before destructive actions.
Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  String confirmLabel = 'Hapus',
  String cancelLabel = 'Batal',
  bool destructive = true,
  IconData icon = Icons.warning_amber_rounded,
}) async {
  final theme = Theme.of(context);
  final scheme = theme.colorScheme;
  final color = destructive ? scheme.error : scheme.primary;

  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      icon: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(alpha: 0.12),
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(title, textAlign: TextAlign.center),
      content: Text(message, textAlign: TextAlign.center),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        OutlinedButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(cancelLabel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: destructive
              ? FilledButton.styleFrom(
                  backgroundColor: scheme.error,
                  foregroundColor: scheme.onError,
                )
              : null,
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return result ?? false;
}
