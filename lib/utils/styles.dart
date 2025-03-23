import 'package:flutter/material.dart';

InputDecoration getInputDecoration(String labelText, {bool hasError = false}) {
  return InputDecoration(
    labelText: labelText,
    labelStyle: const TextStyle(color: Colors.grey),
    floatingLabelStyle: TextStyle(color: hasError ? Colors.red : Colors.blue),
    enabledBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(30.0)),
      borderSide: BorderSide(color: Colors.grey, width: 1.0),
    ),
    focusedBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(30.0)),
      borderSide: BorderSide(color: Colors.blue, width: 2.0),
    ),
    border: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(30.0)),
    ),
  );
}

InputDecoration getUnderlineInputDecoration(String labelText, {bool hasError = false}) {
  return InputDecoration(
    labelText: labelText,
    labelStyle: const TextStyle(color: Colors.black),
    floatingLabelStyle: TextStyle(color: hasError ? Colors.red : Colors.blue),
    enabledBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.grey),
    ),
    focusedBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.blue),
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
