import 'package:flutter/material.dart';

import '../models/note.dart';
import '../models/student.dart';
import '../repositories/note_repository.dart';

/// InheritedWidget yang menyediakan state dan aksi ke seluruh subtree.
class AppProvider extends InheritedWidget {
  /// Membuat [AppProvider].
  const AppProvider({
    super.key,
    required this.student,
    required this.notes,
    required this.isLoading,
    required this.updateStudent,
    required this.addNote,
    required this.deleteNote,
    required super.child,
  });

  
  final Student student;

  
  final List<Note> notes;

  
  final bool isLoading;

  
  final Future<void> Function(Student) updateStudent;

  
  final Future<void> Function(Note) addNote;

  
  final Future<void> Function(String) deleteNote;

  
  static AppProvider of(BuildContext context, {bool listen = true}) {
    final result = listen
        ? context.dependOnInheritedWidgetOfExactType<AppProvider>()
        : context.getInheritedWidgetOfExactType<AppProvider>();
    assert(result != null, 'AppProvider tidak ditemukan di widget tree');
    return result!;
  }

  
  @override
  bool updateShouldNotify(AppProvider oldWidget) {
    return !identical(student, oldWidget.student) ||
        !identical(notes, oldWidget.notes) ||
        isLoading != oldWidget.isLoading;
  }
}


class AppProviderWrapper extends StatefulWidget {
  
  const AppProviderWrapper({super.key, required this.child, this.repository});

  
  final Widget child;

 
  final NoteRepository? repository;

  @override
  State<AppProviderWrapper> createState() => _AppProviderWrapperState();
}

class _AppProviderWrapperState extends State<AppProviderWrapper> {
  late final NoteRepository _repository;
  Student _student = Student.initial;
  List<Note> _notes = const [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _repository = widget.repository ?? NoteRepository();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final student = await _repository.loadStudent();
    final notes = await _repository.getNotes();
    if (!mounted) return;
    setState(() {
      _student = student;
      _notes = notes;
      _isLoading = false;
    });
  }

  Future<void> _updateStudent(Student student) async {
    await _repository.saveStudent(student);
    if (!mounted) return;
    setState(() => _student = student); 
  }

  Future<void> _addNote(Note note) async {
    await _repository.addNote(note);
    if (!mounted) return;
    setState(() => _notes = [note, ..._notes]); 
  }

  Future<void> _deleteNote(String id) async {
    await _repository.deleteNote(id);
    if (!mounted) return;
    setState(() => _notes = _notes.where((n) => n.id != id).toList());
  }

  @override
  Widget build(BuildContext context) {
    return AppProvider(
      student: _student,
      notes: _notes,
      isLoading: _isLoading,
      updateStudent: _updateStudent,
      addNote: _addNote,
      deleteNote: _deleteNote,
      child: widget.child,
    );
  }
}
