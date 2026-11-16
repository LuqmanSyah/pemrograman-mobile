from datetime import datetime

from fastapi import FastAPI
from fastapi.responses import JSONResponse
from sqlalchemy import text

from .database import engine

app = FastAPI(title="TabungKu API", version="0.1.0")


@app.get("/")
def beranda():
    return {"pesan": "Selamat datang di TabungKu API. Dokumentasi: /docs"}


@app.get(
    "/health",
    responses={503: {"description": "API hidup, tetapi database tidak dapat dihubungi"}},
)
def health():
    """Dipakai aplikasi Flutter untuk memastikan API dan database dapat dihubungi.

    - 200: API dan database sehat.
    - 503: API hidup, database mati (`database` bernilai `"error"`).
    """
    waktu = datetime.now().isoformat(timespec="seconds")
    try:
        with engine.connect() as conn:
            versi = conn.execute(text("SELECT VERSION()")).scalar_one()
    except Exception as e:  # noqa: BLE001 - galat apa pun berarti database tidak sehat
        return JSONResponse(
            status_code=503,
            content={
                "status": "error",
                "waktu_server": waktu,
                "database": "error",
                "mysql_version": None,
                # Baris pertama pesan sudah cukup; sisanya biasanya jejak SQLAlchemy.
                "detail": str(e).splitlines()[0],
            },
        )
    return {
        "status": "ok",
        "waktu_server": waktu,
        "database": "ok",
        "mysql_version": versi,
    }
