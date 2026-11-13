# responsi_profil_mahasiswa

Aplikasi Profil Mahasiswa dengan Catatan Kuliah (Responsi Pemrograman Mobile ST407).

## Cara memasang (folder ini hanya berisi kode Dart, bukan folder android/ios)

Folder platform (`android/`, `ios/`) dibuat oleh Flutter, jadi lakukan ini di komputer kamu:

```bash
# 1. Buat proyek baru
flutter create responsi_profil_mahasiswa
cd responsi_profil_mahasiswa

# 2. Hapus file bawaan yang akan ditimpa
rm -rf lib test

# 3. Salin isi folder ini ke dalam proyek (timpa pubspec.yaml)
#    -> lib/, pubspec.yaml, .env, .env.example, .gitignore

# 4. Install dependency & jalankan
flutter pub get
flutter run
```

## Edit AndroidManifest.xml

File: `android/app/src/main/AndroidManifest.xml`

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <uses-permission android:name="android.permission.INTERNET"/>
    <application
        android:label="responsi_profil_mahasiswa"
        android:allowBackup="false"
        ...>
```

## Git (Soal 1) — jalankan sambil mengerjakan

git init
git branch -M main
git config user.name "Nama Kamu"
git config user.email "emailkamu@students.amikom.ac.id"

git add .gitignore pubspec.yaml analysis_options.yaml .metadata .env.example README.md
git commit -m "chore: inisialisasi proyek Flutter, .gitignore, dan dependency"

git checkout -b fitur-profil
git add lib/models/student.dart lib/widgets/profile_card.dart lib/screens/profile_screen.dart
git commit -m "feat: tambah model Student, ProfileCard, dan ProfileScreen"
git add lib/utils/validators.dart
git commit -m "feat: tambah validator dan sanitasi input"
git checkout main
git merge fitur-profil --no-ff -m "merge: fitur-profil"

git checkout -b fitur-catatan
git add lib/models/note.dart lib/services lib/repositories lib/config
git commit -m "feat: tambah Note, SecureStorageService, NoteRepository, AppConfig"
git add lib/providers lib/screens/note_form_screen.dart lib/widgets/note_card.dart lib/widgets/empty_state.dart
git commit -m "feat: tambah AppProvider, NoteFormScreen, NoteCard, EmptyState"
git checkout main
git merge fitur-catatan --no-ff -m "merge: fitur-catatan"

git add .
git commit -m "feat: integrasi HomeScreen, navigasi, HTTP GET, dan tema"

git log --graph --oneline --all

## Catatan keamanan

- `.env` ada di `.gitignore`; gunakan `.env.example` sebagai contoh.
- Isi catatan hanya di flutter_secure_storage (`note_content_<id>`); metadata di SharedPreferences.
- Log tidak pernah mencetak isi catatan, API key, atau header.
