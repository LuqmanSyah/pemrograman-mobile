import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

const kategoriPengeluaran = ['Makanan', 'Transportasi', 'Belanja', 'Lainnya'];

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _gelap = false;

  @override
  void initState() {
    super.initState();
    _muatTema();
  }

  Future<void> _muatTema() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() => _gelap = prefs.getBool('gelap') ?? false);
  }

  Future<void> _ubahTema(bool nilai) async {
    setState(() => _gelap = nilai);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('gelap', nilai);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pencatat Pengeluaran',
      theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.teal,
        useMaterial3: true,
      ),
      themeMode: _gelap ? ThemeMode.dark : ThemeMode.light,
      home: PengeluaranPage(gelap: _gelap, onTemaChanged: _ubahTema),
    );
  }
}

class Pengeluaran {
  final int? id;
  final String nama;
  final int jumlah;
  final String kategori;
  final String tanggal;

  const Pengeluaran({
    this.id,
    required this.nama,
    required this.jumlah,
    required this.kategori,
    required this.tanggal,
  });

  Map<String, Object?> toMap() => {
    'id': id,
    'nama': nama,
    'jumlah': jumlah,
    'kategori': kategori,
    'tanggal': tanggal,
  };

  factory Pengeluaran.fromMap(Map<String, Object?> map) => Pengeluaran(
    id: map['id'] as int,
    nama: map['nama'] as String,
    jumlah: map['jumlah'] as int,
    kategori: map['kategori'] as String,
    tanggal: map['tanggal'] as String,
  );
}

class DbHelper {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    final path = p.join(await getDatabasesPath(), 'pengeluaran.db');
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) => db.execute(
        'CREATE TABLE pengeluaran('
        'id INTEGER PRIMARY KEY AUTOINCREMENT, '
        'nama TEXT NOT NULL, '
        'jumlah INTEGER NOT NULL, '
        'kategori TEXT NOT NULL, '
        'tanggal TEXT NOT NULL)',
      ),
    );
    return _db!;
  }

  static Future<List<Pengeluaran>> semua() async {
    final db = await database;
    final rows = await db.query(
      'pengeluaran',
      orderBy: 'tanggal DESC, id DESC',
    );
    return rows.map(Pengeluaran.fromMap).toList();
  }

  static Future<int> tambah(Pengeluaran data) async {
    final db = await database;
    return db.insert('pengeluaran', data.toMap());
  }

  static Future<int> ubah(Pengeluaran data) async {
    final db = await database;
    return db.update(
      'pengeluaran',
      data.toMap(),
      where: 'id = ?',
      whereArgs: [data.id],
    );
  }

  static Future<int> hapus(int id) async {
    final db = await database;
    return db.delete('pengeluaran', where: 'id = ?', whereArgs: [id]);
  }
}

class PengeluaranPage extends StatefulWidget {
  final bool gelap;
  final ValueChanged<bool> onTemaChanged;

  const PengeluaranPage({
    super.key,
    required this.gelap,
    required this.onTemaChanged,
  });

  @override
  State<PengeluaranPage> createState() => _PengeluaranPageState();
}

class _PengeluaranPageState extends State<PengeluaranPage> {
  late Future<List<Pengeluaran>> _future;

  @override
  void initState() {
    super.initState();
    _future = DbHelper.semua();
  }

  void _muat() {
    setState(() => _future = DbHelper.semua());
  }

