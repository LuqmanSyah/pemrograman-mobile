import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Tugas 1', home: const KartuPerkenalan());
  }
}

class KartuPerkenalan extends StatelessWidget {
  const KartuPerkenalan({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kartu Perkenalan'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person, size: 100, color: Colors.indigo),
            SizedBox(height: 16),
            const Text(
              'Luqman',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            const Text('NIM: 20240801016'),
            const Text('Jurusan: Teknik Informatika'),
            SizedBox(height: 8),
            const Text('Hobi: Main Game'),
          ],
        ),
      ),
    );
  }
}
