# Product Requirements Document (PRD)

**Produk:** SmartPOS & AI Inventory Forecaster **Versi:** 1.0 **Status:** Draft untuk penilaian dosen pengampu **Dasar:** BRD SmartPOS & AI Inventory Forecaster v1.3

> Catatan: PRD ini menurunkan kebutuhan di BRD menjadi spesifikasi produk: user story, kriteria penerimaan, alur layar, alur data, dan antarmuka. Skenario Toko Maju Jaya, persona, dan seluruh angka bersifat fiktif atau hipotetis. Penanda **\[Usulan\]** berarti nilai asumsi yang dapat diubah.

## Riwayat Versi

| Versi | Tanggal | Penulis | Perubahan |
| --- | --- | --- | --- |
| 1.0 | 25 Okt 2026 | Reno | Draft awal PRD berdasarkan BRD v1.3 |

## 1. Ringkasan Produk

### 1.1 Visi

SmartPOS adalah aplikasi kasir Android yang terhubung ke server pusat, dilengkapi pembayaran QRIS melalui Midtrans, dashboard admin berbasis web, dan layanan prediksi kebutuhan stok. Tujuannya membantu toko kecil mencatat penjualan dengan cepat dan tahu kapan harus memesan ulang barang sebelum kehabisan.

### 1.2 Masalah yang Diselesaikan

Berdasarkan skenario Toko Maju Jaya (BRD bagian 2): barang laris sering habis (P1), barang lambat laku menumpuk (P2), pembayaran QRIS diverifikasi manual (P3), data transaksi dan stok tidak terpusat (P4), dan pemilik tidak dapat memantau penjualan dari jauh (P5).

### 1.3 Keputusan Produk

| Keputusan | Pilihan rilis ini |
| --- | --- |
| Platform | Android (Flutter) dan dashboard web (Laravel dengan Filament) |
| Konektivitas | Online-only. Aplikasi mobile memerlukan internet |
| Pembayaran | Tunai dan QRIS melalui Midtrans (mode sandbox) |
| Skala | 1 toko, hingga 3 perangkat, sekitar 1.000 produk, 500 transaksi per hari |
| Analitik | Prediksi permintaan dan peringatan stok menipis. Rekomendasi bundling ditunda |

## 2. Tujuan Produk dan Metrik

| Tujuan produk | Metrik | Target | Asal BRD |
| --- | --- | --- | --- |
| Pembayaran digital terverifikasi otomatis | Persentase transaksi QRIS yang terverifikasi otomatis | ≥ 95% pada pengujian sandbox | BG-01 |
| Kasir cepat | Waktu dari scan terakhir sampai transaksi tunai tersimpan | ≤ 2 detik | BG-02 |
| Stok tidak sering habis | Stockout produk *fast-moving* per bulan | 10 menjadi ≤ 6 (−40%) | BG-03 |
| Status bayar cepat | Waktu dari pelanggan membayar sampai lunas di aplikasi | ≤ 10 detik | BG-04 |
| Data terpusat | Transaksi dan mutasi stok tercatat di sistem | ≥ 99% | BG-05 |
| Prediksi cukup akurat | WAPE pada produk *fast-moving* | ≤ 30% pada dataset uji | BG-06 |

Catatan: BG-03 pada rilis ini hanya dapat dibuktikan lewat simulasi stok (bagian 14), bukan pengukuran di toko nyata.

## 3. Persona dan Perjalanan Pengguna

| Persona | Peran di sistem | Tujuan | Frustrasi saat ini |
| --- | --- | --- | --- |
| Rina (22) dan Andi (24) | Kasir (aplikasi POS) | Melayani antrean cepat, scan barang, terima tunai dan QRIS | Verifikasi QRIS manual lambat, antrean panjang |
| Pak Dedi (35) | Admin (dashboard) | Mengelola produk, mencatat barang masuk, menyesuaikan stok, membaca prediksi | Selisih stok sistem dan fisik, input data dua kali |
| Bu Maya (48) | Pemilik, memakai akun Admin | Memantau penjualan dan tahu kapan harus restock | Barang laris kehabisan, modal tertahan di barang tidak laku |