  Future<void> _bukaForm([Pengeluaran? data]) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => FormPengeluaranPage(data: data)),
    );
    if (!mounted) return;
    _muat();
  }

  Future<void> _hapus(Pengeluaran data) async {
    final setuju = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus pengeluaran?'),
        content: Text('Hapus data "${data.nama}"?'),
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
    if (setuju != true) return;
    await DbHelper.hapus(data.id!);
    if (!mounted) return;
    _muat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pencatat Pengeluaran'),
        actions: [Switch(value: widget.gelap, onChanged: widget.onTemaChanged)],
      ),
      body: FutureBuilder<List<Pengeluaran>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Galat: ${snapshot.error}'));
          }
          final data = snapshot.data ?? [];
          final total = data.fold<int>(0, (sum, item) => sum + item.jumlah);
          return Column(
            children: [
              Card(
                margin: const EdgeInsets.all(16),
                child: ListTile(
                  title: const Text('Total pengeluaran'),
                  trailing: Text(
                    'Rp $total',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ),
              Expanded(
                child: data.isEmpty
                    ? const Center(child: Text('Belum ada pengeluaran'))
                    : ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final item = data[index];
                          return ListTile(
                            title: Text(item.nama),
                            subtitle: Text(
                              '${item.kategori} - ${item.tanggal}',
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Rp ${item.jumlah}'),
                                IconButton(
                                  tooltip: 'Hapus',
                                  icon: const Icon(Icons.delete_outline),
                                  onPressed: () => _hapus(item),
                                ),
                              ],
                            ),
                            onTap: () => _bukaForm(item),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _bukaForm(),
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
      ),
    );
  }
}

class FormPengeluaranPage extends StatefulWidget {
  final Pengeluaran? data;

  const FormPengeluaranPage({super.key, this.data});

  @override
  State<FormPengeluaranPage> createState() => _FormPengeluaranPageState();
}

class _FormPengeluaranPageState extends State<FormPengeluaranPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nama;
  late final TextEditingController _jumlah;
  late String _kategori;
  late DateTime _tanggal;

  @override
  void initState() {
    super.initState();
    _nama = TextEditingController(text: widget.data?.nama ?? '');
    _jumlah = TextEditingController(
      text: widget.data == null ? '' : widget.data!.jumlah.toString(),
    );
    _kategori = widget.data?.kategori ?? kategoriPengeluaran.first;
    _tanggal = widget.data == null
        ? DateTime.now()
        : DateTime.tryParse(widget.data!.tanggal) ?? DateTime.now();
  }

  @override
  void dispose() {
    _nama.dispose();
    _jumlah.dispose();
    super.dispose();
  }

  Future<void> _pilihTanggal() async {
    final tanggal = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      initialDate: _tanggal,
    );
    if (tanggal != null) setState(() => _tanggal = tanggal);
  }

  Future<void> _simpan() async {
    if (!_formKey.currentState!.validate()) return;
    final data = Pengeluaran(
      id: widget.data?.id,
      nama: _nama.text.trim(),
      jumlah: int.parse(_jumlah.text.trim()),
      kategori: _kategori,
      tanggal: _tanggal.toIso8601String().split('T').first,
    );
    if (widget.data == null) {
      await DbHelper.tambah(data);
    } else {
      await DbHelper.ubah(data);
    }
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final baru = widget.data == null;
    return Scaffold(
      appBar: AppBar(
        title: Text(baru ? 'Tambah Pengeluaran' : 'Ubah Pengeluaran'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nama,
              decoration: const InputDecoration(
                labelText: 'Nama pengeluaran',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Nama wajib diisi'
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _jumlah,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Jumlah',
                prefixText: 'Rp ',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                final jumlah = int.tryParse(value?.trim() ?? '');
                return jumlah == null || jumlah <= 0
                    ? 'Jumlah harus berupa angka lebih dari 0'
                    : null;
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _kategori,
              decoration: const InputDecoration(
                labelText: 'Kategori',
                border: OutlineInputBorder(),
              ),
              items: kategoriPengeluaran
                  .map(
                    (item) => DropdownMenuItem(value: item, child: Text(item)),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => _kategori = value);
              },
              validator: (value) =>
                  value == null ? 'Kategori wajib dipilih' : null,
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                'Tanggal: ${_tanggal.toIso8601String().split('T').first}',
              ),
              trailing: OutlinedButton(
                onPressed: _pilihTanggal,
                child: const Text('Pilih tanggal'),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _simpan,
              icon: const Icon(Icons.save),
              label: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
