import 'package:flutter/material.dart';

import '../config/api_config.dart';
import '../services/health_service.dart';

class StatusServerPage extends StatefulWidget {
  const StatusServerPage({super.key});

  @override
  State<StatusServerPage> createState() => _StatusServerPageState();
}

class _StatusServerPageState extends State<StatusServerPage> {
  late Future<StatusServer> _future = cekServer();

  void _periksaLagi() => setState(() => _future = cekServer());

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Status Server')),
    body: FutureBuilder<StatusServer>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        final ok = !snapshot.hasError;
        final data = snapshot.data;
        return ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Icon(
              ok ? Icons.cloud_done : Icons.cloud_off,
              size: 96,
              color: ok ? Colors.green : Colors.red,
            ),
            const SizedBox(height: 12),
            Text(
              ok ? 'Server terhubung' : 'Server tidak dapat dihubungi',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.link),
              title: const Text('Alamat API'),
              subtitle: Text(apiUrl),
            ),
            if (ok && data != null) ...[
              ListTile(
                leading: const Icon(Icons.schedule),
                title: const Text('Waktu server'),
                subtitle: Text(data.waktuServer),
              ),
              ListTile(
                leading: const Icon(Icons.speed),
                title: const Text('Latensi'),
                subtitle: Text('${data.latensi.inMilliseconds} ms'),
              ),
            ] else
              ListTile(
                leading: const Icon(Icons.error_outline, color: Colors.red),
                title: const Text('Galat'),
                subtitle: Text('${snapshot.error}'),
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
  );
}
