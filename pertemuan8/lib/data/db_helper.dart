import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

import '../models/kegiatan.dart';
import '../utils/format.dart';

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

  /// Pencarian kegiatan di semua tanggal. [kata] dicocokkan dengan judul
  /// memakai LIKE; [tipe] dan [kategori] bersifat opsional (null = semua).
  static Future<List<Kegiatan>> cari(
    String kata, {
    TipeKeuangan? tipe,
    String? kategori,
  }) async {
    final syarat = ['judul LIKE ?'];
    final args = <Object>['%$kata%'];
    if (tipe != null) {
      syarat.add('tipe = ?');
      args.add(tipe.name);
    }
    if (kategori != null) {
      syarat.add('kategori = ?');
      args.add(kategori);
    }
    final rows = await (await database).query(
      'kegiatan',
      where: syarat.join(' AND '),
      whereArgs: args,
      orderBy: 'tanggal DESC, id DESC',
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

  // Kolom ringkasan dipakai bersama oleh ringkasan() dan tujuhHari().
  // masuk/keluar = rencana (semua kegiatan), *_selesai = realisasi.
  static const _kolomRingkasan = '''COUNT(*) jumlah,
      COALESCE(SUM(selesai), 0) selesai,
      COALESCE(SUM(CASE WHEN tipe = 'pemasukan' THEN nominal ELSE 0 END), 0) masuk,
      COALESCE(SUM(CASE WHEN tipe = 'pengeluaran' THEN nominal ELSE 0 END), 0) keluar,
      COALESCE(SUM(CASE WHEN tipe = 'pemasukan' AND selesai = 1 THEN nominal ELSE 0 END), 0) masuk_selesai,
      COALESCE(SUM(CASE WHEN tipe = 'pengeluaran' AND selesai = 1 THEN nominal ELSE 0 END), 0) keluar_selesai''';

  static Ringkasan _keRingkasan(Map<String, Object?> row) => Ringkasan(
    jumlah: row['jumlah'] as int,
    selesai: row['selesai'] as int,
    masuk: row['masuk'] as int,
    keluar: row['keluar'] as int,
    masukSelesai: row['masuk_selesai'] as int,
    keluarSelesai: row['keluar_selesai'] as int,
  );

  static Future<Ringkasan> ringkasan(String tanggal) async {
    final rows = await (await database).rawQuery(
      'SELECT $_kolomRingkasan FROM kegiatan WHERE tanggal = ?',
      [tanggal],
    );
    return _keRingkasan(rows.first);
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

  /// Ringkasan per tanggal untuk 7 hari sampai [akhir] (terbaru di atas).
  /// Tanggal tanpa kegiatan tetap muncul dengan nilai 0.
  static Future<Map<String, Ringkasan>> tujuhHari(String akhir) async {
    final hari = tujuhHariTerakhir(akhir);
    final rows = await (await database).rawQuery(
      '''SELECT tanggal, $_kolomRingkasan FROM kegiatan
      WHERE tanggal BETWEEN ? AND ? GROUP BY tanggal''',
      [hari.last, hari.first],
    );
    final hasil = {
      for (final row in rows) row['tanggal'] as String: _keRingkasan(row),
    };
    return {for (final h in hari) h: hasil[h] ?? const Ringkasan()};
  }
}
