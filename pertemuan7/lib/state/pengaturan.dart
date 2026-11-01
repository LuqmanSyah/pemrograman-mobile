import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PengaturanState extends ChangeNotifier {
  bool gelap = false;
  int target = 20000;
  Color warna = const Color(0xff136f63);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    gelap = prefs.getBool('gelap') ?? false;
    target = prefs.getInt('target') ?? 20000;
    warna = Color(prefs.getInt('warna') ?? 0xff136f63);
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
}
