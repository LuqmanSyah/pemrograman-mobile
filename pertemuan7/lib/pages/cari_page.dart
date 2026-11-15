import 'package:flutter/material.dart';

import '../data/db_helper.dart';
import '../models/kegiatan.dart';
import '../widgets/kegiatan_tile.dart';
import 'beranda_page.dart';

/// Pengembangan lanjutan: pencarian dan filter kegiatan di semua tanggal.
class CariPage extends StatefulWidget {
  const CariPage({super.key});
  @override
  State<CariPage> createState() => _CariPageState();
}

class _CariPageState extends State<CariPage> {
  final _kata = TextEditingController();
  TipeKeuangan? _tipe; // null = semua jenis
  String? _kategori; // null = semua kategori
  late Future<List<Kegiatan>> _future;

  @override
  void initState() {
    super.initState();
    _future = _ambil();
    versiData.addListener(_muat);
  }

  @override
  void dispose() {
    versiData.removeListener(_muat);
    _kata.dispose();
    super.dispose();
  }

  void _muat() {
    setState(() {
      _future = _ambil();
    });
  }

  Future<List<Kegiatan>> _ambil() =>
      DbHelper.cari(_kata.text.trim(), tipe: _tipe, kategori: _kategori);

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Cari kegiatan')),
    body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: Column(
            children: [
              TextField(
                controller: _kata,
                decoration: const InputDecoration(
                  labelText: 'Nama kegiatan',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) => _muat(),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<TipeKeuangan?>(
                      initialValue: _tipe,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Jenis',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        const DropdownMenuItem(
                          value: null,
                          child: Text('Semua'),
                        ),
                        for (final tipe in TipeKeuangan.values)
                          DropdownMenuItem(
                            value: tipe,
                            child: Text(labelTipe[tipe]!),
                          ),
                      ],
                      onChanged: (nilai) {
                        _tipe = nilai;
                        // Kategori hanya berlaku untuk pengeluaran.
                        if (nilai != TipeKeuangan.pengeluaran) _kategori = null;
                        _muat();
                      },
                    ),
                  ),
                  if (_tipe == TipeKeuangan.pengeluaran) ...[
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String?>(
                        initialValue: _kategori,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'Kategori',
                          border: OutlineInputBorder(),
                        ),
                        items: [
                          const DropdownMenuItem(
                            value: null,
                            child: Text('Semua'),
                          ),
                          for (final kategori in daftarKategori)
                            DropdownMenuItem(
                              value: kategori,
                              child: Text(kategori),
                            ),
                        ],
                        onChanged: (nilai) {
                          _kategori = nilai;
                          _muat();
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: FutureBuilder<List<Kegiatan>>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting &&
                  !snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Gagal mencari: ${snapshot.error}'));
              }
              final hasil = snapshot.data!;
              if (hasil.isEmpty) {
                return const Center(
                  child: Text('Tidak ada kegiatan yang cocok.'),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: hasil.length,
                itemBuilder: (context, i) {
                  final item = hasil[i];
                  return KegiatanTile(
                    item: item,
                    showDate: true,
                    onToggle: () async {
                      item.selesai = !item.selesai;
                      await DbHelper.simpan(item);
                    },
                    onEdit: () => Navigator.pushNamed(
                      context,
                      '/form-kegiatan',
                      arguments: FormKegiatanArguments(
                        item: item,
                        initialDate: item.tanggal,
                      ),
                    ),
                    onDelete: () => _hapus(item),
                  );
                },
              );
            },
          ),
        ),
      ],
    ),
  );

  Future<void> _hapus(Kegiatan item) async {
    final yakin = await konfirmasiHapus(context, item);
    if (yakin) await DbHelper.hapus(item.id!);
  }
}
