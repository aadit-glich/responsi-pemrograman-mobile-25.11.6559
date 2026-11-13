import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/note.dart';
import '../models/student.dart';
import '../services/secure_storage_service.dart';

class NoteRepository {

  NoteRepository({SecureStorageService? secureStorage})
      : _secure = secureStorage ?? SecureStorageService();

  final SecureStorageService _secure;

  static const String _notesKey = 'notes_metadata';
  static const String _studentKey = 'student_profile';

  Future<List<Map<String, dynamic>>> _readMetadata() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_notesKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    } catch (_) {
      debugPrint('[NoteRepository] metadata rusak, diabaikan');
      return [];
    }
  }

  Future<void> _writeMetadata(List<Map<String, dynamic>> metadata) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_notesKey, jsonEncode(metadata));
  }

  Future<List<Note>> getNotes() async {
    final metadata = await _readMetadata();
    final notes = <Note>[];
    for (final meta in metadata) {
      try {
        final content = await _secure.getContent(meta['id'] as String) ?? '';
        notes.add(Note.fromMetadata(meta, content: content));
      } catch (_) {
        debugPrint('[NoteRepository] satu catatan dilewati (data tidak valid)');
      }
    }
    return notes;
  }

  Future<void> addNote(Note note) async {
    await _secure.saveContent(note.id, note.content);
    final metadata = await _readMetadata();
    metadata.insert(0, note.toMetadataJson());
    await _writeMetadata(metadata);
  }

  Future<void> deleteNote(String id) async {
    final metadata = await _readMetadata();
    metadata.removeWhere((m) => m['id'] == id);
    await _writeMetadata(metadata);
    await _secure.deleteContent(id);
  }


  Future<Student> loadStudent() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_studentKey);
    if (raw == null) return Student.initial;
    try {
      return Student.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return Student.initial;
    }
  }

  
  Future<void> saveStudent(Student student) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_studentKey, jsonEncode(student.toJson()));
  }
}
