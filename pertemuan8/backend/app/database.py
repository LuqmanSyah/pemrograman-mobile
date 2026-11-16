from sqlalchemy import create_engine

from .config import settings

# pool_pre_ping: cek koneksi sebelum dipakai, berguna bila MySQL sempat restart.
# connect_timeout: bila host MySQL ada tetapi tidak merespons, /health tetap
# membalas 503 sebelum batas waktu 10 detik di aplikasi Flutter.
engine = create_engine(
    settings.database_url,
    pool_pre_ping=True,
    connect_args={"connect_timeout": 3},
)
