# Pertemuan 2 - Layout, ListView, dan Navigasi

Praktikum ini membahas penyusunan layout, pemodelan data sederhana, pembuatan daftar menggunakan `ListView`, dan navigasi antarhalaman Flutter.

## Tujuan Pembelajaran

Setelah menyelesaikan praktikum, mahasiswa diharapkan mampu:

- Menyusun layout dengan `Container`, `Padding`, `Row`, `Column`, dan `Expanded`.
- Menampilkan data dengan `ListView.builder`, `Card`, dan `ListTile`.
- Memodelkan data sederhana menggunakan class Dart.
- Berpindah halaman dan mengirim data menggunakan `Navigator.push` serta `Navigator.pop`.

## Persiapan

- Flutter SDK dan editor dari Pertemuan 1.
- Emulator Android atau perangkat fisik.
- Proyek Flutter pada folder `pertemuan2`.

## Menjalankan Proyek

Jalankan dari folder `pertemuan2`:

```bash
flutter pub get
flutter run
```

Beberapa bagian praktikum tersedia sebagai entry point terpisah:

| Bagian          | Entry point               | Keterangan                                     |
| --------------- | ------------------------- | ---------------------------------------------- |
| Aplikasi utama  | `lib/main.dart`           | Implementasi gabungan layout dan navigasi.     |
| Praktikum       | `lib/praktikum/main.dart` | Daftar menu dan halaman detail dasar.          |
| Latihan mandiri | `lib/latihan/main.dart`   | Daftar menu dengan deskripsi dan format harga. |
| Tugas           | `lib/tugas/main.dart`     | Aplikasi Daftar Kontak.                        |

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
| `lib/tugas/`       | Implementasi tugas Daftar Kontak.  |
| `pubspec.yaml`     | Konfigurasi proyek dan dependensi. |
| `android/`, `ios/` | Kode platform native.              |
| `test/`            | Berkas pengujian.                  |

## Konsep Dasar

- **`Container`:** widget serbaguna untuk ukuran, warna, border, radius, padding, dan margin.
- **`Padding`:** memberi jarak di sekeliling widget anak.
- **`Row` dan `Column`:** menyusun widget secara horizontal dan vertikal.
- **`Expanded`:** membuat widget mengisi sisa ruang pada `Row` atau `Column`.
- **`ListView.builder`:** membuat daftar secara efisien berdasarkan jumlah data.
- **`Card` dan `ListTile`:** membentuk tampilan baris daftar dengan struktur standar.
- **`Navigator`:** mengelola tumpukan halaman; `push` membuka halaman dan `pop` menutupnya.

Pada `Row`, sumbu utama adalah horizontal dan sumbu silang adalah vertikal. Pada `Column`, sumbu utama adalah vertikal dan sumbu silang adalah horizontal. Keduanya dapat diatur dengan `mainAxisAlignment` dan `crossAxisAlignment`.

## Dokumentasi Tugas

Penjelasan khusus tugas Daftar Kontak tersedia di [docs/tugas-pertemuan-2.md](docs/tugas-pertemuan-2.md).

Modul praktikum lengkap tersedia di [docs/modul-praktikum-flutter-pertemuan-2.pdf](docs/modul-praktikum-flutter-pertemuan-2.pdf).

## Referensi

- [Dokumentasi Flutter](https://docs.flutter.dev/)
- [ListView.builder](https://api.flutter.dev/flutter/widgets/ListView/ListView.builder.html)
- [Navigator](https://docs.flutter.dev/ui/navigation)
