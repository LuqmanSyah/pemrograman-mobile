# Pertemuan 9 — REST API CRUD dengan FastAPI, SQLAlchemy, dan Alembic

> Modul: [docs/modul-praktikum-flutter-pertemuan-9.md](docs/modul-praktikum-flutter-pertemuan-9.md)
>
> Latihan mandiri dan tugas (endpoint `/laporan` + `LaporanApi`): [docs/tugas-pertemuan-9.md](docs/tugas-pertemuan-9.md)

Lanjutan TabungKu Cloud dari pertemuan 8. Backend mendapat resource `/kegiatan` lengkap (GET daftar/detail, POST, PUT, PATCH, DELETE) dengan ORM SQLAlchemy 2, migrasi Alembic, dan validasi aturan bisnis Pydantic. Di Flutter dibuat lapisan layanan `KegiatanApi` yang akan dipakai UI pada pertemuan 11; UI masih memakai SQLite.

## Struktur

```
pertemuan9/
├── docker-compose.yml          # mysql, api (bind mount ./backend:/code), adminer
├── .env.example
├── backend/
│   ├── Dockerfile              # CMD ["sh", "start.sh"]
│   ├── start.sh                # alembic upgrade head, lalu uvicorn
│   ├── requirements.txt        # + alembic==1.20.0
│   ├── alembic.ini
│   ├── alembic/
│   │   ├── env.py              # URL dari app.config.settings; mode online & offline
│   │   ├── script.py.mako
│   │   └── versions/0001_buat_tabel_kegiatan.py
│   └── app/
│       ├── database.py         # engine, SessionLocal, Base, get_db
│       ├── models.py           # Tipe (enum), Kegiatan
│       ├── schemas.py          # KegiatanInput/Patch/Out, Urutan, LaporanHarian, RingkasanHari
│       ├── main.py
│       └── routers/
│           ├── health.py       # GET /health (dari pertemuan 8)
│           ├── kegiatan.py     # CRUD /kegiatan
│           └── laporan.py      # /laporan/harian, /laporan/rentang (tugas)
├── lib/
│   ├── config/api_config.dart  # + apiUrl (ValueNotifier) untuk lapisan layanan
│   ├── models/
│   │   ├── kegiatan.dart       # + toJson(), Kegiatan.fromJson(), Ringkasan.fromJson()
│   │   └── laporan.dart        # LaporanHarian (tugas)
│   └── services/
│       ├── api_exception.dart  # membaca `detail` FastAPI (teks / daftar 422)
│       ├── api_util.dart       # apiUri(), cekRespons() dipakai bersama
│       ├── kegiatan_api.dart   # daftar, tambah, ubah (PUT), setSelesai (PATCH), hapus
│       └── laporan_api.dart    # harian, rentang (tugas)
└── test/
    ├── kegiatan_api_test.dart  # MockClient
    └── laporan_api_test.dart   # MockClient (tugas)
```

## Menjalankan backend

```bash
cp .env.example .env
docker compose up -d --build
docker compose logs api | grep alembic        # Running upgrade  -> 0001, buat tabel kegiatan
docker compose exec api alembic current       # 0001 (head)
docker compose exec api alembic check         # No new upgrade operations detected.
```

- Swagger UI: http://localhost:8000/docs
- Adminer: http://localhost:8081 (server `mysql`)

Migrasi berjalan otomatis setiap kali container `api` menyala (lewat `start.sh`). Untuk melihat SQL tanpa menjalankannya: `docker compose exec api alembic upgrade head --sql`.

> Nama proyek Compose masih `tabungku` (sama dengan pertemuan 8), jadi `docker compose up` di folder ini menggantikan container pertemuan 8 dan memakai volume MySQL yang sama.

## Endpoint

