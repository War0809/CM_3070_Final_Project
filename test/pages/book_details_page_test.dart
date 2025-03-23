import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mise_en_place/pages/book_details_page.dart';

void main() {
  group('BookDetailsPage Tests', () {
    late Map<String, dynamic> mockBook;

    setUp(() {
      // Set up mock book data before each test
      mockBook = {
        'title': 'Test Book',
        'author': 'Test Author',
        'year': '2024',
        'thumbnail': null,
        'index': 'Page 1: Introduction\nPage 2: Chapter 1',
      };
    });

    testWidgets('Renders BookDetailsPage correctly', (WidgetTester tester) async {
      // Load the page with valid mock data
      await tester.pumpWidget(MaterialApp(
        home: BookDetailsPage(book: mockBook),
      ));

      // Verify the title of the page
      expect(find.text('Book Details'), findsOneWidget);

      // Verify the book details
      expect(find.text('Test Book'), findsOneWidget);
      expect(find.text('Author: Test Author'), findsOneWidget);
      expect(find.text('Year: 2024'), findsOneWidget);
    });

    testWidgets('Displays fallback text for missing book details', (WidgetTester tester) async {
      // Load the page with missing book details
      await tester.pumpWidget(const MaterialApp(
        home: BookDetailsPage(book: {}),
      ));

      // Verify the fallback values
      expect(find.text('Unknown Title'), findsOneWidget);
      expect(find.text('Author: Unknown Author'), findsOneWidget);
      expect(find.text('Year: Unknown Year'), findsOneWidget);
      expect(find.text('No index available'), findsOneWidget);
    });

    testWidgets('Displays placeholder icon when thumbnail is missing', (WidgetTester tester) async {
      // Load the page with no thumbnail
      mockBook['thumbnail'] = null;
      await tester.pumpWidget(MaterialApp(
        home: BookDetailsPage(book: mockBook),
      ));

      // Verify the placeholder icon is displayed
      expect(find.byIcon(Icons.book), findsOneWidget);
    });

    testWidgets('Displays a placeholder widget when thumbnail is missing', (WidgetTester tester) async {
      // Use a simple Container as a fallback if no thumbnail
      mockBook['thumbnail'] = null; // Null to simulate missing thumbnail
      await tester.pumpWidget(MaterialApp(
        home: BookDetailsPage(book: mockBook),
      ));

      // Check for a Container or other fallback widget
      expect(find.byType(Container), findsOneWidget); // This can be any widget that represents the placeholder
    });

    testWidgets('Displays book index content correctly', (WidgetTester tester) async {
      // Load the page with valid index content
      await tester.pumpWidget(MaterialApp(
        home: BookDetailsPage(book: mockBook),
      ));

      // Verify the index content
      expect(find.text('Index:'), findsOneWidget);
      expect(find.text('Page 1: Introduction\nPage 2: Chapter 1'), findsOneWidget);
    });
  });
}
