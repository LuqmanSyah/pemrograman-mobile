import enum
from datetime import date, datetime

from pydantic import BaseModel, ConfigDict, Field, field_validator, model_validator

from .models import Tipe

KATEGORI_PENGELUARAN = ["Makan", "Transport", "Belajar", "Hiburan", "Lainnya"]


class KegiatanBase(BaseModel):
    judul: str = Field(min_length=1, max_length=100, examples=["Makan siang"])
    tanggal: date = Field(examples=["2026-10-06"])
    selesai: bool = False
    tipe: Tipe = Tipe.tanpa
    nominal: int = Field(default=0, ge=0, examples=[15000])
    kategori: str = Field(default="-", examples=["Makan"])


class KegiatanInput(KegiatanBase):
    """Data dari klien untuk POST dan PUT. Aturan bisnis modul 7 dicek di sini."""

    @field_validator("judul")
    @classmethod
    def judul_tidak_kosong(cls, v: str) -> str:
        v = v.strip()
        if not v:
            raise ValueError("judul wajib diisi")
        return v

    @model_validator(mode="after")
    def cek_aturan_bisnis(self):
        if self.tipe == Tipe.tanpa:
            self.nominal = 0
            self.kategori = "-"
            return self
        if self.nominal <= 0:
            raise ValueError("nominal wajib lebih dari 0 untuk pemasukan/pengeluaran")
        if self.tipe == Tipe.pemasukan:
            self.kategori = "-"
        elif self.kategori not in KATEGORI_PENGELUARAN:
            raise ValueError(
                "kategori pengeluaran harus salah satu dari: " + ", ".join(KATEGORI_PENGELUARAN)
            )
        return self


class KegiatanPatch(BaseModel):
    """PATCH: semua field opsional, hanya yang dikirim yang diubah."""

    judul: str | None = None
    tanggal: date | None = None
    selesai: bool | None = None
    tipe: Tipe | None = None
    nominal: int | None = None
    kategori: str | None = None


class KegiatanOut(KegiatanBase):
    model_config = ConfigDict(from_attributes=True)

    id: int
    created_at: datetime
    updated_at: datetime


class Urutan(str, enum.Enum):
    """Nilai parameter `urut` pada GET /kegiatan."""

    terbaru = "terbaru"
    terlama = "terlama"


# ---------------------------------------------------------------------------
# Laporan
# ---------------------------------------------------------------------------


class KategoriTotal(BaseModel):
    kategori: str = Field(examples=["Makan"])
    total: int = Field(examples=[15000])


class RingkasanHari(BaseModel):
    """Ringkasan satu tanggal. Dipakai /laporan/rentang (satu item per hari)."""

    tanggal: date = Field(examples=["2026-10-06"])
    jumlah_kegiatan: int = Field(examples=[4])
    selesai: int = Field(description="Jumlah kegiatan yang sudah dicentang", examples=[2])
    pemasukan: int = Field(description="Rencana: semua pemasukan", examples=[50000])
    pengeluaran: int = Field(description="Rencana: semua pengeluaran", examples=[25000])
    tabungan: int = Field(description="pemasukan - pengeluaran", examples=[25000])
    pemasukan_selesai: int = Field(
        description="Realisasi: pemasukan yang sudah selesai", examples=[0]
    )
    pengeluaran_selesai: int = Field(
        description="Realisasi: pengeluaran yang sudah selesai", examples=[25000]
    )


class LaporanHarian(RingkasanHari):
    """Ringkasan satu tanggal + pengeluaran per kategori (terbesar dulu)."""

    per_kategori: list[KategoriTotal]
