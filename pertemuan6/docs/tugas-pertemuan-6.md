# Tugas Praktikum Flutter Pertemuan 6

## Identitas

- **Nama:** Luqman Syahreno
- **NIM:** 20240801016
- **Program Studi:** Teknik Informatika
- **Mata Kuliah:** Pemrograman Mobile
- **Pertemuan:** 6 - Navigasi, Animasi, dan Theming

## Deskripsi Tugas

Membuat aplikasi demo **Navigasi dan Animasi Flutter** berdasarkan modul praktikum Flutter Pertemuan 6. Aplikasi memiliki beberapa halaman utama, contoh animasi, halaman detail dengan transisi, serta pengaturan tema yang tersimpan secara lokal.

## Ketentuan Tugas

- Membuat halaman Beranda, Animasi, dan Pengaturan.
- Menyediakan navigasi menggunakan `NavigationBar` dan `Drawer`.
- Menampilkan daftar item pada halaman Beranda.
- Membuka halaman detail menggunakan named route dan argumen item.
- Menampilkan animasi `Hero` pada ikon item ketika menuju halaman detail.
- Menyediakan contoh `AnimatedContainer` untuk mengubah bentuk dan ukuran.
- Menyediakan contoh `AnimatedSwitcher` untuk mengganti nilai penghitung.
- Menyediakan `AnimationController` dan `RotationTransition` untuk animasi berulang.
- Menyediakan contoh `AnimatedOpacity` untuk efek muncul dan menghilang.
- Menyediakan mode terang dan mode gelap.
- Menyediakan pilihan warna tema.
- Menyimpan mode dan warna tema menggunakan `SharedPreferences`.
- Menangani route yang tidak dikenal dengan halaman 404.
- Mengumpulkan tangkapan layar Beranda, Animasi, Pengaturan, dan halaman detail.
- Menyertakan berkas `main.dart` atau tautan repositori.

## Berkas Implementasi

Implementasi tugas terdapat pada [`lib/tugas/main.dart`](../lib/tugas/main.dart).

## Dependensi

Aplikasi menggunakan paket [`shared_preferences`](https://pub.dev/packages/shared_preferences) untuk menyimpan preferensi mode gelap dan warna tema.

Jika dependensi belum terpasang, jalankan:

```bash
flutter pub get
```

## Cara Menjalankan

Jalankan perintah berikut dari folder `pertemuan6`:

```bash
flutter run -t lib/tugas/main.dart
```

## Hasil Tugas

Aplikasi memiliki beberapa bagian utama:

1. **Beranda** menampilkan daftar Flutter, Musik, Kamera, dan Peta. Setiap item dapat diketuk untuk membuka halaman detail.
2. **Halaman Detail** menampilkan ikon berukuran besar, nama item, dan animasi `Hero`. Halaman dibuka menggunakan route generator dengan transisi fade.
3. **Halaman Animasi** menyediakan empat demo: perubahan bentuk dengan `AnimatedContainer`, pergantian angka dengan `AnimatedSwitcher`, ikon berputar dengan `AnimationController`, dan efek transparansi dengan `AnimatedOpacity`.
4. **Halaman Pengaturan** menyediakan switch mode gelap dan pilihan warna tema indigo, teal, deep orange, atau pink.
5. **Drawer dan NavigationBar** menyediakan dua cara untuk berpindah di antara halaman utama tanpa kehilangan state tab.
6. **Halaman 404** ditampilkan ketika aplikasi menerima nama route yang tidak dikenal dan menyediakan tombol untuk kembali ke Beranda.

Pengaturan tema dikelola melalui `ValueNotifier<ThemeMode>` dan `ValueNotifier<Color>`. Nilainya dimuat saat aplikasi dimulai dan disimpan setiap kali pengguna mengubah mode atau warna tema.

## Daftar Animasi

| Komponen              | Fungsi                                           |
| --------------------- | ------------------------------------------------ |
| `AnimatedContainer`   | Mengubah ukuran, warna, dan radius secara halus. |
| `AnimatedSwitcher`    | Mengubah tampilan angka penghitung.              |
| `AnimationController` | Menjalankan atau menghentikan animasi putar.     |
| `AnimatedOpacity`     | Menampilkan efek fade pada kartu.                |
| `Hero`                | Menghubungkan animasi ikon daftar dan detail.    |

Dokumentasi ini belum menyertakan berkas screenshot karena folder `docs/screenshots` belum tersedia pada proyek. Screenshot dapat ditambahkan setelah aplikasi dijalankan.
