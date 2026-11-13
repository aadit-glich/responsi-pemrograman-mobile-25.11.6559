import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  /// Membuat service 
  SecureStorageService({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(encryptedSharedPreferences: true),
            );

  final FlutterSecureStorage _storage;

  static String keyFor(String noteId) => 'note_content_$noteId';

  
  Future<void> saveContent(String noteId, String content) async {
    try {
      await _storage.write(key: keyFor(noteId), value: content);
      debugPrint('[SecureStorage] saveContent OK (id=$noteId)');
    } catch (e) {
      debugPrint('[SecureStorage] saveContent gagal (${e.runtimeType})');
      rethrow;
    }
  }


  Future<String?> getContent(String noteId) async {
    try {
      return await _storage.read(key: keyFor(noteId));
    } catch (e) {
      debugPrint('[SecureStorage] getContent gagal (${e.runtimeType})');
      return null;
    }
  }

  Future<void> deleteContent(String noteId) async {
    try {
      await _storage.delete(key: keyFor(noteId));
      debugPrint('[SecureStorage] deleteContent OK (id=$noteId)');
    } catch (e) {
      debugPrint('[SecureStorage] deleteContent gagal (${e.runtimeType})');
      rethrow;
    }
  }
}
