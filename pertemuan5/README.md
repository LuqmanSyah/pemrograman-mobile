# Pertemuan 5 - Penyimpanan Data Lokal

Praktikum ini membahas penyimpanan data lokal pada Flutter menggunakan `shared_preferences` dan SQLite melalui paket `sqflite`. Aplikasi menyimpan preferensi sederhana serta data terstruktur yang dapat ditambah, dibaca, diubah, dan dihapus.

## Tujuan Pembelajaran

Setelah menyelesaikan praktikum, mahasiswa diharapkan mampu:

- Menyimpan preferensi sederhana menggunakan `SharedPreferences`.
- Membuat dan membuka database SQLite menggunakan `sqflite`.
- Memetakan data Dart ke tabel SQLite menggunakan `toMap` dan `fromMap`.
- Menerapkan operasi CRUD pada data lokal.
- Menangani versi database dan migrasi kolom dengan `onUpgrade`.
- Menampilkan data asynchronous menggunakan `FutureBuilder`.
- Membuat form validasi untuk menambah dan mengubah data.

## Persiapan

- Flutter SDK, editor, dan emulator atau perangkat fisik dari pertemuan sebelumnya.
- Dependensi `shared_preferences`, `sqflite`, dan `path` sudah tercantum pada `pubspec.yaml`.
- Platform target yang mendukung SQLite, seperti Android, iOS, atau desktop.

Jika dependensi belum terpasang, jalankan:

```bash
flutter pub get
```

## Menjalankan Proyek

Jalankan dari folder `pertemuan5`:

```bash
flutter pub get
flutter run
```

Beberapa bagian praktikum tersedia sebagai entry point terpisah:

| Bagian          | Entry point               | Keterangan                                                           |
| --------------- | ------------------------- | -------------------------------------------------------------------- |
| Aplikasi utama  | `lib/main.dart`           | Catatan dengan pencarian, pengurutan, tanggal, dan migrasi database. |
| Praktikum       | `lib/praktikum/main.dart` | Catatan sederhana dengan operasi CRUD SQLite.                        |
| Latihan mandiri | `lib/latihan/main.dart`   | Catatan sederhana dengan pengaturan tersimpan.                       |
| Tugas           | `lib/tugas/main.dart`     | Aplikasi Pencatat Pengeluaran.                                       |

Untuk menjalankan bagian tertentu:

```bash
flutter run -t lib/praktikum/main.dart
flutter run -t lib/latihan/main.dart
flutter run -t lib/tugas/main.dart
```

## Struktur Proyek

| Folder/File        | Fungsi                                   |
| ------------------ | ---------------------------------------- |
| `lib/main.dart`    | Titik masuk aplikasi utama.              |
| `lib/praktikum/`   | Implementasi langkah praktikum.          |
| `lib/latihan/`     | Implementasi latihan mandiri.            |
| `lib/tugas/`       | Implementasi tugas Pencatat Pengeluaran. |
| `pubspec.yaml`     | Konfigurasi proyek dan dependensi.       |
| `android/`, `ios/` | Kode platform native.                    |
| `test/`            | Berkas pengujian.                        |

## Konsep Dasar

- **`SharedPreferences`:** menyimpan pasangan key-value sederhana seperti string, boolean, dan integer.
- **SQLite:** database relasional lokal untuk menyimpan data terstruktur.
- **`sqflite`:** paket Flutter untuk membuka database dan menjalankan query SQLite.
- **`Database`:** objek koneksi yang digunakan untuk operasi query dan transaksi.
- **CRUD:** operasi create, read, update, dan delete pada data.
- **`toMap` dan `fromMap`:** mengubah objek Dart menjadi baris database dan sebaliknya.
- **`onUpgrade`:** menjalankan migrasi ketika versi database dinaikkan.
- **`FutureBuilder`:** membangun tampilan berdasarkan proses pembacaan database asynchronous.

Pada aplikasi tugas, data pengeluaran disimpan pada tabel `pengeluaran` dengan kolom nama, jumlah, kategori, dan tanggal. Data diurutkan berdasarkan tanggal, total pengeluaran dihitung dari daftar yang dibaca, dan perubahan tema disimpan menggunakan `SharedPreferences`.

## Dokumentasi Tugas

Penjelasan khusus tugas Pencatat Pengeluaran tersedia di [docs/tugas-pertemuan-5.md](docs/tugas-pertemuan-5.md).

Modul praktikum lengkap tersedia di [docs/modul-praktikum-flutter-pertemuan-5.pdf](docs/modul-praktikum-flutter-pertemuan-5.pdf).

## Referensi

- [Dokumentasi Flutter](https://docs.flutter.dev/)
- [Paket shared_preferences](https://pub.dev/packages/shared_preferences)
- [Paket sqflite](https://pub.dev/packages/sqflite)
- [Paket path](https://pub.dev/packages/path)
- [SQLite Documentation](https://sqlite.org/docs.html)
