import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

import '../../../../core/error/error_handler.dart';
import '../../../../core/error/failure.dart';
import '../providers/auth_repository_provider.dart';
import 'auth_state.dart';

export 'auth_state.dart';

/// Owns the authentication lifecycle: session restore, login, registration,
/// logout and profile refresh.
class AuthController extends Notifier<AuthState> {
  StreamSubscription<sb.AuthState>? _authSubscription;
  Timer? _approvalTimer;

  @override
  AuthState build() {
    final repository = ref.watch(authRepositoryProvider);

    _authSubscription = repository.onAuthStateChange.listen(
      _handleAuthEvent,
      onError: (Object error, StackTrace _) {
        state = state.copyWith(errorMessage: ErrorHandler.message(error));
      },
    );
    ref.onDispose(_dispose);

    unawaited(resolveSession());

    return const AuthState();
  }

  void _dispose() {
    _authSubscription?.cancel();
    _approvalTimer?.cancel();
  }

  void _handleAuthEvent(sb.AuthState event) {
    final user = event.session?.user;
    if (user == null) {
      _approvalTimer?.cancel();
      state = const AuthState(status: AuthStatus.unauthenticated);
      return;
    }
    unawaited(_loadProfile(user));
  }

  /// Restores the persisted session (called on startup).
  Future<void> resolveSession() async {
    final repository = ref.read(authRepositoryProvider);
    final user = repository.currentUser;
    if (user == null) {
      state = const AuthState(status: AuthStatus.unauthenticated);
      return;
    }
    await _loadProfile(user);
  }

  Future<void> _loadProfile(sb.User user) async {
    final repository = ref.read(authRepositoryProvider);
    try {
      final profile = await repository.fetchProfile(user.id);
      final isActive = profile?.isActive ?? false;
      state = AuthState(
        status: isActive
            ? AuthStatus.authenticated
            : AuthStatus.awaitingApproval,
        user: user,
        profile: profile,
      );
      if (!isActive) {
        _startApprovalPolling();
      } else {
        _approvalTimer?.cancel();
      }
    } on Failure catch (failure) {
      state = AuthState(
        status: AuthStatus.unauthenticated,
        user: user,
        errorMessage: failure.message,
      );
    } catch (error) {
      state = AuthState(
        status: AuthStatus.unauthenticated,
        user: user,
        errorMessage: ErrorHandler.message(error),
      );
    }
  }

  /// Polls the profile while the account is waiting for approval.
  void _startApprovalPolling() {
    _approvalTimer?.cancel();
    _approvalTimer = Timer.periodic(const Duration(seconds: 15), (_) {
      if (state.status == AuthStatus.awaitingApproval) {
        unawaited(refreshProfile());
      }
    });
  }

  Future<void> refreshProfile() async {
    final user = state.user ?? ref.read(authRepositoryProvider).currentUser;
    if (user == null) return;
    await _loadProfile(user);
  }

  Future<void> signIn({required String email, required String password}) async {
    state = state.copyWith(isSubmitting: true, clearError: true);
    try {
      await ref
          .read(authRepositoryProvider)
          .signIn(email: email.trim(), password: password);
      await resolveSession();
    } catch (error) {
      final failure = ErrorHandler.map(error);
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: failure.message,
        status: AuthStatus.unauthenticated,
      );
      throw failure;
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String fullName,
  }) async {
    state = state.copyWith(isSubmitting: true, clearError: true);
    try {
      final response = await ref
          .read(authRepositoryProvider)
          .signUp(
            email: email.trim(),
            password: password,
            fullName: fullName.trim(),
          );

      final user = response.user;
      if (user != null) {
        state = AuthState(status: AuthStatus.awaitingApproval, user: user);
        await _loadProfile(user);
      } else {
        state = const AuthState(status: AuthStatus.unauthenticated);
      }
    } catch (error) {
      final failure = ErrorHandler.map(error);
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: failure.message,
        status: AuthStatus.unauthenticated,
      );
      throw failure;
    }
  }

  Future<void> signOut() async {
    _approvalTimer?.cancel();
    try {
      await ref.read(authRepositoryProvider).signOut();
    } catch (error) {
      // Signing out locally must always succeed, even when the server errors.
      state = const AuthState(status: AuthStatus.unauthenticated);
      return;
    }
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  Future<void> sendPasswordReset(String email) async {
    await ref.read(authRepositoryProvider).sendPasswordReset(email.trim());
  }

  Future<void> updatePassword(String password) async {
    await ref.read(authRepositoryProvider).updatePassword(password);
  }

  Future<void> updateFullName(String fullName) async {
    await ref.read(authRepositoryProvider).updateFullName(fullName);
    await refreshProfile();
  }

  void clearError() {
    if (state.errorMessage != null) {
      state = state.copyWith(clearError: true);
    }
  }
}

/// The single source of truth for the authentication state.
final authControllerProvider = NotifierProvider<AuthController, AuthState>(
  AuthController.new,
);
