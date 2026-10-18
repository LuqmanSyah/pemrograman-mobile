# Tugas Praktikum Flutter Pertemuan 4

## Identitas

- **Nama:** Luqman Syahreno
- **NIM:** 20240801016
- **Program Studi:** Teknik Informatika
- **Mata Kuliah:** Pemrograman Mobile
- **Pertemuan:** 4 - Asynchronous dan REST API

## Deskripsi Tugas

Membuat aplikasi **Daftar Postingan** berdasarkan modul praktikum Flutter Pertemuan 4. Aplikasi mengambil data postingan dan komentar dari REST API JSONPlaceholder, kemudian menampilkannya melalui halaman daftar dan halaman detail.

## Ketentuan Tugas

- Mengambil data postingan dari endpoint `https://jsonplaceholder.typicode.com/posts`.
- Memodelkan data postingan menggunakan class `Post`.
- Menampilkan daftar postingan menggunakan `FutureBuilder` dan `ListView.builder`.
- Menampilkan indikator loading selama proses pengambilan data.
- Menampilkan pesan error dan tombol **Coba lagi** ketika permintaan gagal.
- Membuka halaman detail ketika salah satu postingan diketuk.
- Mengambil komentar berdasarkan ID postingan dari endpoint REST API.
- Menampilkan komentar menggunakan class `Komentar` dan widget `Card`.
- Menyediakan tombol refresh pada halaman daftar dan halaman komentar.
- Mengumpulkan tangkapan layar halaman daftar, detail postingan, dan komentar.
- Menyertakan berkas `main.dart` atau tautan repositori.

## Berkas Implementasi

Implementasi tugas terdapat pada [`lib/tugas/main.dart`](../lib/tugas/main.dart).

## Dependensi

Aplikasi menggunakan paket [`http`](https://pub.dev/packages/http) untuk mengirim permintaan GET ke JSONPlaceholder.

Jika dependensi belum terpasang, jalankan:

```bash
flutter pub get
```

## Cara Menjalankan

Jalankan perintah berikut dari folder `pertemuan4`:

```bash
flutter run -t lib/tugas/main.dart
```

Perangkat yang menjalankan aplikasi harus memiliki koneksi internet agar data postingan dan komentar dapat dimuat.

## Hasil Tugas

Aplikasi **Daftar Postingan** memiliki dua halaman utama:

1. **Halaman Daftar Postingan** mengambil dan menampilkan daftar postingan. Setiap item menampilkan nomor, judul, dan ringkasan isi postingan. Tombol refresh pada AppBar digunakan untuk mengambil data terbaru.
2. **Halaman Detail Postingan** menampilkan judul dan isi lengkap postingan, kemudian mengambil komentar berdasarkan ID postingan. Setiap komentar menampilkan nama, email, dan isi komentar.

Proses pengambilan data dikelola oleh `ApiService`. Class `Post` dan `Komentar` mengubah data JSON menjadi objek Dart. `FutureBuilder` digunakan untuk membedakan tampilan loading, error, data kosong, dan data berhasil dimuat.

## Endpoint API

| Data      | Endpoint                                                       |
| --------- | -------------------------------------------------------------- |
| Postingan | `GET https://jsonplaceholder.typicode.com/posts`               |
| Komentar  | `GET https://jsonplaceholder.typicode.com/posts/{id}/comments` |

Dokumentasi ini belum menyertakan berkas screenshot karena folder `docs/screenshots` belum tersedia pada proyek. Screenshot dapat ditambahkan setelah aplikasi dijalankan.
