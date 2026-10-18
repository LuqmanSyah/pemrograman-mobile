# Pertemuan 4 - Asynchronous dan REST API

Praktikum ini membahas proses asynchronous di Flutter, pengambilan data dari REST API, pemodelan JSON ke dalam class Dart, serta penanganan loading, error, dan refresh data.

## Tujuan Pembelajaran

Setelah menyelesaikan praktikum, mahasiswa diharapkan mampu:

- Menjalankan operasi asynchronous menggunakan `Future`.
- Mengambil data REST API menggunakan paket `http`.
- Mengubah respons JSON menjadi objek class Dart.
- Menampilkan state loading, data, dan error menggunakan `FutureBuilder`.
- Membuat navigasi ke halaman detail dan mengambil data terkait berdasarkan ID.
- Menambahkan fitur memuat ulang data secara manual dan pull-to-refresh.

## Persiapan

- Flutter SDK, editor, dan emulator atau perangkat fisik dari pertemuan sebelumnya.
- Koneksi internet untuk mengakses JSONPlaceholder.
- Paket `http` sudah tercantum pada `pubspec.yaml`.

Jika dependensi belum terpasang, jalankan:

```bash
flutter pub get
```

## Menjalankan Proyek

Jalankan dari folder `pertemuan4`:

```bash
flutter pub get
flutter run
```

Beberapa bagian praktikum tersedia sebagai entry point terpisah:

| Bagian          | Entry point               | Keterangan                                                   |
| --------------- | ------------------------- | ------------------------------------------------------------ |
| Aplikasi utama  | `lib/main.dart`           | Daftar pengguna dari REST API dan halaman detail pengguna.   |
| Praktikum       | `lib/praktikum/main.dart` | Contoh Future, daftar pengguna, dan halaman detail pengguna. |
| Latihan mandiri | `lib/latihan/main.dart`   | Daftar pengguna dengan jumlah data dan pull-to-refresh.      |
| Tugas           | `lib/tugas/main.dart`     | Aplikasi Daftar Postingan dengan komentar.                   |

Untuk menjalankan bagian tertentu:

```bash
flutter run -t lib/praktikum/main.dart
flutter run -t lib/latihan/main.dart
flutter run -t lib/tugas/main.dart
```

## Struktur Proyek

| Folder/File        | Fungsi                               |
| ------------------ | ------------------------------------ |
| `lib/main.dart`    | Titik masuk aplikasi utama.          |
| `lib/praktikum/`   | Implementasi langkah praktikum.      |
| `lib/latihan/`     | Implementasi latihan mandiri.        |
| `lib/tugas/`       | Implementasi tugas Daftar Postingan. |
| `pubspec.yaml`     | Konfigurasi proyek dan dependensi.   |
| `android/`, `ios/` | Kode platform native.                |
| `test/`            | Berkas pengujian.                    |

## Konsep Dasar

- **`Future`:** merepresentasikan hasil operasi asynchronous yang selesai kemudian.
- **`async` dan `await`:** menjalankan serta menunggu operasi asynchronous dengan sintaks yang lebih mudah dibaca.
- **REST API:** layanan yang menyediakan data melalui endpoint HTTP.
- **`http.get`:** mengirim permintaan GET ke endpoint API.
- **`jsonDecode`:** mengubah teks JSON menjadi objek Dart.
- **`FutureBuilder`:** membangun UI berdasarkan state Future, seperti loading, error, dan data.
- **`RefreshIndicator`:** menyediakan gesture tarik untuk memuat ulang data pada `ListView`.
- **`Navigator.push`:** membuka halaman detail dari item yang dipilih.

Alur aplikasi tugas adalah mengambil daftar postingan, menampilkannya dalam `ListView`, membuka detail saat item dipilih, kemudian mengambil komentar berdasarkan ID postingan. Setiap permintaan memiliki tombol coba lagi ketika terjadi error.

## Dokumentasi Tugas

Penjelasan khusus tugas Daftar Postingan tersedia di [docs/tugas-pertemuan-4.md](docs/tugas-pertemuan-4.md).

Modul praktikum lengkap tersedia di [docs/modul-praktikum-flutter-pertemuan-4.pdf](docs/modul-praktikum-flutter-pertemuan-4.pdf).

## Referensi

- [Dokumentasi Flutter](https://docs.flutter.dev/)
- [Paket http](https://pub.dev/packages/http)
- [FutureBuilder](https://api.flutter.dev/flutter/widgets/FutureBuilder-class.html)
- [JSONPlaceholder](https://jsonplaceholder.typicode.com/)
