import 'package:flutter_test/flutter_test.dart';

import 'package:opratingsystem/main.dart';

void main() {
  testWidgets('App launches successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const OSMasteryApp());

    // Verify that splash screen loads
    expect(find.text('OS MASTERY'), findsOneWidget);
    expect(find.text('STUDY TRACKER'), findsOneWidget);
  });
}
