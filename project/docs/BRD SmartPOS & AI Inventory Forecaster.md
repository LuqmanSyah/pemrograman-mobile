# Business Requirements Document (BRD)

**Proyek:** SmartPOS & AI Inventory Forecaster **Versi:** 1.3 (studi kasus, online-only) **Status:** Draft untuk penilaian dosen pengampu

> **Catatan studi kasus:** Dokumen ini ditulis untuk tugas mata kuliah dengan skenario dan persona fiktif (Toko Maju Jaya). Seluruh angka dan kondisi usaha bersifat hipotetis. Penanda **\[Usulan\]** berarti nilai asumsi yang ditetapkan penulis untuk studi kasus ini dan dapat diubah.

## Riwayat Versi

| Versi | Tanggal | Penulis | Perubahan |
| --- | --- | --- | --- |
| 1.0 | - | Reno | Draft awal |
| 1.1 | 24 Okt 2026 | Reno | Penambahan stakeholder, metrik sukses, ID dan prioritas kebutuhan, risiko, timeline, kriteria penerimaan, keputusan teknologi (Flutter, Laravel, FastAPI) |
| 1.2 | 24 Okt 2026 | Reno | Skenario fiktif Toko Maju Jaya, persona, baseline hipotetis, pemangkasan ruang lingkup ke MVP, penyesuaian asumsi dan kriteria penerimaan |
| 1.3 | 25 Okt 2026 | Reno | Perubahan ke online-only, penambahan integrasi Midtrans (sandbox), pemindahan offline-first dan bundling ke pengembangan lanjutan |

## 1. Ringkasan Eksekutif

SmartPOS & AI Inventory Forecaster adalah sistem yang memadukan aplikasi *Point of Sale* (POS) mobile dengan pembayaran digital dan analitik prediktif berbasis *Machine Learning*. Sistem ditujukan bagi UMKM dan perusahaan dagang ritel yang kesulitan mengelola stok: barang menumpuk menjadi *dead stock* di satu sisi, sementara barang laris sering kehabisan (*stockout*) di sisi lain.

Sistem menyediakan tiga kemampuan utama:

1. Transaksi kasir yang cepat dengan scan barcode, pembayaran tunai, dan pembayaran QRIS melalui Midtrans.
2. Pengelolaan data master, stok, dan laporan melalui dashboard web.
3. Peringatan stok cerdas: prediksi kebutuhan stok (*demand forecasting*) dan peringatan otomatis saat stok menipis.

### 1.1 Konteks Studi Kasus

Seluruh kebutuhan di dokumen ini disusun untuk satu skenario fiktif, **Toko Maju Jaya**, agar kebutuhan bisa dinilai terhadap masalah yang konkret.

- **Profil usaha:** toko kelontong dan sembako dengan 1 toko fisik, sekitar 450 jenis produk, dan 2 kasir. Rata-rata 250 transaksi per hari.
- **Cara kerja saat ini:** kasir memakai aplikasi kasir sederhana di tablet tanpa pembayaran digital terintegrasi, sedangkan stok dicatat manual di buku dan Excel oleh admin.
- **Sumber data pengembangan:** data transaksi Toko Maju Jaya tidak nyata, sehingga model dilatih dan diuji dengan data sintetis hasil simulasi dan atau dataset publik yang mewakilinya, yaitu *Rossmann Store Sales* atau *M5 Forecasting* (Walmart) untuk peramalan permintaan.
- **Keterbatasan:** nilai akurasi model dan KPI di dokumen ini bersifat demonstrasi dan tidak boleh dibaca sebagai hasil di usaha nyata.

**Keputusan rilis:** agar tetap realistis untuk dikerjakan satu orang, rilis ini dirancang **online-only**, yaitu aplikasi mobile memerlukan koneksi internet. Mode offline-first dan rekomendasi bundling dicatat sebagai pengembangan lanjutan (bagian 5.3). Pembayaran QRIS memakai Midtrans dalam mode sandbox.

## 2. Latar Belakang dan Permasalahan

