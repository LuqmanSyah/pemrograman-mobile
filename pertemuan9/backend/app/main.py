from fastapi import FastAPI

from .routers import health, kegiatan, laporan

app = FastAPI(title="TabungKu API", version="0.2.0")


@app.get("/", include_in_schema=False)
def beranda():
    return {"pesan": "Selamat datang di TabungKu API. Dokumentasi: /docs"}


app.include_router(health.router)
app.include_router(kegiatan.router)
app.include_router(laporan.router)
