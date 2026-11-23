import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import 'api_exception.dart';

/// Header untuk permintaan yang membawa badan JSON.
const headerJson = {'Content-Type': 'application/json'};

/// Menyusun URL dari alamat API aktif ([apiUrl]) dan [path].
///
/// Map kosong tidak dikirim ke `replace`, karena `queryParameters: {}`
/// menghasilkan URL berakhiran `?` (misalnya `/kegiatan?`).
Uri apiUri(String path, [Map<String, String>? query]) =>
    Uri.parse('${apiUrl.value}$path')
        .replace(queryParameters: (query?.isEmpty ?? true) ? null : query);

/// Mengembalikan [res] bila kodenya 2xx; selain itu melempar [ApiException].
http.Response cekRespons(http.Response res) {
  if (res.statusCode < 200 || res.statusCode >= 300) {
    throw ApiException.dariRespons(res);
  }
  return res;
}
