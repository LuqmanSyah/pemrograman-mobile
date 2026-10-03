# Pertemuan 3 - Form Input dan State Management

Praktikum ini membahas input pengguna, validasi form, dan state management menggunakan `ChangeNotifier` serta paket Provider.

## Tujuan Pembelajaran

Setelah menyelesaikan praktikum, mahasiswa diharapkan mampu:

- Mengambil input pengguna dengan `TextField` dan `TextEditingController`.
- Membuat form dengan `Form`, `TextFormField`, dropdown, dan checkbox.
- Memvalidasi input dan menampilkan pesan kesalahan.
- Menerapkan state management dengan `ChangeNotifier` dan Provider.
- Membedakan penggunaan `context.watch` dan `context.read`.

## Persiapan

- Flutter SDK, editor, dan emulator atau perangkat fisik dari pertemuan sebelumnya.
- Koneksi internet untuk dependensi Provider.
- Paket `provider` sudah tercantum pada `pubspec.yaml`.

Jika dependensi belum terpasang, jalankan:

```bash
flutter pub add provider
```

## Menjalankan Proyek

Jalankan dari folder `pertemuan3`:

```bash
flutter pub get
flutter run
```

Beberapa bagian praktikum tersedia sebagai entry point terpisah:

| Bagian          | Entry point               | Keterangan                                                       |
| --------------- | ------------------------- | ---------------------------------------------------------------- |
| Aplikasi utama  | `lib/main.dart`           | Aplikasi daftar tugas dengan Provider.                           |
| Praktikum       | `lib/praktikum/main.dart` | Daftar tugas dasar dengan Provider.                              |
| Latihan mandiri | `lib/latihan/main.dart`   | Daftar tugas dengan validasi, hapus tugas selesai, dan SnackBar. |
| Tugas           | `lib/tugas/main.dart`     | Aplikasi Daftar Belanja.                                         |

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
| `lib/tugas/`       | Implementasi tugas Daftar Belanja. |
| `pubspec.yaml`     | Konfigurasi proyek dan dependensi. |
| `android/`, `ios/` | Kode platform native.              |
| `test/`            | Berkas pengujian.                  |

## Konsep Dasar

- **`TextEditingController`:** membaca dan mengelola nilai input teks.
- **`Form`:** mengelompokkan input yang perlu divalidasi bersama.
- **`TextFormField`:** input teks yang memiliki fungsi `validator`.
- **`ChangeNotifier`:** objek state yang memberi tahu listener ketika data berubah.
- **Provider:** menyediakan objek state kepada widget yang membutuhkannya.
- **`context.watch<T>()`:** membaca state dan membangun ulang widget saat state berubah.
- **`context.read<T>()`:** membaca state tanpa berlangganan perubahan, cocok untuk callback.
- **`notifyListeners()`:** memicu pembaruan widget yang sedang menggunakan state.

Controller harus dilepas di `dispose()` agar tidak menyebabkan kebocoran memori. Gunakan `setState` untuk state lokal satu widget, sedangkan Provider cocok untuk data yang dipakai oleh beberapa widget atau halaman.

## Dokumentasi Tugas

Penjelasan khusus tugas Daftar Belanja tersedia di [docs/tugas-pertemuan-3.md](docs/tugas-pertemuan-3.md).

Modul praktikum lengkap tersedia di [docs/modul-praktikum-flutter-pertemuan-3.pdf](docs/modul-praktikum-flutter-pertemuan-3.pdf).

## Referensi

- [Dokumentasi Forms Flutter](https://docs.flutter.dev/cookbook/forms)
- [State Management Flutter](https://docs.flutter.dev/data-and-backend/state-mgmt)
- [Paket Provider](https://pub.dev/packages/provider)
