import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/domain/models/user_role.dart';
import '../../data/admin_repository.dart';

/// Holds the current query of the admin user list.
class AdminUserQueryNotifier extends Notifier<AdminUserQuery> {
  @override
  AdminUserQuery build() => const AdminUserQuery();

  void setSearch(String value) {
    final trimmed = value.trim();
    if (trimmed == state.search) return;
    state = state.copyWith(search: trimmed);
  }

  void setRole(UserRole? role) {
    if (role == null) {
      if (state.role == null) return;
      state = state.copyWith(clearRole: true);
      return;
    }
    if (role == state.role) return;
    state = state.copyWith(role: role);
  }

  void reset() => state = const AdminUserQuery();
}

/// The query used by the admin user list.
final adminUserQueryProvider =
    NotifierProvider<AdminUserQueryNotifier, AdminUserQuery>(
      AdminUserQueryNotifier.new,
    );
