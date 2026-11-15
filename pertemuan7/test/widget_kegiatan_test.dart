import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pertemuan7/models/kegiatan.dart';
import 'package:pertemuan7/state/pengaturan.dart';
import 'package:pertemuan7/widgets/kegiatan_tile.dart';
import 'package:pertemuan7/widgets/ringkasan_card.dart';

Widget _bungkus(Widget anak) => MaterialApp(home: Scaffold(body: anak));

KegiatanTile _tile(Kegiatan item) =>
    KegiatanTile(item: item, onToggle: () {}, onEdit: () {}, onDelete: () {});

void main() {
  testWidgets('Pemasukan tampil hijau dengan tanda +', (tester) async {
    await tester.pumpWidget(
      _bungkus(
        _tile(
          Kegiatan(
            judul: 'Freelance',
            tanggal: '2026-03-05',
            tipe: TipeKeuangan.pemasukan,
            nominal: 50000,
          ),
        ),
      ),
    );

    final teks = tester.widget<Text>(find.text('+ Rp 50.000'));
    expect(teks.style?.color, Colors.green);
  });

  testWidgets('Pengeluaran tampil merah (error) dengan tanda -', (
    tester,
  ) async {
    await tester.pumpWidget(
      _bungkus(
        _tile(
          Kegiatan(
            judul: 'Makan siang',
            tanggal: '2026-03-05',
            tipe: TipeKeuangan.pengeluaran,
            nominal: 15000,
            kategori: 'Makan',
          ),
        ),
      ),
    );

    final konteks = tester.element(find.byType(KegiatanTile));
    final teks = tester.widget<Text>(find.text('- Rp 15.000 • Makan'));
    expect(teks.style?.color, Theme.of(konteks).colorScheme.error);
  });

  testWidgets('Kegiatan selesai judulnya tercoret', (tester) async {
    await tester.pumpWidget(
      _bungkus(
        _tile(Kegiatan(judul: 'Belajar', tanggal: '2026-03-05', selesai: true)),
      ),
    );

    final judul = tester.widget<Text>(find.text('Belajar'));
    expect(judul.style?.decoration, TextDecoration.lineThrough);
    expect(find.text('Tidak melibatkan uang'), findsOneWidget);
  });

  testWidgets('Tabungan negatif menampilkan peringatan', (tester) async {
    await tester.pumpWidget(
      _bungkus(
        RingkasanCard(
          summary: const Ringkasan(jumlah: 2, masuk: 10000, keluar: 30000),
          settings: PengaturanState(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('-Rp 20.000'), findsOneWidget);
    expect(find.text('Peringatan: tabungan negatif'), findsOneWidget);
  });

  testWidgets('Tabungan mencapai target memberi apresiasi', (tester) async {
    await tester.pumpWidget(
      _bungkus(
        RingkasanCard(
          summary: const Ringkasan(jumlah: 1, masuk: 50000),
          settings: PengaturanState(), // target bawaan Rp 20.000
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Target tercapai!'), findsOneWidget);
  });

  testWidgets('Konfirmasi hapus: Batal mengembalikan false', (tester) async {
    bool? hasil;
    await tester.pumpWidget(
      _bungkus(
        Builder(
          builder: (context) => TextButton(
            onPressed: () async {
              hasil = await konfirmasiHapus(
                context,
                Kegiatan(judul: 'Uji', tanggal: '2026-03-05'),
              );
            },
            child: const Text('buka'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('buka'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Batal'));
    await tester.pumpAndSettle();
    expect(hasil, isFalse);

    await tester.tap(find.text('buka'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Hapus'));
    await tester.pumpAndSettle();
    expect(hasil, isTrue);
  });
}
