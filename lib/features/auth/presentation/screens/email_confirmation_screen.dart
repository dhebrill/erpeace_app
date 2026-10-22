import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/content_width.dart';
import '../providers/auth_controller.dart';

/// Shown when the account was created but the email address still has to be
/// confirmed before the user can sign in.
class EmailConfirmationScreen extends ConsumerWidget {
  const EmailConfirmationScreen({super.key});

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
                      color: scheme.tertiaryContainer.withValues(alpha: 0.6),
                    ),
                    child: Icon(
                      Icons.mark_email_read_outlined,
                      size: 52,
                      color: scheme.tertiary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  Text(
                    'Konfirmasi email Anda',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.6,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Kami sudah mengirim tautan konfirmasi ke email Anda. '
                    'Buka email tersebut lalu kembali ke aplikasi untuk masuk.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                  if (auth.email.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.xl),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.md,
                      ),
                      decoration: BoxDecoration(
                        color: scheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(AppSpacing.md),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.alternate_email_rounded,
                            size: 20,
                            color: scheme.primary,
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Text(
                              auth.email,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.xl),
                  FilledButton.icon(
                    onPressed: auth.isSubmitting
                        ? null
                        : () async {
                            try {
                              await ref
                                  .read(authControllerProvider.notifier)
                                  .resendConfirmationEmail();
                              if (!context.mounted) return;
                              AppSnackBar.showSuccess(
                                context,
                                'Email konfirmasi telah dikirim ulang.',
                              );
                            } catch (error) {
                              if (!context.mounted) return;
                              AppSnackBar.showError(context, error.toString());
                            }
                          },
                    icon: const Icon(Icons.send_rounded),
                    label: const Text('Kirim ulang email'),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  OutlinedButton(
                    onPressed: () async {
                      await ref.read(authControllerProvider.notifier).signOut();
                      if (!context.mounted) return;
                      GoRouter.of(context).go(AppRoutes.login);
                    },
                    child: const Text('Ke halaman masuk'),
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
