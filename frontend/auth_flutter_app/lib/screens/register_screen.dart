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
      backgroundColor: const Color(
          0xFFada7af), // Set the background color to match the mockup
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 60),
                      const Text(
                        'Create new Account',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // First Name Field
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'First Name',
                          labelStyle: TextStyle(color: Colors.white),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                        onSaved: (val) => firstName = val!.trim(),
                        validator: (val) =>
                            val!.isEmpty ? 'Enter first name' : null,
                      ),
                      const SizedBox(height: 10),

                      // Last Name Field
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Last Name',
                          labelStyle: TextStyle(color: Colors.white),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                        onSaved: (val) => lastName = val!.trim(),
                        validator: (val) =>
                            val!.isEmpty ? 'Enter last name' : null,
                      ),
                      const SizedBox(height: 10),

                      // Username Field
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'User name',
                          labelStyle: TextStyle(color: Colors.white),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          prefixIcon: Icon(Icons.person_2, color: Colors.white),
                        ),
                        style: const TextStyle(color: Colors.white),
                        onSaved: (val) => username = val!.trim(),
                        validator: (val) =>
                            val!.isEmpty ? 'Enter username' : null,
                      ),
                      const SizedBox(height: 10),

                      // Email Field
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(color: Colors.white),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          prefixIcon:
                              Icon(Icons.email_outlined, color: Colors.white),
                        ),
                        style: const TextStyle(color: Colors.white),
                        onSaved: (val) => email = val!.trim(),
                        validator: (val) => val!.isEmpty || !val.contains('@')
                            ? 'Enter valid email'
                            : null,
                      ),
                      const SizedBox(height: 10),

                      // Password Field
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(color: Colors.white),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          prefixIcon: Icon(Icons.key, color: Colors.white),
                        ),
                        obscureText: true,
                        style: const TextStyle(color: Colors.white),
                        onSaved: (val) => password = val!.trim(),
                        validator: (val) => val!.length < 6
                            ? 'Password must be at least 6 characters'
                            : null,
                      ),
                      const SizedBox(height: 20),

                      // Profile Image Section (Updated with Text next to the CircleAvatar)
                      GestureDetector(
                        onTap: _pickImage,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Colors.white,
                                  child: _faceImage == null
                                      ? const Icon(Icons.person,
                                          size: 60, color: Color(0xFF1d0416))
                                      : ClipOval(
                                          child: Image.file(
                                            _faceImage!,
                                            fit: BoxFit.cover,
                                            width: 100,
                                            height: 100,
                                          ),
                                        ),
                                ),
                                const Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: CircleAvatar(
                                    backgroundColor: Color(0xFF1d0416),
                                    radius: 15,
                                    child: Icon(Icons.add_a_photo,
                                        size: 20, color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                                width: 15), // Space between image and text
                            const Text(
                              "Set Profile Image",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Capture Face Image Button
                      ElevatedButton(
                        onPressed: _pickImage,
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
                          'CAPTURE FACE IMAGE',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Register Button
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
                          'REGISTER',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      //const SizedBox(height: 1),

                      // Display any registration message
                      Text(
                        message,
                        style: TextStyle(color: successColor(message)),
                        textAlign: TextAlign.center,
                      ),
                      //const SizedBox(height: 1),

                      // Login Link
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                        child: const Text(
                          'Already have an account? Login',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 30),
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
