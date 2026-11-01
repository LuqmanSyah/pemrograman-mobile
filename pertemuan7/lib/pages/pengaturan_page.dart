import 'package:flutter/material.dart';

import '../state/pengaturan.dart';
import '../utils/format.dart';

class PengaturanPage extends StatelessWidget {
  const PengaturanPage({super.key, required this.settings});
  final PengaturanState settings;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Pengaturan')),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        SwitchListTile(
          title: const Text('Mode gelap'),
          value: settings.gelap,
          onChanged: settings.setGelap,
        ),
        ListTile(
          title: const Text('Target tabungan harian'),
          subtitle: Text(rupiah(settings.target)),
          trailing: SizedBox(
            width: 160,
            child: Slider(
              min: 5000,
              max: 100000,
              divisions: 19,
              value: settings.target.toDouble(),
              onChanged: (value) => settings.setTarget(value.round()),
            ),
          ),
        ),
        const Divider(),
        const ListTile(title: Text('Warna tema')),
        Wrap(
          spacing: 12,
          children: [Colors.teal, Colors.indigo, Colors.orange, Colors.pink]
              .map(
                (color) => InkWell(
                  onTap: () => settings.setWarna(color),
                  child: CircleAvatar(
                    backgroundColor: color,
                    child: settings.warna.toARGB32() == color.toARGB32()
                        ? const Icon(Icons.check, color: Colors.white)
                        : null,
                  ),
                ),
              )
              .toList(),
        ),
      ],
    ),
  );
}
