import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mise_en_place/pages/addbook.dart';

void main() {
  // Test 1: Add Book form fields test
  testWidgets('Add Book form fields test', (WidgetTester tester) async {
    // Pump the AddBookPage widget into the widget tree
    await tester.pumpWidget(const MaterialApp(
      home: AddBookPage(),
    ));

    // Find the text fields and button by their order in the widget tree
    final isbnField = find.byType(TextField).first;
    final titleField = find.byType(TextField).at(1);
    final authorField = find.byType(TextField).at(2);
    final yearField = find.byType(TextField).at(3);
    final indexField = find.byType(TextField).at(4);
    final addButton = find.byType(ElevatedButton);

    // Check that the text fields are found
    expect(isbnField, findsOneWidget);
    expect(titleField, findsOneWidget);
    expect(authorField, findsOneWidget);
    expect(yearField, findsOneWidget);
    expect(indexField, findsOneWidget);

    // Verify that the button is initially disabled (as per the form validation logic)
    expect(tester.widget<ElevatedButton>(addButton).enabled, false);

    // Enter text into all the fields to test if the button gets enabled
    await tester.enterText(isbnField, '1234567890');
    await tester.enterText(titleField, 'Test Book');
    await tester.enterText(authorField, 'Test Author');
    await tester.enterText(yearField, '2024');
    await tester.enterText(indexField, 'Index info');

    // Pump the widget again to rebuild after the changes
    await tester.pump();

    // Verify that the button is now enabled (all fields filled)
    expect(tester.widget<ElevatedButton>(addButton).enabled, true);
  });

  // Test 2: Add Book form incomplete fields test
  testWidgets('Add Book form incomplete fields test', (WidgetTester tester) async {
    // Pump the AddBookPage widget into the widget tree
    await tester.pumpWidget(const MaterialApp(
      home: AddBookPage(),
    ));

    // Find the text fields and button by their order in the widget tree
    final isbnField = find.byType(TextField).first;
    final titleField = find.byType(TextField).at(1);
    final authorField = find.byType(TextField).at(2);
    final yearField = find.byType(TextField).at(3);
    final indexField = find.byType(TextField).at(4);
    final addButton = find.byType(ElevatedButton);

    // Check that the text fields are found
    expect(isbnField, findsOneWidget);
    expect(titleField, findsOneWidget);
    expect(authorField, findsOneWidget);
    expect(yearField, findsOneWidget);
    expect(indexField, findsOneWidget);

    // Verify that the button is initially disabled (as per the form validation logic)
    expect(tester.widget<ElevatedButton>(addButton).enabled, false);

    // Enter text into only the ISBN field
    await tester.enterText(isbnField, '1234567890');
    
    // Pump the widget again to rebuild after the changes
    await tester.pump();

    // Verify that the button is still disabled (other fields are empty)
    expect(tester.widget<ElevatedButton>(addButton).enabled, false);
  });

  // Test 3: Add Book form clear fields test
  testWidgets('Add Book form clear fields test', (WidgetTester tester) async {
    // Pump the AddBookPage widget into the widget tree
    await tester.pumpWidget(const MaterialApp(
      home: AddBookPage(),
    ));

    // Find the text fields and button by their order in the widget tree
    final isbnField = find.byType(TextField).first;
    final titleField = find.byType(TextField).at(1);
    final authorField = find.byType(TextField).at(2);
    final yearField = find.byType(TextField).at(3);
    final indexField = find.byType(TextField).at(4);
    final addButton = find.byType(ElevatedButton);

    // Check that the text fields are found
    expect(isbnField, findsOneWidget);
    expect(titleField, findsOneWidget);
    expect(authorField, findsOneWidget);
    expect(yearField, findsOneWidget);
    expect(indexField, findsOneWidget);

    // Enter text into all the fields to enable the button
    await tester.enterText(isbnField, '1234567890');
    await tester.enterText(titleField, 'Test Book');
    await tester.enterText(authorField, 'Test Author');
    await tester.enterText(yearField, '2024');
    await tester.enterText(indexField, 'Index info');
    await tester.pump(); // Rebuild the widget

    // Verify that the button is enabled after filling all fields
    expect(tester.widget<ElevatedButton>(addButton).enabled, true);

    // Clear the text fields
    await tester.enterText(isbnField, '');
    await tester.enterText(titleField, '');
    await tester.enterText(authorField, '');
    await tester.enterText(yearField, '');
    await tester.enterText(indexField, '');
    await tester.pump(); // Rebuild the widget

    // Verify that the button is now disabled after clearing the fields
    expect(tester.widget<ElevatedButton>(addButton).enabled, false);
  });

  // Test 4: Add Book form invalid year input test
  testWidgets('Add Book form invalid year input test', (WidgetTester tester) async {
    // Pump the AddBookPage widget into the widget tree
    await tester.pumpWidget(const MaterialApp(
      home: AddBookPage(),
    ));

    // Find the text fields and button by their order in the widget tree
    final isbnField = find.byType(TextField).first;
    final titleField = find.byType(TextField).at(1);
    final authorField = find.byType(TextField).at(2);
    final yearField = find.byType(TextField).at(3);
    final indexField = find.byType(TextField).at(4);
    final addButton = find.byType(ElevatedButton);

    // Check that the text fields are found
    expect(isbnField, findsOneWidget);
    expect(titleField, findsOneWidget);
    expect(authorField, findsOneWidget);
    expect(yearField, findsOneWidget);
    expect(indexField, findsOneWidget);

    // Verify that the button is initially disabled (as per the form validation logic)
    expect(tester.widget<ElevatedButton>(addButton).enabled, false);

    // Enter text into all fields except for an invalid year (non-numeric input)
    await tester.enterText(isbnField, '1234567890');
    await tester.enterText(titleField, 'Test Book');
    await tester.enterText(authorField, 'Test Author');
    await tester.enterText(yearField, 'invalid-year');
    await tester.enterText(indexField, 'Index info');
    
    // Pump the widget again to rebuild after the changes
    await tester.pump();

    // Verify that the button is still disabled (invalid year input)
    expect(tester.widget<ElevatedButton>(addButton).enabled, false);
  });

  // Test 5: Add Book form valid year input test
testWidgets('Add Book form valid year input test', (WidgetTester tester) async {
  // Pump the AddBookPage widget into the widget tree
  await tester.pumpWidget(const MaterialApp(
    home: AddBookPage(),
  ));

  // Find the text fields and button by their order in the widget tree
  final isbnField = find.byType(TextField).first;
  final titleField = find.byType(TextField).at(1);
  final authorField = find.byType(TextField).at(2);
  final yearField = find.byType(TextField).at(3);
  final indexField = find.byType(TextField).at(4);
  final addButton = find.byType(ElevatedButton);

  // Check that the text fields are found
  expect(isbnField, findsOneWidget);
  expect(titleField, findsOneWidget);
  expect(authorField, findsOneWidget);
  expect(yearField, findsOneWidget);
  expect(indexField, findsOneWidget);

  // Verify that the button is initially disabled (as per the form validation logic)
  expect(tester.widget<ElevatedButton>(addButton).enabled, false);

  // Enter text into all fields with a valid year
  await tester.enterText(isbnField, '1234567890');
  await tester.enterText(titleField, 'Test Book');
  await tester.enterText(authorField, 'Test Author');
  await tester.enterText(yearField, '2024');
  await tester.enterText(indexField, 'Index info');
  
  // Pump the widget again to rebuild after the changes
  await tester.pump();

  // Verify that the button is now enabled with a valid year
  expect(tester.widget<ElevatedButton>(addButton).enabled, true);
});

// Test 7: Add Book form valid ISBN input test
testWidgets('Add Book form valid ISBN input test', (WidgetTester tester) async {
  // Pump the AddBookPage widget into the widget tree
  await tester.pumpWidget(const MaterialApp(
    home: AddBookPage(),
  ));

  // Find the text fields and button by their order in the widget tree
  final isbnField = find.byType(TextField).first;
  final titleField = find.byType(TextField).at(1);
  final authorField = find.byType(TextField).at(2);
  final yearField = find.byType(TextField).at(3);
  final indexField = find.byType(TextField).at(4);
  final addButton = find.byType(ElevatedButton);

  // Check that the text fields are found
  expect(isbnField, findsOneWidget);
  expect(titleField, findsOneWidget);
  expect(authorField, findsOneWidget);
  expect(yearField, findsOneWidget);
  expect(indexField, findsOneWidget);

  // Verify that the button is initially disabled (as per the form validation logic)
  expect(tester.widget<ElevatedButton>(addButton).enabled, false);

  // Enter a valid ISBN format
  await tester.enterText(isbnField, '9781234567890');
  await tester.enterText(titleField, 'Test Book');
  await tester.enterText(authorField, 'Test Author');
  await tester.enterText(yearField, '2024');
  await tester.enterText(indexField, 'Index info');

  // Pump the widget again to rebuild after the changes
  await tester.pump();

  // Verify that the button is now enabled with valid ISBN
  expect(tester.widget<ElevatedButton>(addButton).enabled, true);
});

// Test 8: Add Book form special character input test
testWidgets('Add Book form special character input test', (WidgetTester tester) async {
  // Pump the AddBookPage widget into the widget tree
  await tester.pumpWidget(const MaterialApp(
    home: AddBookPage(),
  ));

  // Find the text fields and button by their order in the widget tree
  final isbnField = find.byType(TextField).first;
  final titleField = find.byType(TextField).at(1);
  final authorField = find.byType(TextField).at(2);
  final yearField = find.byType(TextField).at(3);
  final indexField = find.byType(TextField).at(4);
  final addButton = find.byType(ElevatedButton);

  // Check that the text fields are found
  expect(isbnField, findsOneWidget);
  expect(titleField, findsOneWidget);
  expect(authorField, findsOneWidget);
  expect(yearField, findsOneWidget);
  expect(indexField, findsOneWidget);

  // Verify that the button is initially disabled (as per the form validation logic)
  expect(tester.widget<ElevatedButton>(addButton).enabled, false);

  // Enter special characters in some fields
  await tester.enterText(isbnField, '9781234567890');
  await tester.enterText(titleField, 'Test @ Book!');
  await tester.enterText(authorField, 'Test \$ Author!');
  await tester.enterText(yearField, '2024');
  await tester.enterText(indexField, 'Index # info');

  // Pump the widget again to rebuild after the changes
  await tester.pump();

  // Verify that the button is enabled with valid inputs (special characters allowed)
  expect(tester.widget<ElevatedButton>(addButton).enabled, true);
});


}
