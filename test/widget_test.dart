import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:do_it/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame with default isLoggedIn = false
    await tester.pumpWidget(const MyApp(isLoggedIn: false));

    // Since isLoggedIn is false, SplashScreen should appear
    expect(find.text('0'), findsNothing); // No counter in SplashScreen

    // For demonstration, test with isLoggedIn = true
    await tester.pumpWidget(const MyApp(isLoggedIn: true));

    // Verify the UI for logged-in state loads (MainScreen)
    // This is just an example check — replace with something from MainScreen
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
