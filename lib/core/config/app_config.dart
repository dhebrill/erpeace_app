import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Runtime configuration loaded from the `.env` asset.
class AppConfig {
  const AppConfig({required this.supabaseUrl, required this.supabaseAnonKey});

  final String supabaseUrl;
  final String supabaseAnonKey;

  static const String urlKey = 'SUPABASE_URL';
  static const String anonKey = 'SUPABASE_ANON_KEY';

  /// Loads the `.env` asset and validates the required keys.
  ///
  /// Throws [AppConfigException] with a user friendly message when the
  /// configuration is missing so the app can show a helpful screen instead of
  /// crashing.
  static Future<AppConfig> load() async {
    await dotenv.load(fileName: '.env', isOptional: true);

    final url = _resolve(urlKey);
    final key = _resolve(anonKey);

    final missing = <String>[if (url.isEmpty) urlKey, if (key.isEmpty) anonKey];

    if (missing.isNotEmpty) {
      throw AppConfigException(
        'Konfigurasi belum lengkap. Isi variabel ${missing.join(' dan ')} '
        'pada file .env atau lewat --dart-define, lalu jalankan ulang '
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

  /// Reads [key] from `--dart-define` first, falling back to the `.env` asset.
  ///
  /// `--dart-define` keeps real credentials out of the repository, which is the
  /// recommended setup for release builds.
  static String _resolve(String key) {
    const fromDefine = String.fromEnvironment('SUPABASE_URL');
    const fromDefineKey = String.fromEnvironment('SUPABASE_ANON_KEY');
    final defined = key == urlKey ? fromDefine : fromDefineKey;
    if (defined.trim().isNotEmpty) return defined.trim();
    return dotenv.maybeGet(key)?.trim() ?? '';
  }
}

/// Raised when the `.env` configuration is missing or invalid.
class AppConfigException implements Exception {
  const AppConfigException(this.message);

  final String message;

  @override
  String toString() => message;
}
