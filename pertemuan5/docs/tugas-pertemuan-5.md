# Tugas Praktikum Flutter Pertemuan 5

## Identitas

- **Nama:** Luqman Syahreno
- **NIM:** 20240801016
- **Program Studi:** Teknik Informatika
- **Mata Kuliah:** Pemrograman Mobile
- **Pertemuan:** 5 - Penyimpanan Data Lokal

## Deskripsi Tugas

Membuat aplikasi **Pencatat Pengeluaran** berdasarkan modul praktikum Flutter Pertemuan 5. Aplikasi menyimpan data pengeluaran secara lokal menggunakan SQLite, menghitung total pengeluaran, dan menyediakan pengaturan mode gelap.

## Ketentuan Tugas

- Menyimpan data pengeluaran menggunakan SQLite melalui paket `sqflite`.
- Setiap data memiliki nama, jumlah, kategori, dan tanggal.
- Menampilkan daftar pengeluaran yang tersimpan secara lokal.
- Menampilkan total seluruh pengeluaran.
- Menyediakan form tambah dan ubah pengeluaran.
- Memvalidasi nama dan jumlah pengeluaran.
- Menyediakan pilihan kategori: Makanan, Transportasi, Belanja, dan Lainnya.
- Menyediakan date picker untuk memilih tanggal pengeluaran.
- Menghapus data dengan dialog konfirmasi.
- Menyediakan switch untuk mengaktifkan mode gelap.
- Menyimpan preferensi mode gelap menggunakan `SharedPreferences`.
- Mengumpulkan tangkapan layar halaman daftar, form, validasi, dan mode gelap.
- Menyertakan berkas `main.dart` atau tautan repositori.

## Berkas Implementasi

Implementasi tugas terdapat pada [`lib/tugas/main.dart`](../lib/tugas/main.dart).

## Dependensi

Aplikasi menggunakan paket berikut:

- [`shared_preferences`](https://pub.dev/packages/shared_preferences) untuk menyimpan preferensi mode gelap.
- [`sqflite`](https://pub.dev/packages/sqflite) untuk database SQLite lokal.
- [`path`](https://pub.dev/packages/path) untuk menyusun lokasi berkas database.

Jika dependensi belum terpasang, jalankan:

```bash
flutter pub get
```

## Cara Menjalankan

Jalankan perintah berikut dari folder `pertemuan5`:

```bash
flutter run -t lib/tugas/main.dart
```

## Hasil Tugas

Aplikasi **Pencatat Pengeluaran** memiliki fitur berikut:

1. **Daftar pengeluaran** menampilkan nama, kategori, tanggal, dan jumlah setiap data. Total seluruh jumlah ditampilkan pada bagian atas.
2. **Tambah pengeluaran** menyediakan input nama, jumlah, kategori, dan tanggal. Data disimpan ke tabel SQLite setelah seluruh input valid.
3. **Ubah pengeluaran** menggunakan form yang sama dengan data lama sebagai nilai awal.
4. **Hapus pengeluaran** meminta konfirmasi sebelum menghapus data dari database.
5. **Mode gelap** dapat diaktifkan melalui switch pada AppBar dan preferensinya disimpan agar tetap digunakan saat aplikasi dibuka kembali.

Model `Pengeluaran` menyediakan konversi `toMap` dan `fromMap`, sedangkan `DbHelper` menangani operasi database. `FutureBuilder` digunakan untuk menampilkan proses pemuatan, error, daftar data, atau pesan ketika belum ada pengeluaran.

## Struktur Database

Database disimpan dengan nama `pengeluaran.db` dan memiliki tabel `pengeluaran`:

| Kolom      | Tipe    | Keterangan                 |
| ---------- | ------- | -------------------------- |
| `id`       | INTEGER | Primary key autoincrement. |
| `nama`     | TEXT    | Nama pengeluaran.          |
| `jumlah`   | INTEGER | Nominal pengeluaran.       |
| `kategori` | TEXT    | Kategori pengeluaran.      |
| `tanggal`  | TEXT    | Tanggal pengeluaran.       |

Dokumentasi ini belum menyertakan berkas screenshot karena folder `docs/screenshots` belum tersedia pada proyek. Screenshot dapat ditambahkan setelah aplikasi dijalankan.
