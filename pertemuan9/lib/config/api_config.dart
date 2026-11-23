import 'package:flutter/foundation.dart';

/// Alamat API bawaan bila pengguna belum mengubahnya di halaman Pengaturan.
///
/// `10.0.2.2` adalah alamat khusus emulator Android untuk menuju `localhost`
/// milik laptop. Untuk HP fisik atau simulator iOS, ubah dari Pengaturan atau
/// tentukan saat menjalankan aplikasi, misalnya:
///   flutter run --dart-define=API_URL=http://192.168.1.10:8000
const apiUrlBawaan = String.fromEnvironment(
  'API_URL',
  defaultValue: 'http://10.0.2.2:8000',
);

/// Alamat API yang sedang dipakai oleh lapisan layanan (misalnya `KegiatanApi`).
///
/// Nilainya diisi oleh `PengaturanState` saat memuat atau mengubah alamat di
/// halaman Pengaturan, sehingga layanan tidak perlu menerima alamat lewat
/// parameter. Di unit test, nilai ini boleh diganti langsung.
final apiUrl = ValueNotifier<String>(apiUrlBawaan);

/// Batas waktu tunggu setiap permintaan ke server.
const batasWaktu = Duration(seconds: 10);

/// Mengembalikan pesan galat bila [input] bukan URL API yang sah, atau `null`
/// bila sah. URL harus diawali `http://` atau `https://` dan memiliki host.
String? validasiApiUrl(String? input) {
  final teks = input?.trim() ?? '';
  if (teks.isEmpty) return 'Alamat API wajib diisi';
  final uri = Uri.tryParse(teks);
  if (uri == null || !(uri.isScheme('http') || uri.isScheme('https'))) {
    return 'Harus diawali http:// atau https://';
  }
  if (uri.host.isEmpty) return 'Host tidak boleh kosong';
  if (uri.hasQuery || uri.hasFragment) {
    return 'Jangan sertakan ? atau # pada alamat';
  }
  return null;
}

/// Merapikan URL sebelum disimpan: buang spasi dan garis miring di akhir agar
/// `'$url/health'` tidak menjadi `//health`.
String rapikanApiUrl(String input) =>
    input.trim().replaceFirst(RegExp(r'/+$'), '');
