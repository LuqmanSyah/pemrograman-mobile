from datetime import date, timedelta

from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy import and_, case, func, select
from sqlalchemy.orm import Session

from ..database import get_db
from ..models import Kegiatan, Tipe
from ..schemas import KategoriTotal, LaporanHarian, RingkasanHari

router = APIRouter(prefix="/laporan", tags=["laporan"])

MAKS_HARI_RENTANG = 31

_ANGKA = (
    "jumlah_kegiatan",
    "selesai",
    "pemasukan",
    "pengeluaran",
    "tabungan",
    "pemasukan_selesai",
    "pengeluaran_selesai",
)


def _kolom_ringkasan():
    """Kolom agregat yang dipakai bersama oleh /harian dan /rentang.

    Semua angka dihitung oleh MySQL (COUNT, SUM(CASE WHEN ...), COALESCE),
    bukan dengan perulangan Python atas setiap baris kegiatan. COALESCE
    mengubah NULL (SUM atas nol baris) menjadi 0.
    """
    selesai = Kegiatan.selesai.is_(True)
    masuk = Kegiatan.tipe == Tipe.pemasukan
    keluar = Kegiatan.tipe == Tipe.pengeluaran

    def jumlah(kondisi, nilai=Kegiatan.nominal):
        return func.coalesce(func.sum(case((kondisi, nilai), else_=0)), 0)

    return (
        func.count(Kegiatan.id).label("jumlah_kegiatan"),
        jumlah(selesai, 1).label("selesai"),
        jumlah(masuk).label("pemasukan"),
        jumlah(keluar).label("pengeluaran"),
        # Tabungan = pemasukan - pengeluaran, juga dihitung di SQL.
        func.coalesce(
            func.sum(
                case(
                    (masuk, Kegiatan.nominal),
                    (keluar, -Kegiatan.nominal),
                    else_=0,
                )
            ),
            0,
        ).label("tabungan"),
        jumlah(and_(masuk, selesai)).label("pemasukan_selesai"),
        jumlah(and_(keluar, selesai)).label("pengeluaran_selesai"),
    )


def _angka(row) -> dict[str, int]:
    """MySQL membalas SUM sebagai DECIMAL; ubah menjadi int untuk JSON."""
    return {k: int(row._mapping[k]) for k in _ANGKA}


@router.get("/harian", response_model=LaporanHarian)
def laporan_harian(
    tanggal: date = Query(description="Format YYYY-MM-DD", examples=["2026-10-06"]),
    db: Session = Depends(get_db),
):
    """Ringkasan satu hari dan pengeluaran per kategori (terbesar dulu).

    `pemasukan`/`pengeluaran`/`tabungan` adalah rencana (semua kegiatan), sama
    seperti aturan bisnis pertemuan 7. `*_selesai` adalah realisasi.
    """
    ringkasan = db.execute(
        select(*_kolom_ringkasan()).where(Kegiatan.tanggal == tanggal)
    ).one()

    total = func.sum(Kegiatan.nominal).label("total")
    per_kategori = db.execute(
        select(Kegiatan.kategori, total)
        .where(Kegiatan.tanggal == tanggal, Kegiatan.tipe == Tipe.pengeluaran)
        .group_by(Kegiatan.kategori)
        .order_by(total.desc(), Kegiatan.kategori)
    ).all()

    return LaporanHarian(
        tanggal=tanggal,
        **_angka(ringkasan),
        per_kategori=[KategoriTotal(kategori=k, total=int(t)) for k, t in per_kategori],
    )


@router.get(
    "/rentang",
    response_model=list[RingkasanHari],
    responses={400: {"description": "Rentang terbalik atau lebih dari 31 hari"}},
)
def laporan_rentang(
    mulai: date = Query(description="Tanggal awal (inklusif)", examples=["2026-10-01"]),
    sampai: date = Query(description="Tanggal akhir (inklusif)", examples=["2026-10-07"]),
    db: Session = Depends(get_db),
):
    """Ringkasan setiap hari dari `mulai` sampai `sampai` (urut naik), termasuk
    hari tanpa kegiatan (semua angka 0). Maksimal 31 hari."""
    if sampai < mulai:
        raise HTTPException(
            status.HTTP_400_BAD_REQUEST, "Tanggal sampai tidak boleh sebelum tanggal mulai"
        )
    jumlah_hari = (sampai - mulai).days + 1
    if jumlah_hari > MAKS_HARI_RENTANG:
        raise HTTPException(
            status.HTTP_400_BAD_REQUEST,
            f"Rentang maksimal {MAKS_HARI_RENTANG} hari (diminta {jumlah_hari} hari)",
        )

    # Satu query untuk seluruh rentang: satu baris per tanggal yang punya kegiatan.
    rows = db.execute(
        select(Kegiatan.tanggal, *_kolom_ringkasan())
        .where(Kegiatan.tanggal.between(mulai, sampai))
        .group_by(Kegiatan.tanggal)
    ).all()
    per_tanggal = {row.tanggal: _angka(row) for row in rows}

    # Melengkapi hari kosong (maksimal 31 iterasi, bukan perulangan atas data).
    nol = dict.fromkeys(_ANGKA, 0)
    hasil = []
    for i in range(jumlah_hari):
        hari = mulai + timedelta(days=i)
        hasil.append(RingkasanHari(tanggal=hari, **per_tanggal.get(hari, nol)))
    return hasil
