import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

import '../models/kegiatan.dart';

final ValueNotifier<int> versiData = ValueNotifier(0);

class DbHelper {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    final path = '${await getDatabasesPath()}/tabungku.db';
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''CREATE TABLE kegiatan(
        id INTEGER PRIMARY KEY AUTOINCREMENT, judul TEXT NOT NULL,
        tanggal TEXT NOT NULL, selesai INTEGER NOT NULL, tipe TEXT NOT NULL,
        nominal INTEGER NOT NULL, kategori TEXT NOT NULL)''');
      },
    );
    return _db!;
  }

  static Future<List<Kegiatan>> pada(String tanggal) async {
    final rows = await (await database).query(
      'kegiatan',
      where: 'tanggal = ?',
      whereArgs: [tanggal],
      orderBy: 'selesai, id DESC',
    );
    return rows.map(Kegiatan.fromMap).toList();
  }

  static Future<void> simpan(Kegiatan kegiatan) async {
    final db = await database;
    final map = kegiatan.toMap()..remove('id');
    if (kegiatan.id == null) {
      await db.insert('kegiatan', map);
    } else {
      await db.update(
        'kegiatan',
        map,
        where: 'id = ?',
        whereArgs: [kegiatan.id],
      );
    }
    versiData.value++;
  }

  static Future<void> hapus(int id) async {
    await (await database).delete('kegiatan', where: 'id = ?', whereArgs: [id]);
    versiData.value++;
  }

  static Future<Ringkasan> ringkasan(String tanggal) async {
    final rows = await (await database).rawQuery(
      '''SELECT COUNT(*) jumlah,
      COALESCE(SUM(selesai), 0) selesai,
      COALESCE(SUM(CASE WHEN tipe = 'pemasukan' THEN nominal ELSE 0 END), 0) masuk,
      COALESCE(SUM(CASE WHEN tipe = 'pengeluaran' THEN nominal ELSE 0 END), 0) keluar
      FROM kegiatan WHERE tanggal = ?''',
      [tanggal],
    );
    final row = rows.first;
    return Ringkasan(
      jumlah: row['jumlah'] as int,
      selesai: row['selesai'] as int,
      masuk: row['masuk'] as int,
      keluar: row['keluar'] as int,
    );
  }

  static Future<Map<String, int>> perKategori(String tanggal) async {
    final rows = await (await database).rawQuery(
      '''SELECT kategori, SUM(nominal) total FROM kegiatan
      WHERE tanggal = ? AND tipe = 'pengeluaran' GROUP BY kategori ORDER BY total DESC''',
      [tanggal],
    );
    return {
      for (final row in rows) row['kategori'] as String: row['total'] as int,
    };
  }
}
