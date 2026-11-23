from datetime import datetime

from fastapi import APIRouter
from fastapi.responses import JSONResponse
from sqlalchemy import text

from ..database import engine

router = APIRouter(tags=["health"])


@router.get(
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
