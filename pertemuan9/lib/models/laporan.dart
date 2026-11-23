import 'kegiatan.dart';

/// Hasil GET /laporan/harian.
class LaporanHarian {
  const LaporanHarian({
    required this.tanggal,
    required this.ringkasan,
    this.perKategori = const {},
  });

  /// Tanggal laporan (`yyyy-MM-dd`).
  final String tanggal;
  final Ringkasan ringkasan;

  /// Pengeluaran per kategori, urut dari terbesar (urutan dari server
  /// dipertahankan karena `Map` literal Dart menjaga urutan penyisipan).
  final Map<String, int> perKategori;

  factory LaporanHarian.fromJson(Map<String, dynamic> j) => LaporanHarian(
    tanggal: j['tanggal'] as String,
    ringkasan: Ringkasan.fromJson(j),
    perKategori: {
      for (final e in j['per_kategori'] as List<dynamic>)
        (e as Map<String, dynamic>)['kategori'] as String: e['total'] as int,
    },
  );
}
