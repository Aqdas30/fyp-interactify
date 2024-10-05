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
      appBar: AppBar(title: const Text('Login')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Username'),
                      onSaved: (val) => username = val!.trim(),
                      validator: (val) =>
                          val!.isEmpty ? 'Enter username' : null,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      onSaved: (val) => password = val!.trim(),
                      validator: (val) =>
                          val!.isEmpty ? 'Enter password' : null,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
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
                      child: const Text('Login'),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      message,
                      style: TextStyle(color: successColor(message)),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/register');
                      },
                      child: const Text('Don\'t have an account? Register'),
                    ),
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
