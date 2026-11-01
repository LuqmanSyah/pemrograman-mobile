import 'package:flutter/material.dart';

import '../data/db_helper.dart';
import '../models/kegiatan.dart';
import '../utils/format.dart';

class FormKegiatanPage extends StatefulWidget {
  const FormKegiatanPage({super.key, this.item, required this.initialDate});
  final Kegiatan? item;
  final String initialDate;
  @override
  State<FormKegiatanPage> createState() => _FormKegiatanPageState();
}

class _FormKegiatanPageState extends State<FormKegiatanPage> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController title;
  late final TextEditingController amount;
  late String date;
  late TipeKeuangan type;
  late String category;
  final categories = ['Makan', 'Transport', 'Belajar', 'Hiburan', 'Lainnya'];

  @override
  void initState() {
    super.initState();
    final item = widget.item;
    title = TextEditingController(text: item?.judul);
    amount = TextEditingController(
      text: item == null || item.nominal == 0 ? '' : item.nominal.toString(),
    );
    date = item?.tanggal ?? widget.initialDate;
    type = item?.tipe ?? TipeKeuangan.tanpa;
    category = item?.kategori == '-' ? 'Makan' : item?.kategori ?? 'Makan';
  }

  @override
  void dispose() {
    title.dispose();
    amount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(widget.item == null ? 'Tambah kegiatan' : 'Ubah kegiatan'),
    ),
    body: Form(
      key: formKey,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextFormField(
            controller: title,
            decoration: const InputDecoration(
              labelText: 'Nama kegiatan',
              border: OutlineInputBorder(),
            ),
            validator: (value) => value == null || value.trim().isEmpty
                ? 'Nama wajib diisi'
                : null,
          ),
          const SizedBox(height: 14),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text('Tanggal: $date'),
            trailing: const Icon(Icons.calendar_month),
            onTap: _pickDate,
          ),
          DropdownButtonFormField<TipeKeuangan>(
            initialValue: type,
            decoration: const InputDecoration(
              labelText: 'Jenis keuangan',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(
                value: TipeKeuangan.tanpa,
                child: Text('Tidak melibatkan uang'),
              ),
              DropdownMenuItem(
                value: TipeKeuangan.pemasukan,
                child: Text('Pemasukan'),
              ),
              DropdownMenuItem(
                value: TipeKeuangan.pengeluaran,
                child: Text('Pengeluaran'),
              ),
            ],
            onChanged: (value) => setState(() => type = value!),
          ),
          if (type != TipeKeuangan.tanpa) ...[
            const SizedBox(height: 14),
            TextFormField(
              controller: amount,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Nominal (Rp)',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                final number = int.tryParse(value ?? '');
                return number == null || number <= 0
                    ? 'Nominal harus lebih dari 0'
                    : null;
              },
            ),
          ],
          if (type == TipeKeuangan.pengeluaran) ...[
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              initialValue: category,
              decoration: const InputDecoration(
                labelText: 'Kategori',
                border: OutlineInputBorder(),
              ),
              items: categories
                  .map(
                    (item) => DropdownMenuItem(value: item, child: Text(item)),
                  )
                  .toList(),
              onChanged: (value) => setState(() => category = value!),
            ),
          ],
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.save),
            label: const Text('Simpan'),
          ),
        ],
      ),
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

  Future<void> _save() async {
    if (!formKey.currentState!.validate()) return;
    await DbHelper.simpan(
      Kegiatan(
        id: widget.item?.id,
        judul: title.text.trim(),
        tanggal: date,
        selesai: widget.item?.selesai ?? false,
        tipe: type,
        nominal: type == TipeKeuangan.tanpa ? 0 : int.parse(amount.text),
        kategori: type == TipeKeuangan.pengeluaran ? category : '-',
      ),
    );
    if (mounted) Navigator.pop(context);
  }
}
