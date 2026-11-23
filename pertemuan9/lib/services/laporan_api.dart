import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/kegiatan.dart';
import '../models/laporan.dart';
import 'api_exception.dart';
import 'api_util.dart';

/// Pembungkus endpoint `/laporan` di TabungKu API.
///
/// Seperti `KegiatanApi`, [http.Client] dapat diganti `MockClient` saat
/// pengujian dan respons di luar 2xx dilempar sebagai [ApiException]
/// (misalnya 400 untuk rentang terbalik atau lebih dari 31 hari).
class LaporanApi {
  final http.Client _client;

  LaporanApi({http.Client? client}) : _client = client ?? http.Client();

  /// GET /laporan/harian?tanggal=[tanggal] (`yyyy-MM-dd`).
  Future<LaporanHarian> harian(String tanggal) async {
    final res = cekRespons(
      await _client
          .get(apiUri('/laporan/harian', {'tanggal': tanggal}))
          .timeout(batasWaktu),
    );
    return LaporanHarian.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }

  /// GET /laporan/rentang?mulai=[mulai]&sampai=[sampai].
  ///
  /// Mengembalikan map tanggal -> [Ringkasan] untuk setiap hari dalam rentang
  /// (urut naik, hari tanpa kegiatan bernilai 0). Bentuknya sama dengan
  /// `DbHelper.tujuhHari()` agar mudah dipakai halaman Laporan.
  Future<Map<String, Ringkasan>> rentang(String mulai, String sampai) async {
    final res = cekRespons(
      await _client
          .get(apiUri('/laporan/rentang', {'mulai': mulai, 'sampai': sampai}))
          .timeout(batasWaktu),
    );
    final data = jsonDecode(res.body) as List<dynamic>;
    return {
      for (final e in data.cast<Map<String, dynamic>>())
        e['tanggal'] as String: Ringkasan.fromJson(e),
    };
  }
}
