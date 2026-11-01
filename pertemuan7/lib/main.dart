import 'package:flutter/material.dart';

import 'pages/beranda_page.dart';
import 'pages/form_kegiatan_page.dart';
import 'pages/shell_page.dart';
import 'state/pengaturan.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final settings = PengaturanState();
  await settings.load();
  runApp(TabungKu(settings: settings));
}

class TabungKu extends StatelessWidget {
  const TabungKu({super.key, required this.settings});
  final PengaturanState settings;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: settings,
    builder: (_, child) => MaterialApp(
      title: 'TabungKu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: settings.warna),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: settings.warna,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: settings.gelap ? ThemeMode.dark : ThemeMode.light,
      home: ShellPage(settings: settings),
      routes: {
        '/form-kegiatan': (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments
                  as FormKegiatanArguments;
          return FormKegiatanPage(
            item: args.item,
            initialDate: args.initialDate,
          );
        },
      },
    ),
  );
}
