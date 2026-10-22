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

    final url = dotenv.maybeGet(urlKey)?.trim() ?? '';
    final key = dotenv.maybeGet(anonKey)?.trim() ?? '';

    final missing = <String>[if (url.isEmpty) urlKey, if (key.isEmpty) anonKey];

    if (missing.isNotEmpty) {
      throw AppConfigException(
        'Konfigurasi belum lengkap. Isi variabel ${missing.join(' dan ')} '
        'pada file .env lalu jalankan ulang aplikasi.',
      );
    }

    if (!url.startsWith('http')) {
      throw const AppConfigException(
        'SUPABASE_URL tidak valid. Pastikan alamat diawali https://',
      );
    }

    return AppConfig(supabaseUrl: url, supabaseAnonKey: key);
  }
}

/// Raised when the `.env` configuration is missing or invalid.
class AppConfigException implements Exception {
  const AppConfigException(this.message);

  final String message;

  @override
  String toString() => message;
}
