import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/error/error_handler.dart';
import '../../../core/error/failure.dart';
import '../domain/models/profile.dart';

/// Handles every Supabase Auth / profile interaction.
class AuthRepository {
  AuthRepository(this._client);

  final SupabaseClient _client;

  Stream<AuthState> get onAuthStateChange => _client.auth.onAuthStateChange;

  User? get currentUser => _client.auth.currentUser;

  String? get currentUserId => _client.auth.currentUser?.id;

  /// Reads the profile of the given user.
  ///
  /// Returns `null` when the profile row does not exist (yet).
  Future<Profile?> fetchProfile(String userId) async {
    try {
      final data = await _client
          .from(AppConstants.tProfiles)
          .select('id, full_name, email, role, is_active, created_at')
          .eq('id', userId)
          .maybeSingle();

      if (data == null) return null;
      return Profile.fromJson(Map<String, dynamic>.from(data));
    } catch (error) {
      throw ErrorHandler.map(error);
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    try {
      await _client.auth.signInWithPassword(email: email, password: password);
    } catch (error) {
      throw ErrorHandler.map(error);
    }
  }

  /// Registers a new user. The database trigger creates the profile row with
  /// `role = 'sales'` and `is_active = false`.
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      return await _client.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': fullName},
      );
    } catch (error) {
      throw ErrorHandler.map(error);
    }
  }

  /// Sends the confirmation email again to a user that has not confirmed yet.
  Future<void> resendConfirmationEmail(String email) async {
    try {
      await _client.auth.resend(type: OtpType.signup, email: email);
    } catch (error) {
      throw ErrorHandler.map(error);
    }
  }

  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } catch (error) {
      throw ErrorHandler.map(error);
    }
  }

  /// Sends the password reset email.
  Future<void> sendPasswordReset(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
    } catch (error) {
      throw ErrorHandler.map(error);
    }
  }

  /// Changes the password of the signed in user.
  Future<void> updatePassword(String password) async {
    try {
      await _client.auth.updateUser(UserAttributes(password: password));
    } catch (error) {
      throw ErrorHandler.map(error);
    }
  }

  /// Updates the display name of the signed in user.
  Future<void> updateFullName(String fullName) async {
    final userId = currentUserId;
    if (userId == null) {
      throw const Failure('Anda harus masuk terlebih dahulu.');
    }
    try {
      await _client
          .from(AppConstants.tProfiles)
          .update({'full_name': fullName})
          .eq('id', userId);
    } catch (error) {
      throw ErrorHandler.map(error);
    }
  }
}