### 2.1 Kondisi Saat Ini (As-Is)

Toko Maju Jaya (fiktif) memakai aplikasi kasir sederhana tanpa pembayaran digital terintegrasi, sehingga pembayaran QRIS harus diperiksa manual oleh kasir lewat ponsel pemilik. Stok dihitung manual oleh admin seminggu sekali di Excel, dan keputusan memesan ulang barang bergantung pada ingatan dan perkiraan pemilik. Tidak ada prediksi kebutuhan stok.

### 2.2 Masalah Utama

| # | Masalah | Dampak Bisnis | Data Pendukung (hipotetis) |
| --- | --- | --- | --- |
| P1 | Stok barang laris habis sebelum sempat dipesan ulang | Kehilangan penjualan dan pelanggan | Rata-rata 10 kejadian stockout produk fast-moving per bulan |
| P2 | Barang lambat laku menumpuk | Modal tertahan, risiko rusak atau kedaluwarsa | Sekitar 15% nilai persediaan berupa dead stock |
| P3 | Pembayaran QRIS diverifikasi manual | Antrean lambat dan risiko salah verifikasi | Sekitar 30% transaksi memakai QRIS, verifikasi manual sekitar 45 detik |
| P4 | Data transaksi dan stok tidak terpusat | Keputusan stok berdasarkan perkiraan, bukan data | Stok dihitung manual seminggu sekali |
| P5 | Pemilik tidak dapat memantau penjualan dari jauh | Keputusan restock terlambat | Laporan hanya tersedia saat pemilik berada di toko |

## 3. Tujuan Bisnis dan Metrik Keberhasilan

| ID | Tujuan | Indikator (KPI) | Baseline (hipotetis) | Target | Periode Ukur |
| --- | --- | --- | --- | --- | --- |
| BG-01 | Pembayaran digital | Persentase transaksi QRIS yang terverifikasi otomatis | 0% (verifikasi manual) | ≥ 95% pada pengujian sandbox **\[Usulan\]** | Pengujian skenario |
| BG-02 | Kecepatan transaksi | Waktu dari scan produk terakhir sampai transaksi tunai tersimpan | 4 detik | ≤ 2 detik **\[Usulan\]** | Per transaksi |
| BG-03 | Optimalisasi inventori | Frekuensi stockout produk *fast-moving* | 10 kejadian per bulan | ≤ 6 kejadian per bulan (−40%) | 3 bulan setelah *cold start period* berakhir |
| BG-04 | Kecepatan verifikasi pembayaran | Waktu dari pelanggan membayar sampai status lunas di aplikasi | Sekitar 45 detik (manual) | ≤ 10 detik **\[Usulan\]** | Per transaksi |
| BG-05 | Digitalisasi data | Persentase transaksi dan mutasi stok yang tercatat di sistem pusat | Sekitar 70% (stok dicatat mingguan) | ≥ 99% | Bulanan |
| BG-06 | Kualitas prediksi | WAPE forecasting pada produk *fast-moving* | - | ≤ 30% **\[Usulan\]** | Evaluasi pada dataset uji |

**Definisi:**

- *Fast-moving*: produk yang masuk 20% teratas berdasarkan volume penjualan dalam 30 hari terakhir **\[Usulan\]**.
- *Stockout*: kondisi stok sistem bernilai 0 ketika terjadi upaya penjualan atau permintaan.
- *WAPE*: Weighted Absolute Percentage Error, yaitu total selisih absolut prediksi dan aktual dibagi total aktual.

## 4. Stakeholder dan Persona

