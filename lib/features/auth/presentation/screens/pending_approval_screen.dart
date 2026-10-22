import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/content_width.dart';
import '../providers/auth_controller.dart';

/// Shown while a newly registered account waits for admin activation.
class PendingApprovalScreen extends ConsumerWidget {
  const PendingApprovalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final auth = ref.watch(authControllerProvider);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            child: ContentWidth(
              maxWidth: 460,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 112,
                    height: 112,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: scheme.primary.withValues(alpha: 0.1),
                    ),
                    child: Icon(
                      Icons.hourglass_top_rounded,
                      size: 52,
                      color: scheme.primary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  Text(
                    'Menunggu persetujuan admin',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.6,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Akun Anda sudah dibuat, namun belum aktif. '
                    'Admin perlu menyetujui akun sebelum Anda dapat masuk.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  AppCard(
                    elevated: true,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _InfoRow(
                          label: 'Nama',
                          value: auth.displayName,
                          icon: Icons.badge_outlined,
                        ),
                        const Divider(height: AppSpacing.xl),
                        _InfoRow(
                          label: 'Email',
                          value: auth.user?.email ?? '-',
                          icon: Icons.alternate_email_rounded,
                        ),
                        const Divider(height: AppSpacing.xl),
                        _InfoRow(
                          label: 'Status',
                          value: 'Menunggu aktivasi',
                          icon: Icons.pending_actions_rounded,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  FilledButton.icon(
                    onPressed: () async {
                      await ref
                          .read(authControllerProvider.notifier)
                          .refreshProfile();
                      if (!context.mounted) return;
                      if (ref.read(authControllerProvider).isAuthenticated) {
                        GoRouter.of(context).go(AppRoutes.dashboard);
                      } else {
                        AppSnackBar.showInfo(
                          context,
                          'Akun belum aktif. Silakan coba lagi nanti.',
                        );
                      }
                    },
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Periksa status'),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextButton(
                    onPressed: () async {
                      await ref.read(authControllerProvider.notifier).signOut();
                      if (!context.mounted) return;
                      GoRouter.of(context).go(AppRoutes.login);
                    },
                    child: const Text('Keluar'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: scheme.primary),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
