import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';

/// Branded header used by every authentication screen.
class AuthBrandHeader extends StatelessWidget {
  const AuthBrandHeader({
    super.key,
    this.title = 'Selamat datang kembali',
    this.subtitle = 'Masuk untuk mengelola operasional bisnis Anda.',
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [scheme.primary, scheme.primary.withValues(alpha: 0.72)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: scheme.primary.withValues(alpha: 0.28),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(
            Icons.inventory_2_rounded,
            color: Colors.white,
            size: 30,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Text(
          title,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.7,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          subtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: scheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