| Peran | Persona (fiktif) | Kebutuhan Utama | Kekhawatiran |
| --- | --- | --- | --- |
| Pemilik Usaha | Bu Maya (48 tahun), pemilik Toko Maju Jaya selama 12 tahun, memantau usaha lewat ponsel | Laporan penjualan dan stok yang mudah dibaca, tahu kapan harus restock | Kehabisan barang laris, modal tertahan di barang yang tidak laku |
| Admin / Manajer Toko | Pak Dedi (35 tahun), admin gudang, bekerja dengan laptop | CRUD produk, pencatatan mutasi stok, melihat prediksi dan peringatan stok menipis | Selisih stok sistem dan fisik, input data dua kali |
| Kasir | Rina (22 tahun, shift pagi) dan Andi (24 tahun, shift sore), memakai tablet Android dengan Wi-Fi toko | Transaksi cepat, scan barcode, pembayaran tunai dan QRIS, struk digital | Antrean panjang saat sistem lambat atau error |
| Pemasok (tidak langsung) | Pak Hendra, sales distributor, menerima pesanan lewat WhatsApp | Tidak berinteraksi langsung dengan sistem pada rilis ini | - |
| Tim Pengembang | Penulis (mahasiswa) | Kebutuhan jelas, terukur, dan realistis untuk satu semester | Ruang lingkup terlalu besar |
| Dosen Pengampu | Penilai tugas | Dokumen runtut dan sistem yang dapat didemokan | - |

## 5. Ruang Lingkup

### 5.1 In-Scope

- Aplikasi POS mobile (Flutter, Android): login, keranjang belanja, pemindai barcode, pembayaran tunai dan QRIS melalui Midtrans (sandbox), serta pratinjau struk di layar atau PDF.
- Dashboard admin web (Laravel dengan Filament): CRUD produk, kategori, dan pengguna (peran Admin dan Kasir); mutasi stok (barang masuk, penyesuaian, penjualan) dengan riwayat; laporan transaksi dengan ekspor CSV.
- Integrasi Midtrans (sandbox): pembuatan pembayaran QRIS dan penerimaan notifikasi (*webhook*) untuk status pembayaran.
- Layanan Machine Learning (FastAPI): peramalan permintaan, *reorder point* dan *low stock alert*, serta metode cadangan (rata-rata bergerak) untuk produk baru.
- Pencatatan HPP per produk sebagai data master.
- Data awal produk dan stok Toko Maju Jaya melalui skrip *seeding* dari data skenario.

### 5.2 Out-of-Scope

- Akun produksi Midtrans dan pembayaran dengan uang sungguhan. Rilis ini hanya memakai mode sandbox.
- Mode offline-first, termasuk basis data lokal dan sinkronisasi. Aplikasi mobile membutuhkan koneksi internet.
- Modul akuntansi lanjutan (Buku Besar, Neraca, Laba Rugi).
- Manajemen logistik dan pelacakan pengiriman.
- Program loyalitas atau member lanjutan.
- Integrasi e-commerce dan marketplace.
- Versi iOS. Rilis ini hanya untuk Android.

### 5.3 Pengembangan Lanjutan

Kebutuhan berprioritas Should dan Could di bagian 6 tidak diimplementasikan pada rilis tugas ini, tetapi dicatat sebagai arah pengembangan berikutnya:

- Mode offline-first: basis data lokal, antrean transaksi, sinkronisasi dua arah, dan penanganan konflik stok.
- Rekomendasi bundling (*Market Basket Analysis*) dan penerapan promo bundle di kasir.
- Cetak struk ke *thermal printer* via Bluetooth.
- Void dan retur transaksi, serta shift kasir dan rekap tutup kas.
- Pajak (PPN), laporan stok dan laba kotor, impor CSV dengan validasi.
- Banyak toko dan banyak perangkat, serta parameter stok per produk yang diatur dari antarmuka.
- Metode pembayaran digital lain dan akun produksi Midtrans.
- Log audit, notifikasi email, dan pemantauan akurasi serta *drift* model.
- Otentikasi berlapis (MFA) untuk peran Admin.

## 6. Kebutuhan Fungsional

