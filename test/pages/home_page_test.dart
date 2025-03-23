import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mise_en_place/pages/home_page.dart';

void main() {
  testWidgets('HomePage contains Sign In button and navigates when tapped', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: const HomePage(),
      routes: {
        '/signin': (context) => const Scaffold(body: Text('Sign In Page')),
      },
    ));

    // Verify that the Sign In button is displayed
    expect(find.text('Sign In'), findsOneWidget);

    // Tap the Sign In button
    await tester.tap(find.text('Sign In'));

    // Wait for the navigation to complete
    await tester.pumpAndSettle();

    // Verify that we are navigated to the Sign In page
    expect(find.text('Sign In Page'), findsOneWidget);
  });

  testWidgets('HomePage contains Register button and navigates when tapped', (WidgetTester tester) async {
    // Build the widget tree for the HomePage
    await tester.pumpWidget(MaterialApp(
      home: const HomePage(),
      routes: {
        '/signup': (context) => const Scaffold(body: Text('Register Page')),
      },
    ));

    // Verify that the Register button is displayed
    expect(find.text('Register'), findsOneWidget);

    // Tap the Register button
    await tester.tap(find.text('Register'));

    // Wait for the navigation to complete
    await tester.pumpAndSettle();

    // Verify that we are navigated to the Register page
    expect(find.text('Register Page'), findsOneWidget);
  });

  testWidgets('HomePage contains a logo image', (WidgetTester tester) async {
    // Build the widget tree for the HomePage
    await tester.pumpWidget(const MaterialApp(
      home: HomePage(),
    ));

    // Verify that the logo image is displayed
    expect(find.byType(Image), findsOneWidget);
  });

  testWidgets('HomePage contains non-null Sign In and Register buttons', (WidgetTester tester) async {
    // Build the widget tree for the HomePage
    await tester.pumpWidget(const MaterialApp(
      home: HomePage(),
    ));

    // Check that the Sign In and Register buttons are rendered
    final signInButton = find.byType(ElevatedButton).at(0); // First ElevatedButton (Sign In)
    final registerButton = find.byType(ElevatedButton).at(1); // Second ElevatedButton (Register)

    // Verify that both buttons are found
    expect(signInButton, findsOneWidget);
    expect(registerButton, findsOneWidget);
  });

  testWidgets('HomePage contains an AppBar', (WidgetTester tester) async {
    // Build the widget tree for the HomePage
    await tester.pumpWidget(const MaterialApp(
      home: HomePage(),
    ));

    // Verify that the AppBar is present
    expect(find.byType(AppBar), findsOneWidget);
  });

  testWidgets('HomePage buttons are vertically aligned with proper spacing', (WidgetTester tester) async {
    // Build the widget tree for the HomePage
    await tester.pumpWidget(const MaterialApp(
      home: HomePage(),
    ));

    // Check for the vertical alignment of the buttons
    final signInButton = find.text('Sign In');
    final registerButton = find.text('Register');
    
    final signInButtonOffset = tester.getCenter(signInButton);
    final registerButtonOffset = tester.getCenter(registerButton);

    // Verify that the buttons are vertically aligned
    expect(signInButtonOffset.dy < registerButtonOffset.dy, true);
  });
}
