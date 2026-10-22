import 'package:flutter/material.dart';

/// Palette used across ERPeace. The whole UI is built from a single teal seed
/// colour, everything else is a soft neutral derived from the colour scheme.
abstract final class AppColors {
  const AppColors._();

  /// Brand seed colour.
  static const Color seed = Color(0xFF0F9D8A);

  /// Lighter mint accent used for highlights and gradients.
  static const Color mint = Color(0xFF5FD3C0);

  static const Color lightBackground = Color(0xFFF6F8F8);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceMuted = Color(0xFFEFF3F3);

  static const Color darkBackground = Color(0xFF0E1517);
  static const Color darkSurface = Color(0xFF162023);
  static const Color darkSurfaceMuted = Color(0xFF1D292D);

  /// Status colours used by chips across the app.
  static const Color statusDraft = Color(0xFF64748B);
  static const Color statusApproved = Color(0xFF2563EB);
  static const Color statusReceived = Color(0xFF0F9D8A);
  static const Color statusCompleted = Color(0xFF16A34A);
  static const Color statusCancelled = Color(0xFFDC2626);

  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFDC2626);
  static const Color info = Color(0xFF2563EB);
  static const Color success = Color(0xFF16A34A);
}