**Perjalanan singkat:**

1. **Kasir:** login, scan barang, pilih tunai atau QRIS, pelanggan membayar, struk muncul, stok berkurang otomatis.
2. **Admin:** barang datang dari pemasok, admin mencatat barang masuk. Pada akhir minggu admin mencocokkan stok fisik lewat penyesuaian stok.
3. **Pemilik:** membuka dashboard, melihat daftar produk yang stoknya di bawah batas pesan ulang beserta perkiraan hari bertahan, lalu memutuskan restock.

## 4. Ruang Lingkup Rilis

**Termasuk (Must):** login dan hak akses dua peran, keranjang dan scan barcode, pembayaran tunai, pembayaran QRIS (Midtrans sandbox), pratinjau struk, CRUD produk dan pengguna, mutasi stok dengan kartu stok, laporan transaksi dengan ekspor CSV, prediksi permintaan, *reorder point*, peringatan stok menipis, dan metode cadangan untuk produk baru.

**Tidak termasuk:** akun produksi Midtrans dan uang sungguhan, mode offline-first, akuntansi lanjutan, logistik, program loyalitas, integrasi e-commerce, dan iOS.

**Pengembangan lanjutan (Should dan Could):** lihat bagian 16.

## 5. Arsitektur Produk

| Komponen | Teknologi | Tanggung jawab |
| --- | --- | --- |
| Aplikasi POS | Flutter (Android) | Antarmuka kasir, kamera barcode, menampilkan QR, pratinjau struk. Hanya berbicara dengan Laravel |
| Core Backend dan Dashboard | Laravel, Filament, Sanctum | REST API, autentikasi, peran, logika stok, integrasi Midtrans, dashboard admin |
| Layanan Analitik | FastAPI (Python) | Menyajikan hasil prediksi dan peringatan stok lewat REST API |
| Pekerjaan batch ML | Skrip Python (terjadwal harian) | Membaca transaksi, menghitung fitur, menjalankan model, menyimpan hasil ke tabel |
| Basis data | PostgreSQL | Sumber kebenaran data |
| Pembayaran | Midtrans (sandbox) | Membuat pembayaran QRIS dan mengirim notifikasi (*webhook*) |

**Alur data:**

1. Aplikasi POS memanggil Laravel (token Sanctum).
2. Laravel menyimpan data ke PostgreSQL dan memanggil Midtrans untuk pembayaran QRIS.
3. Midtrans mengirim webhook ke Laravel, yang memperbarui status pembayaran dan stok.
4. Skrip batch membaca PostgreSQL dan menulis hasil prediksi serta peringatan ke tabel khusus.
5. Laravel memanggil FastAPI (API key) untuk menampilkan prediksi di dashboard.

## 6. Spesifikasi Fitur

Prioritas: **M** (Must, ada di rilis ini), **S** (Should), **C** (Could). ID mengikuti BRD.

### 6.1 Aplikasi POS (Flutter)

