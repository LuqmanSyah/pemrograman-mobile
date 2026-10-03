# Tugas Praktikum Flutter Pertemuan 2

## Identitas

- **Nama:** Luqman Syahreno
- **NIM:** 20240801016
- **Program Studi:** Teknik Informatika
- **Mata Kuliah:** Pemrograman Mobile
- **Pertemuan:** 2 - Layout, ListView, dan Navigasi Antar Halaman

## Deskripsi Tugas

Membuat aplikasi **Daftar Kontak** berdasarkan modul praktikum Flutter Pertemuan 2. Aplikasi menampilkan daftar kontak dan menyediakan halaman detail untuk setiap kontak.

## Ketentuan Tugas

- Memiliki minimal 6 kontak.
- Setiap kontak disimpan sebagai objek class dengan data nama, nomor telepon, dan email.
- Halaman utama menampilkan daftar kontak menggunakan `ListView.builder` dan `ListTile`.
- Avatar setiap kontak menampilkan huruf pertama dari nama.
- Ketika kontak diketuk, aplikasi membuka halaman detail.
- Halaman detail menampilkan seluruh data kontak dan tombol kembali.
- Mengumpulkan tangkapan layar halaman daftar dan halaman detail.
- Menyertakan berkas `main.dart` atau tautan repositori.

## Berkas Implementasi

Implementasi tugas terdapat pada [`lib/tugas/main.dart`](../lib/tugas/main.dart).

## Cara Menjalankan

Jalankan perintah berikut dari folder `pertemuan2`:

```bash
flutter pub get
flutter run -t lib/tugas/main.dart
```

## Hasil Tugas

Aplikasi **Daftar Kontak** berisi 6 kontak dengan informasi nama, nomor telepon, dan email. Halaman utama menampilkan nama serta nomor telepon dalam daftar yang dapat di-scroll. Setiap item memiliki avatar berisi huruf pertama nama dan ikon navigasi.

Saat salah satu kontak diketuk, aplikasi membuka halaman detail yang menampilkan avatar, nama, nomor telepon, email, dan tombol **Kembali**. Navigasi halaman menggunakan `Navigator.push`, sedangkan tombol kembali menggunakan `Navigator.pop`.

## Screenshot Halaman Daftar

> **Placeholder screenshot:** tambahkan tangkapan layar halaman utama Daftar Kontak di sini.
>
> Contoh nama berkas: `screenshots/daftar-kontak.png`

## Screenshot Halaman Detail

> **Placeholder screenshot:** tambahkan tangkapan layar halaman detail kontak di sini.
>
> Contoh nama berkas: `screenshots/detail-kontak.png`
