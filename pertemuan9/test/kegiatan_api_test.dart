import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:pertemuan9/config/api_config.dart';
import 'package:pertemuan9/models/kegiatan.dart';
import 'package:pertemuan9/services/api_exception.dart';
import 'package:pertemuan9/services/kegiatan_api.dart';

const base = 'http://server-uji:8000';

/// Contoh respons `KegiatanOut` dari FastAPI.
Map<String, Object?> jsonKegiatan({
  int id = 1,
  String judul = 'Makan siang',
  bool selesai = false,
  String tipe = 'pengeluaran',
  int nominal = 15000,
  String kategori = 'Makan',
}) => {
  'id': id,
  'judul': judul,
  'tanggal': '2026-10-06',
  'selesai': selesai,
  'tipe': tipe,
  'nominal': nominal,
  'kategori': kategori,
  'created_at': '2026-10-06T08:00:00',
  'updated_at': '2026-10-06T08:00:00',
};

http.Response jsonRes(Object? body, int kode) => http.Response(
  jsonEncode(body),
  kode,
  headers: {'content-type': 'application/json'},
);

void main() {
  setUp(() => apiUrl.value = base);

  group('Kegiatan JSON', () {
    test('fromJson membaca KegiatanOut (boolean dan enum)', () {
      final k = Kegiatan.fromJson(jsonKegiatan(selesai: true));
      expect(k.id, 1);
      expect(k.judul, 'Makan siang');
      expect(k.tanggal, '2026-10-06');
      expect(k.selesai, isTrue);
      expect(k.tipe, TipeKeuangan.pengeluaran);
      expect(k.nominal, 15000);
      expect(k.kategori, 'Makan');
    });

    test('toJson: selesai boolean, tanpa id', () {
      final k = Kegiatan(
        id: 7,
        judul: 'Uang saku',
        tanggal: '2026-10-06',
        selesai: true,
        tipe: TipeKeuangan.pemasukan,
        nominal: 50000,
      );
      expect(k.toJson(), {
        'judul': 'Uang saku',
        'tanggal': '2026-10-06',
        'selesai': true,
        'tipe': 'pemasukan',
        'nominal': 50000,
        'kategori': '-',
      });
      expect(k.toJson().containsKey('id'), isFalse);
    });

    test('toJson lalu fromJson menghasilkan data yang sama', () {
      final asli = Kegiatan.fromJson(jsonKegiatan());
      final ulang = Kegiatan.fromJson({...asli.toJson(), 'id': asli.id});
      expect(ulang.toMap(), asli.toMap());
    });
  });

  group('KegiatanApi', () {
    test('daftar() tanpa filter tidak menambah query', () async {
      final api = KegiatanApi(
        client: MockClient((req) async {
          expect(req.method, 'GET');
          expect(req.url.toString(), '$base/kegiatan');
          return jsonRes([jsonKegiatan(), jsonKegiatan(id: 2)], 200);
        }),
      );
      final hasil = await api.daftar();
      expect(hasil.map((k) => k.id), [1, 2]);
    });

    test('daftar(tanggal) mengirim filter tanggal di URL', () async {
      final api = KegiatanApi(
        client: MockClient((req) async {
          expect(req.url.path, '/kegiatan');
          expect(req.url.queryParameters, {'tanggal': '2026-10-06'});
          return jsonRes([jsonKegiatan()], 200);
        }),
      );
      final hasil = await api.daftar(tanggal: '2026-10-06');
      expect(hasil, hasLength(1));
      expect(hasil.first.judul, 'Makan siang');
    });

    test('tambah() mengirim POST berisi JSON', () async {
      final api = KegiatanApi(
        client: MockClient((req) async {
          expect(req.method, 'POST');
          expect(req.url.toString(), '$base/kegiatan');
          expect(req.headers['Content-Type'], startsWith('application/json'));
          final body = jsonDecode(req.body) as Map<String, dynamic>;
          expect(body, {
            'judul': 'Makan siang',
            'tanggal': '2026-10-06',
            'selesai': false,
            'tipe': 'pengeluaran',
            'nominal': 15000,
            'kategori': 'Makan',
          });
          return jsonRes(jsonKegiatan(id: 10), 201);
        }),
      );
      final baru = await api.tambah(
        Kegiatan(
          judul: 'Makan siang',
          tanggal: '2026-10-06',
          tipe: TipeKeuangan.pengeluaran,
          nominal: 15000,
          kategori: 'Makan',
        ),
      );
      expect(baru.id, 10);
    });

    test('ubah() mengirim PUT ke /kegiatan/{id}', () async {
      final api = KegiatanApi(
        client: MockClient((req) async {
          expect(req.method, 'PUT');
          expect(req.url.toString(), '$base/kegiatan/3');
          final body = jsonDecode(req.body) as Map<String, dynamic>;
          expect(body['judul'], 'Makan malam');
          expect(body.containsKey('id'), isFalse);
          return jsonRes(jsonKegiatan(id: 3, judul: 'Makan malam'), 200);
        }),
      );
      final k = Kegiatan.fromJson(jsonKegiatan(id: 3))..judul = 'Makan malam';
      final hasil = await api.ubah(k);
      expect(hasil.judul, 'Makan malam');
    });

    test('ubah() menolak kegiatan tanpa id', () {
      final api = KegiatanApi(
        client: MockClient((_) async => fail('tidak boleh memanggil server')),
      );
      expect(
        () => api.ubah(Kegiatan(judul: 'x', tanggal: '2026-10-06')),
        throwsArgumentError,
      );
    });

    test('setSelesai() mengirim PATCH yang hanya berisi selesai', () async {
      final api = KegiatanApi(
        client: MockClient((req) async {
          expect(req.method, 'PATCH');
          expect(req.url.toString(), '$base/kegiatan/1');
          expect(jsonDecode(req.body), {'selesai': true});
          return jsonRes(jsonKegiatan(selesai: true), 200);
        }),
      );
      final hasil = await api.setSelesai(1, true);
      expect(hasil.selesai, isTrue);
    });

    test('hapus() mengirim DELETE dan menerima 204', () async {
      var dipanggil = false;
      final api = KegiatanApi(
        client: MockClient((req) async {
          dipanggil = true;
          expect(req.method, 'DELETE');
          expect(req.url.toString(), '$base/kegiatan/2');
          return http.Response('', 204);
        }),
      );
      await api.hapus(2);
      expect(dipanggil, isTrue);
    });

    test('memakai alamat terbaru dari apiUrl', () async {
      apiUrl.value = 'http://192.168.1.10:8000';
      final api = KegiatanApi(
        client: MockClient((req) async {
          expect(req.url.toString(), 'http://192.168.1.10:8000/kegiatan');
          return jsonRes([], 200);
        }),
      );
      expect(await api.daftar(), isEmpty);
    });
  });

  group('ApiException', () {
    test(
      '422: pesan dibaca dari detail[].msg tanpa awalan Value error',
      () async {
        final api = KegiatanApi(
          client: MockClient(
            (req) async => jsonRes({
              'detail': [
                {
                  'type': 'value_error',
                  'loc': ['body'],
                  'msg':
                      'Value error, nominal wajib lebih dari 0 untuk '
                      'pemasukan/pengeluaran',
                },
              ],
            }, 422),
          ),
        );
        await expectLater(
          api.setSelesai(1, true),
          throwsA(
            isA<ApiException>()
                .having((e) => e.kode, 'kode', 422)
                .having(
                  (e) => e.pesan,
                  'pesan',
                  'nominal wajib lebih dari 0 untuk pemasukan/pengeluaran',
                ),
          ),
        );
      },
    );

    test('422 dengan beberapa galat digabung per baris', () {
      final e = ApiException.dariRespons(
        jsonRes({
          'detail': [
            {
              'loc': ['body', 'judul'],
              'msg': 'Value error, judul wajib diisi',
            },
            {
              'loc': ['body', 'tanggal'],
              'msg': 'Input should be a valid date or datetime',
            },
          ],
        }, 422),
      );
      expect(
        e.pesan,
        'judul wajib diisi\nInput should be a valid date or datetime',
      );
    });

    test('404: detail berupa teks', () async {
      final api = KegiatanApi(
        client: MockClient(
          (req) async => jsonRes({'detail': 'Kegiatan tidak ditemukan'}, 404),
        ),
      );
      await expectLater(
        api.hapus(99),
        throwsA(
          isA<ApiException>()
              .having((e) => e.kode, 'kode', 404)
              .having(
                (e) => e.toString(),
                'toString',
                'Kegiatan tidak ditemukan',
              ),
        ),
      );
    });

    test('badan bukan JSON memakai pesan bawaan', () {
      final e = ApiException.dariRespons(
        http.Response('<html>502 Bad Gateway</html>', 502),
      );
      expect(e.kode, 502);
      expect(e.pesan, 'Server membalas kode 502');
    });
  });
}
