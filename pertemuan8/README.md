# Pertemuan 8 — TabungKu Cloud: Docker Compose dan Kerangka Backend

> Tugas pertemuan 8 (Adminer, `/health` dengan cek database, status API/database, alamat API di Pengaturan) beserta cara mengujinya: [docs/tugas-pertemuan-8.md](docs/tugas-pertemuan-8.md).

Aplikasi TabungKu (pertemuan 7) ditambah backend FastAPI + MySQL yang dijalankan dengan Docker Compose, serta halaman **Status Server** di Flutter.

## Struktur

```
pertemuan8/
├── docker-compose.yml     # layanan mysql (MySQL 8.4) dan api (FastAPI)
├── .env.example           # contoh variabel lingkungan (salin menjadi .env)
├── backend/               # FastAPI
│   ├── Dockerfile
│   ├── requirements.txt
│   └── app/ (config.py, database.py, main.py)
├── lib/                   # Flutter (kode pertemuan 7 + status server)
│   ├── config/api_config.dart
│   ├── services/health_service.dart
│   └── pages/status_server_page.dart
└── test/health_service_test.dart
```

## Menjalankan backend

```bash
cp .env.example .env
docker compose up -d --build
docker compose ps          # tunggu mysql "healthy" dan api "Up"
```

- Health check: http://localhost:8000/health
- Swagger UI: http://localhost:8000/docs
- Adminer: http://localhost:8081 (server `mysql`)
- MySQL dari laptop: `localhost:3307`

Menghentikan: `docker compose down` (data tetap ada) atau `docker compose down -v` (data dihapus).

## Menjalankan aplikasi Flutter

```bash
flutter pub get
flutter run                                                 # emulator Android (10.0.2.2)
flutter run --dart-define=API_URL=http://localhost:8000     # simulator iOS
flutter run --dart-define=API_URL=http://192.168.1.10:8000  # HP fisik (ganti IP laptop)
flutter test
```

Buka **Pengaturan → Status server** untuk memeriksa koneksi ke API dan database. Alamat API dapat diubah di **Pengaturan → Alamat API**.