| Method + URL | Aksi | Sukses | Gagal |
| --- | --- | --- | --- |
| `GET /kegiatan?tanggal=&tipe=&selesai=&q=&urut=&limit=&offset=` | Daftar + filter + pagination; header `X-Total-Count` | 200 | 422 |
| `GET /kegiatan/{id}` | Detail | 200 | 404 |
| `POST /kegiatan` | Tambah | 201 | 422 |
| `PUT /kegiatan/{id}` | Ganti seluruh data | 200 | 404, 422 |
| `PATCH /kegiatan/{id}` | Ubah sebagian (divalidasi ulang setelah digabung) | 200 | 404, 422 |
| `DELETE /kegiatan/{id}` | Hapus | 204 | 404 |
| `GET /laporan/harian?tanggal=` | Ringkasan satu hari + pengeluaran per kategori | 200 | 422 |
| `GET /laporan/rentang?mulai=&sampai=` | Ringkasan setiap hari (maks. 31 hari) | 200 | 400, 422 |

Aturan bisnis (dari pertemuan 7) di `KegiatanInput`: judul tidak boleh kosong/spasi; tipe `tanpa` memaksa `nominal = 0` dan `kategori = "-"`; pemasukan/pengeluaran wajib `nominal > 0`; pemasukan memaksa `kategori = "-"`; pengeluaran wajib salah satu dari `Makan, Transport, Belajar, Hiburan, Lainnya`.

## Hasil Uji Bagian F (Swagger UI)

Dijalankan pada database kosong, berurutan (sebelum latihan mandiri; urutan `GET` saat itu masih `selesai, id DESC`).

| No | Permintaan | Hasil yang diharapkan | Hasil yang didapat | Status |
| --- | --- | --- | --- | --- |
| 1 | POST pengeluaran Rp 15.000 kategori Makan | 201; respons berisi `id`, `created_at` | `201 Created`, `id: 1`, `created_at: "2026-11-23T06:38:02"` | Sesuai |
| 2 | POST pemasukan dengan `kategori: "Makan"` | 201; kategori otomatis menjadi `"-"` | `201 Created`, `id: 2`, `kategori: "-"` | Sesuai |
| 3 | POST dengan `judul: " "` | 422 judul wajib diisi | `422`, `loc: ["body","judul"]`, `msg: "Value error, judul wajib diisi"` | Sesuai |
| 4 | POST pengeluaran `kategori: "Jajan"` | 422 dengan daftar kategori yang sah | `422`, `msg: "... harus salah satu dari: Makan, Transport, Belajar, Hiburan, Lainnya"` | Sesuai |
| 5 | `PATCH /kegiatan/1` `{"selesai": true}` | 200; hanya `selesai` dan `updated_at` berubah | `200`, `selesai: true`, `updated_at` 06:38:02 → 06:38:03, field lain tetap | Sesuai |
| 6 | `PATCH /kegiatan/1` `{"nominal": 0}` | 422; data tidak berubah | `422`, `msg: "Value error, nominal wajib lebih dari 0 untuk pemasukan/pengeluaran"`; `GET /kegiatan/1` tetap `nominal: 15000` | Sesuai |
| 7 | `GET /kegiatan?tanggal=2026-10-06&limit=1` | Satu data; header `x-total-count` berisi jumlah seluruhnya | `200`, 1 data (id 2, belum selesai diurutkan lebih dulu), `x-total-count: 2` | Sesuai |
| 8 | `DELETE /kegiatan/2`, lalu `GET /kegiatan/2` | 204, lalu 404 | `204 No Content`, lalu `404 {"detail":"Kegiatan tidak ditemukan"}` | Sesuai |

Uji tambahan: `PUT /kegiatan/1` → 200; `PUT /kegiatan/999` → 404; `"tanggal": "06-10-2026"` → 422 `date_from_datetime_parsing`. Data di Adminer (tabel `kegiatan`) sama dengan hasil GET.

## Flutter

```bash
flutter pub get
flutter analyze     # No issues found!
flutter test        # termasuk test/kegiatan_api_test.dart
```

`KegiatanApi` membaca alamat server dari `apiUrl.value` (`lib/config/api_config.dart`), yang selalu disinkronkan dengan alamat di **Pengaturan → Alamat API** (tugas pertemuan 8). `http.Client` diterima lewat konstruktor sehingga dapat diganti `MockClient` saat pengujian. Respons di luar 2xx dilempar sebagai `ApiException` dengan pesan dari field `detail` FastAPI.

Catatan: `apiUri()` tidak meneruskan map query kosong ke `Uri.replace`, karena `queryParameters: {}` menghasilkan URL berakhiran `?` (`/kegiatan?`) saat `daftar()` dipanggil tanpa filter.
