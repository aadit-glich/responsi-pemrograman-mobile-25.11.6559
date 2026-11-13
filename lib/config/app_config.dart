import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  AppConfig._();

  static const String _fallbackBaseUrl = 'https://jsonplaceholder.typicode.com';

  static Future<void> load() async {
    try {
      await dotenv.load(fileName: '.env');
    } catch (e) {
      debugPrint('[AppConfig] .env gagal dimuat (${e.runtimeType}).');
    }
  }

  static String get baseUrl {
    if (!dotenv.isInitialized) return _fallbackBaseUrl;
    return dotenv.env['BASE_URL'] ?? _fallbackBaseUrl;
  }

  static String get apiKey {
    if (!dotenv.isInitialized) return '';
    return dotenv.env['API_KEY'] ?? '';
  }
}
