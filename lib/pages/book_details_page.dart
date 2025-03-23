import 'package:flutter/material.dart';

class BookDetailsPage extends StatelessWidget {
  final Map<String, dynamic> book;

  const BookDetailsPage({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Display the book thumbnail at the top
            Center(
              child: Container(
                width: 150,
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: book['thumbnail'] != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          book['thumbnail'],
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      )
                    : const Icon(Icons.book, size: 50), // Placeholder icon
              ),
            ),
            const SizedBox(height: 16),
            // Display book details below the thumbnail
            Text(
              book['title'] ?? 'Unknown Title',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Author: ${book['author'] ?? 'Unknown Author'}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 4),
            Text(
              'Year: ${book['year'] ?? 'Unknown Year'}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            // Display the index field
            const Text(
              'Index:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 4),
            Text(
              book['index'] ?? 'No index available',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
