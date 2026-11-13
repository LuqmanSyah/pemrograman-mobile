import 'package:flutter/material.dart';

void main() {
  runApp(const TabungKuApp());
}

// model riwayat, jumlah negatif = penarikan
class Riwayat {
  final String keterangan;
  final String waktu;
  final int jumlah;

  const Riwayat({
    required this.keterangan,
    required this.waktu,
    required this.jumlah,
  });
}

// data transaksi statis (hard-coded)
const riwayatTerbaru = [
  Riwayat(
    keterangan: 'Sisa uang jajan',
    waktu: '12 November 2026',
    jumlah: 50000,
  ),
  Riwayat(
    keterangan: 'Bayar iuran himpunan',
    waktu: '9 November 2026',
    jumlah: -30000,
  ),
  Riwayat(
    keterangan: 'Honor asisten lab',
    waktu: '4 November 2026',
    jumlah: 400000,
  ),
  Riwayat(
    keterangan: 'Ongkos pulang kampung',
    waktu: '31 Oktober 2026',
    jumlah: -120000,
  ),
];

// data kartu saldo
const judulTabungan = 'Dana Darurat';
const saldo = 1840000;
const target = 5000000;

// format ribuan, 1840000 -> Rp 1.840.000
String formatRupiah(int angka) {
  final teks = angka.toString();
  var hasil = '';
  for (var i = 0; i < teks.length; i++) {
    final sisa = teks.length - i;
    hasil += teks[i];
    if (sisa > 1 && sisa % 3 == 1) hasil += '.';
  }
  return 'Rp $hasil';
}

// root aplikasi
class TabungKuApp extends StatelessWidget {
  const TabungKuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TabungKu',
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const RingkasanPage(),
    );
  }
}

// halaman utama
class RingkasanPage extends StatelessWidget {
  const RingkasanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ringkasan Tabungan')),
      // bisa di-scroll agar tidak overflow
      body: SingleChildScrollView(
        // lebar maks 600 agar rapi di tablet
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            // jarak dari tepi layar
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // kartu saldo
                  const KartuSaldo(),
                  const SizedBox(height: 20),
                  // tombol kategori
                  const MenuKategori(),
                  const SizedBox(height: 28),
                  // riwayat transaksi
                  const Text(
                    'Riwayat Terbaru',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  for (final r in riwayatTerbaru) BarisRiwayat(data: r),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// kartu saldo: nama, saldo, target
class KartuSaldo extends StatelessWidget {
  const KartuSaldo({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(0),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ikon + nama tabungan
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.shield_outlined,
                    color: Colors.indigo,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    judulTabungan,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            // saldo
            Text(
              formatRupiah(saldo),
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            const Text('saldo saat ini', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 16),
            // garis pemisah
            Container(height: 1, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            // target dan kekurangan
            Row(
              children: [
                Expanded(
                  child: InfoKecil(
                    judul: 'Target',
                    nilai: formatRupiah(target),
                  ),
                ),
                Expanded(
                  child: InfoKecil(
                    judul: 'Kurang',
                    nilai: formatRupiah(target - saldo),
                    rataKanan: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// label kecil + nilai
class InfoKecil extends StatelessWidget {
  final String judul;
  final String nilai;
  final bool rataKanan;

  const InfoKecil({
    super.key,
    required this.judul,
    required this.nilai,
    this.rataKanan = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: rataKanan
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(judul, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 2),
        Text(nilai, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}

// baris tiga tombol kategori
class MenuKategori extends StatelessWidget {
  const MenuKategori({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: TombolKategori(ikon: Icons.savings, label: 'Menabung'),
        ),
        SizedBox(width: 10),
        Expanded(
          child: TombolKategori(ikon: Icons.output, label: 'Tarik'),
        ),
        SizedBox(width: 10),
        Expanded(
          child: TombolKategori(ikon: Icons.receipt_long, label: 'Riwayat'),
        ),
      ],
    );
  }
}

// satu tombol: ikon + label
class TombolKategori extends StatelessWidget {
  final IconData ikon;
  final String label;

  const TombolKategori({super.key, required this.ikon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76,
      decoration: BoxDecoration(
        color: Colors.indigo.shade50,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(ikon, color: Colors.indigo),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }
}

// satu item riwayat: ikon, judul, tanggal, nominal
class BarisRiwayat extends StatelessWidget {
  final Riwayat data;

  const BarisRiwayat({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final setor = data.jumlah > 0;
    final nominal = formatRupiah(data.jumlah.abs());

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 18),
        leading: Icon(
          setor ? Icons.add_circle : Icons.remove_circle,
          color: setor ? Colors.teal : Colors.deepOrange,
          size: 32,
        ),
        title: Text(data.keterangan),
        subtitle: Text(data.waktu),
        trailing: Text(
          setor ? nominal : '- $nominal',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: setor ? Colors.teal : Colors.deepOrange,
          ),
        ),
      ),
    );
  }
}
