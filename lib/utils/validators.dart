/// Kumpulan fungsi validasi dan sanitasi input pengguna.
class Validators {
  Validators._();

  static String sanitize(String input) {
    return input.replaceAll(RegExp('[<>"\']'), '').trim();
  }

  static String? validateTitle(String? value) {
    final v = sanitize(value ?? '');
    if (v.isEmpty) return 'Judul wajib diisi';
    if (v.length < 3) return 'Judul minimal 3 karakter';
    if (v.length > 50) return 'Judul maksimal 50 karakter';
    return null;
  }

  static String? validateContent(String? value) {
    final v = sanitize(value ?? '');
    if (v.isEmpty) return 'Isi catatan wajib diisi';
    if (v.length < 10) return 'Isi catatan minimal 10 karakter';
    if (v.length > 1000) return 'Isi catatan maksimal 1000 karakter';
    return null;
  }

  static String? validateName(String? value) {
    final v = sanitize(value ?? '');
    if (v.isEmpty) return 'Nama wajib diisi';
    if (v.length < 3) return 'Nama minimal 3 karakter';
    if (v.length > 60) return 'Nama maksimal 60 karakter';
    return null;
  }

  static String? validateNim(String? value) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return 'NIM wajib diisi';
    if (!RegExp(r'^[0-9.]{5,20}$').hasMatch(v)) {
      return 'NIM hanya angka/titik (5-20 karakter)';
    }
    return null;
  }


  static String? validateProgramStudi(String? value) {
    final v = sanitize(value ?? '');
    if (v.isEmpty) return 'Program studi wajib diisi';
    if (v.length < 3) return 'Program studi minimal 3 karakter';
    if (v.length > 50) return 'Program studi maksimal 50 karakter';
    return null;
  }

  static String? validateEmail(String? value) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return 'Email wajib diisi';
    if (!RegExp(r'^[\w.+-]+@[\w-]+(\.[\w-]+)+$').hasMatch(v)) {
      return 'Format email tidak valid';
    }
    return null;
  }
}