| ID | User story | Kriteria penerimaan | Prioritas |
| --- | --- | --- | --- |
| FR-POS-01 | Sebagai kasir, saya ingin login dengan akun dari admin agar transaksi tercatat atas nama saya. | Login berhasil dengan kredensial benar. Kredensial salah menampilkan pesan. Sesi tersimpan selama token berlaku. Akun nonaktif tidak bisa login. | M |
| FR-POS-02 | Sebagai kasir, saya ingin menambah produk lewat scan barcode atau pencarian agar input cepat. | Scan menambahkan produk ke keranjang dalam ≤ 1 detik pada pencahayaan normal **\[Usulan\]**. Pencarian cocok nama atau SKU. Barcode tidak dikenal menampilkan pesan. Produk berstok 0 ditandai dan tidak bisa ditambahkan. | M |
| FR-POS-03 | Sebagai kasir, saya ingin mengubah jumlah atau menghapus item agar salah input bisa dikoreksi. | Total berubah seketika. Jumlah minimal 1. Jumlah melebihi stok ditolak dengan peringatan (BR-06). | M |
| FR-POS-04 | Sebagai kasir, saya ingin transaksi tersimpan di server agar stok dan laporan selalu benar. | Transaksi dikirim dengan ID unik (*idempotency key*). Ketukan ganda atau pengiriman ulang tidak menggandakan transaksi. Kegagalan menampilkan pesan dan keranjang tetap ada. | M |
| FR-POS-05 | Sebagai kasir, saya ingin menerima pembayaran tunai dan melihat kembalian. | Kasir memasukkan uang diterima. Kembalian dihitung otomatis. Uang kurang ditolak. Transaksi tersimpan berstatus lunas. | M |
| FR-POS-06 | Sebagai kasir, saya ingin menerima pembayaran QRIS agar pelanggan bisa membayar nontunai tanpa saya cek manual. | Kode QR tampil ≤ 5 detik. Status berubah lunas otomatis ≤ 10 detik setelah notifikasi diterima. Gagal atau kedaluwarsa membatalkan transaksi tanpa mengurangi stok. Kasir dapat membatalkan dan beralih ke tunai. | M |
| FR-POS-07 | Sebagai kasir, saya ingin melihat struk agar bisa ditunjukkan ke pelanggan. | Pratinjau memuat nama toko, tanggal, kasir, item, total, metode bayar, dan kembalian. Dapat disimpan sebagai PDF atau dibagikan. | M |
| FR-POS-08 | Sebagai kasir, saya ingin tahu saat koneksi terputus agar tidak salah mengira transaksi tersimpan. | Banner koneksi muncul. Tombol bayar nonaktif. Keranjang tidak hilang. Aplikasi pulih otomatis saat koneksi kembali. | M |

### 6.2 Dashboard Admin (Laravel dengan Filament)

| ID | User story | Kriteria penerimaan | Prioritas |
| --- | --- | --- | --- |
| FR-ADM-01 | Sebagai admin, saya ingin mengelola produk, kategori, dan pengguna agar data master selalu terbaru. | SKU dan barcode unik. Harga dan HPP tidak negatif. Produk yang sudah punya transaksi dinonaktifkan, bukan dihapus. | M |
| FR-ADM-02 | Sebagai pemilik, saya ingin kasir hanya memakai aplikasi POS agar data sensitif aman. | Kasir tidak dapat login ke dashboard. Endpoint admin menolak token kasir. | M |
| FR-ADM-03 | Sebagai admin, saya ingin melihat dan mengekspor laporan transaksi. | Filter tanggal, kasir, dan metode pembayaran. Tabel berpaginasi. Ekspor CSV sesuai filter. | M |
| FR-ADM-04 | Sebagai admin, saya ingin stok berkurang otomatis agar tidak input dua kali. | Transaksi tunai mengurangi stok saat tersimpan. Transaksi QRIS mengurangi stok saat lunas. Stok tidak pernah negatif. | M |
| FR-ADM-05 | Sebagai admin, saya ingin mencatat barang masuk dan penyesuaian stok. | Barang masuk menambah stok dan dapat memperbarui HPP. Penyesuaian memakai stok fisik dan menghitung selisih. Alasan wajib. Keduanya tercatat di riwayat. | M |
| FR-ADM-06 | Sebagai admin, saya ingin melihat kartu stok per produk untuk menelusuri selisih. | Menampilkan tanggal, tipe (penjualan, masuk, penyesuaian), jumlah, saldo, dan pelaku. Saldo akhir sama dengan stok saat ini. | M |
| FR-ADM-07 | Sebagai admin, saya ingin melihat status pembayaran Midtrans agar bisa menelusuri transaksi QRIS bermasalah. | Daftar order dengan status dan waktu. Log notifikasi mencatat validitas tanda tangan. Dapat difilter per status. | M |

### 6.3 Analitik Stok (FastAPI dan batch ML)

