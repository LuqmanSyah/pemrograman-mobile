# Pertemuan 6 - Navigasi, Animasi, dan Theming

Praktikum ini membahas navigasi antarhalaman, named routes, transisi halaman, animasi Flutter, pengelolaan tema menggunakan `ValueNotifier`, serta penyimpanan preferensi tema secara lokal.

## Tujuan Pembelajaran

Setelah menyelesaikan praktikum, mahasiswa diharapkan mampu:

- Membuat navigasi menggunakan named routes dan route generator.
- Mengirim argumen dari halaman daftar ke halaman detail.
- Menangani route yang tidak ditemukan menggunakan `onUnknownRoute`.
- Membuat animasi implisit menggunakan `AnimatedContainer`, `AnimatedSwitcher`, dan `AnimatedOpacity`.
- Mengontrol animasi secara manual menggunakan `AnimationController`.
- Membuat transisi halaman menggunakan `PageRouteBuilder` dan `FadeTransition`.
- Mengatur mode terang, mode gelap, dan warna tema aplikasi.
- Menyimpan serta memuat preferensi pengguna dengan `SharedPreferences`.

## Persiapan

- Flutter SDK, editor, dan emulator atau perangkat fisik dari pertemuan sebelumnya.
- Paket `shared_preferences` sudah tercantum pada `pubspec.yaml`.

Jika dependensi belum terpasang, jalankan:

```bash
flutter pub get
```

## Menjalankan Proyek

Jalankan dari folder `pertemuan6`:

```bash
flutter pub get
flutter run
```

Beberapa bagian praktikum tersedia sebagai entry point terpisah:

| Bagian          | Entry point               | Keterangan                                                      |
| --------------- | ------------------------- | --------------------------------------------------------------- |
| Aplikasi utama  | `lib/main.dart`           | Navigasi, animasi, dan pengaturan tema dasar.                   |
| Praktikum       | `lib/praktikum/main.dart` | Demo navigasi, animasi, dan pengaturan tema.                    |
| Latihan mandiri | `lib/latihan/main.dart`   | Tema yang disimpan menggunakan `SharedPreferences` dan animasi. |
| Tugas           | `lib/tugas/main.dart`     | Aplikasi demo lengkap dengan drawer, route, dan empat animasi.  |

Untuk menjalankan bagian tertentu:

```bash
flutter run -t lib/praktikum/main.dart
flutter run -t lib/latihan/main.dart
flutter run -t lib/tugas/main.dart
```

## Struktur Proyek

| Folder/File        | Fungsi                             |
| ------------------ | ---------------------------------- |
| `lib/main.dart`    | Titik masuk aplikasi utama.        |
| `lib/praktikum/`   | Implementasi langkah praktikum.    |
| `lib/latihan/`     | Implementasi latihan mandiri.      |
| `lib/tugas/`       | Implementasi tugas Pertemuan 6.    |
| `pubspec.yaml`     | Konfigurasi proyek dan dependensi. |
| `android/`, `ios/` | Kode platform native.              |
| `test/`            | Berkas pengujian.                  |

## Konsep Dasar

- **Named route:** rute yang diberi nama dan dapat dibuka menggunakan `Navigator.pushNamed`.
- **`onGenerateRoute`:** membuat route secara dinamis berdasarkan nama dan argumen.
- **`onUnknownRoute`:** menyediakan halaman pengganti ketika route tidak ditemukan.
- **`Hero`:** menganimasikan elemen yang sama saat berpindah antarhalaman.
- **`AnimatedContainer`:** menganimasikan perubahan ukuran, warna, dan bentuk secara otomatis.
- **`AnimatedSwitcher`:** menganimasikan pergantian widget.
- **`AnimatedOpacity`:** menganimasikan perubahan tingkat transparansi widget.
- **`AnimationController`:** mengatur durasi dan status animasi secara manual.
- **`ValueNotifier`:** menyimpan nilai sederhana dan memberi tahu listener ketika nilainya berubah.
- **`ThemeData`:** mendefinisikan warna, brightness, dan konfigurasi visual aplikasi.

Aplikasi tugas memakai `IndexedStack` agar isi tab tetap dipertahankan ketika berpindah melalui `NavigationBar` atau `Drawer`. Pengaturan mode gelap dan warna tema disimpan dengan `SharedPreferences`, sehingga preferensi tetap tersedia saat aplikasi dibuka kembali.

## Dokumentasi Tugas

Penjelasan khusus tugas tersedia di [docs/tugas-pertemuan-6.md](docs/tugas-pertemuan-6.md).

Modul praktikum lengkap tersedia di [docs/modul-praktikum-flutter-pertemuan-6.pdf](docs/modul-praktikum-flutter-pertemuan-6.pdf).

# pertemuan6

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
