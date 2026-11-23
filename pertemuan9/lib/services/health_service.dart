import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';

/// Hasil GET /health. Bila objek ini ada, berarti API dapat dihubungi;
/// kondisi database dibaca dari [databaseOk].
class StatusServer {
  final bool databaseOk;
  final String waktuServer;
  final String? mysqlVersion;

  /// Pesan galat database dari server (hanya terisi bila kode 503).
  final String? detail;
  final Duration latensi;

  const StatusServer({
    required this.databaseOk,
    required this.waktuServer,
    required this.latensi,
    this.mysqlVersion,
    this.detail,
  });
}

/// Memanggil GET [baseUrl]/health dan mengukur lama responsnya.
///
/// - 200: API dan database sehat.
/// - 503: API hidup, database mati; tetap mengembalikan [StatusServer]
///   dengan `databaseOk == false`, bukan dianggap galat jaringan.
/// - Kode lain atau galat jaringan: melempar [Exception].
Future<StatusServer> cekServer(String baseUrl, {http.Client? client}) async {
  final c = client ?? http.Client();
  final jam = Stopwatch()..start();
  try {
    final res = await c.get(Uri.parse('$baseUrl/health')).timeout(batasWaktu);
    jam.stop();
    if (res.statusCode != 200 && res.statusCode != 503) {
      throw Exception('Server membalas kode ${res.statusCode}');
    }
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    return StatusServer(
      databaseOk: res.statusCode == 200 && data['database'] == 'ok',
      waktuServer: data['waktu_server'] as String,
      mysqlVersion: data['mysql_version'] as String?,
      detail: data['detail'] as String?,
      latensi: jam.elapsed,
    );
  } finally {
    if (client == null) c.close();
  }
}
