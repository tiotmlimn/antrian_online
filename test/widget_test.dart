import 'package:flutter_test/flutter_test.dart';

import 'package:antrian_online/main.dart';

void main() {
  testWidgets('App builds and shows login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.byType(MyApp), findsOneWidget);
  });
}
