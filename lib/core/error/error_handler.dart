import 'dart:async';
import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart'
    show AuthException, PostgrestException;

import 'failure.dart';

/// Translates any error thrown by Supabase / the network layer into a
/// [Failure] with a friendly Indonesian message.
abstract final class ErrorHandler {
  const ErrorHandler._();

  static Failure map(Object error) {
    if (error is Failure) return error;

    if (error is AuthException) return _mapAuth(error);
    if (error is PostgrestException) return _mapPostgrest(error);
    if (error is SocketException) {
      return const Failure(
        'Tidak ada koneksi ke server. Periksa jaringan Anda lalu coba lagi.',
        code: 'offline',
      );
    }
    if (error is HttpException) {
      return const Failure(
        'Jaringan tidak stabil. Silakan coba beberapa saat lagi.',
        code: 'network',
      );
    }
    if (error is TimeoutException) {
      return const Failure(
        'Permintaan terlalu lama. Silakan coba lagi.',
        code: 'timeout',
      );
    }
    if (error is FormatException) {
      return const Failure(
        'Data dari server tidak dapat dibaca.',
        code: 'format',
      );
    }
    if (error is ArgumentError) {
      return Failure('Data tidak valid: ${error.message}', code: 'argument');
    }

    return Failure(
      'Terjadi kesalahan yang tidak terduga. Silakan coba lagi.',
      code: 'unknown',
      cause: error,
    );
  }

  /// Convenience helper returning only the message.
  static String message(Object error) => map(error).message;

  static Failure _mapAuth(AuthException error) {
    final code = error.code ?? '';
    final raw = error.message.toLowerCase();

    if (raw.contains('invalid login credentials')) {
      return const Failure(
        'Email atau kata sandi salah. Silakan coba lagi.',
        code: 'invalid_credentials',
      );
    }
    if (raw.contains('email not confirmed')) {
      return const Failure(
        'Email belum dikonfirmasi. Periksa kotak masuk Anda.',
        code: 'email_not_confirmed',
      );
    }
    if (raw.contains('user already registered')) {
      return const Failure(
        'Email ini sudah terdaftar. Silakan masuk.',
        code: 'email_exists',
      );
    }
    if (raw.contains('password should be at least')) {
      return const Failure(
        'Kata sandi minimal 6 karakter.',
        code: 'weak_password',
      );
    }
    if (raw.contains('unable to validate email') ||
        raw.contains('invalid email')) {
      return const Failure('Format email tidak valid.', code: 'invalid_email');
    }
    if (raw.contains('rate limit') || raw.contains('too many requests')) {
      return const Failure(
        'Terlalu banyak percobaan. Silakan coba lagi beberapa saat lagi.',
        code: 'rate_limited',
      );
    }
    if (raw.contains('failed to fetch') || raw.contains('network')) {
      return const Failure(
        'Tidak ada koneksi ke server. Periksa jaringan Anda lalu coba lagi.',
        code: 'offline',
      );
    }
    if (code == 'otp_expired') {
      return const Failure(
        'Kode verifikasi sudah kedaluwarsa. Silakan minta kode baru.',
        code: 'otp_expired',
      );
    }
    return Failure(
      error.message,
      code: code.isEmpty ? 'auth_error' : code,
      cause: error,
    );
  }

  static Failure _mapPostgrest(PostgrestException error) {
    switch (error.code) {
      case '23505':
        return const Failure(
          'Data sudah ada. Periksa kembali data yang Anda masukkan.',
          code: '23505',
        );
      case '23503':
        return const Failure(
          'Data masih terhubung dengan data lain sehingga tidak bisa dihapus.',
          code: '23503',
        );
      case '23514':
        return const Failure(
          'Nilai di luar rentang yang diperbolehkan.',
          code: '23514',
        );
      case '42501':
        return const Failure(
          'Anda tidak memiliki izin untuk melakukan tindakan ini.',
          code: '42501',
        );
      case 'PGRST116':
      case 'PGRST204':
        return const Failure('Data tidak ditemukan.', code: 'not_found');
      case 'P0001':
        return Failure(
          _humanizeRaise(error.message),
          code: 'P0001',
          cause: error,
        );
      case 'P0002':
        return const Failure('Data tidak ditemukan.', code: 'P0002');
      default:
        return Failure(
          _humanizeRaise(error.message),
          code: error.code ?? 'postgrest_error',
          cause: error,
        );
    }
  }

  /// Postgres `raise exception` messages are written for developers, this
  /// converts the most common ones into a friendly sentence.
  static String _humanizeRaise(String message) {
    final raw = message.trim();
    if (raw.isEmpty) {
      return 'Terjadi kesalahan di server. Silakan coba lagi.';
    }
    if (raw.contains('Hanya admin atau manager')) {
      return 'Hanya admin atau manager yang dapat melakukan tindakan ini.';
    }
    if (raw.contains('Hanya admin, manager, atau gudang')) {
      return 'Hanya admin, manager, atau gudang yang dapat menerima purchase order.';
    }
    if (raw.contains('Hanya admin, manager, atau penjualan')) {
      return 'Hanya admin, manager, atau penjualan yang dapat menyelesaikan order penjualan.';
    }
    if (raw.contains('Stok') && raw.contains('tidak mencukupi')) {
      return raw;
    }
    if (raw.contains('purchase order harus berstatus approved')) {
      return 'Purchase order harus berstatus approved untuk dapat diterima.';
    }
    if (raw.contains('sales order harus berstatus approved')) {
      return 'Sales order harus berstatus approved untuk dapat diselesaikan.';
    }
    if (raw.contains('tidak ditemukan')) {
      return 'Data tidak ditemukan.';
    }
    return raw;
  }
}
