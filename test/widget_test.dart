import 'package:flutter_test/flutter_test.dart';
import 'package:responsi_profil_mahasiswa/models/student.dart';
import 'package:responsi_profil_mahasiswa/utils/validators.dart';

void main() {
  group('Validators.sanitize', () {
    test('menghapus karakter < > " \'', () {
      expect(Validators.sanitize('  a<b>c"d\'e  '), 'abcde');
    });
  });

  group('Validators.validateTitle', () {
    test('kosong ditolak', () {
      expect(Validators.validateTitle(''), isNotNull);
    });
    test('kurang dari 3 karakter ditolak', () {
      expect(Validators.validateTitle('ab'), isNotNull);
    });
    test('3 karakter diterima', () {
      expect(Validators.validateTitle('abc'), isNull);
    });
    test('lebih dari 50 karakter ditolak', () {
      expect(Validators.validateTitle('a' * 51), isNotNull);
    });
  });

  group('Validators.validateContent', () {
    test('kurang dari 10 karakter ditolak', () {
      expect(Validators.validateContent('pendek'), isNotNull);
    });
    test('10 karakter diterima', () {
      expect(Validators.validateContent('a' * 10), isNull);
    });
    test('lebih dari 1000 karakter ditolak', () {
      expect(Validators.validateContent('a' * 1001), isNotNull);
    });
  });

  group('Student', () {
    test('initials mengambil huruf pertama dua kata pertama', () {
      const s = Student(
        name: 'Budi Santoso',
        nim: '23.11.0001',
        programStudi: 'S1 Informatika',
        email: 'budi@students.amikom.ac.id',
      );
      expect(s.initials, 'BS');
    });
  });
}