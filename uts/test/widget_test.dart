import 'package:flutter_test/flutter_test.dart';

import 'package:uts/main.dart';

void main() {
  testWidgets('Kasirku starts on the login screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('KASIRKU'), findsOneWidget);
    expect(find.text('Masuk untuk mulai berjualan'), findsOneWidget);
    expect(find.text('Masuk'), findsOneWidget);
  });
}
