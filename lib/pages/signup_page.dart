import 'package:flutter/material.dart';
import 'package:mise_en_place/utils/constant.dart';
import 'package:mise_en_place/utils/styles.dart';
import 'package:mise_en_place/utils/email_validation.dart';
import 'package:mise_en_place/utils/password_validation.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String? emailError;
  String? passwordError;
  String? confirmPasswordError;

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  bool isFormValid = false;

  void _validateEmail(String value) {
  setState(() {
    emailError = EmailValidator.validateEmail(value);
    _checkFormValidity();
  });
}

  void _validatePassword(String value) {
  setState(() {
    passwordError = PasswordValidator.validatePassword(value);

    // Ensure confirm password matches the password
    if (_confirmPasswordController.text.isNotEmpty &&
        _confirmPasswordController.text != value) {
      confirmPasswordError = 'Passwords do not match';
    } else {
      confirmPasswordError = null;
    }
    _checkFormValidity();
  });
}

  void _validateConfirmPassword(String value) {
    setState(() {
      if (value != _passwordController.text) {
        confirmPasswordError = 'Passwords do not match';
      } else {
        confirmPasswordError = null;
      }
      _checkFormValidity();
    });
  }

  void _checkFormValidity() {
    setState(() {
      isFormValid = emailError == null &&
          passwordError == null &&
          confirmPasswordError == null &&
          _emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty &&
          _confirmPasswordController.text.isNotEmpty;
    });
  }

  Future<bool> createUser({
    required final String email,
    required final String password,
  }) async {
    final response = await client.auth.signUp(email, password);
    final error = response.error;
    return error == null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Image.asset(
              'assets/images/logo.png',
              width: 150,
              height: 150,
              ),
              largeGap,

              TextFormField(
                controller: _emailController,
                cursorColor: Colors.blue,
                decoration: getInputDecoration('Email', hasError: emailError != null).copyWith(
                  errorText: emailError,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                style: const TextStyle(color: Colors.black),
                onChanged: _validateEmail,
              ),
              smallGap,

              TextFormField(
                controller: _passwordController,
                cursorColor: Colors.blue,
                decoration: getInputDecoration('Password', hasError: passwordError != null).copyWith(
                  errorText: passwordError,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      color: Colors.blue,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                style: const TextStyle(color: Colors.black),
                obscureText: !_isPasswordVisible,
                onChanged: _validatePassword,
              ),
              smallGap,

              TextFormField(
                controller: _confirmPasswordController,
                cursorColor: Colors.blue,
                decoration: getInputDecoration('Confirm Password', hasError: confirmPasswordError != null).copyWith(
                  errorText: confirmPasswordError,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      color: Colors.blue,
                    ),
                    onPressed: () {
                      setState(() {
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                style: const TextStyle(color: Colors.black),
                obscureText: !_isConfirmPasswordVisible,
                onChanged: _validateConfirmPassword,
              ),
              largeGap,

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isFormValid
                      ? () async {
                          final userValue = await createUser(
                            email: _emailController.text,
                            password: _passwordController.text,
                          );
                          if (userValue == true) {
                            Navigator.pushReplacementNamed(context, '/signin');
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Successful Registration')),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Registration Failed')),
                            );
                          }
                        }
                      : null, // Disable the button if form is invalid
                  style: ElevatedButton.styleFrom(
                          backgroundColor: isFormValid ? Colors.blue : Colors.grey,
                          foregroundColor: Colors.white,
                          elevation: 8,
                          shadowColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                        ),
                        child: const Text('Register'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
