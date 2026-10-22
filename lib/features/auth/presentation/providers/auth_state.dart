import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

import '../../domain/models/profile.dart';
import '../../domain/models/user_role.dart';

/// Lifecycle of the current session.
enum AuthStatus {
  /// Still restoring the persisted session.
  unknown,

  /// No user is signed in.
  unauthenticated,

  /// The account was created but the email address is not confirmed yet.
  awaitingEmailConfirmation,

  /// The user signed up but has not been activated by an admin yet.
  awaitingApproval,

  /// The user is signed in and active.
  authenticated,
}

/// Immutable snapshot of the authentication state.
class AuthState {
  const AuthState({
    this.status = AuthStatus.unknown,
    this.user,
    this.profile,
    this.errorMessage,
    this.isSubmitting = false,
  });

  final AuthStatus status;
  final User? user;
  final Profile? profile;
  final String? errorMessage;
  final bool isSubmitting;

  bool get isAuthenticated => status == AuthStatus.authenticated;

  bool get isAwaitingApproval => status == AuthStatus.awaitingApproval;

  bool get isAwaitingEmailConfirmation =>
      status == AuthStatus.awaitingEmailConfirmation;

  UserRole? get role => profile?.role;

  String get displayName {
    final name = profile?.fullName.trim() ?? '';
    if (name.isNotEmpty) return name;
    final email = user?.email ?? '';
    return email.isEmpty ? 'Pengguna' : email.split('@').first;
  }

  /// The email address of the signed in user, falling back to the auth user.
  String get email => profile?.email ?? user?.email ?? '';

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    Profile? profile,
    String? errorMessage,
    bool? isSubmitting,
    bool clearError = false,
    bool clearProfile = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      profile: clearProfile ? null : (profile ?? this.profile),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}
