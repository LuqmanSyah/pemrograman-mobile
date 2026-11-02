# UTS Pemrograman Mobile

## Identitas

- **Nama:** Luqman Syahreno
- **NIM:** 20240801016

## Deskripsi

Project UTS ini merupakan implementasi aplikasi kasir mobile berdasarkan
mockup yang telah dibuat. Aplikasi diberi nama **Kasirku** dan digunakan untuk
mensimulasikan proses transaksi pada sebuah toko.

Dokumen acuan kebutuhan aplikasi adalah [BRD SmartPOS & AI Inventory
Forecaster](docs/BRD%20SmartPOS%20%26%20AI%20Inventory%20Forecaster.md) dan
[PRD SmartPOS & AI Inventory Forecaster](docs/PRD%20SmartPOS%20%26%20AI%20Inventory%20Forecaster.md).

Implementasi dibuat menggunakan Flutter dengan beberapa layar utama yang
saling terhubung:

1. **Login** - halaman masuk kasir.
2. **Antarmuka kasir** - menampilkan pencarian produk dan keranjang belanja.
3. **Pemindai produk** - simulasi pemindaian atau pencarian barcode produk.
4. **Metode pembayaran** - pilihan pembayaran tunai atau QRIS.
5. **Pembayaran QRIS** - menampilkan kode QR dan status menunggu pembayaran.
6. **Transaksi berhasil** - menampilkan ringkasan dan struk pembayaran.

## Pemetaan Alur Mockup dan Wireframe

Mockup dan wireframe UTS mengambil alur **Aplikasi POS** pada PRD, yaitu
alur kasir dari login sampai transaksi selesai. Urutan layar yang
diimplementasikan adalah:

| Urutan | Layar pada PRD | Implementasi mockup/wireframe |
| ------ | -------------- | ----------------------------- |
| 1 | P1 Login | Login |
| 2 | P2 Kasir | Antarmuka Kasir |
| 3 | P3 Pemindai | Pemindaian Produk |
| 4 | P4 Pembayaran | Pilih Metode Bayar |
| 5 | P5 QRIS | Scan QRIS & Menunggu |
| 6 | P6 Struk | Transaksi Berhasil |

Dengan demikian, alur utama yang digunakan adalah **Alur B: Pembayaran
QRIS** pada PRD, dengan alur pendukung login, memasukkan produk ke keranjang,
memilih metode pembayaran, dan menampilkan struk. Layar **P3 Pemindai**
sekarang juga tersedia sebagai bagian dari rangkaian mockup dan wireframe
yang diimplementasikan pada UTS.

Dalam roadmap BRD, implementasi ini termasuk **tahap 2: Aplikasi POS**.
Bagian pembayaran QRIS dan status pembayaran terkait dengan **tahap 3:
Integrasi Midtrans**. Integrasi pada project ini masih berupa simulasi untuk
keperluan demonstrasi antarmuka dan alur transaksi.

## Desain Figma

**Wireframe & Mockup:** [Buka desain di Figma](https://www.figma.com/design/800oScXUv6ye8LN1gbOl8c/Pemmob?t=kGx3eEqawHOClFxc-1)

## Fitur

- Tampilan antarmuka mengikuti desain mockup.
- Navigasi antarhalaman transaksi.
- Daftar produk dan total pembayaran.
- Pemindaian produk melalui simulasi kamera atau input barcode.
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
│   ├── receipt_screen.dart
│   └── scanner_screen.dart
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