| ID | User story | Kriteria penerimaan | Prioritas |
| --- | --- | --- | --- |
| FR-AI-01 | Sebagai admin, saya ingin melihat prediksi permintaan 7 sampai 14 hari agar tahu kebutuhan stok. | Halaman dimuat ≤ 3 detik. Menampilkan riwayat dan proyeksi per produk beserta waktu pembaruan terakhir. Hasil dihitung ulang minimal harian. | M |
| FR-AI-02 | Sebagai pemilik, saya ingin diperingatkan saat stok di bawah batas pesan ulang. | Rumus ada di bagian 9. Daftar diurutkan dari paling kritis dan menampilkan stok saat ini, batas pesan ulang, dan perkiraan hari bertahan. | M |
| FR-AI-03 | Sebagai admin, saya ingin produk baru tetap punya perkiraan sederhana. | Produk dengan data kurang dari 4 minggu memakai rata-rata bergerak dan diberi tanda “prediksi belum andal”. | M |

## 7. Alur Layar

**Aplikasi POS**

| Layar | Isi utama | Terkait |
| --- | --- | --- |
| P1 Login | Kolom akun dan kata sandi, pesan kesalahan | FR-POS-01 |
| P2 Kasir | Kolom pencarian, tombol scan, daftar keranjang, total, tombol Bayar, banner koneksi | FR-POS-02, 03, 08 |
| P3 Pemindai | Pratinjau kamera, penanda barcode terbaca | FR-POS-02 |
| P4 Pembayaran | Pilihan Tunai atau QRIS, input uang diterima, kembalian | FR-POS-05 |
| P5 QRIS | Kode QR, hitung mundur kedaluwarsa, status, tombol Batal | FR-POS-06 |
| P6 Struk | Pratinjau struk, tombol Simpan PDF dan Bagikan, tombol Transaksi Baru | FR-POS-07 |

**Dashboard Admin**

| Layar | Isi utama | Terkait |
| --- | --- | --- |
| D1 Login | Akun dan kata sandi | FR-ADM-02 |
| D2 Beranda | Jumlah transaksi hari ini dan daftar peringatan stok menipis | FR-AI-02 |
| D3 Produk dan Kategori | Tabel, formulir tambah dan ubah | FR-ADM-01 |
| D4 Pengguna | Daftar admin dan kasir, aktif atau nonaktif | FR-ADM-01, 02 |
| D5 Mutasi Stok | Formulir barang masuk dan penyesuaian, kartu stok per produk | FR-ADM-05, 06 |
| D6 Transaksi | Tabel dengan filter dan tombol Ekspor CSV | FR-ADM-03 |
| D7 Pembayaran Midtrans | Daftar order, status, log notifikasi | FR-ADM-07 |
| D8 Prediksi dan Peringatan | Grafik riwayat dan proyeksi, tabel peringatan, tanda prediksi belum andal | FR-AI-01, 02, 03 |

## 8. Alur Utama

**A. Pembayaran tunai**

1. Kasir menambah produk ke keranjang, lalu menekan Bayar dan memilih Tunai.
2. Kasir mengisi uang diterima, aplikasi menghitung kembalian.
3. Aplikasi mengirim transaksi ke server dengan ID unik.
4. Server memeriksa stok, menyimpan transaksi, mengurangi stok, dan mencatat mutasi.
5. Aplikasi menampilkan struk.

**B. Pembayaran QRIS**

1. Kasir memilih QRIS. Aplikasi membuat transaksi berstatus menunggu.
2. Server membuat pembayaran QRIS ke Midtrans dan mengembalikan kode QR.
3. Aplikasi menampilkan QR dan memeriksa status ke server secara berkala.
4. Pelanggan membayar. Midtrans mengirim webhook ke server.
5. Server memverifikasi tanda tangan, mengubah status menjadi lunas, mengurangi stok, dan mencatat mutasi.
6. Aplikasi melihat status lunas dan menampilkan struk.
7. Jika QR kedaluwarsa atau pembayaran gagal, transaksi dibatalkan dan stok tidak berubah.

**C. Koneksi terputus**

1. Aplikasi mendeteksi koneksi hilang dan menampilkan banner.
2. Tombol Bayar nonaktif, keranjang tetap tersimpan di layar.
3. Saat koneksi kembali, banner hilang dan tombol Bayar aktif lagi.

