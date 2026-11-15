import 'package:flutter/material.dart';

import '../data/db_helper.dart';
import '../models/kegiatan.dart';
import '../utils/format.dart';

class LaporanPage extends StatefulWidget {
  const LaporanPage({super.key});
  @override
  State<LaporanPage> createState() => _LaporanPageState();
}

class _LaporanPageState extends State<LaporanPage> {
  String date = tanggal(DateTime.now());

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Laporan')),
    body: FutureBuilder(
      future: Future.wait([
        DbHelper.ringkasan(date),
        DbHelper.perKategori(date),
      ]),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return const Center(child: CircularProgressIndicator());
        final summary = snapshot.data![0] as Ringkasan;
        final categories = snapshot.data![1] as Map<String, int>;
        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('Tanggal $date'),
              trailing: IconButton(
                icon: const Icon(Icons.calendar_month),
                onPressed: _pickDate,
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${summary.selesai}/${summary.jumlah} kegiatan selesai',
                    ),
                    Text(
                      'Pemasukan ${rupiah(summary.masuk)}',
                      style: const TextStyle(color: Colors.green),
                    ),
                    Text(
                      'Pengeluaran ${rupiah(summary.keluar)}',
                      style: const TextStyle(color: Colors.red),
                    ),
                    Text(
                      'Tabungan ${rupiah(summary.tabungan)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Pengeluaran per kategori',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            ...categories.entries.map(
              (entry) => ListTile(
                title: Text(entry.key),
                trailing: Text(rupiah(entry.value)),
              ),
            ),
          ],
        );
      },
    ),
  );

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      initialDate: DateTime.tryParse(date) ?? DateTime.now(),
    );
    if (picked != null) setState(() => date = tanggal(picked));
  }
}
