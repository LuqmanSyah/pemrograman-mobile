String rupiah(int value) {
  final negative = value < 0;
  final digits = value.abs().toString();
  final formatted = digits.replaceAllMapped(
    // (?<=\d) mencegah titik di depan angka, misalnya '.105.000'.
    RegExp(r'(?<=\d)(?=(\d{3})+(?!\d))'),
    (match) => '.',
  );
  return '${negative ? '-' : ''}Rp $formatted';
}

/// Nominal dengan tanda: "+ Rp 50.000" untuk pemasukan, "- Rp 15.000" untuk
/// pengeluaran.
String rupiahBertanda(int nilai, {required bool masuk}) =>
    '${masuk ? '+' : '-'} ${rupiah(nilai)}';

String tanggal(DateTime date) =>
    '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

/// Tujuh tanggal `yyyy-MM-dd` mundur dari [akhir], dimulai dari [akhir] itu
/// sendiri. Contoh: '2026-03-02' -> ['2026-03-02', '2026-03-01', '2026-02-28', ...].
List<String> tujuhHariTerakhir(String akhir) {
  final hari = DateTime.parse(akhir);
  return [
    for (var i = 0; i < 7; i++)
      tanggal(DateTime(hari.year, hari.month, hari.day - i)),
  ];
}
