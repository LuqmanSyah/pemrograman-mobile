import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BarangBelanja {
  final String nama;
  final int jumlah;
  final String kategori;
  bool sudahDibeli;

  BarangBelanja({
    required this.nama,
    required this.jumlah,
    required this.kategori,
    this.sudahDibeli = false,
  });
}

class BelanjaModel extends ChangeNotifier {
  final List<BarangBelanja> _items = [];
  List<BarangBelanja> get items => List.unmodifiable(_items);
  int get jumlahBelumDibeli =>
      _items.where((barang) => !barang.sudahDibeli).length;

  void tambah({
    required String nama,
    required int jumlah,
    required String kategori,
  }) {
    _items.add(BarangBelanja(nama: nama, jumlah: jumlah, kategori: kategori));
    notifyListeners();
  }

  void toggle(int index) {
    _items[index].sudahDibeli = !_items[index].sudahDibeli;
    notifyListeners();
  }

  void hapus(int index) {
    _items.removeAt(index);
    notifyListeners();
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(create: (_) => BelanjaModel(), child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daftar Belanja',
      theme: ThemeData(colorSchemeSeed: Colors.blue, useMaterial3: true),
      home: const DaftarBelanjaPage(),
    );
  }
}

class DaftarBelanjaPage extends StatelessWidget {
  const DaftarBelanjaPage({super.key});
  @override
  Widget build(BuildContext context) {
    final model = context.watch<BelanjaModel>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Belanja (${model.jumlahBelumDibeli} belum dibeli)'),
      ),
      body: model.items.isEmpty
          ? const Center(child: Text('Belum ada barang'))
          : ListView.builder(
              itemCount: model.items.length,
              itemBuilder: (context, i) {
                final barang = model.items[i];
                return ListTile(
                  leading: Checkbox(
                    value: barang.sudahDibeli,
                    onChanged: (_) => context.read<BelanjaModel>().toggle(i),
                  ),
                  title: Text(
                    barang.nama,
                    style: TextStyle(
                      decoration: barang.sudahDibeli
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  subtitle: Text('${barang.jumlah} x - ${barang.kategori}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => context.read<BelanjaModel>().hapus(i),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TambahBelanjaPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TambahBelanjaPage extends StatefulWidget {
  const TambahBelanjaPage({super.key});
  @override
  State<TambahBelanjaPage> createState() => _TambahBelanjaPageState();
}

class _TambahBelanjaPageState extends State<TambahBelanjaPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _jumlahController = TextEditingController();
  String? _kategori;

  static const _kategoriOptions = [
    'Makanan',
    'Minuman',
    'Kebutuhan rumah',
    'Kesehatan',
    'Lainnya',
  ];

  @override
  void dispose() {
    _namaController.dispose();
    _jumlahController.dispose();
    super.dispose();
  }

  void _simpan() {
    if (!_formKey.currentState!.validate()) return;
    context.read<BelanjaModel>().tambah(
      nama: _namaController.text.trim(),
      jumlah: int.parse(_jumlahController.text.trim()),
      kategori: _kategori!,
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Barang')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _namaController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Nama barang',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama barang wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _jumlahController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Jumlah',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final jumlah = int.tryParse(value?.trim() ?? '');
                  if (jumlah == null || jumlah <= 0) {
                    return 'Jumlah harus berupa angka lebih dari 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _kategori,
                decoration: const InputDecoration(
                  labelText: 'Kategori',
                  border: OutlineInputBorder(),
                ),
                items: _kategoriOptions
                    .map(
                      (kategori) => DropdownMenuItem(
                        value: kategori,
                        child: Text(kategori),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _kategori = value),
                validator: (value) =>
                    value == null ? 'Kategori wajib dipilih' : null,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _simpan,
                  child: const Text('Simpan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
