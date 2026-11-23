import 'package:flutter/material.dart';

import '../services/health_service.dart';

class StatusServerPage extends StatefulWidget {
  const StatusServerPage({super.key, required this.baseUrl});
  final String baseUrl;

  @override
  State<StatusServerPage> createState() => _StatusServerPageState();
}

class _StatusServerPageState extends State<StatusServerPage> {
  late Future<StatusServer> _future = cekServer(widget.baseUrl);

  // Callback setState wajib memakai blok { }: arrow `() => _future = ...`
  // mengembalikan Future, dan Flutter menolak setState yang mengembalikan
  // Future sehingga halaman tidak pernah memuat ulang.
  void _periksaLagi() {
    setState(() {
      _future = cekServer(widget.baseUrl);
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Status Server')),
    // SafeArea agar tombol bawah tidak tertutup gesture bar Android
    // (ListView dengan padding eksplisit tidak menambah inset sistem).
    body: SafeArea(
      child: FutureBuilder<StatusServer>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          final data = snapshot.data;
          final apiOk = !snapshot.hasError && data != null;
          final dbOk = apiOk && data.databaseOk;

          final (IconData ikon, Color warna, String judul) = switch ((
            apiOk,
            dbOk,
          )) {
            (true, true) => (Icons.cloud_done, Colors.green, 'Server sehat'),
            (true, false) => (
              Icons.cloud_queue,
              Colors.orange,
              'API hidup, database mati',
            ),
            _ => (Icons.cloud_off, Colors.red, 'Server tidak dapat dihubungi'),
          };

          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Icon(ikon, size: 96, color: warna),
              const SizedBox(height: 12),
              Text(
                judul,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 24),
              ListTile(
                leading: const Icon(Icons.link),
                title: const Text('Alamat API'),
                subtitle: Text(widget.baseUrl),
              ),
              const Divider(),
              _BarisStatus(
                ikon: Icons.api,
                nama: 'API',
                ok: apiOk,
                keterangan: apiOk
                    ? 'Terhubung (${data.latensi.inMilliseconds} ms)'
                    : '${snapshot.error}',
              ),
              _BarisStatus(
                ikon: Icons.storage,
                nama: 'Database',
                ok: apiOk ? dbOk : null,
                keterangan: !apiOk
                    ? 'Tidak diketahui karena API tidak dapat dihubungi'
                    : dbOk
                    ? 'MySQL ${data.mysqlVersion}'
                    : data.detail ?? 'Database tidak dapat dihubungi',
              ),
              if (apiOk)
                ListTile(
                  leading: const Icon(Icons.schedule),
                  title: const Text('Waktu server'),
                  subtitle: Text(data.waktuServer),
                ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _periksaLagi,
                icon: const Icon(Icons.refresh),
                label: const Text('Periksa lagi'),
              ),
            ],
          );
        },
      ),
    ),
  );
}

/// Satu baris status komponen. [ok] bernilai `null` bila statusnya tidak
/// diketahui.
class _BarisStatus extends StatelessWidget {
  const _BarisStatus({
    required this.ikon,
    required this.nama,
    required this.ok,
    required this.keterangan,
  });

  final IconData ikon;
  final String nama;
  final bool? ok;
  final String keterangan;

  @override
  Widget build(BuildContext context) {
    final (String label, Color warna) = switch (ok) {
      true => ('Hidup', Colors.green),
      false => ('Mati', Colors.red),
      null => ('?', Colors.grey),
    };
    return ListTile(
      leading: Icon(ikon, color: warna),
      title: Text(nama),
      subtitle: Text(keterangan),
      trailing: Chip(
        label: Text(label),
        labelStyle: TextStyle(color: warna, fontWeight: FontWeight.bold),
        side: BorderSide(color: warna),
      ),
    );
  }
}
