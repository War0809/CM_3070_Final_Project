import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mise_en_place/utils/styles.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddBookPage extends StatefulWidget {
  const AddBookPage({super.key});

  @override
  _AddBookPageState createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  final TextEditingController _isbnController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _indexController = TextEditingController();


  bool isLoading = false;
  bool isFormValid = false;

  List<Map<String, dynamic>> _searchResults = [];
  String? selectedIsbn;
  String? selectedThumbnail;

  @override
  void initState() {
    super.initState();
    _isbnController.addListener(_searchBooks);
    _authorController.addListener(_validateForm);
    _yearController.addListener(_validateForm);
    _indexController.addListener(_validateForm);
  }

  Future<void> _selectAndRecognizeText() async {
  
  final picker = ImagePicker();
  final List<XFile>? images = await picker.pickMultiImage();

  // Check if no images were selected
  if (images == null || images.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('No images selected')),
    );
    return;
  }

  List<String> allRecognizedLines = [];

  final TextRecognizer textRecognizer = TextRecognizer();

  for (XFile image in images) {
    // Process the image
    final InputImage inputImage = InputImage.fromFile(File(image.path));
    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

    // Debugging
    print("Debug: Recognized Text Blocks and Lines for ${image.name}:");
    for (TextBlock block in recognizedText.blocks) {
      print("Block text: ${block.text}");
      for (TextLine line in block.lines) {
        print("Line text: ${line.text}");

        // Filter and process the recognised text line
        List<String> filteredWords = _filterRecognizedText(line.text);
        allRecognizedLines.addAll(filteredWords);
      }
    }
  }

  // Handle case where no text is recognised
  if (allRecognizedLines.isEmpty) {
    print("No text recognized");  // Debug
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('No text recognized in the images')),
    );
    return;
  }

  // Remove duplicates by converting to a Set (case insensitive)
  Set<String> uniqueWords = allRecognizedLines.map((word) => word.toLowerCase()).toSet();

  // Insert the unique recognized text as comma-separated values into the index field
  setState(() {
    String existingText = _indexController.text.trim();
    if (existingText.isNotEmpty) {
      _indexController.text = existingText + ', ' + uniqueWords.join(', ');
    } else {
    _indexController.text = uniqueWords.join(', ');
     } // Combine unique recognized lines
  });

  // Release resources
  textRecognizer.close();
}

