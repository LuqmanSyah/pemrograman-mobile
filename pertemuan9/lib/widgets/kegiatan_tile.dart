import 'package:flutter/material.dart';

import '../models/kegiatan.dart';
import '../utils/format.dart';

class KegiatanTile extends StatelessWidget {
  const KegiatanTile({
    super.key,
    required this.item,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
    this.showDate = false,
  });
  final Kegiatan item;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  /// Tampilkan tanggal di bawah judul (dipakai di halaman pencarian).
  final bool showDate;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final income = item.tipe == TipeKeuangan.pemasukan;
    return Card(
      child: ListTile(
        leading: Checkbox(value: item.selesai, onChanged: (_) => onToggle()),
        title: Text(
          item.judul,
          style: TextStyle(
            decoration: item.selesai ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showDate) Text(item.tanggal),
            if (item.tipe == TipeKeuangan.tanpa)
              const Text('Tidak melibatkan uang')
            else
              Text(
                '${rupiahBertanda(item.nominal, masuk: income)}'
                '${item.kategori == '-' ? '' : ' • ${item.kategori}'}',
                style: TextStyle(
                  // Hijau/merah sebagai warna semantik pemasukan/pengeluaran.
                  color: income ? Colors.green : colors.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) => value == 'edit' ? onEdit() : onDelete(),
          itemBuilder: (_) => const [
            PopupMenuItem(value: 'edit', child: Text('Ubah')),
            PopupMenuItem(value: 'delete', child: Text('Hapus')),
          ],
        ),
      ),
    );
  }
}

/// Dialog konfirmasi hapus yang dipakai di Beranda dan halaman Cari.
/// Mengembalikan true hanya bila pengguna menekan Hapus.
Future<bool> konfirmasiHapus(BuildContext context, Kegiatan item) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
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
  return confirmed == true;
}
