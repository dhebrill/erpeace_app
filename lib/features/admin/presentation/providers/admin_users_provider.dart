import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/domain/models/profile.dart';
import '../../../auth/domain/models/user_role.dart';
import 'admin_repository_provider.dart';
import 'admin_user_query_provider.dart';

/// Loads the list of users shown in the admin panel.
class AdminUsersController extends AsyncNotifier<List<Profile>> {
  @override
  Future<List<Profile>> build() {
    final query = ref.watch(adminUserQueryProvider);
    return ref.watch(adminRepositoryProvider).fetchUsers(query);
  }

  /// Reloads the list, keeping the current data visible while loading.
  Future<void> reload() async {
    state = await AsyncValue.guard(
      () => ref
          .read(adminRepositoryProvider)
          .fetchUsers(ref.read(adminUserQueryProvider)),
    );
  }

  /// Changes the role of a user and refreshes the list.
  Future<void> updateRole(String userId, UserRole role) async {
    await ref.read(adminRepositoryProvider).updateUserRole(userId, role);
    await reload();
  }

  /// Activates or deactivates a user and refreshes the list.
  Future<void> setActive(String userId, bool isActive) async {
    await ref.read(adminRepositoryProvider).setUserActive(userId, isActive);
    await reload();
  }
}

/// The users of the application.
final adminUsersProvider =
    AsyncNotifierProvider<AdminUsersController, List<Profile>>(
      AdminUsersController.new,
    );