// Function to filter recognized text
List<String> _filterRecognizedText(String text) {
  // Regular expression to filter out page numbers, dashes, hyphens, and unwanted characters
  final RegExp regExp = RegExp(r'[\d]+|[-—]|[A-Z](?=\s)|\b\w*[^a-zA-Z]+\w*\b');

  // List of stop words to exclude
  final List<String> stopWords = [
    'a', 'about', 'above', 'after', 'again', 'against', 'all', 'am', 'an', 'and', 'any', 
    'are', 'aren\'t', 'as', 'at', 'be', 'because', 'been', 'before', 'being', 'below', 
    'between', 'both', 'but', 'by', 'can', 'could', 'couldn\'t', 'did', 'didn\'t', 
    'do', 'does', 'doesn\'t', 'doing', 'don\'t', 'down', 'during', 'each', 'few', 
    'for', 'from', 'further', 'had', 'hadn\'t', 'has', 'hasn\'t', 'have', 'haven\'t', 
    'having', 'he', 'he\'s', 'her', 'here', 'here\'s', 'him', 'himself', 'his', 'how', 
    'i', 'i\'m', 'if', 'in', 'into', 'is', 'isn\'t', 'it', 'it\'s', 'just', 'like', 
    'll', 'me', 'might', 'mightn\'t', 'more', 'most', 'must', 'mustn\'t', 'my', 
    'myself', 'need', 'needn\'t', 'no', 'not', 'now', 'o', 'of', 'off', 'on', 
    'once', 'only', 'or', 'other', 'our', 'ours', 'ourselves', 'out', 'over', 
    'own', 're', 's', 'same', 'she', 'she\'s', 'should', 'should\'ve', 'so', 
    'some', 'such', 't', 'than', 'that', 'that\'s', 'the', 'their', 'theirs', 
    'them', 'themselves', 'then', 'there', 'there\'s', 'these', 'they', 'they\'re', 
    'this', 'those', 'through', 'to', 'too', 'under', 'until', 'up', 've', 
    'very', 'was', 'wasn\'t', 'we', 'we\'re', 'were', 'weren\'t', 'what', 
    'what\'s', 'when', 'where', 'where\'s', 'which', 'while', 'who', 'who\'s', 
    'whom', 'why', 'will', 'with', 'won\'t', 'would', 'wouldn\'t', 'you', 
    'you\'re', 'your', 'yours', 'yourself', 'yourselves'
  ];

  // Split text into words and filter using the regular expression
  List<String> filteredWords = text
      .split(RegExp(r'\s+')) // Split by whitespace
      .where((word) => !regExp.hasMatch(word) && word.length > 1) // Remove unwanted words and single letters
      .map((word) => word.trim().replaceAll(RegExp(r'[\""]'), '').replaceAll(RegExp(r',$'), '')) // Trim whitespace, remove quotation marks and trailing commas
      .where((word) => word.isNotEmpty && !stopWords.contains(word.toLowerCase())) // Remove empty strings and stop words
      .toList();

  return filteredWords; // Return the filtered list of words
}

  void _searchBooks() async {
  final query = _isbnController.text.trim();
  if (query.isNotEmpty) {
    
    final url = 'https://www.googleapis.com/books/v1/volumes?q=$query+subject:cooking';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _searchResults = data['items'] != null
            ? (data['items'] as List).map((item) => {
                  'title': item['volumeInfo']['title'],
                  'author': item['volumeInfo']['authors'] != null
                      ? item['volumeInfo']['authors'].join(', ')
                      : 'Unknown',
                  'year': item['volumeInfo']['publishedDate'] != null
                      ? item['volumeInfo']['publishedDate'].substring(0, 4)
                      : 'Unknown',
                  'thumbnail': item['volumeInfo']['imageLinks'] != null
                      ? item['volumeInfo']['imageLinks']['thumbnail']
                      : null,
                  'industryIdentifiers': item['volumeInfo']['industryIdentifiers'],
                }).toList()
            : [];
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${response.reasonPhrase}')),
      );
    }
  } else {
    setState(() {
      _searchResults.clear();
    });
  }
}


  void _selectBook(Map<String, dynamic> book) {
    _titleController.text = book['title'];
    _authorController.text = book['author'];
    _yearController.text = book['year'];

    // Fetch the ISBN and thumbnail
    final identifiers = book['industryIdentifiers'] as List<dynamic>?;
    selectedThumbnail = book['thumbnail'];

    selectedIsbn = null;

    if (identifiers != null && identifiers.isNotEmpty) {
      final isbn13 = identifiers.firstWhere(
        (id) => id['type'] == 'ISBN_13',
        orElse: () => null,
      );

      if (isbn13 != null) {
        selectedIsbn = isbn13['identifier'];
      } else {
        final isbn10 = identifiers.firstWhere(
          (id) => id['type'] == 'ISBN_10',
          orElse: () => null,
        );
        if (isbn10 != null) {
          selectedIsbn = isbn10['identifier'];
        }
      }
    }

    setState(() {
      _searchResults.clear();
    });
  }

  void _validateForm() {
    setState(() {
      isFormValid = _titleController.text.isNotEmpty &&
          _authorController.text.isNotEmpty &&
          _isValidYear(_yearController.text)&&
          _indexController.text.isNotEmpty;
    });
  }

  bool _isValidYear(String year) {
    final parsedYear = int.tryParse(year);
    return parsedYear != null &&
        parsedYear > 1000 &&
        parsedYear <= DateTime.now().year;
  }

  Future<void> _scanBarcode() async {
    String isbn;
    try {
      isbn = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.BARCODE,
      );

      if (isbn != '-1') {
        _isbnController.text = isbn;
        await _fetchBookData(isbn);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to scan barcode: $e')),
      );
    }
  }

  Future<void> _fetchBookData(String isbn) async {
  final url = 'https://www.googleapis.com/books/v1/volumes?q=isbn:$isbn';
  
  
  print('Fetching data from URL: $url');
  
  final response = await http.get(Uri.parse(url));

  
  print('Response status code: ${response.statusCode}');

  if (response.statusCode == 200) {
    final data = json.decode(response.body);

    
    print('Response data: $data');

    if (data['totalItems'] > 0) {
      final book = data['items'][0]['volumeInfo'];

      
      print('Book data: $book');

      final categories = book['categories'] != null ? List<String>.from(book['categories']) : [];

      
      print('Book categories: $categories');

      
      if (categories.any((category) => category.toLowerCase().contains('cooking'))) {
        setState(() {
          _titleController.text = book['title'] ?? '';
          _authorController.text = book['authors'] != null ? book['authors'].join(', ') : '';
          _yearController.text = book['publishedDate'] != null
              ? book['publishedDate'].substring(0, 4)
              : '';
          selectedIsbn = book['industryIdentifiers'] != null
              ? book['industryIdentifiers'][0]['identifier']
              : null;
          selectedThumbnail = book['imageLinks'] != null ? book['imageLinks']['thumbnail'] : null;
        });
        
        
        print('Parsed Book Title: ${book['title']}');
        print('Parsed Authors: ${book['authors']}');
        print('Parsed Published Date: ${book['publishedDate']}');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('This book is not categorized as a cooking book')),
        );
        
        
        print('Book is not categorized under cooking.');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No book found with that ISBN')),
      );
      
      
      print('No book found with the given ISBN: $isbn');
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to retrieve book data: ${response.reasonPhrase}')),
    );
    
    
    print('Error: ${response.reasonPhrase}');
  }
}

  Future<void> _addBook() async {
    if (!isFormValid) return;

    FocusScope.of(context).unfocus();

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

    // Checking if the book already exists in the database
    final existingBookResponse = await Supabase.instance.client
        .from('books')
        .select()
        .eq('isbn', selectedIsbn)
        .eq('user_id', user.id)
        .execute();

    if (existingBookResponse.data != null &&
        existingBookResponse.data.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This book is already in your collection')),
      );
      setState(() {
        isLoading = false;
      });
      return;
    }

    final response = await Supabase.instance.client.from('books').insert({
      'isbn': selectedIsbn,
      'title': _titleController.text,
      'author': _authorController.text,
      'year': int.tryParse(_yearController.text),
      'index': _indexController.text,
      'user_id': user.id,
      'thumbnail': selectedThumbnail,
    }).execute();

    setState(() {
      isLoading = false;
    });

    if (response.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${response.error!.message}')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Book added successfully')),
      );
      _clearFields();
    }
  }

  void _clearFields() {
    _isbnController.clear();
    _titleController.clear();
    _authorController.clear();
    _yearController.clear();
    _indexController.clear();
    _validateForm();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Book'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _isbnController,
              cursorColor: Colors.blue,
              decoration: getInputDecoration('Search by title').copyWith(
                suffixIcon: IconButton(
                  icon: const Icon(Icons.qr_code_scanner),
                  color: Colors.black,
                  onPressed: _scanBarcode,
                ),
              ),
              style: const TextStyle(color: Colors.black),
            ),
            if (_searchResults.isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
  padding: const EdgeInsets.all(8),
  decoration: BoxDecoration(
    border: Border.all(color: Colors.grey),
    borderRadius: BorderRadius.circular(8),
  ),
  child: Column(
    children: _searchResults.map((book) {
      return ListTile(
        leading: book['thumbnail'] != null
            ? Image.network(
                book['thumbnail'],
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              )
            : const Icon(Icons.book, size: 50), // Placeholder icon if no thumbnail
        title: Text(book['title']),
        subtitle: Text('${book['author']} (${book['year']})'),
        onTap: () => _selectBook(book),
      );
    }).toList(),
  ),
),
            ],
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: getInputDecoration('Title'),
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _authorController,
              decoration: getInputDecoration('Author'),
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _yearController,
              keyboardType: TextInputType.number,
              decoration: getInputDecoration('Year'),
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 16),
            TextField(
  controller: _indexController,
  decoration: getInputDecoration('Index').copyWith(
    suffixIcon: IconButton(
      icon: const Icon(Icons.camera_alt),
      onPressed: _selectAndRecognizeText, // Call the text recognition function
    ),
  ),
  style: const TextStyle(color: Colors.black),
  maxLines: 5, // Allow up to 5 lines of text
  minLines: 3, // Minimum 3 lines to keep it visually larger
  expands: false,
  readOnly: true, // Fill the available vertical space
  keyboardType: TextInputType.multiline, // Keyboard suitable for multiline input
),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isFormValid && !isLoading ? _addBook : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isFormValid ? Colors.blue : Colors.grey,
                  foregroundColor: Colors.white, // Text color
                    elevation: 8,
                    shadowColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Add Book'),
              ),

            ),

          ],
        ),
      ),
      bottomNavigationBar: buildBottomNavigationBar(context, 2, (index) {
        if (index == 0) {
          Navigator.pushReplacementNamed(context, '/simpleapp');
        } else if (index == 3) {
          Navigator.pushReplacementNamed(context, '/profile');
        }
      }),
    );
  }
}