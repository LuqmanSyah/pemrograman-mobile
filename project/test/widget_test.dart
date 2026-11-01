import 'package:flutter_test/flutter_test.dart';

import 'package:project/main.dart';

void main() {
  testWidgets('SmartPOS starts on the login screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SmartPosApp());

    expect(find.text('SmartPOS'), findsOneWidget);
    expect(find.text('Siap melayani, Rina?'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });
}
