import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/error/error_handler.dart';
import '../../auth/domain/models/profile.dart';
import '../../auth/domain/models/user_role.dart';

/// Filters applied to the user list of the admin panel.
class AdminUserQuery {
  const AdminUserQuery({this.search = '', this.role});

  /// Free text search over the name and the email address.
  final String search;

  /// Role filter, `null` means every role.
  final UserRole? role;

  AdminUserQuery copyWith({
    String? search,
    UserRole? role,
    bool clearRole = false,
  }) {
    return AdminUserQuery(
      search: search ?? this.search,
      role: clearRole ? null : (role ?? this.role),
    );
  }
}

/// Reads and manages the user accounts of the application.
class AdminRepository {
  AdminRepository(this._client);

  final SupabaseClient _client;

  /// Loads the profiles matching the given query.
  ///
  /// The search matches the name or the email address; filters are combined
  /// with AND, the two search columns with OR.
  Future<List<Profile>> fetchUsers(AdminUserQuery query) async {
    try {
      var builder = _client
          .from(AppConstants.tProfiles)
          .select('id, full_name, email, role, is_active, created_at');

      final search = query.search.trim();
      if (search.isNotEmpty) {
        final term = _sanitize(search);
        builder = builder.or('full_name.ilike.%$term%,email.ilike.%$term%');
      }
      final roleFilter = query.role;
      if (roleFilter != null) {
        builder = builder.eq('role', roleFilter.name);
      }

      final rows = await builder.order('created_at', ascending: false);
      return rows
          .map((row) => Profile.fromJson(Map<String, dynamic>.from(row)))
          .toList(growable: false);
    } catch (error) {
      throw ErrorHandler.map(error);
    }
  }

  /// Changes the role of a user.
  Future<void> updateUserRole(String userId, UserRole role) async {
    try {
      await _client
          .from(AppConstants.tProfiles)
          .update({'role': role.name})
          .eq('id', userId);
    } catch (error) {
      throw ErrorHandler.map(error);
    }
  }

  /// Activates or deactivates a user account.
  Future<void> setUserActive(String userId, bool isActive) async {
    try {
      await _client
          .from(AppConstants.tProfiles)
          .update({'is_active': isActive})
          .eq('id', userId);
    } catch (error) {
      throw ErrorHandler.map(error);
    }
  }

  String _sanitize(String value) {
    return value
        .replaceAll(RegExp(r'[,.()%*]'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }
}
