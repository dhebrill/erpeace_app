/// Runtime configuration supplied at build/run time.
///
/// Values are read from `--dart-define` or `--dart-define-from-file=.env` so
/// credentials never need to be bundled as a Flutter asset.
class AppConfig {
  const AppConfig({required this.supabaseUrl, required this.supabaseAnonKey});

  final String supabaseUrl;
  final String supabaseAnonKey;

  static const String urlKey = 'SUPABASE_URL';
  static const String anonKey = 'SUPABASE_ANON_KEY';

  /// Loads configuration from `--dart-define` (or `--dart-define-from-file`).
  ///
  /// Throws [AppConfigException] with a user friendly message when the
  /// configuration is missing so the app can show a helpful screen instead of
  /// crashing.
  static AppConfig load() {
    final url = _resolve(urlKey);
    final key = _resolve(anonKey);

    final missing = <String>[if (url.isEmpty) urlKey, if (key.isEmpty) anonKey];

    if (missing.isNotEmpty) {
      throw AppConfigException(
        'Konfigurasi belum lengkap. Isi variabel ${missing.join(' dan ')} '
        'lewat --dart-define atau --dart-define-from-file=.env, lalu jalankan ulang '
        'aplikasi.',
      );
    }

    if (!url.startsWith('http')) {
      throw const AppConfigException(
        'SUPABASE_URL tidak valid. Pastikan alamat diawali https://',
      );
    }

    return AppConfig(supabaseUrl: url, supabaseAnonKey: key);
  }

  /// Reads [key] from `--dart-define` (supports `--dart-define-from-file`).
  static String _resolve(String key) {
    const fromDefineUrl = String.fromEnvironment('SUPABASE_URL');
    const fromDefineKey = String.fromEnvironment('SUPABASE_ANON_KEY');
    final defined = key == urlKey ? fromDefineUrl : fromDefineKey;
    return defined.trim();
  }
}

/// Raised when the `.env` configuration is missing or invalid.
class AppConfigException implements Exception {
  const AppConfigException(this.message);

  final String message;

  @override
  String toString() => message;
}