**D. Barang masuk dan penyesuaian stok**

1. Admin memilih produk, mengisi jumlah (dan HPP baru bila ada).
2. Server menambah stok dan mencatat mutasi bertipe masuk.
3. Untuk penyesuaian, admin mengisi stok fisik dan alasan. Server menghitung selisih dan mencatat mutasi bertipe penyesuaian.

**E. Prediksi harian**

1. Skrip batch berjalan terjadwal, membaca transaksi 28 hari terakhir ke atas.
2. Skrip menghitung fitur, menjalankan model (atau rata-rata bergerak untuk produk baru), lalu menyimpan prediksi dan peringatan.
3. Dashboard memanggil FastAPI untuk menampilkan hasil tersimpan.

## 9. Aturan Bisnis dan Perhitungan

| ID | Aturan |
| --- | --- |
| BR-01 | Server pusat adalah sumber kebenaran stok. Stok hanya berubah saat transaksi dinyatakan berhasil oleh server. |
| BR-02 | Transaksi tidak dapat diproses tanpa koneksi ke server. |
| BR-03 | Setiap transaksi memiliki ID unik. Pengiriman ulang tidak menggandakan transaksi maupun pengurangan stok. |
| BR-04 | Transaksi QRIS lunas hanya setelah server menerima notifikasi sukses dari Midtrans. |
| BR-05 | Pembayaran QRIS gagal atau kedaluwarsa tidak mengurangi stok. |
| BR-06 | Stok tidak boleh negatif. Penjualan melebihi stok ditolak dengan peringatan. |
| BR-07 | Penyesuaian stok manual wajib menyertakan alasan dan pelaku. |

**Perhitungan:**

- **Reorder point** = (rata-rata permintaan harian prediksi × lead time) + stok pengaman. Nilai awal: lead time 3 hari dan stok pengaman setara 2 hari permintaan rata-rata **\[Usulan\]**.
- **Perkiraan hari bertahan** = stok saat ini dibagi rata-rata permintaan harian prediksi.
- **Produk *fast-moving*:** 20% teratas berdasarkan volume penjualan 30 hari terakhir.
- **Metode cadangan:** rata-rata bergerak 7 atau 28 hari bila riwayat produk kurang dari 28 hari.
- **WAPE** = total selisih absolut prediksi dan aktual dibagi total aktual.

## 10. Model Data (tingkat tinggi)

| Entitas | Kolom utama | Catatan |
| --- | --- | --- |
| users | id, nama, email, kata sandi (hash), peran (admin atau kasir), aktif | Dua peran |
| categories | id, nama |  |
| products | id, sku, barcode, nama, category\_id, satuan, harga, hpp, stok, aktif | SKU dan barcode unik |
| transactions | id, idempotency\_key, cashier\_id, total, metode (tunai atau qris), status (pending, paid, failed, expired, cancelled), waktu bayar | idempotency\_key unik |
| transaction\_items | id, transaction\_id, product\_id, jumlah, harga, hpp\_saat\_transaksi |  |
| stock\_movements | id, product\_id, tipe (sale, in, adjustment), perubahan, saldo\_setelah, alasan, user\_id, transaction\_id | Dasar kartu stok |
| payments | id, transaction\_id, order\_id, midtrans\_transaction\_id, jumlah, status, kode QR, kedaluwarsa | order\_id unik |
| payment\_notifications | id, order\_id, payload, signature\_valid, waktu terima | Log audit webhook |
| forecasts | id, product\_id, tanggal, horizon, prediksi, metode (model atau rata-rata bergerak), dibuat\_pada | Ditulis oleh skrip batch |
| stock\_alerts | id, product\_id, stok, reorder\_point, hari\_bertahan, andal (ya atau tidak), dibuat\_pada | Ditulis oleh skrip batch |

## 11. Antarmuka API (draf)

**Laravel (untuk aplikasi POS)**

