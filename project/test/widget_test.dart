import 'package:flutter_test/flutter_test.dart';

import 'package:project/main.dart';

void main() {
  testWidgets('SmartPOS starts on the login screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SmartPosApp());

    expect(find.text('KASIRKU'), findsOneWidget);
    expect(find.text('Masuk untuk mulai berjualan'), findsOneWidget);
    expect(find.text('Masuk'), findsOneWidget);
  });
}
