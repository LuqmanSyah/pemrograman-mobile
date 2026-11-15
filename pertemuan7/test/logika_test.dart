import 'package:flutter_test/flutter_test.dart';
import 'package:pertemuan7/models/kegiatan.dart';
import 'package:pertemuan7/utils/format.dart';

void main() {
  group('format', () {
    test('rupiah memakai titik ribuan dan tanda minus', () {
      expect(rupiah(0), 'Rp 0');
      expect(rupiah(50000), 'Rp 50.000');
      expect(rupiah(1250000), 'Rp 1.250.000');
      expect(rupiah(-25000), '-Rp 25.000');
    });

    test('rupiahBertanda: + untuk pemasukan, - untuk pengeluaran', () {
      expect(rupiahBertanda(50000, masuk: true), '+ Rp 50.000');
      expect(rupiahBertanda(15000, masuk: false), '- Rp 15.000');
    });

    test('tanggal berformat yyyy-MM-dd', () {
      expect(tanggal(DateTime(2026, 3, 5)), '2026-03-05');
    });

    test('tujuhHariTerakhir mundur 7 hari dan melewati batas bulan', () {
      expect(tujuhHariTerakhir('2026-03-02'), [
        '2026-03-02',
        '2026-03-01',
        '2026-02-28',
        '2026-02-27',
        '2026-02-26',
        '2026-02-25',
        '2026-02-24',
      ]);
    });
  });

  group('Ringkasan', () {
    // Contoh skenario satu hari pada modul bagian 3.2.
    const contoh = Ringkasan(
      jumlah: 4,
      selesai: 2,
      masuk: 50000,
      keluar: 25000,
      masukSelesai: 0, // freelance belum selesai
      keluarSelesai: 25000, // makan + angkot sudah selesai
    );

    test('tabungan = pemasukan - pengeluaran (semua kegiatan)', () {
      expect(contoh.tabungan, 25000);
    });

    test('rencana vs realisasi hanya menghitung yang selesai', () {
      expect(contoh.tabunganRealisasi, -25000);
      expect(contoh.selisih, -50000);
    });

    test('ringkasan kosong bernilai 0', () {
      const kosong = Ringkasan();
      expect(kosong.tabungan, 0);
      expect(kosong.tabunganRealisasi, 0);
      expect(kosong.selisih, 0);
    });
  });

  test('Kegiatan toMap/fromMap bolak-balik', () {
    final asli = Kegiatan(
      id: 1,
      judul: 'Makan siang',
      tanggal: '2026-03-05',
      selesai: true,
      tipe: TipeKeuangan.pengeluaran,
      nominal: 15000,
      kategori: 'Makan',
    );
    final map = asli.toMap();
    expect(map['selesai'], 1);
    expect(map['tipe'], 'pengeluaran');

    final hasil = Kegiatan.fromMap(map);
    expect(hasil.judul, asli.judul);
    expect(hasil.selesai, isTrue);
    expect(hasil.tipe, TipeKeuangan.pengeluaran);
    expect(hasil.kategori, 'Makan');
  });
}
