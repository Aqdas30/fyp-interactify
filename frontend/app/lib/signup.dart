

// import 'dart:convert';
// import 'package:app/email_verification.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class SignupPage extends StatefulWidget {
//   @override
//   _SignupPageState createState() => _SignupPageState();
// }

// class _SignupPageState extends State<SignupPage> {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController firstNameController = TextEditingController();
//   final TextEditingController lastNameController = TextEditingController();
//   final TextEditingController usernameController = TextEditingController();

//   Future<void> signup(String email, String password, String firstName, String lastName, String username) async {
//     final url = Uri.parse('http://127.0.0.1:8000/user/create/');
//     final response = await http.post(
//       url,
//       body: jsonEncode({
//         'email': email,
//         'password': password,
//         'first_name': firstName,
//         'last_name': lastName,
//         'username': username,
//       }),
//       headers: {'Content-Type': 'application/json'},
//     );

//     if (response.statusCode == 201) {
//       // Navigate to verification page
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => EmailVerificationPage(email: email),
//         ),
//       );
//     } else {
//       print('Signup failed');
//       print(response.body);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Signup'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: emailController,
//               decoration: InputDecoration(labelText: 'Email'),
//             ),
//             TextField(
//               controller: passwordController,
//               decoration: InputDecoration(labelText: 'Password'),
//               obscureText: true,
//             ),
//             TextField(
//               controller: firstNameController,
//               decoration: InputDecoration(labelText: 'First Name'),
//             ),
//             TextField(
//               controller: lastNameController,
//               decoration: InputDecoration(labelText: 'Last Name'),
//             ),
//             TextField(
//               controller: usernameController,
//               decoration: InputDecoration(labelText: 'Username'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 signup(
//                   emailController.text,
//                   passwordController.text,
//                   firstNameController.text,
//                   lastNameController.text,
//                   usernameController.text,
//                 );
//               },
//               child: Text('Signup'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:app/email_verification.dart';  // Import the EmailVerificationPage

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  String username = '';
  String email = '';
  String password = '';
  String firstName = '';
  String lastName = '';
  bool isLoading = false;
  String message = '';

  // Function to handle signup API request
  Future<void> signup(String email, String password, String firstName, String lastName, String username) async {
    final url = Uri.parse('http://127.0.0.1:8000/user/create/');
    
    // Create request body
    var body = jsonEncode({
      'email': email,
      'password': password,
      'first_name': firstName,
      'last_name': lastName,
      'username': username,
    });

    final response = await http.post(
      url,
      body: body,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      // If successful, navigate to the email verification page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EmailVerificationPage(email: email),
        ),
      );
    } else {
      setState(() {
        message = 'Signup failed. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFada7af), // Background color
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
                        validator: (val) => val!.isEmpty ? 'Enter first name' : null,
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
                        validator: (val) => val!.isEmpty ? 'Enter last name' : null,
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
                        validator: (val) => val!.isEmpty ? 'Enter username' : null,
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
                          prefixIcon: Icon(Icons.email_outlined, color: Colors.white),
                        ),
                        style: const TextStyle(color: Colors.white),
                        onSaved: (val) => email = val!.trim(),
                        validator: (val) => val!.isEmpty || !val.contains('@') ? 'Enter valid email' : null,
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
                        validator: (val) => val!.length < 6 ? 'Password must be at least 6 characters' : null,
                      ),
                      const SizedBox(height: 20),

                      // Register Button
                      ElevatedButton(
                        onPressed: () async {
                          final form = _formKey.currentState;
                          if (form != null && form.validate()) {
                            form.save();
                            setState(() {
                              isLoading = true;
                              message = '';
                            });

                            // Call the register function and handle response
                            await signup(email, password, firstName, lastName, username);

                            setState(() {
                              isLoading = false;
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1d0416),
                          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'REGISTER',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),

                      // Display any registration message
                      Text(
                        message,
                        style: TextStyle(color: successColor(message)),
                        textAlign: TextAlign.center,
                      ),

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
