import 'package:flutter/material.dart';

import '../data/db_helper.dart';
import '../models/kegiatan.dart';
import '../state/pengaturan.dart';
import '../utils/format.dart';
import '../widgets/kegiatan_tile.dart';
import '../widgets/ringkasan_card.dart';

/// Data halaman Hari Ini dalam satu Future.
class DataHari {
  const DataHari(this.summary, this.activities);
  final Ringkasan summary;
  final List<Kegiatan> activities;
}

class BerandaPage extends StatefulWidget {
  const BerandaPage({super.key, required this.settings});
  final PengaturanState settings;
  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  final today = tanggal(DateTime.now());
  late Future<DataHari> data;

  @override
  void initState() {
    super.initState();
    data = _fetch();
    versiData.addListener(_reload);
  }

  @override
  void dispose() {
    versiData.removeListener(_reload);
    super.dispose();
  }

  void _reload() {
    setState(() {
      data = _fetch(); // Future baru -> FutureBuilder memuat ulang
    });
  }

  Future<DataHari> _fetch() async {
    final summary = await DbHelper.ringkasan(today);
    final activities = await DbHelper.pada(today);
    return DataHari(summary, activities);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('TabungKu'),
      actions: [
        IconButton(
          tooltip: 'Cari kegiatan',
          icon: const Icon(Icons.search),
          onPressed: () => Navigator.pushNamed(context, '/cari'),
        ),
      ],
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () => _openForm(),
      child: const Icon(Icons.add),
    ),
    body: FutureBuilder<DataHari>(
      future: data,
      builder: (context, snapshot) {
        // Spinner hanya saat data belum pernah ada, supaya saat memuat ulang
        // progress bar beranimasi dari nilai sebelumnya (tidak berkedip).
        if (snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Gagal memuat data: ${snapshot.error}'));
        }
        final summary = snapshot.data!.summary;
        final list = snapshot.data!.activities;
        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Ringkasan hari ini',
              style: Theme.of(context).textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            RingkasanCard(summary: summary, settings: widget.settings),
            const SizedBox(height: 20),
            Text(
              'Kegiatan',
              style: Theme.of(context).textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            if (list.isEmpty)
              const Padding(
                padding: EdgeInsets.all(32),
                child: Center(child: Text('Belum ada kegiatan hari ini.')),
              ),
            ...list.map(
              (item) => KegiatanTile(
                item: item,
                onToggle: () async {
                  item.selesai = !item.selesai;
                  await DbHelper.simpan(item);
                },
                onEdit: () => _openForm(item),
                onDelete: () => _delete(item),
              ),
            ),
          ],
        );
      },
    ),
  );

  Future<void> _openForm([Kegiatan? item]) async {
    await Navigator.pushNamed(
      context,
      '/form-kegiatan',
      arguments: FormKegiatanArguments(item: item, initialDate: today),
    );
  }

  Future<void> _delete(Kegiatan item) async {
    final confirmed = await konfirmasiHapus(context, item);
    if (confirmed) await DbHelper.hapus(item.id!);
  }
}

class FormKegiatanArguments {
  const FormKegiatanArguments({this.item, required this.initialDate});
  final Kegiatan? item;
  final String initialDate;
}
