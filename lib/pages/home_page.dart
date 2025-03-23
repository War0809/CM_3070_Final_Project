import 'package:flutter/material.dart';
import 'package:mise_en_place/utils/constant.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// Logo Image
            Image.asset(
              'assets/images/logo.png',
              width: 150,
              height: 150,
            ),
            smallGap,

            /// Sign In Button (3D effect)
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signin');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Button color
                foregroundColor: Colors.white, // Text color
                elevation: 8, // 3D elevation
                shadowColor: Colors.blueAccent, // Shadow color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: const Text('Sign In', style: TextStyle(fontSize: 16)),
            ),
            smallGap,

            /// Register Button (3D effect)
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signup');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Button color
                foregroundColor: Colors.white, // Text color
                elevation: 8, // 3D elevation
                shadowColor: Colors.blueAccent, // Shadow color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: const Text('Register', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
