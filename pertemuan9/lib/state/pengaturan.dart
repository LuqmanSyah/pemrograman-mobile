import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/api_config.dart';
import '../config/api_config.dart' as config show apiUrl;

class PengaturanState extends ChangeNotifier {
  bool gelap = false;
  int target = 20000;
  Color warna = Colors.teal; // ada di pilihan warna, jadi tanda centang muncul

  /// Alamat API aktif. Disimpan di `config.apiUrl` agar lapisan layanan
  /// (`KegiatanApi`) memakai alamat yang sama dengan halaman Pengaturan.
  String get apiUrl => config.apiUrl.value;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    gelap = prefs.getBool('gelap') ?? false;
    target = prefs.getInt('target') ?? 20000;
    warna = Color(prefs.getInt('warna') ?? Colors.teal.toARGB32());
    config.apiUrl.value = prefs.getString('api_url') ?? apiUrlBawaan;
    notifyListeners();
  }

  Future<void> setGelap(bool value) async {
    gelap = value;
    notifyListeners();
    await (await SharedPreferences.getInstance()).setBool('gelap', value);
  }

  Future<void> setTarget(int value) async {
    target = value;
    notifyListeners();
    await (await SharedPreferences.getInstance()).setInt('target', value);
  }

  Future<void> setWarna(Color value) async {
    warna = value;
    notifyListeners();
    await (await SharedPreferences.getInstance()).setInt(
      'warna',
      value.toARGB32(),
    );
  }

  /// Menyimpan alamat API. Pemanggil wajib memvalidasi dengan
  /// [validasiApiUrl] lebih dulu.
  Future<void> setApiUrl(String value) async {
    config.apiUrl.value = rapikanApiUrl(value);
    notifyListeners();
    await (await SharedPreferences.getInstance()).setString('api_url', apiUrl);
  }

  /// Kembali ke alamat bawaan (dari --dart-define atau 10.0.2.2).
  Future<void> resetApiUrl() async {
    config.apiUrl.value = apiUrlBawaan;
    notifyListeners();
    await (await SharedPreferences.getInstance()).remove('api_url');
  }
}
