// lib/screens/forgot_password_screen.dart

import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  bool isLoading = false;
  String message = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFada7af), // Background color as per the design
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Lock Icon
                    const Icon(
                      Icons.lock_open_outlined,
                      size: 100,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 20),

                    // Title
                    const Text(
                      'Forgot your Password?',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Subtitle
                    const Text(
                      'Please enter the email address you\'d like your password reset information sent to',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Email Input Field
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Enter Email',
                        labelStyle: TextStyle(color: Colors.white),
                        prefixIcon:
                            Icon(Icons.email_outlined, color: Colors.white),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                      onSaved: (val) => email = val!.trim(),
                      validator: (val) => val!.isEmpty || !val.contains('@')
                          ? 'Enter a valid email'
                          : null,
                    ),
                    const SizedBox(height: 40),

                    // Reset Password Button
                    ElevatedButton(
                      onPressed: () async {
                        final form = _formKey.currentState;
                        if (form != null && form.validate()) {
                          form.save();
                          setState(() {
                            isLoading = true;
                          });
                          // Simulate password reset process
                          await Future.delayed(const Duration(seconds: 2));
                          setState(() {
                            isLoading = false;
                            message = 'Password reset email sent!';
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFF1d0416), // Button color
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'RESET PASSWORD',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    //const SizedBox(height: 10),

                    // Message or Error Text
                    Text(
                      message,
                      style: const TextStyle(color: Colors.green),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),

                    // Back to Login
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      child: const Text(
                        'Go back to login',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
