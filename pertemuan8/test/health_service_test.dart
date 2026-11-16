import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:pertemuan8/config/api_config.dart';
import 'package:pertemuan8/services/health_service.dart';

const base = 'http://server-uji:8000';

void main() {
  group('cekServer', () {
    test('200: API dan database sehat', () async {
      final client = MockClient((req) async {
        expect(req.url.toString(), '$base/health');
        return http.Response(
          jsonEncode({
            'status': 'ok',
            'waktu_server': '2026-10-06T08:00:00',
            'database': 'ok',
            'mysql_version': '8.4.13',
          }),
          200,
        );
      });
      final s = await cekServer(base, client: client);
      expect(s.databaseOk, isTrue);
      expect(s.mysqlVersion, '8.4.13');
      expect(s.waktuServer, '2026-10-06T08:00:00');
      expect(s.detail, isNull);
    });

    test('503: API hidup, database mati (bukan galat jaringan)', () async {
      final client = MockClient(
        (req) async => http.Response(
          jsonEncode({
            'status': 'error',
            'waktu_server': '2026-10-06T08:00:00',
            'database': 'error',
            'mysql_version': null,
            'detail': "Can't connect to MySQL server on 'mysql'",
          }),
          503,
        ),
      );
      final s = await cekServer(base, client: client);
      expect(s.databaseOk, isFalse);
      expect(s.mysqlVersion, isNull);
      expect(s.detail, contains("Can't connect"));
    });

    test('kode lain (500) dianggap galat', () async {
      final client = MockClient((req) async => http.Response('gagal', 500));
      await expectLater(
        cekServer(base, client: client),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'pesan',
            contains('500'),
          ),
        ),
      );
    });
  });

  group('validasiApiUrl', () {
    test('menerima URL http/https yang sah', () {
      expect(validasiApiUrl('http://10.0.2.2:8000'), isNull);
      expect(validasiApiUrl('https://api.contoh.id'), isNull);
      expect(validasiApiUrl('  http://192.168.1.10:8000/  '), isNull);
    });

    test('menolak URL yang tidak sah', () {
      expect(validasiApiUrl(''), isNotNull);
      expect(validasiApiUrl('10.0.2.2:8000'), isNotNull);
      expect(validasiApiUrl('ftp://10.0.2.2'), isNotNull);
      expect(validasiApiUrl('http://'), isNotNull);
      expect(validasiApiUrl('http://host:8000/?a=1'), isNotNull);
    });

    test('rapikanApiUrl membuang spasi dan garis miring di akhir', () {
      expect(rapikanApiUrl(' http://host:8000// '), 'http://host:8000');
    });
  });
}