| Metode | Endpoint | Fungsi | Akses |
| --- | --- | --- | --- |
| POST | /api/auth/login | Login, mengembalikan token | Publik |
| POST | /api/auth/logout | Mencabut token | Kasir |
| GET | /api/products?search= | Cari produk | Kasir |
| GET | /api/products/barcode/{kode} | Cari produk dari barcode | Kasir |
| POST | /api/transactions | Buat transaksi (item, metode, idempotency\_key, uang diterima). Untuk QRIS mengembalikan transaksi menunggu dan kode QR | Kasir |
| GET | /api/transactions/{id} | Status transaksi (dipakai untuk memeriksa status QRIS) | Kasir |
| POST | /api/transactions/{id}/cancel | Membatalkan transaksi yang masih menunggu | Kasir |
| POST | /api/webhooks/midtrans | Menerima notifikasi pembayaran | Publik, diverifikasi tanda tangan |

**FastAPI (hanya dipanggil Laravel, header X-API-Key)**

| Metode | Endpoint | Fungsi |
| --- | --- | --- |
| GET | /forecasts/{product\_id} | Riwayat dan proyeksi permintaan |
| GET | /alerts/low-stock | Daftar produk di bawah reorder point |
| GET | /health | Pemeriksaan layanan |

## 12. Integrasi Midtrans (sandbox)

- Laravel membuat pembayaran QRIS lewat Core API Midtrans dan menyimpan order\_id unik per transaksi. Aplikasi mobile tidak pernah memegang kunci Midtrans.
- Notifikasi diterima di /api/webhooks/midtrans. Server menghitung tanda tangan SHA-512 dari order\_id, status\_code, gross\_amount, dan server key, lalu membandingkannya dengan *signature\_key* di notifikasi. Notifikasi dengan tanda tangan tidak valid ditolak dan dicatat.
- Notifikasi yang sama boleh datang lebih dari sekali. Pemrosesan berdasarkan order\_id harus idempoten.
- Selama pengembangan, webhook diarahkan ke URL publik sementara (tunnel). Pengujian memakai simulator pembayaran di sandbox.
- Batas waktu QR default 15 menit **\[Usulan\]**.

| Status Midtrans | Status transaksi | Tindakan |
| --- | --- | --- |
| pending | pending | Tunggu pembayaran |
| settlement | paid | Tandai lunas, kurangi stok, catat mutasi |
| expire | expired | Batalkan, stok tidak berubah |
| cancel atau deny | failed | Batalkan, stok tidak berubah |

Detail parameter dan nilai status mengikuti dokumentasi resmi Midtrans saat implementasi.

## 13. Persyaratan Non-Fungsional

| ID BRD | Kebutuhan | Cara pemenuhan di produk |
| --- | --- | --- |
| NFR-01 | Tidak menutup paksa saat tidak ada koneksi | Banner koneksi dan keranjang tetap di memori aplikasi |
| NFR-03 | Tambah ke keranjang ≤ 500 ms, simpan transaksi tunai ≤ 2 detik | Respons API ringan dan indeks pada barcode dan SKU |
| NFR-04 | Halaman prediksi ≤ 3 detik | Hasil prediksi dihitung terjadwal, bukan saat halaman dibuka |
| NFR-05 | QR ≤ 5 detik, status lunas ≤ 10 detik | Pemeriksaan status berkala ke server setiap beberapa detik |
| NFR-07 | Keamanan akses | Token Sanctum, API key untuk FastAPI, verifikasi tanda tangan Midtrans |
| NFR-08 | Keamanan data | HTTPS/TLS, kata sandi di-hash, kunci Midtrans hanya di server |
| NFR-11 | Kompatibilitas | Android 8.0 ke atas dan browser modern untuk dashboard |
| NFR-13 | Keandalan pembayaran | Pemrosesan webhook idempoten berdasarkan order\_id |

NFR lain di BRD (ketersediaan server, backup, kepatuhan data, observabilitas) dicatat sebagai pertimbangan desain dan tidak diuji formal pada rilis ini.

## 14. Rencana Pengujian

