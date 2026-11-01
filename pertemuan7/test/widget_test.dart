import 'package:flutter_test/flutter_test.dart';
import 'package:pertemuan7/main.dart';
import 'package:pertemuan7/state/pengaturan.dart';

void main() {
  testWidgets('TabungKu menampilkan navigasi utama', (tester) async {
    final settings = PengaturanState();
    await tester.pumpWidget(TabungKu(settings: settings));
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('TabungKu'), findsOneWidget);
    expect(find.text('Hari ini'), findsOneWidget);
    expect(find.text('Laporan'), findsOneWidget);
    expect(find.text('Pengaturan'), findsOneWidget);
  });
}
