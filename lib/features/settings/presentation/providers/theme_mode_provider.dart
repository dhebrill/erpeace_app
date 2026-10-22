import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/storage/preferences_provider.dart';

/// Stores the selected theme mode and persists it on the device.
class ThemeModeController extends Notifier<ThemeMode> {
  static const String _key = 'erpeace.theme_mode';

  @override
  ThemeMode build() {
    final stored = ref.watch(sharedPreferencesProvider).getString(_key);
    return _fromStorage(stored);
  }

  void setMode(ThemeMode mode) {
    state = mode;
    ref.read(sharedPreferencesProvider).setString(_key, mode.name);
  }

  ThemeMode _fromStorage(String? value) {
    return ThemeMode.values.firstWhere(
      (mode) => mode.name == value,
      orElse: () => ThemeMode.system,
    );
  }
}

/// The current theme mode of the application.
final themeModeProvider = NotifierProvider<ThemeModeController, ThemeMode>(
  ThemeModeController.new,
);
