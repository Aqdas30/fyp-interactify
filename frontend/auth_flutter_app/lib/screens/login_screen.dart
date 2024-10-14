// lib/screens/login_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'home_screen.dart';
import 'verification_pending_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String username = '';
  String password = '';
  bool isLoading = false;
  String message = '';

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor:
          const Color(0xFFada7af), // Background color from your provided scheme
      resizeToAvoidBottomInset:
          true, // To avoid bottom overflow when keyboard appears
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              // Wrap with SingleChildScrollView to enable scrolling when keyboard appears
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                        height: 80), // Space from top to center the form

                    // Logo image
                    Image.asset(
                      'images/logo.png', // Ensure your logo is in this location
                      height: 250, // Set the height you want
                      width: 250, // Set the width you want
                      fit: BoxFit.contain,
                    ),
                    //const SizedBox(height: 10), // Space between logo and form

                    // Username field
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'User name',
                        labelStyle: TextStyle(color: Colors.white),
                        prefixIcon: Icon(Icons.person_2,
                            color: Colors.white), // Icon color
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.white), // Underline border color
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      style: const TextStyle(
                          color: Colors.white), // Text color for input
                      onSaved: (val) => username = val!.trim(),
                      validator: (val) =>
                          val!.isEmpty ? 'Enter username' : null,
                    ),
                    const SizedBox(height: 20), // Space between input fields

                    // Password field
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Colors.white),
                        prefixIcon:
                            Icon(Icons.key, color: Colors.white), // Icon color
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.white), // Underline border color
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      obscureText: true,
                      style: const TextStyle(color: Colors.white),
                      onSaved: (val) => password = val!.trim(),
                      validator: (val) =>
                          val!.isEmpty ? 'Enter password' : null,
                    ),
                    const SizedBox(
                        height:
                            5), // Small space between input and "Forgot Password"

                    // Forgot password link
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, '/forgot-password');
                        },
                        child: const Text(
                          'Forgot your password?',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Login button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFF1d0416), // Button color
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(30), // Rounded button
                        ),
                      ),
                      onPressed: () async {
                        final form = _formKey.currentState;
                        if (form != null && form.validate()) {
                          form.save();
                          setState(() {
                            isLoading = true;
                            message = '';
                          });
                          var result = await authProvider.login(
                            username: username,
                            password: password,
                          );
                          setState(() {
                            isLoading = false;
                            if (result['success']) {
                              message = 'Login successful';
                            } else {
                              message = result['error'] ?? 'Login failed';
                            }
                          });
                          if (result['success']) {
                            Navigator.pushReplacementNamed(context, '/home');
                          } else {
                            // If the error indicates that the email is not verified, navigate to verification pending screen
                            if (message.contains('verify your email')) {
                              Navigator.pushReplacementNamed(
                                  context, '/verification-pending');
                            }
                          }
                        }
                      },
                      child: const Text(
                        'LOGIN',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    //const SizedBox(
                    //height: 0), // Space between button and message

                    // Display any login message
                    Text(
                      message,
                      style: TextStyle(color: successColor(message)),
                    ),

                    // Register link
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/register');
                      },
                      child: const Text(
                        'Don\'t have an account? Register',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),

                    const SizedBox(height: 40), // Extra space at the bottom
                  ],
                ),
              ),
            ),
    );
  }

  Color successColor(String msg) {
    if (msg.contains('successful')) {
      return Colors.green;
    } else if (msg.contains('failed') || msg.contains('verify your email')) {
      return Colors.red;
    } else {
      return Colors.black;
    }
  }
}
