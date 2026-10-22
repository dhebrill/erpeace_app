import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_search_field.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/content_width.dart';
import '../../../auth/domain/models/profile.dart';
import '../../../auth/domain/models/user_role.dart';
import '../../../auth/presentation/providers/auth_controller.dart';
import '../providers/admin_user_query_provider.dart';
import '../providers/admin_users_provider.dart';
import '../widgets/admin_user_card.dart';
import '../widgets/role_picker_sheet.dart';

/// Admin panel used to manage users and their roles.
class AdminScreen extends ConsumerWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel Admin'),
        actions: [
          IconButton(
            tooltip: 'Muat ulang',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => ref.read(adminUsersProvider.notifier).reload(),
          ),
        ],
      ),
      body: const _AdminBody(),
    );
  }
}

class _AdminBody extends ConsumerStatefulWidget {
  const _AdminBody();

  @override
  ConsumerState<_AdminBody> createState() => _AdminBodyState();
}

class _AdminBodyState extends ConsumerState<_AdminBody> {
  final _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(AppConstants.searchDebounce, () {
      if (!mounted) return;
      ref.read(adminUserQueryProvider.notifier).setSearch(value);
    });
  }

  Future<void> _changeRole(String userId, UserRole currentRole) async {
    final nextRole = await showRolePickerSheet(
      context,
      currentRole: currentRole,
    );
    if (nextRole == null || nextRole == currentRole || !mounted) return;

    try {
      await ref.read(adminUsersProvider.notifier).updateRole(userId, nextRole);
      if (!mounted) return;
      AppSnackBar.showSuccess(context, 'Role berhasil diperbarui.');
    } catch (error) {
      if (!mounted) return;
      AppSnackBar.showError(context, 'Role gagal diperbarui.');
    }
  }

  Future<void> _toggleActive(String userId, bool currentActive) async {
    final nextActive = !currentActive;
    final action = nextActive ? 'mengaktifkan' : 'menonaktifkan';

    try {
      await ref.read(adminUsersProvider.notifier).setActive(userId, nextActive);
      if (!mounted) return;
      AppSnackBar.showSuccess(
        context,
        nextActive
            ? 'Akun berhasil diaktifkan.'
            : 'Akun berhasil dinonaktifkan.',
      );
    } catch (error) {
      if (!mounted) return;
      AppSnackBar.showError(context, 'Gagal $action akun.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final usersAsync = ref.watch(adminUsersProvider);
    final query = ref.watch(adminUserQueryProvider);
    final currentUserId = ref.watch(authControllerProvider).user?.id ?? '';
    final users = usersAsync.value ?? const [];
    final inactiveCount = users.where((user) => !user.isActive).length;
    final theme = Theme.of(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.sm,
          ),
          child: ContentWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSearchField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  hintText: 'Cari nama atau email pengguna',
                ),
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  height: 36,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: AppSpacing.sm),
                        child: FilterChip(
                          label: const Text('Semua'),
                          selected: query.role == null,
                          onSelected: (_) => ref
                              .read(adminUserQueryProvider.notifier)
                              .setRole(null),
                        ),
                      ),
                      for (final role in UserRole.values)
                        Padding(
                          padding: const EdgeInsets.only(right: AppSpacing.sm),
                          child: FilterChip(
                            label: Text(role.label),
                            selected: query.role == role,
                            onSelected: (_) => ref
                                .read(adminUserQueryProvider.notifier)
                                .setRole(role),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  inactiveCount > 0
                      ? '${users.length} pengguna • $inactiveCount menunggu aktivasi'
                      : '${users.length} pengguna',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(child: _buildBody(usersAsync, currentUserId)),
      ],
    );
  }

  Widget _buildBody(AsyncValue<List<Profile>> state, String currentUserId) {
    final users = state.value;
    if (users == null) {
      if (state.hasError) {
        return AppErrorState(
          message: state.error.toString(),
          onRetry: () => ref.read(adminUsersProvider.notifier).reload(),
        );
      }
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: AppShimmerList(itemCount: 8, itemHeight: 112),
      );
    }

    if (users.isEmpty) {
      return const AppEmptyState(
        title: 'Tidak ada pengguna',
        message:
            'Pengguna akan muncul setelah mendaftar, atau tidak ada '
            'yang cocok dengan pencarian.',
        icon: Icons.people_outline_rounded,
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(adminUsersProvider.notifier).reload(),
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.sm,
          AppSpacing.lg,
          AppSpacing.xxxl,
        ),
        itemCount: users.length,
        separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
        itemBuilder: (context, index) {
          final profile = users[index];
          return ContentWidth(
            child: AdminUserCard(
              profile: profile,
              currentUserId: currentUserId,
              onChangeRole: () => _changeRole(profile.id, profile.role),
              onToggleActive: () => _toggleActive(profile.id, profile.isActive),
            ),
          );
        },
      ),
    );
  }
}
