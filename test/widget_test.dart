import 'package:flutter_test/flutter_test.dart';

import 'package:vitta_app/main.dart';

void main() {
  testWidgets('Home screen shows the greeting', (WidgetTester tester) async {
    await tester.pumpWidget(const VittaApp());
    expect(find.text('Hello Alex,'), findsOneWidget);
    expect(find.text('Recommended for you'), findsOneWidget);
  });
}
