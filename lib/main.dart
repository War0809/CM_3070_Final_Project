import 'package:flutter/material.dart';
import 'package:mise_en_place/utils/constant.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:mise_en_place/pages/home_page.dart';
import 'package:mise_en_place/pages/signin_page.dart';
import 'package:mise_en_place/pages/signup_page.dart';
import 'package:mise_en_place/pages/simpleapp_page.dart';
import 'package:mise_en_place/pages/profile_page.dart';
import 'package:mise_en_place/pages/addbook.dart';
import 'package:mise_en_place/pages/library_page.dart';

void main() async {
  await Supabase.initialize(
    url: 'https://osnbhcnwscdgvxpekmvs.supabase.co',
    anonKey:'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9zbmJoY253c2NkZ3Z4cGVrbXZzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mjc4MDI0ODQsImV4cCI6MjA0MzM3ODQ4NH0.KNWf_-iZZPCOKySw-ibZeEGNSrkU3r4PxcuiLR-ySsQ', 
    );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mise En Place',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: client.auth.currentSession != null ? '/simpleapp' : '/',
      routes: {
        '/': (context) => const HomePage(),
        '/signin': (context) => const SignInPage(),
        '/signup': (context) => const SignUpPage(),
        '/simpleapp': (context) => const SimpleAppPage(),
        '/profile' : (context) => const ProfilePage(),
        '/addbook' :(context) => const AddBookPage(),
        '/library' :(context) => const LibraryPage(),
      },
    );
  }
}

