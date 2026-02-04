// Basic smoke test for Jam.ai app

import 'package:flutter_test/flutter_test.dart';
import 'package:jam_ai/main.dart';

void main() {
  testWidgets('App renders home screen', (WidgetTester tester) async {
    // Build app and verify it renders
    await tester.pumpWidget(const JamAiApp());
    
    // Verify app title is displayed
    expect(find.text('Jam.ai'), findsOneWidget);
  });
}
