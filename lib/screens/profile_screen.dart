import 'package:flutter/material.dart';

import '../models/student.dart';
import '../providers/app_provider.dart';
import '../utils/validators.dart';
import '../widgets/profile_card.dart';


class ProfileScreen extends StatelessWidget {
  /// Membuat [ProfileScreen].
  const ProfileScreen({super.key});

  Future<void> _edit(BuildContext context, Student current) async {
    final provider = AppProvider.of(context, listen: false);
    final result = await showDialog<Student>(
      context: context,
      builder: (_) => _EditProfileDialog(student: current),
    );
    if (result == null) return;
    await provider.updateStudent(result);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil berhasil diperbarui')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final student = AppProvider.of(context).student;
    return Scaffold(
      appBar: AppBar(title: const Text('Profil Mahasiswa')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProfileCard(student: student),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => _edit(context, student),
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit Profil'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EditProfileDialog extends StatefulWidget {
  const _EditProfileDialog({required this.student});

  final Student student;

  @override
  State<_EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<_EditProfileDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _nim;
  late final TextEditingController _prodi;
  late final TextEditingController _email;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.student.name);
    _nim = TextEditingController(text: widget.student.nim);
    _prodi = TextEditingController(text: widget.student.programStudi);
    _email = TextEditingController(text: widget.student.email);
  }

  @override
  void dispose() {
    _name.dispose();
    _nim.dispose();
    _prodi.dispose();
    _email.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(
      context,
      Student(
        name: Validators.sanitize(_name.text),
        nim: _nim.text.trim(),
        programStudi: Validators.sanitize(_prodi.text),
        email: _email.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Profil'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _name,
                decoration: const InputDecoration(
                  labelText: 'Nama',
                  border: OutlineInputBorder(),
                ),
                validator: Validators.validateName,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nim,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'NIM',
                  border: OutlineInputBorder(),
                ),
                validator: Validators.validateNim,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _prodi,
                decoration: const InputDecoration(
                  labelText: 'Program Studi',
                  border: OutlineInputBorder(),
                ),
                validator: Validators.validateProgramStudi,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: Validators.validateEmail,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        FilledButton(onPressed: _save, child: const Text('Simpan')),
      ],
    );
  }
}
