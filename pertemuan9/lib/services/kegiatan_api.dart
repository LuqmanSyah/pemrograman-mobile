import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/kegiatan.dart';
import 'api_exception.dart';
import 'api_util.dart';

/// Pembungkus endpoint `/kegiatan` di TabungKu API.
///
/// [http.Client] diterima lewat konstruktor agar dapat diganti `MockClient`
/// saat pengujian, sehingga tes tidak membutuhkan server sungguhan.
/// Setiap respons di luar 2xx dilempar sebagai [ApiException].
class KegiatanApi {
  final http.Client _client;

  KegiatanApi({http.Client? client}) : _client = client ?? http.Client();

  static const _json = headerJson;

  Uri _uri(String path, [Map<String, String>? query]) => apiUri(path, query);

  http.Response _cek(http.Response res) => cekRespons(res);

  Kegiatan _satu(http.Response res) =>
      Kegiatan.fromJson(jsonDecode(res.body) as Map<String, dynamic>);

  /// GET /kegiatan, opsional difilter [tanggal] (`yyyy-MM-dd`).
  Future<List<Kegiatan>> daftar({String? tanggal}) async {
    final res = _cek(
      await _client
          .get(_uri('/kegiatan', {'tanggal': ?tanggal}))
          .timeout(batasWaktu),
    );
    final data = jsonDecode(res.body) as List<dynamic>;
    return data
        .map((e) => Kegiatan.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// POST /kegiatan. Mengembalikan data dari server (sudah berisi `id`).
  Future<Kegiatan> tambah(Kegiatan k) async {
    final res = _cek(
      await _client
          .post(_uri('/kegiatan'), headers: _json, body: jsonEncode(k.toJson()))
          .timeout(batasWaktu),
    );
    return _satu(res);
  }

  /// PUT /kegiatan/{id}: mengganti seluruh data. [k] wajib memiliki `id`.
  Future<Kegiatan> ubah(Kegiatan k) async {
    final id = k.id;
    if (id == null) {
      throw ArgumentError.value(k, 'k', 'Kegiatan belum memiliki id');
    }
    final res = _cek(
      await _client
          .put(
            _uri('/kegiatan/$id'),
            headers: _json,
            body: jsonEncode(k.toJson()),
          )
          .timeout(batasWaktu),
    );
    return _satu(res);
  }

  /// PATCH /kegiatan/{id}: hanya mengirim field `selesai`.
  Future<Kegiatan> setSelesai(int id, bool selesai) async {
    final res = _cek(
      await _client
          .patch(
            _uri('/kegiatan/$id'),
            headers: _json,
            body: jsonEncode({'selesai': selesai}),
          )
          .timeout(batasWaktu),
    );
    return _satu(res);
  }

  /// DELETE /kegiatan/{id}. Server membalas 204 tanpa badan.
  Future<void> hapus(int id) async {
    _cek(await _client.delete(_uri('/kegiatan/$id')).timeout(batasWaktu));
  }
}
