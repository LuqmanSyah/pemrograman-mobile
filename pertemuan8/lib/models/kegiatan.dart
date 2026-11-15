enum TipeKeuangan { tanpa, pemasukan, pengeluaran }

const labelTipe = {
  TipeKeuangan.tanpa: 'Tidak melibatkan uang',
  TipeKeuangan.pemasukan: 'Pemasukan',
  TipeKeuangan.pengeluaran: 'Pengeluaran',
};

const daftarKategori = ['Makan', 'Transport', 'Belajar', 'Hiburan', 'Lainnya'];

class Kegiatan {
  Kegiatan({
    this.id,
    required this.judul,
    required this.tanggal,
    this.selesai = false,
    this.tipe = TipeKeuangan.tanpa,
    this.nominal = 0,
    this.kategori = '-',
  });

  final int? id;
  String judul;
  String tanggal;
  bool selesai;
  TipeKeuangan tipe;
  int nominal;
  String kategori;

  Map<String, Object?> toMap() => {
    'id': id,
    'judul': judul,
    'tanggal': tanggal,
    'selesai': selesai ? 1 : 0,
    'tipe': tipe.name,
    'nominal': nominal,
    'kategori': kategori,
  };

  factory Kegiatan.fromMap(Map<String, Object?> map) => Kegiatan(
    id: map['id'] as int,
    judul: map['judul'] as String,
    tanggal: map['tanggal'] as String,
    selesai: map['selesai'] == 1,
    tipe: TipeKeuangan.values.byName(map['tipe'] as String),
    nominal: map['nominal'] as int,
    kategori: map['kategori'] as String,
  );
}

class Ringkasan {
  const Ringkasan({
    this.jumlah = 0,
    this.selesai = 0,
    this.masuk = 0,
    this.keluar = 0,
    this.masukSelesai = 0,
    this.keluarSelesai = 0,
  });
  final int jumlah;
  final int selesai;

  // Rencana: semua kegiatan pada tanggal itu (aturan bisnis utama).
  final int masuk;
  final int keluar;

  // Realisasi: hanya kegiatan yang sudah dicentang selesai.
  final int masukSelesai;
  final int keluarSelesai;

  int get tabungan => masuk - keluar;
  int get tabunganRealisasi => masukSelesai - keluarSelesai;

  /// Positif berarti realisasi lebih baik dari rencana.
  int get selisih => tabunganRealisasi - tabungan;
}
