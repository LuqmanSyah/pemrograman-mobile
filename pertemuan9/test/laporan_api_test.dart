import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:pertemuan9/config/api_config.dart';
import 'package:pertemuan9/models/kegiatan.dart';
import 'package:pertemuan9/models/laporan.dart';
import 'package:pertemuan9/services/api_exception.dart';
import 'package:pertemuan9/services/laporan_api.dart';

const base = 'http://server-uji:8000';

/// Respons asli GET /laporan/harian?tanggal=2026-10-06 untuk data
/// "Contoh Skenario Satu Hari" modul 7.
const skenarioHarian = {
  'tanggal': '2026-10-06',
  'jumlah_kegiatan': 4,
  'selesai': 2,
  'pemasukan': 50000,
  'pengeluaran': 25000,
  'tabungan': 25000,
  'pemasukan_selesai': 0,
  'pengeluaran_selesai': 25000,
  'per_kategori': [
    {'kategori': 'Makan', 'total': 15000},
    {'kategori': 'Transport', 'total': 10000},
  ],
};

Map<String, Object?> hariKosong(String tanggal) => {
  'tanggal': tanggal,
  'jumlah_kegiatan': 0,
  'selesai': 0,
  'pemasukan': 0,
  'pengeluaran': 0,
  'tabungan': 0,
  'pemasukan_selesai': 0,
  'pengeluaran_selesai': 0,
};

http.Response jsonRes(Object? body, int kode) => http.Response(
  jsonEncode(body),
  kode,
  headers: {'content-type': 'application/json'},
);

void main() {
  setUp(() => apiUrl.value = base);

  group('Ringkasan.fromJson', () {
    test('memetakan nama field server ke Ringkasan', () {
      final r = Ringkasan.fromJson(skenarioHarian);
      expect(r.jumlah, 4);
      expect(r.selesai, 2);
      expect(r.masuk, 50000);
      expect(r.keluar, 25000);
      expect(r.tabungan, 25000);
      expect(r.masukSelesai, 0);
      expect(r.keluarSelesai, 25000);
      expect(r.tabunganRealisasi, -25000);
    });

    test('field realisasi yang tidak ada dianggap 0', () {
      final r = Ringkasan.fromJson({
        'jumlah_kegiatan': 1,
        'selesai': 0,
        'pemasukan': 10000,
        'pengeluaran': 0,
        'tabungan': 10000,
      });
      expect(r.masukSelesai, 0);
      expect(r.keluarSelesai, 0);
      expect(r.tabungan, 10000);
    });
  });

  group('LaporanHarian.fromJson', () {
    test('membaca tanggal, ringkasan, dan per_kategori berurutan', () {
      final l = LaporanHarian.fromJson(skenarioHarian);
      expect(l.tanggal, '2026-10-06');
      expect(l.ringkasan.jumlah, 4);
      expect(l.perKategori, {'Makan': 15000, 'Transport': 10000});
      expect(l.perKategori.keys.toList(), ['Makan', 'Transport']);
    });

    test('per_kategori kosong pada hari tanpa pengeluaran', () {
      final l = LaporanHarian.fromJson({
        ...hariKosong('2026-10-01'),
        'per_kategori': [],
      });
      expect(l.perKategori, isEmpty);
      expect(l.ringkasan.tabungan, 0);
    });
  });

  group('LaporanApi.harian', () {
    test(
      'GET /laporan/harian?tanggal=... dan hasil skenario modul 7',
      () async {
        final api = LaporanApi(
          client: MockClient((req) async {
            expect(req.method, 'GET');
            expect(req.url.path, '/laporan/harian');
            expect(req.url.queryParameters, {'tanggal': '2026-10-06'});
            return jsonRes(skenarioHarian, 200);
          }),
        );
        final l = await api.harian('2026-10-06');
        expect(l.ringkasan.jumlah, 4);
        expect(l.ringkasan.selesai, 2);
        expect(l.ringkasan.masuk, 50000);
        expect(l.ringkasan.keluar, 25000);
        expect(l.ringkasan.tabungan, 25000);
        expect(l.perKategori, {'Makan': 15000, 'Transport': 10000});
      },
    );

    test('422 format tanggal salah menjadi ApiException', () async {
      final api = LaporanApi(
        client: MockClient(
          (req) async => jsonRes({
            'detail': [
              {
                'type': 'date_from_datetime_parsing',
                'loc': ['query', 'tanggal'],
                'msg':
                    'Input should be a valid date or datetime, '
                    'invalid character in year',
              },
            ],
          }, 422),
        ),
      );
      await expectLater(
        api.harian('06-10-2026'),
        throwsA(
          isA<ApiException>()
              .having((e) => e.kode, 'kode', 422)
              .having((e) => e.pesan, 'pesan', contains('valid date')),
        ),
      );
    });
  });

  group('LaporanApi.rentang', () {
    test('mengirim mulai & sampai, hasil map tanggal -> Ringkasan', () async {
      final api = LaporanApi(
        client: MockClient((req) async {
          expect(req.url.path, '/laporan/rentang');
          expect(req.url.queryParameters, {
            'mulai': '2026-10-05',
            'sampai': '2026-10-07',
          });
          final hari6 = Map<String, Object?>.of(skenarioHarian)
            ..remove('per_kategori');
          return jsonRes([
            hariKosong('2026-10-05'),
            hari6,
            hariKosong('2026-10-07'),
          ], 200);
        }),
      );
      final hasil = await api.rentang('2026-10-05', '2026-10-07');
      expect(hasil.keys.toList(), ['2026-10-05', '2026-10-06', '2026-10-07']);
      expect(hasil['2026-10-05']!.jumlah, 0);
      expect(hasil['2026-10-06']!.tabungan, 25000);
      expect(hasil['2026-10-07']!.tabungan, 0);
    });

    test('400 rentang terbalik dibaca dari detail teks', () async {
      final api = LaporanApi(
        client: MockClient(
          (req) async => jsonRes({
            'detail': 'Tanggal sampai tidak boleh sebelum tanggal mulai',
          }, 400),
        ),
      );
      await expectLater(
        api.rentang('2026-10-08', '2026-10-05'),
        throwsA(
          isA<ApiException>()
              .having((e) => e.kode, 'kode', 400)
              .having((e) => e.pesan, 'pesan', contains('tidak boleh sebelum')),
        ),
      );
    });

    test('400 rentang lebih dari 31 hari', () async {
      final api = LaporanApi(
        client: MockClient(
          (req) async => jsonRes({
            'detail': 'Rentang maksimal 31 hari (diminta 32 hari)',
          }, 400),
        ),
      );
      await expectLater(
        api.rentang('2026-10-01', '2026-11-01'),
        throwsA(
          isA<ApiException>().having((e) => e.pesan, 'pesan', contains('31')),
        ),
      );
    });
  });
}
