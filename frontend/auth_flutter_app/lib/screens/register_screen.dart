// lib/screens/register_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'verification_pending_screen.dart'; // Import the new screen
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String username = '';
  String email = '';
  String password = '';
  String firstName = '';
  String lastName = '';
  bool isLoading = false;
  String message = '';
  File? _faceImage;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _faceImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'Username'),
                        onSaved: (val) => username = val!.trim(),
                        validator: (val) =>
                            val!.isEmpty ? 'Enter username' : null,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Email'),
                        onSaved: (val) => email = val!.trim(),
                        validator: (val) => val!.isEmpty || !val.contains('@')
                            ? 'Enter valid email'
                            : null,
                      ),
                      TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'First Name'),
                        onSaved: (val) => firstName = val!.trim(),
                        validator: (val) =>
                            val!.isEmpty ? 'Enter first name' : null,
                      ),
                      TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'Last Name'),
                        onSaved: (val) => lastName = val!.trim(),
                        validator: (val) =>
                            val!.isEmpty ? 'Enter last name' : null,
                      ),
                      TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'Password'),
                        obscureText: true,
                        onSaved: (val) => password = val!.trim(),
                        validator: (val) => val!.length < 6
                            ? 'Password must be at least 6 characters'
                            : null,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _pickImage,
                        child: const Text('Capture Face Image'),
                      ),
                      if (_faceImage != null)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.file(_faceImage!),
                        ),
                      ElevatedButton(
                        onPressed: () async {
                          final form = _formKey.currentState;
                          if (form != null && form.validate()) {
                            form.save();
                            if (_faceImage == null) {
                              setState(() {
                                message =
                                    'Please capture your face image to proceed.';
                              });
                              return;
                            }
                            setState(() {
                              isLoading = true;
                              message = '';
                            });

                            // Call the register function and handle response
                            var response = await authProvider.register(
                              username: username,
                              email: email,
                              password: password,
                              firstName: firstName,
                              lastName: lastName,
                              faceImage: _faceImage!,
                            );

                            // Handle the response
                            if (response['success']) {
                              // Registration successful, navigate to verification pending screen
                              Navigator.pushReplacementNamed(
                                  context, '/verification-pending');
                            } else {
                              // Show error message
                              setState(() {
                                message = response['message'];
                              });
                            }

                            setState(() {
                              isLoading = false;
                            });
                          }
                        },
                        child: const Text('Register'),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        message,
                        style: TextStyle(color: successColor(message)),
                        textAlign: TextAlign.center,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                        child: const Text('Already have an account? Login'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Color successColor(String msg) {
    if (msg.contains('successful')) {
      return Colors.green;
    } else if (msg.contains('failed')) {
      return Colors.red;
    } else {
      return Colors.black;
    }
  }
}
