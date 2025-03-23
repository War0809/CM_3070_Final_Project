import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mise_en_place/utils/styles.dart';
import 'book_details_page.dart'; // Import the BookDetailsPage

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  bool isLoading = false;
  List<Map<String, dynamic>> _books = [];
  List<Map<String, dynamic>> _filteredBooks = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _fetchBooks();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchBooks() async {
    setState(() {
      isLoading = true;
    });

    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not logged in')),
      );
      setState(() {
        isLoading = false;
      });
      return;
    }

    final response = await Supabase.instance.client
        .from('books')
        .select('id, title, author, year, thumbnail, index, is_favorite') // Fetch the 'is_favorite' field
        .eq('user_id', user.id)
        .execute();

    setState(() {
      isLoading = false;
    });

    if (response.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${response.error!.message}')),
      );
    } else {
      setState(() {
        _books = List<Map<String, dynamic>>.from(response.data);
        _filteredBooks = _books.map((book) {
          // Ensure the 'is_favorite' field is present for each book
          book['isFavorite'] = book['is_favorite'] ?? false; // Default to false if not set
          return book;
        }).toList(); // Initially show all books
      });
    }
  }

  void _onSearchChanged() {
    String searchTerm = _searchController.text.toLowerCase();
    List<String> searchTerms = searchTerm.trim().split(RegExp(r'\s+')); // Split by whitespace, ignore extra spaces
    setState(() {
      if (searchTerm.isEmpty) {
        // If the search term is empty, show all books
        _filteredBooks = _books;
      } else {
        // Filter books by checking if the 'index' contains any of the search terms
        _filteredBooks = _books.where((book) {
          final indexText = book['index']?.toLowerCase() ?? '';
          // Check if any search term is present in the index
          return searchTerms.any((term) => indexText.contains(term));
        }).toList();
      }
    });
  }

  void _toggleFavorite(Map<String, dynamic> book) async {
    setState(() {
      book['isFavorite'] = !book['isFavorite']; // Toggle favorite status
    });

    // Update the database with the new favorite status
    final response = await Supabase.instance.client
        .from('books')
        .update({
          'is_favorite': book['isFavorite'],
        })
        .eq('id', book['id']) // Use the book's ID to find the correct record
        .execute();

    if (response.error != null) {
      // Handle error if needed
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating favorite: ${response.error!.message}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Library'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by ingredient',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue), // Blue border when focused
                  borderRadius: BorderRadius.circular(8),
                ),
                floatingLabelStyle: TextStyle(color: Colors.blue), // Blue label text when focused
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredBooks.isEmpty
                    ? const Center(child: Text('No books found'))
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.7,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                          ),
                          itemCount: _filteredBooks.length,
                          itemBuilder: (context, index) {
                            final book = _filteredBooks[index];
                            return GestureDetector(
                              onTap: () {
                                // Navigate to BookDetailsPage and pass book data
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BookDetailsPage(book: book),
                                  ),
                                );
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Stack(
                                    alignment: Alignment.topRight,
                                    children: [
                                      Container(
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
                                            : const Icon(Icons.book, size: 50),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          book['isFavorite'] ? Icons.star : Icons.star_border,
                                          color: book['isFavorite'] ? Colors.yellow : Colors.grey,
                                        ),
                                        onPressed: () => _toggleFavorite(book), // Toggle favorite status
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    book['title'] ?? 'Unknown',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
      bottomNavigationBar: buildBottomNavigationBar(context, 1, (index) {
        if (index == 0) {
          Navigator.pushReplacementNamed(context, '/simpleapp');
        } else if (index == 2) {
          Navigator.pushReplacementNamed(context, '/addbook');
        } else if (index == 3) {
          Navigator.pushReplacementNamed(context, '/profile');
        }
      }),
    );
  }
}
