String rupiah(int value) {
  final negative = value < 0;
  final digits = value.abs().toString();
  final formatted = digits.replaceAllMapped(
    RegExp(r'(?=(\d{3})+(?!\d))'),
    (match) => '.',
  );
  return '${negative ? '-' : ''}Rp $formatted';
}

String tanggal(DateTime date) =>
    '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
