import 'package:flutter/material.dart';

import '../data/db_helper.dart';
import '../models/kegiatan.dart';
import '../utils/format.dart';

/// Data halaman Laporan dalam satu Future.
class DataLaporan {
  const DataLaporan(this.summary, this.categories, this.lastSevenDays);
  final Ringkasan summary;
  final Map<String, int> categories;
  final Map<String, Ringkasan> lastSevenDays;
}

class LaporanPage extends StatefulWidget {
  const LaporanPage({super.key});
  @override
  State<LaporanPage> createState() => _LaporanPageState();
}

class _LaporanPageState extends State<LaporanPage> {
  String date = tanggal(DateTime.now());
  late Future<DataLaporan> report;

  @override
  void initState() {
    super.initState();
    report = _fetch();
    versiData.addListener(_reload);
  }

  @override
  void dispose() {
    versiData.removeListener(_reload);
    super.dispose();
  }

  void _reload() {
    setState(() {
      report = _fetch();
    });
  }

  Future<DataLaporan> _fetch() async {
    final summary = await DbHelper.ringkasan(date);
    final categories = await DbHelper.perKategori(date);
    final lastSevenDays = await DbHelper.tujuhHari(date);
    return DataLaporan(summary, categories, lastSevenDays);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Laporan')),
    body: FutureBuilder<DataLaporan>(
      future: report,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Gagal memuat laporan: ${snapshot.error}'));
        }
        final colors = Theme.of(context).colorScheme;
        final summary = snapshot.data!.summary;
        final categories = snapshot.data!.categories;
        final lastSevenDays = snapshot.data!.lastSevenDays;
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
                      style: TextStyle(color: colors.error),
                    ),
                    Text(
                      'Tabungan ${rupiah(summary.tabungan)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: summary.tabungan < 0 ? colors.error : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            _planVsActualCard(summary),
            const SizedBox(height: 20),
            Text(
              'Pengeluaran per kategori',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            if (categories.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text('Belum ada pengeluaran pada tanggal ini.'),
              ),
            ...categories.entries.map(
              (entry) => ListTile(
                title: Text(entry.key),
                trailing: Text(rupiah(entry.value)),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '7 hari terakhir',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            ...lastSevenDays.entries.map(
              (entry) => _dayTile(entry.key, entry.value),
            ),
          ],
        );
      },
    ),
  );

  /// Pengembangan lanjutan: rencana (semua kegiatan) vs realisasi (hanya
  /// kegiatan yang sudah selesai).
  Widget _planVsActualCard(Ringkasan summary) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final diff = summary.selisih;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Rencana vs realisasi', style: theme.textTheme.titleMedium),
            Text(
              'Realisasi hanya menghitung kegiatan yang sudah selesai.',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            _compareRow('', 'Rencana', 'Realisasi', bold: true),
            _compareRow(
              'Pemasukan',
              rupiah(summary.masuk),
              rupiah(summary.masukSelesai),
            ),
            _compareRow(
              'Pengeluaran',
              rupiah(summary.keluar),
              rupiah(summary.keluarSelesai),
            ),
            _compareRow(
              'Tabungan',
              rupiah(summary.tabungan),
              rupiah(summary.tabunganRealisasi),
              bold: true,
            ),
            const Divider(),
            Text(
              'Selisih ${diff > 0 ? '+' : ''}${rupiah(diff)}'
              '${diff == 0 ? ' (sesuai rencana)' : ''}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: diff < 0 ? colors.error : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _compareRow(
    String label,
    String plan,
    String actual, {
    bool bold = false,
  }) {
    final style = TextStyle(fontWeight: bold ? FontWeight.bold : null);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(child: Text(label, style: style)),
          Expanded(
            child: Text(plan, style: style, textAlign: TextAlign.end),
          ),
          Expanded(
            child: Text(actual, style: style, textAlign: TextAlign.end),
          ),
        ],
      ),
    );
  }

  Widget _dayTile(String day, Ringkasan summary) {
    final colors = Theme.of(context).colorScheme;
    return ListTile(
      selected: day == date,
      title: Text(day),
      subtitle: Text(
        '${summary.jumlah} kegiatan • Masuk ${rupiah(summary.masuk)} • '
        'Keluar ${rupiah(summary.keluar)}',
      ),
      trailing: Text(
        rupiah(summary.tabungan),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: summary.tabungan < 0 ? colors.error : null,
        ),
      ),
      onTap: () => _changeDate(day),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      initialDate: DateTime.tryParse(date) ?? DateTime.now(),
    );
    if (!mounted || picked == null) return;
    _changeDate(tanggal(picked));
  }

  void _changeDate(String newDate) {
    date = newDate;
    _reload();
  }
}
