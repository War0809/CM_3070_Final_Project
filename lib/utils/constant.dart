import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


/// [client] for Supabase instance
final client = Supabase.instance.client;

/// Small Gap
const smallGap = SizedBox(
  height: 15,
);

/// Large Gap
const largeGap = SizedBox(
  height: 30,
);

///Custom SnackBar
extension ShowSnackBar on BuildContext{
  void showErrorMessage(String message){
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.redAccent),
          ),
          backgroundColor: Colors.grey,
          ),
          );
  }
}
