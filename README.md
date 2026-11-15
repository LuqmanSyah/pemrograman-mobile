# Pemrograman Mobile

Tugas mata kuliah **Pemrograman Mobile** menggunakan **Flutter** (Dart).

- **Nama:** Luqman Syahreno
- **NIM:** 20240801016
- **Program Studi:** Teknik Informatika

## Daftar Pertemuan

| Pertemuan | Folder                       | Materi                                                                                 | Dokumentasi                                                                    |
| --------- | ---------------------------- | -------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------ |
| 1         | [`pertemuan1/`](pertemuan1/) | Flutter fundamental, `StatelessWidget`, `StatefulWidget`, `setState`, dan layout dasar | [README](pertemuan1/README.md) · [Tugas](pertemuan1/docs/tugas-pertemuan-1.md) |
| 2         | [`pertemuan2/`](pertemuan2/) | Layout, `ListView`, model data, dan navigasi antarhalaman                              | [README](pertemuan2/README.md) · [Tugas](pertemuan2/docs/tugas-pertemuan-2.md) |
| 3         | [`pertemuan3/`](pertemuan3/) | Form input, validasi, `ChangeNotifier`, dan Provider                                   | [README](pertemuan3/README.md) · [Tugas](pertemuan3/docs/tugas-pertemuan-3.md) |
| 4         | [`pertemuan4/`](pertemuan4/) | Asynchronous, REST API, `FutureBuilder`, dan pengambilan data JSON                     | [README](pertemuan4/README.md) · [Tugas](pertemuan4/docs/tugas-pertemuan-4.md) |
| 5         | [`pertemuan5/`](pertemuan5/) | Penyimpanan lokal, SQLite, CRUD, dan `SharedPreferences`                               | [README](pertemuan5/README.md) · [Tugas](pertemuan5/docs/tugas-pertemuan-5.md) |
| 6         | [`pertemuan6/`](pertemuan6/) | Navigasi, animasi, theming, dan preferensi tema                                        | [README](pertemuan6/README.md) · [Tugas](pertemuan6/docs/tugas-pertemuan-6.md) |
| 7         | [`pertemuan7/`](pertemuan7/) | Mini proyek **TabungKu**: pencatat kegiatan dan tabungan dengan SQLite                 | [README](pertemuan7/README.md) · [Modul](pertemuan7/docs/modul-praktikum-flutter-pertemuan-7.pdf) |
| 8         | [`pertemuan8/`](pertemuan8/) | **TabungKu Cloud**: Docker Compose, MySQL, kerangka FastAPI, dan halaman status server | [README](pertemuan8/README.md) · [Modul](pertemuan8/docs/modul-praktikum-flutter-pertemuan-8.md) |

## Tugas

| Folder | Keterangan | Dokumentasi |
| ------ | ---------- | ----------- |
| [`tugas/tabungku_layout/`](tugas/tabungku_layout/) | Layout layar **Ringkasan Tabungan** TabungKu dengan widget dasar Flutter (tugas minggu 3) | [README](tugas/tabungku_layout/README.md) |

## UTS

Folder [`uts/`](uts/) berisi implementasi aplikasi kasir **Kasirku**
berdasarkan mockup. Aplikasi ini mensimulasikan alur transaksi kasir mulai
dari login, memilih produk, memilih metode pembayaran, pembayaran QRIS, hingga
menampilkan struk transaksi berhasil.

Fitur utama:

- Halaman login kasir.
- Antarmuka keranjang dan daftar produk.
- Pilihan pembayaran tunai dan QRIS.
- Simulasi pembayaran QRIS.
- Ringkasan dan struk transaksi.

Dokumentasi lengkap UTS tersedia di [README UTS](uts/README.md).

## Proyek Akhir

Folder [`project/`](project/) berisi aplikasi **SmartPOS & AI Inventory
Forecaster**: aplikasi kasir Android yang terhubung ke server pusat, dengan
pembayaran QRIS melalui Midtrans, dashboard admin web, dan prediksi kebutuhan
stok.

Dokumentasi:

- [BRD SmartPOS & AI Inventory Forecaster](<project/docs/BRD SmartPOS & AI Inventory Forecaster.md>)
- [PRD SmartPOS & AI Inventory Forecaster](<project/docs/PRD SmartPOS & AI Inventory Forecaster.md>)
- Wireframe dan mockup di [`project/docs/`](project/docs/)

## Struktur Folder

```
pemob/
├── README.md
├── pertemuan1/      # Flutter fundamental dan Kartu Perkenalan
├── pertemuan2/      # Layout, daftar data, navigasi, dan Daftar Kontak
├── pertemuan3/      # Form, validasi, Provider, dan Daftar Belanja
├── pertemuan4/      # Asynchronous, REST API, dan Daftar Postingan
├── pertemuan5/      # SQLite, SharedPreferences, dan Pencatat Pengeluaran
├── pertemuan6/      # Navigasi, animasi, theming, dan preferensi tema
├── pertemuan7/      # Mini proyek TabungKu (SQLite, SharedPreferences)
├── pertemuan8/      # TabungKu Cloud: Docker Compose, MySQL, FastAPI (backend/)
├── tugas/           # Tugas terpisah (TabungKu Layout)
├── uts/             # Implementasi mockup aplikasi kasir Kasirku
└── project/         # Proyek akhir SmartPOS & AI Inventory Forecaster
```

Setiap folder pertemuan memiliki modul pada folder `docs/`, implementasi pada `lib/`, serta dokumentasi tugas masing-masing. Mulai pertemuan 8, folder pertemuan juga berisi `backend/` dan `docker-compose.yml`; cara menjalankannya ada di README pertemuan tersebut.
