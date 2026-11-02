# UTS Pemrograman Mobile

## Identitas

- **Nama:** Luqman Syahreno
- **NIM:** 20240801016

## Deskripsi

Project UTS ini merupakan implementasi aplikasi kasir mobile berdasarkan
mockup yang telah dibuat. Aplikasi diberi nama **Kasirku** dan digunakan untuk
mensimulasikan proses transaksi pada sebuah toko.

Implementasi dibuat menggunakan Flutter dengan beberapa layar utama yang
saling terhubung:

1. **Login** - halaman masuk kasir.
2. **Antarmuka kasir** - menampilkan pencarian produk dan keranjang belanja.
3. **Metode pembayaran** - pilihan pembayaran tunai atau QRIS.
4. **Pembayaran QRIS** - menampilkan kode QR dan status menunggu pembayaran.
5. **Transaksi berhasil** - menampilkan ringkasan dan struk pembayaran.

## Fitur

- Tampilan antarmuka mengikuti desain mockup.
- Navigasi antarhalaman transaksi.
- Daftar produk dan total pembayaran.
- Pilihan metode pembayaran tunai dan QRIS.
- Simulasi pembayaran QRIS berhasil.
- Tampilan struk transaksi.
- Tombol untuk membatalkan transaksi dan memulai transaksi baru.

## Struktur Utama

```text
lib/
├── main.dart
├── models/
│   └── product.dart
├── screens/
│   ├── cashier_screen.dart
│   ├── login_screen.dart
│   ├── payment_screen.dart
│   ├── qr_screen.dart
│   └── receipt_screen.dart
├── theme/
│   └── app_theme.dart
└── widgets/
    ├── pos_widgets.dart
    └── qr_code.dart
```

## Cara Menjalankan

Pastikan Flutter sudah terpasang, kemudian jalankan perintah berikut dari
folder `uts`:

```bash
flutter pub get
flutter run
```

Untuk menjalankan pengujian:

```bash
flutter test
```
