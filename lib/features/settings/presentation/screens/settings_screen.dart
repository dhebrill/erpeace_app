import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_confirm_dialog.dart';
import '../../../../core/widgets/app_section_title.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/content_width.dart';
import '../../../../core/widgets/user_avatar.dart';
import '../../../auth/domain/models/user_role.dart';
import '../../../auth/presentation/providers/auth_controller.dart';
import '../../../auth/presentation/widgets/role_chip.dart';
import '../providers/theme_mode_provider.dart';
import '../widgets/password_sheet.dart';
import '../widgets/profile_name_sheet.dart';

/// Settings: profile, password, appearance and sign out.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _editName(BuildContext context, WidgetRef ref) async {
    final auth = ref.read(authControllerProvider);
    final saved = await showProfileNameSheet(
      context,
      currentName: auth.profile?.fullName ?? '',
    );
    if (saved == true && context.mounted) {
      AppSnackBar.showSuccess(context, 'Nama berhasil diperbarui.');
    }
  }

  Future<void> _editPassword(BuildContext context) async {
    final saved = await showPasswordSheet(context);
    if (saved == true && context.mounted) {
      AppSnackBar.showSuccess(context, 'Kata sandi berhasil diperbarui.');
    }
  }

  Future<void> _signOut(BuildContext context, WidgetRef ref) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Keluar dari akun?',
      message: 'Anda perlu masuk kembali untuk menggunakan aplikasi.',
      confirmLabel: 'Keluar',
      icon: Icons.logout_rounded,
    );
    if (!confirmed) return;
    await ref.read(authControllerProvider.notifier).signOut();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authControllerProvider);
    final themeMode = ref.watch(themeModeProvider);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final role = auth.role ?? UserRole.sales;

    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.xxxl,
        ),
        children: [
          ContentWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppCard(
                  elevated: true,
                  child: Column(
                    children: [
                      UserAvatar(name: auth.displayName, radius: 32),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        auth.displayName,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        auth.email,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      RoleChip(role: role),
                      const SizedBox(height: AppSpacing.lg),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => _editName(context, ref),
                              icon: const Icon(Icons.edit_outlined, size: 18),
                              label: const Text('Ubah nama'),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => _editPassword(context),
                              icon: const Icon(
                                Icons.lock_outline_rounded,
                                size: 18,
                              ),
                              label: const Text('Kata sandi'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                AppSectionTitle(title: 'Tampilan'),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mode tema',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      SizedBox(
                        width: double.infinity,
                        child: SegmentedButton<ThemeMode>(
                          segments: const [
                            ButtonSegment(
                              value: ThemeMode.system,
                              label: Text('Sistem'),
                              icon: Icon(
                                Icons.brightness_auto_rounded,
                                size: 18,
                              ),
                            ),
                            ButtonSegment(
                              value: ThemeMode.light,
                              label: Text('Terang'),
                              icon: Icon(Icons.light_mode_rounded, size: 18),
                            ),
                            ButtonSegment(
                              value: ThemeMode.dark,
                              label: Text('Gelap'),
                              icon: Icon(Icons.dark_mode_rounded, size: 18),
                            ),
                          ],
                          selected: {themeMode},
                          onSelectionChanged: (selection) => ref
                              .read(themeModeProvider.notifier)
                              .setMode(selection.first),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                AppSectionTitle(title: 'Akun'),
                AppCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(
                          Icons.info_outline_rounded,
                          color: scheme.onSurfaceVariant,
                        ),
                        title: const Text('Tentang aplikasi'),
                        subtitle: const Text(
                          '${AppConstants.appName} • ${AppConstants.appTagline}',
                        ),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: Icon(
                          Icons.logout_rounded,
                          color: scheme.error,
                        ),
                        title: Text(
                          'Keluar',
                          style: TextStyle(color: scheme.error),
                        ),
                        onTap: () => _signOut(context, ref),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Center(
                  child: Text(
                    '${AppConstants.appName} v1.0.0',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
