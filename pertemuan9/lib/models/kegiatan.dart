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

  /// Badan JSON untuk POST/PUT ke API. Bedanya dengan [toMap] (SQLite):
  /// `selesai` berupa boolean dan `id` tidak dikirim karena sudah ada di URL.
  Map<String, Object?> toJson() => {
    'judul': judul,
    'tanggal': tanggal,
    'selesai': selesai,
    'tipe': tipe.name,
    'nominal': nominal,
    'kategori': kategori,
  };

  /// Membaca satu objek `KegiatanOut` dari API. Field `created_at` dan
  /// `updated_at` diabaikan karena belum dipakai aplikasi.
  factory Kegiatan.fromJson(Map<String, dynamic> j) => Kegiatan(
    id: j['id'] as int,
    judul: j['judul'] as String,
    tanggal: j['tanggal'] as String,
    selesai: j['selesai'] as bool,
    tipe: TipeKeuangan.values.byName(j['tipe'] as String),
    nominal: j['nominal'] as int,
    kategori: j['kategori'] as String,
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

  /// Membaca ringkasan dari `/laporan/harian` atau satu item `/laporan/rentang`.
  ///
  /// `pemasukan_selesai`/`pengeluaran_selesai` (realisasi) boleh tidak ada;
  /// nilainya dianggap 0. Field `tabungan` dari server tidak disimpan karena
  /// [tabungan] dihitung dengan rumus yang sama (masuk - keluar).
  factory Ringkasan.fromJson(Map<String, dynamic> j) => Ringkasan(
    jumlah: j['jumlah_kegiatan'] as int,
    selesai: j['selesai'] as int,
    masuk: j['pemasukan'] as int,
    keluar: j['pengeluaran'] as int,
    masukSelesai: j['pemasukan_selesai'] as int? ?? 0,
    keluarSelesai: j['pengeluaran_selesai'] as int? ?? 0,
  );

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