| ID | Skenario | Hasil yang diharapkan | Terkait |
| --- | --- | --- | --- |
| T-01 | Login dengan akun benar, salah, dan nonaktif | Berhasil, ditolak dengan pesan, ditolak | FR-POS-01 |
| T-02 | Scan barcode dikenal dan tidak dikenal | Produk masuk keranjang, pesan kesalahan | FR-POS-02 |
| T-03 | Menambah jumlah melebihi stok | Ditolak dengan peringatan | FR-POS-03, BR-06 |
| T-04 | Bayar tunai dengan uang pas, lebih, dan kurang | Kembalian benar, uang kurang ditolak | FR-POS-05 |
| T-05 | Kirim transaksi yang sama dua kali | Hanya satu transaksi dan satu pengurangan stok | FR-POS-04, BR-03 |
| T-06 | QRIS berhasil di simulator sandbox | Status lunas ≤ 10 detik, stok berkurang | FR-POS-06, BR-04 |
| T-07 | QRIS kedaluwarsa dan gagal | Transaksi batal, stok tetap | BR-05 |
| T-08 | Webhook dikirim dua kali | Tidak ada pencatatan atau pengurangan ganda | NFR-13 |
| T-09 | Webhook dengan tanda tangan salah | Ditolak dan dicatat | NFR-07 |
| T-10 | Matikan internet saat di layar Kasir | Banner muncul, keranjang utuh, pulih saat kembali | FR-POS-08 |
| T-11 | Barang masuk dan penyesuaian stok | Stok dan kartu stok sesuai, alasan wajib | FR-ADM-05, 06 |
| T-12 | Ekspor laporan dengan filter | CSV sesuai filter | FR-ADM-03 |
| T-13 | Akun kasir membuka dashboard | Ditolak | FR-ADM-02 |
| T-14 | Halaman prediksi dengan data uji | Dimuat ≤ 3 detik | FR-AI-01 |
| T-15 | Produk di bawah reorder point dan produk baru | Muncul di peringatan, produk baru bertanda belum andal | FR-AI-02, 03 |
| T-16 | Evaluasi model pada data uji | WAPE dilaporkan dan dibandingkan dengan baseline | BG-06 |
| T-17 | Simulasi stok kebijakan mingguan versus reorder point | Jumlah stockout dibandingkan, dilaporkan sebagai hasil simulasi | BG-03 |

## 15. Asumsi, Risiko, dan Dependensi

**Asumsi:** perangkat Android punya kamera dan internet (Wi-Fi toko) selama dipakai. Produk punya barcode terbaca. Data historis berasal dari data sintetis atau dataset publik. Midtrans memakai sandbox. Struk berupa pratinjau layar atau PDF.

**Risiko utama:** integrasi Midtrans bermasalah (webhook tidak sampai, URL publik berubah), akurasi model di bawah target, data stok awal tidak konsisten, dan waktu pengerjaan terbatas oleh satu orang. Mitigasi lengkap ada di BRD bagian 10.

**Dependensi:** akun sandbox Midtrans, URL publik sementara untuk webhook, perangkat Android untuk pengujian, dan dataset untuk melatih model.

## 16. Pengembangan Lanjutan

- Mode offline-first: basis data lokal, antrean transaksi, sinkronisasi dua arah, dan penanganan konflik stok.
- Rekomendasi bundling (*Market Basket Analysis*, FR-AI-05 dan FR-AI-06) dan penerapan promo bundle di kasir.
- Cetak struk ke *thermal printer* via Bluetooth (FR-POS-12).
- Void dan retur (FR-POS-09), shift dan tutup kas (FR-POS-10), diskon manual (FR-POS-11), PPN (FR-POS-13).
- Laporan stok dan laba kotor (FR-ADM-08), impor CSV (FR-ADM-09), parameter stok per produk (FR-ADM-10), banyak toko (FR-ADM-11), log audit (FR-ADM-12).
- Tampilan metrik akurasi di dashboard (FR-AI-04), notifikasi email (FR-AI-07), retraining otomatis dan pemantauan *drift* (FR-AI-08).
- Metode pembayaran digital lain, akun produksi Midtrans, dan otentikasi berlapis (MFA).
