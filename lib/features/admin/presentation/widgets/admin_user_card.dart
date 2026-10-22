import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../../../core/widgets/user_avatar.dart';
import '../../../auth/domain/models/profile.dart';
import '../../../auth/presentation/widgets/role_chip.dart';

/// Card that summarises a user account inside the admin list.
class AdminUserCard extends StatelessWidget {
  const AdminUserCard({
    super.key,
    required this.profile,
    required this.currentUserId,
    this.onChangeRole,
    this.onToggleActive,
  });

  final Profile profile;
  final String currentUserId;
  final VoidCallback? onChangeRole;
  final VoidCallback? onToggleActive;

  bool get _isSelf => profile.id == currentUserId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final name = profile.fullName.trim().isNotEmpty
        ? profile.fullName.trim()
        : (profile.email ?? 'Pengguna');

    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserAvatar(name: name),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    if (_isSelf) ...[
                      const SizedBox(width: AppSpacing.sm),
                      StatusChip(
                        label: 'Anda',
                        dense: true,
                        color: scheme.primary,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  profile.email ?? '-',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [
                    RoleChip(role: profile.role, dense: true),
                    StatusChip(
                      label: profile.isActive ? 'Aktif' : 'Nonaktif',
                      dense: true,
                      color: profile.isActive
                          ? Colors.green.shade700
                          : Colors.orange.shade700,
                      icon: profile.isActive
                          ? Icons.check_circle_outline_rounded
                          : Icons.pause_circle_outline_rounded,
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (!_isSelf)
            PopupMenuButton<String>(
              tooltip: 'Aksi pengguna',
              onSelected: (value) {
                switch (value) {
                  case 'role':
                    onChangeRole?.call();
                  case 'active':
                    onToggleActive?.call();
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'role',
                  child: ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.shield_outlined, size: 20),
                    title: Text('Ubah role'),
                  ),
                ),
                PopupMenuItem(
                  value: 'active',
                  child: ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      profile.isActive
                          ? Icons.person_off_outlined
                          : Icons.person_add_alt_1_outlined,
                      size: 20,
                    ),
                    title: Text(
                      profile.isActive ? 'Nonaktifkan akun' : 'Aktifkan akun',
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
