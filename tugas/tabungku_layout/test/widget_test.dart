import 'package:flutter_test/flutter_test.dart';

import 'package:tabungku_layout/main.dart';

void main() {
  testWidgets('halaman ringkasan tampil', (WidgetTester tester) async {
    await tester.pumpWidget(const TabungKuApp());

    expect(find.text('Ringkasan Tabungan'), findsOneWidget);
    expect(find.text('Menabung'), findsOneWidget);
    expect(find.text('Tarik'), findsOneWidget);
    expect(find.text('Riwayat'), findsOneWidget);
  });
}
