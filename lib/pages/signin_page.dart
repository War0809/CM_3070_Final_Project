import 'package:flutter/material.dart';
import 'package:mise_en_place/utils/constant.dart';
import 'package:mise_en_place/utils/styles.dart';
import 'package:mise_en_place/utils/email_validation.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  /// Initialize controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Error message for email validation
  String? emailError;
  bool isLoading = false;
  bool isFormValid = false;

  // Password visibility toggle
  bool _isPasswordVisible = false;

  /// Email validation function
  void _validateEmail(String value) {
  setState(() {
    emailError = EmailValidator.validateEmail(value);
    _checkFormValidity();
  });
}

  /// Check if the form is valid
  void _checkFormValidity() {
    setState(() {
      isFormValid = emailError == null &&
          _emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty;
    });
  }

  /// [userLogin] Function to handle login
  Future<String?> userLogin({
    required final String email,
    required final String password,
  }) async {
    final response = await client.auth.signIn(email: email, password: password);
    final user = response.data?.user;
    return user?.id;
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
              /// Logo Image
            Image.asset(
              'assets/images/logo.png',
              width: 150,
              height: 150,
              ),
              largeGap,

              /// Email Input
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

              /// Password Input with visibility toggle
              TextFormField(
                controller: _passwordController,
                cursorColor: Colors.blue,
                decoration: getInputDecoration('Password').copyWith(
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
                onChanged: (value) => _checkFormValidity(),
              ),
              largeGap,

              /// Sign In Button with 3D effect
              isLoading
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isFormValid
                            ? () async {
                                setState(() {
                                  isLoading = true;
                                });
                                dynamic loginValue = await userLogin(
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                );
                                setState(() {
                                  isLoading = false;
                                });
                                if (loginValue != null) {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    '/simpleapp',
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Invalid Email or Password')),
                                  );
                                }
                              }
                            : null, // Disable the button if the form is invalid
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isFormValid ? Colors.blue : Colors.grey,
                          foregroundColor: Colors.white, // Text color
                          elevation: 8, // 3D effect
                          shadowColor: Colors.blueAccent, // Shadow color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                        ),
                        child: const Text('Sign In'),
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
    super.dispose();
  }
}
