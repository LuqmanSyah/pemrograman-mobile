# TabungKu

TabungKu adalah aplikasi Flutter sederhana untuk mencatat kegiatan harian sekaligus pemasukan dan pengeluaran.

## Fitur

- Tambah, ubah, centang selesai, dan hapus kegiatan.
- Pilihan jenis: tanpa uang, pemasukan, atau pengeluaran.
- Validasi nama dan nominal.
- Penyimpanan SQLite agar data tetap ada setelah aplikasi ditutup.
- Ringkasan pemasukan, pengeluaran, tabungan, dan progres target.
- Laporan berdasarkan tanggal dan pengeluaran per kategori.
- NavigationBar tiga tab: Hari ini, Laporan, dan Pengaturan.
- Mode gelap, target tabungan, dan warna tema tersimpan dengan `shared_preferences`.

## Menjalankan

```bash
flutter pub get
flutter run
```

## Struktur utama

```text
lib/main.dart                       Tema dan named routes
lib/models/kegiatan.dart             Model Kegiatan dan Ringkasan
lib/data/db_helper.dart              SQLite, CRUD, dan query agregasi
lib/state/pengaturan.dart            Tema, warna, dan target
lib/utils/format.dart                Format tanggal dan rupiah
lib/widgets/ringkasan_card.dart      Kartu ringkasan dan progress target
lib/widgets/kegiatan_tile.dart       Baris kegiatan
lib/pages/shell_page.dart            NavigationBar tiga tab
lib/pages/beranda_page.dart          Kegiatan hari ini
lib/pages/form_kegiatan_page.dart    Form tambah/ubah kegiatan
lib/pages/laporan_page.dart          Laporan
lib/pages/pengaturan_page.dart       Pengaturan
test/widget_test.dart
```

## Aturan perhitungan

Tabungan harian dihitung dari semua kegiatan pada tanggal terpilih: total pemasukan dikurangi total pengeluaran. Kegiatan yang belum selesai tetap dihitung sesuai aturan modul.

## Pengujian

```bash
flutter test
flutter analyze
```
