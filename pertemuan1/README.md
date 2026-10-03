# Pertemuan 1 - Flutter Fundamental

Praktikum ini membahas pengenalan Flutter, instalasi, struktur proyek, widget dasar, dan pembuatan aplikasi Flutter pertama menggunakan Dart.

## Tujuan Pembelajaran

Setelah menyelesaikan praktikum, mahasiswa diharapkan mampu:

- Menjelaskan Flutter, Dart, dan perbedaannya dengan pengembangan native.
- Memasang serta memverifikasi Flutter SDK, editor, emulator, atau perangkat fisik.
- Membuat dan menjalankan proyek Flutter.
- Memahami struktur folder proyek dan konsep widget.
- Memodifikasi UI sederhana menggunakan hot reload.

## Persiapan

- Laptop dengan RAM minimal 8 GB dan ruang disk minimal 10 GB.
- Flutter SDK versi stabil.
- Android Studio atau VS Code dengan ekstensi Flutter dan Dart.
- Emulator Android atau perangkat Android dengan USB debugging aktif.
- Koneksi internet.

Verifikasi instalasi dengan perintah berikut:

```bash
flutter doctor
flutter doctor --android-licenses
```

## Menjalankan Proyek

Jalankan dari folder `pertemuan1`:

```bash
flutter pub get
flutter run
```

Beberapa bagian praktikum tersedia sebagai entry point terpisah:

| Bagian          | Entry point               | Keterangan                                                   |
| --------------- | ------------------------- | ------------------------------------------------------------ |
| Aplikasi utama  | `lib/main.dart`           | Counter dasar.                                               |
| Praktikum       | `lib/praktikum/main.dart` | Implementasi langkah interaktif pada modul.                  |
| Latihan mandiri | `lib/latihan/main.dart`   | Counter dengan tambah, kurang, reset, dan batas minimum nol. |
| Tugas           | `lib/tugas/main.dart`     | Aplikasi Kartu Perkenalan.                                   |

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
| `lib/praktikum/`   | Implementasi praktikum.              |
| `lib/latihan/`     | Implementasi latihan mandiri.        |
| `lib/tugas/`       | Implementasi tugas Kartu Perkenalan. |
| `pubspec.yaml`     | Konfigurasi proyek dan dependensi.   |
| `android/`, `ios/` | Kode platform native.                |
| `test/`            | Berkas pengujian.                    |

## Konsep Dasar

- **Widget:** elemen penyusun aplikasi Flutter, seperti teks, tombol, dan layout.
- **StatelessWidget:** widget yang tampilannya tidak bergantung pada state yang berubah.
- **StatefulWidget:** widget yang tampilannya dapat berubah berdasarkan state.
- **`setState()`:** memberi tahu Flutter bahwa state berubah sehingga UI diperbarui.
- **Hot reload:** menampilkan perubahan kode tanpa memulai ulang aplikasi secara penuh.

Widget tree dasar pada praktikum:

```text
MaterialApp
└── Scaffold
	├── AppBar
	└── Center
		└── Column
			├── Icon
			├── Text
			└── Text
```

## Dokumentasi Tugas

Penjelasan khusus tugas Kartu Perkenalan tersedia di [docs/tugas-pertemuan-1.md](docs/tugas-pertemuan-1.md).

Modul praktikum lengkap tersedia di [docs/modul-praktikum-flutter-pertemuan-1.pdf](docs/modul-praktikum-flutter-pertemuan-1.pdf).

## Referensi

- [Dokumentasi Flutter](https://docs.flutter.dev/)
- [Dart Language Tour](https://dart.dev/language)
- [Widget Catalog Flutter](https://docs.flutter.dev/ui/widgets)
