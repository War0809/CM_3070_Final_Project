import 'package:flutter/material.dart';
import 'package:mise_en_place/pages/library_page.dart';
import 'package:mise_en_place/utils/constant.dart';
import 'package:mise_en_place/utils/styles.dart';
import 'package:mise_en_place/pages/addbook.dart';
import 'package:mise_en_place/pages/profile_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SimpleAppPage extends StatefulWidget {
  const SimpleAppPage({super.key});

  @override
  State<SimpleAppPage> createState() => _SimpleAppPageState();
}

class _SimpleAppPageState extends State<SimpleAppPage> {
  int _currentIndex = 0;
  List<Map<String, dynamic>> _books = [];
  List<Map<String, dynamic>> _favoriteBooks = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchBooks();
    _fetchFavoriteBooks();
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
        .select('id, title, thumbnail')
        .eq('user_id', user.id)
        .execute();

    setState(() {
      isLoading = false;
      if (response.error == null) {
        _books = List<Map<String, dynamic>>.from(response.data);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.error!.message}')),
        );
      }
    });
  }

  Future<void> _fetchFavoriteBooks() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    final response = await Supabase.instance.client
        .from('books')
        .select('id, title, thumbnail')
        .eq('user_id', user.id)
        .eq('is_favorite', true)
        .execute();

    setState(() {
      if (response.error == null) {
        _favoriteBooks = List<Map<String, dynamic>>.from(response.data);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.error!.message}')),
        );
      }
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LibraryPage()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AddBookPage()),
      );
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfilePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Mise En Place'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ElevatedButton(
              onPressed: () {
                client.auth.signOut();
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
              ),
              child: const Text('Sign Out'),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : _books.isEmpty
                    ? const Center(child: Text('No books found'))
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Text(
                                'Your library',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              height: 250,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _books.length,
                                itemBuilder: (context, index) {
                                  final book = _books[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
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
                                        const SizedBox(height: 8),
                                        SizedBox(
                                          width: 150,
                                          height: 40,
                                          child: Text(
                                            book['title'] ?? 'Unknown',
                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Text(
                                'Your Favourites',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              height: 250,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _favoriteBooks.length,
                                itemBuilder: (context, index) {
                                  final book = _favoriteBooks[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
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
                                        const SizedBox(height: 8),
                                        SizedBox(
                                          width: 150,
                                          height: 40,
                                          child: Text(
                                            book['title'] ?? 'Unknown',
                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
          ),
        ],
      ),
      bottomNavigationBar: buildBottomNavigationBar(context, _currentIndex, _onItemTapped),
    );
  }
}
