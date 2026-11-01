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
  });
  final Kegiatan item;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      leading: Checkbox(value: item.selesai, onChanged: (_) => onToggle()),
      title: Text(
        item.judul,
        style: TextStyle(
          decoration: item.selesai ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: Text(
        item.tipe == TipeKeuangan.tanpa
            ? 'Tidak melibatkan uang'
            : '${item.tipe == TipeKeuangan.pemasukan ? '+' : '-'} ${rupiah(item.nominal)}${item.kategori == '-' ? '' : ' • ${item.kategori}'}',
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
