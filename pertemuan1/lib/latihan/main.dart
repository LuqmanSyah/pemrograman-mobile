import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Latihan 1', home: const CounterPage());
  }
}

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});
  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int _count = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter Saya'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.flutter_dash, size: 80, color: Colors.blue),
            SizedBox(height: 16),
            Text('Halo, nama saya Luqman!', style: TextStyle(fontSize: 24)),
            Text('NIM: 20240801016'),
            Text('$_count', style: const TextStyle(fontSize: 48)),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => setState(() => _count++),
                  child: const Icon(Icons.add),
                ),
                SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () =>
                      setState(() => _count = _count > 0 ? _count - 1 : 0),
                  child: const Icon(Icons.remove),
                ),
                SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () => setState(() => _count = 0),
                  child: const Icon(Icons.restart_alt),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
