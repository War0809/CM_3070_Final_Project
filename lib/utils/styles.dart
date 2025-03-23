import 'package:flutter/material.dart';

// Outlined input decoration (for search bar)
InputDecoration getInputDecoration(String labelText, {bool hasError = false}) {
  return InputDecoration(
    labelText: labelText,
    labelStyle: const TextStyle(color: Colors.grey), // Default label color
    floatingLabelStyle: TextStyle(color: hasError ? Colors.red : Colors.blue), // Label color when focused
    enabledBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(30.0)), // Rounded corners
      borderSide: BorderSide(color: Colors.grey, width: 1.0), // Grey border when not focused
    ),
    focusedBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(30.0)), // Rounded corners
      borderSide: BorderSide(color: Colors.blue, width: 2.0), // Blue border when focused
    ),
    border: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(30.0)), // Rounded corners
    ),
  );
}

// Underline input decoration (for Title, Author, Year fields)
InputDecoration getUnderlineInputDecoration(String labelText, {bool hasError = false}) {
  return InputDecoration(
    labelText: labelText,
    labelStyle: const TextStyle(color: Colors.black), // Default label color
    floatingLabelStyle: TextStyle(color: hasError ? Colors.red : Colors.blue), // Label color when focused
    enabledBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.grey), // Underline color when not focused
    ),
    focusedBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.blue), // Underline color when focused
    ),
  );
}

Widget buildBottomNavigationBar(BuildContext context, int currentIndex, Function(int) onTap) {
  return BottomNavigationBar(
    items: const [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.book),
        label: 'Library',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.add),
        label: 'Add',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: 'Profile',
      ),
    ],
    currentIndex: currentIndex,
    selectedItemColor: Colors.blue,
    unselectedItemColor: Colors.grey,
    onTap: onTap,
  );
}