Prioritas menggunakan MoSCoW: **M** (Must), **S** (Should), **C** (Could), **W** (Won't, pada rilis ini). **Rilis tugas ini (MVP) mengimplementasikan seluruh kebutuhan berprioritas Must.** Kebutuhan Should dan Could menjadi pengembangan lanjutan (lihat 5.3) dan dikerjakan hanya bila waktu tersisa.

### 6.1 Modul POS Mobile (Flutter)

| ID | Kebutuhan | Prioritas |
| --- | --- | --- |
| FR-POS-01 | Kasir dapat login dengan akun yang dibuat admin. | M |
| FR-POS-02 | Kasir dapat menambahkan produk ke keranjang melalui pencarian teks atau scan barcode kamera. | M |
| FR-POS-03 | Kasir dapat mengubah jumlah dan menghapus item pada keranjang. | M |
| FR-POS-04 | Sistem memproses transaksi dengan mengirimkannya ke server pusat. Setiap transaksi memiliki ID unik, dan pengiriman ulang akibat gangguan jaringan tidak menggandakan transaksi. | M |
| FR-POS-05 | Kasir dapat memproses pembayaran tunai dan sistem menghitung kembalian. | M |
| FR-POS-06 | Kasir dapat memilih pembayaran QRIS. Aplikasi menampilkan kode QR dari Midtrans, menunggu status pembayaran, dan menandai transaksi lunas hanya setelah server menerima notifikasi sukses dari Midtrans. Pembayaran yang gagal atau kedaluwarsa dibatalkan otomatis. | M |
| FR-POS-07 | Aplikasi menampilkan pratinjau struk di layar dan dapat menyimpannya sebagai PDF. | M |
| FR-POS-08 | Aplikasi menampilkan pesan yang jelas saat koneksi ke server tidak tersedia dan mencegah transaksi baru sampai koneksi pulih. Keranjang yang sedang dibuat tidak hilang. | M |
| FR-POS-09 | Kasir dapat membatalkan (*void*) transaksi dan membuat retur atas transaksi yang sudah selesai, dengan persetujuan sesuai hak akses. | S |
| FR-POS-10 | Kasir dapat membuka dan menutup shift, dengan rekap penjualan per metode pembayaran dan selisih kas. | S |
| FR-POS-11 | Kasir dapat memberi diskon manual pada keranjang sesuai hak akses. | S |
| FR-POS-12 | Sistem mengirim perintah cetak struk ke *thermal printer* via Bluetooth. | C |
| FR-POS-13 | Aplikasi mendukung pencatatan pajak (PPN) yang dapat diaktifkan per toko. | C |

### 6.2 Modul Admin Core (Dashboard Web, Laravel)

| ID | Kebutuhan | Prioritas |
| --- | --- | --- |
| FR-ADM-01 | CRUD Produk (SKU, barcode, nama, kategori, satuan, harga jual, HPP, status aktif), Kategori, dan Pengguna dengan peran Admin dan Kasir. | M |
| FR-ADM-02 | Pembatasan hak akses berbasis dua peran: Admin dapat mengakses dashboard dan Kasir hanya dapat memakai aplikasi POS. | M |
| FR-ADM-03 | Laporan transaksi historis dengan filter rentang tanggal, kasir, dan metode pembayaran, dapat diekspor ke CSV. | M |
| FR-ADM-04 | Stok produk berkurang otomatis setiap transaksi berhasil diterima server. | M |
| FR-ADM-05 | Mutasi stok: barang masuk (menambah stok dan dapat memperbarui HPP) dan penyesuaian stok manual (stok opname) dengan alasan wajib diisi. | M |
| FR-ADM-06 | Riwayat mutasi stok (kartu stok) per produk: penjualan, barang masuk, penyesuaian. | M |
| FR-ADM-07 | Dashboard menampilkan status pembayaran Midtrans per transaksi dan mencatat setiap notifikasi yang diterima. | M |
| FR-ADM-08 | Laporan stok saat ini dan laporan laba kotor (omzet dikurangi HPP) per periode dan per produk. | S |
| FR-ADM-09 | Impor data awal produk dan stok melalui template CSV dengan validasi dan laporan kesalahan. | S |
| FR-ADM-10 | Pengaturan parameter stok per produk: lead time pemasok, stok pengaman (*safety stock*), dan batas minimum manual. | S |
| FR-ADM-11 | Pengelolaan banyak toko dan banyak perangkat per toko. | S |
| FR-ADM-12 | Log audit untuk aksi sensitif: ubah harga, penyesuaian stok, void atau retur, ubah hak akses. | S |

### 6.3 Modul Analitik AI (FastAPI)

| ID | Kebutuhan | Prioritas |
| --- | --- | --- |
| FR-AI-01 | Menghasilkan proyeksi permintaan per produk untuk 7 sampai 14 hari ke depan dengan model *time-series forecasting*. Model dilatih di luar layanan (notebook) dengan data skenario atau dataset publik, dan layanan FastAPI menyajikan hasil proyeksi yang sudah dihitung (*pre-computed*) ke dashboard. | M |
| FR-AI-02 | Menghitung *reorder point* per produk dengan rumus: (rata-rata permintaan harian prediksi × lead time) + stok pengaman. Peringatan *low stock alert* muncul di dashboard jika stok saat ini di bawah reorder point. | M |
| FR-AI-03 | Menyediakan metode cadangan (*fallback*) untuk produk baru atau data historis kurang dari 4 minggu, yaitu rata-rata bergerak atau batas minimum default. Dashboard menandai produk tersebut sebagai “prediksi belum andal”. | M |
| FR-AI-04 | Menyimpan dan menampilkan metrik akurasi model (WAPE) per produk di dashboard. | S |
| FR-AI-05 | Menjalankan *Market Basket Analysis* terjadwal untuk menemukan pasangan produk yang sering dibeli bersamaan, dengan ambang minimum *support*, *confidence*, dan *lift*, lalu menampilkannya sebagai rekomendasi bundling. | C |
| FR-AI-06 | Admin dapat menyetujui, menolak, atau menyembunyikan rekomendasi bundling. | C |
| FR-AI-07 | Mengirim notifikasi email ringkasan produk dengan stok kritis. | C |
| FR-AI-08 | Menyediakan retraining model terjadwal dan pemantauan *drift* sederhana. | C |

### 6.4 Aturan Bisnis Kunci

| ID | Aturan |
| --- | --- |
| BR-01 | **Sumber kebenaran stok** adalah server pusat. Stok hanya berubah saat transaksi diterima dan dinyatakan berhasil oleh server. |
| BR-02 | Transaksi **tidak dapat diproses** tanpa koneksi ke server. Aplikasi menampilkan pesan dan menjaga keranjang yang sedang dibuat. |
| BR-03 | Setiap transaksi memiliki ID unik. Pengiriman ulang akibat gangguan jaringan tidak menggandakan transaksi maupun pengurangan stok. |
| BR-04 | Transaksi QRIS dinyatakan lunas **hanya** setelah server menerima notifikasi pembayaran sukses dari Midtrans, bukan berdasarkan tampilan di aplikasi. |
| BR-05 | Pembayaran QRIS yang gagal atau kedaluwarsa tidak mengurangi stok. |
| BR-06 | Stok tidak boleh negatif. Penjualan melebihi stok sistem ditolak dengan peringatan, dan admin menyesuaikan stok bila ada selisih dengan stok fisik. |
| BR-07 | Penyesuaian stok manual wajib menyertakan alasan dan pelaku. |
| BR-08 | Void atau retur hanya dapat dilakukan oleh peran dengan izin khusus (pengembangan lanjutan). |

## 7. Kebutuhan Non-Fungsional

| ID | Kategori | Kebutuhan |
| --- | --- | --- |
| NFR-01 | Ketersediaan (mobile) | Aplikasi mobile menampilkan pesan yang jelas dan tidak menutup paksa saat server atau internet tidak tersedia. Keranjang yang sedang dibuat tidak hilang. |
| NFR-02 | Ketersediaan (server) | Backend dan dashboard memiliki ketersediaan ≥ 99,5% per bulan di luar maintenance terjadwal **\[Usulan\]**. |
| NFR-03 | Kinerja POS | Penambahan produk ke keranjang ≤ 500 ms dan penyimpanan transaksi tunai ≤ 2 detik pada jaringan Wi-Fi normal **\[Usulan\]**. |
| NFR-04 | Kinerja dashboard | Halaman prediksi dan peringatan stok dimuat ≤ 3 detik. Inferensi tidak dijalankan saat halaman dibuka, melainkan memakai hasil *pre-computed*. |
| NFR-05 | Kinerja pembayaran | Kode QR QRIS tampil ≤ 5 detik setelah kasir memilih QRIS, dan status lunas tampil di aplikasi ≤ 10 detik setelah notifikasi diterima server **\[Usulan\]**. |
| NFR-06 | Skalabilitas | Rilis ini mendukung 1 toko, hingga 3 perangkat, 1.000 produk, dan 500 transaksi per hari **\[Usulan\]**. |
| NFR-07 | Keamanan akses | Autentikasi berbasis token (Laravel Sanctum) untuk aplikasi mobile dan dashboard. Layanan FastAPI hanya dapat dipanggil oleh Laravel dengan API key. Notifikasi Midtrans diverifikasi melalui tanda tangan (*signature*) sebelum diproses. Otentikasi berlapis (MFA) dicatat sebagai pengembangan lanjutan. |
| NFR-08 | Keamanan data | Seluruh komunikasi memakai HTTPS/TLS. Kata sandi disimpan dalam bentuk hash. Kunci API Midtrans disimpan di konfigurasi server dan tidak pernah ada di aplikasi mobile. |
| NFR-09 | Kepatuhan data | Pengelolaan data pribadi (pengguna dan, bila ada, pelanggan) mengikuti UU No. 27 Tahun 2022 tentang Pelindungan Data Pribadi. |
| NFR-10 | Backup dan pemulihan | Backup basis data otomatis harian. RPO ≤ 24 jam dan RTO ≤ 4 jam **\[Usulan\]**. Retensi data transaksi minimal 5 tahun **\[Usulan\]**. |
| NFR-11 | Kompatibilitas | Android 8.0 ke atas **\[Usulan\]**. Dashboard mendukung dua versi mayor terbaru Chrome, Edge, dan Firefox. |
| NFR-12 | Observabilitas | Pencatatan log untuk kegagalan pembayaran, notifikasi Midtrans, dan proses ML. |
| NFR-13 | Keandalan pembayaran | Notifikasi Midtrans yang diterima lebih dari sekali tidak menggandakan pencatatan pembayaran maupun pengurangan stok. |
| NFR-14 | Usability | Kasir baru mampu menyelesaikan transaksi pertama setelah pelatihan maksimal 30 menit **\[Usulan\]**. |

**Catatan MVP:** NFR-02, NFR-09, NFR-10, dan NFR-12 dicatat sebagai pertimbangan desain dan tidak diuji formal pada rilis tugas ini. Pengujian kinerja (NFR-03 sampai NFR-05) memakai data uji dari skenario.

## 8. Keputusan dan Batasan Teknologi

Tumpukan teknologi berikut telah diputuskan dan diperlakukan sebagai **batasan (constraint)** proyek:

| Komponen | Teknologi | Catatan |
| --- | --- | --- |
| Aplikasi mobile POS | Flutter | Android. Berkomunikasi dengan Laravel lewat REST API dan membutuhkan koneksi internet |
| Core Backend dan Dashboard Admin | Laravel | Menangani REST API untuk mobile, otentikasi, peran, integrasi Midtrans (webhook), dan antarmuka admin (Filament) |
| Layanan Analitik AI | FastAPI (Python) | Layanan terisolasi yang diakses lewat REST API |
| Basis data pusat | PostgreSQL | Sumber kebenaran data transaksi dan stok |

Pembayaran QRIS memakai Midtrans (mode sandbox) sebagai layanan pihak ketiga, dan hanya Laravel yang berkomunikasi dengannya, bukan aplikasi mobile. Pemilihan algoritma (misalnya XGBoost atau rata-rata bergerak untuk forecasting) dan detail arsitektur didokumentasikan pada SRS dan dokumen desain teknis, bukan pada BRD ini.

## 9. Asumsi

1. Perangkat kasir Android memiliki kamera berfungsi dan terhubung ke internet (Wi-Fi toko) selama dipakai.
2. Produk memiliki barcode yang terbaca baik, atau toko mencetak label barcode internal.
3. Model prediksi memerlukan data historis 1 sampai 3 bulan (*cold start period*). Selama periode ini berlaku metode cadangan (FR-AI-03) dan target BG-03 belum berlaku. Untuk pengembangan, data historis disediakan dari data sintetis atau dataset publik.
4. Midtrans dipakai dalam mode sandbox untuk pengembangan dan demo. Kunci sandbox tersedia, dan URL publik sementara (tunnel) dipakai agar webhook dapat diterima saat pengembangan.
5. Data awal produk dan stok Toko Maju Jaya disediakan melalui data skenario (*seeding*).
6. Lead time pemasok default 3 hari dan stok pengaman setara 2 hari permintaan rata-rata, diatur di konfigurasi **\[Usulan\]**.
7. Kasir dan admin menggunakan sistem sebagai satu-satunya pencatatan stok.
8. Struk ditampilkan sebagai pratinjau di layar atau PDF, tanpa printer fisik.
9. Koneksi internet toko dianggap stabil selama jam operasional. Gangguan koneksi hanya ditangani dengan pesan kesalahan **\[Usulan\]**.
10. Baseline dan angka usaha di dokumen ini hipotetis dan hanya untuk keperluan studi kasus.

## 10. Risiko

| ID | Risiko | Kemungkinan | Dampak | Mitigasi |
| --- | --- | --- | --- | --- |
| R1 | Koneksi internet toko terputus sehingga kasir tidak dapat bertransaksi | Sedang | Tinggi | Pesan yang jelas, keranjang tersimpan sementara, dan offline-first dicatat sebagai pengembangan lanjutan |
| R2 | Data stok awal tidak akurat sehingga prediksi buruk | Tinggi | Tinggi | Seeding data awal yang konsisten, penyesuaian stok manual |
| R3 | Data historis kurang atau tidak bersih | Sedang | Tinggi | Fallback FR-AI-03, penandaan prediksi belum andal |
| R4 | Kasir enggan memakai sistem baru | Sedang | Tinggi | Pelatihan, UI sederhana, pendampingan awal |
| R5 | Integrasi Midtrans bermasalah (webhook tidak sampai, URL publik berubah, simulator sandbox terbatas) | Sedang | Tinggi | Tunnel stabil, uji skenario gagal dan kedaluwarsa, pengecekan status manual ke Midtrans sebagai cadangan |
| R6 | Akses tidak sah ke akun kasir pada perangkat yang hilang | Sedang | Sedang | Token dapat dicabut dari dashboard |
| R7 | Akurasi model tidak mencapai target | Sedang | Sedang | Evaluasi WAPE, metode cadangan rata-rata bergerak |
| R8 | Notifikasi Midtrans diterima ganda atau tidak berurutan | Sedang | Tinggi | Idempotensi berdasarkan ID pesanan, verifikasi tanda tangan |
| R9 | Cakupan melebar (*scope creep*) | Sedang | Sedang | Prioritas MoSCoW dan proses perubahan terkontrol |
| R10 | Waktu pengerjaan terbatas dan dikerjakan satu orang | Tinggi | Tinggi | MVP dipangkas ke kebutuhan Must, bagian forecasting dapat disederhanakan lebih jauh bila waktu mepet |

## 11. Dependensi

- Ketersediaan data transaksi historis atau data sintetis dan dataset publik untuk melatih dan menguji model.
- Perangkat Android untuk pengujian.
- Akun sandbox Midtrans dan URL publik sementara (tunnel) untuk webhook.
- Infrastruktur server (hosting atau lingkungan lokal, PostgreSQL, penjadwal job) untuk Laravel dan FastAPI.
- Keputusan parameter bisnis: lead time, stok pengaman, target KPI.

## 12. Rencana Rilis

| Tahap | Fokus | Hasil |
| --- | --- | --- |
| 1 | Desain dan backend dasar | BRD final, desain basis data dan API, Laravel dengan autentikasi, seeding data, CRUD produk dan pengguna lewat Filament |
| 2 | Aplikasi POS | Flutter: login, keranjang, scan barcode, pembayaran tunai, pratinjau struk, pengiriman transaksi ke server, mutasi stok dan stok otomatis |
| 3 | Integrasi Midtrans | QRIS sandbox: pembuatan pembayaran, webhook, status lunas, skenario gagal dan kedaluwarsa, laporan transaksi |
| 4 | Analitik AI | Notebook forecasting dan evaluasi WAPE, layanan FastAPI, reorder point, peringatan stok menipis di dashboard, metode cadangan |
| 5 | Integrasi dan penyelesaian | Pengujian skenario, perbaikan bug, laporan, dan persiapan demo |

## 13. Kriteria Penerimaan

Sistem dinyatakan siap rilis jika:

1. Seluruh kebutuhan berprioritas Must lulus pengujian fungsional berdasarkan daftar kasus uji.
2. Skenario tunai lulus: kasir membuat transaksi, stok di server berkurang, dan transaksi muncul di laporan.
3. Skenario QRIS sandbox lulus: pembayaran berhasil menandai transaksi lunas dan mengurangi stok. Pembayaran gagal atau kedaluwarsa tidak mengurangi stok. Notifikasi ganda tidak menggandakan pencatatan.
4. Skenario tanpa koneksi lulus: aplikasi menampilkan pesan, tidak menutup paksa, dan keranjang tidak hilang.
5. Target kinerja NFR-03 sampai NFR-05 terpenuhi pada uji dengan data skenario.
6. Hasil forecasting dan peringatan stok menipis tampil di dashboard dalam batas waktu NFR-04.
7. Pengujian keamanan dasar lulus: pembatasan akses per peran, token, dan verifikasi tanda tangan Midtrans.
8. Hasil evaluasi model (WAPE) dilaporkan pada dataset uji.
9. Demo dan laporan diterima oleh dosen pengampu.

## 14. Keputusan Asumsi

1. Platform: Android saja.
2. Mode: online-only. Offline-first dicatat sebagai pengembangan lanjutan.
3. Pembayaran: tunai dan QRIS melalui Midtrans (sandbox). Metode lain adalah pengembangan lanjutan.
4. Rekomendasi bundling: pengembangan lanjutan.
5. Skala: 1 toko, 3 perangkat, 1.000 produk, 500 transaksi per hari.
6. Pajak (PPN): tidak diterapkan pada rilis ini.
7. Lead time dan stok pengaman: nilai default di konfigurasi (lihat asumsi 6).
8. Varian produk dan tanggal kedaluwarsa: di luar ruang lingkup.
9. Notifikasi: hanya di dashboard.
10. Model bisnis: satu usaha (*single-tenant*), bukan layanan multi-usaha.

## 15. Glosarium

| Istilah | Arti |
| --- | --- |
| POS | *Point of Sale*, sistem kasir |
| Offline-first | Sistem dirancang bekerja penuh tanpa internet, lalu sinkron saat tersambung |
| Dead stock | Barang yang sangat lambat atau tidak laku |
| Stockout | Kehabisan stok |
| AOV | *Average Order Value*, rata-rata nilai transaksi |
| HPP | Harga Pokok Penjualan |
| MBA | *Market Basket Analysis*, analisis pola pembelian bersama |
| Support / Confidence / Lift | Metrik kekuatan aturan asosiasi produk |
| WAPE | *Weighted Absolute Percentage Error*, metrik kesalahan prediksi |
| Reorder point | Batas stok yang memicu pemesanan ulang |
| Safety stock | Cadangan stok untuk menghadapi lonjakan permintaan atau keterlambatan pasokan |
| RBAC | *Role-Based Access Control* |
| RPO / RTO | Batas kehilangan data / batas waktu pemulihan layanan |
| UAT | *User Acceptance Testing* |
