import 'package:flutter/material.dart';

import '../data/db_helper.dart';
import '../models/kegiatan.dart';
import '../state/pengaturan.dart';
import '../utils/format.dart';
import '../widgets/kegiatan_tile.dart';
import '../widgets/ringkasan_card.dart';

class BerandaPage extends StatefulWidget {
  const BerandaPage({super.key, required this.settings});
  final PengaturanState settings;
  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  final today = tanggal(DateTime.now());
  late Future<List<Kegiatan>> activities;
  late Future<Ringkasan> report;

  @override
  void initState() {
    super.initState();
    _reload();
    versiData.addListener(_reload);
  }

  @override
  void dispose() {
    versiData.removeListener(_reload);
    super.dispose();
  }

  void _reload() {
    activities = DbHelper.pada(today);
    report = DbHelper.ringkasan(today);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('TabungKu')),
    floatingActionButton: FloatingActionButton(
      onPressed: () => _openForm(),
      child: const Icon(Icons.add),
    ),
    body: FutureBuilder(
      future: Future.wait([report, activities]),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return const Center(child: CircularProgressIndicator());
        final summary = snapshot.data![0] as Ringkasan;
        final list = snapshot.data![1] as List<Kegiatan>;
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
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus kegiatan?'),
        content: Text(item.judul),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (confirmed == true) await DbHelper.hapus(item.id!);
  }
}

class FormKegiatanArguments {
  const FormKegiatanArguments({this.item, required this.initialDate});
  final Kegiatan? item;
  final String initialDate;
}
