
// // login.dart

// import 'dart:convert';
// import 'package:app/google_signin.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'forgot_password.dart';  // Import the ForgotPasswordPage

// class LoginPage extends StatefulWidget {
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   Future<void> login(String email, String password) async {
//     final url = Uri.parse('http://127.0.0.1:8000/user/login/');
//     final response = await http.post(
//       url,
//       body: jsonEncode({'email': email, 'password': password}),
//       headers: {'Content-Type': 'application/json'},
//     );

//     if (response.statusCode == 200) {
//       final responseData = jsonDecode(response.body);

//       if (responseData['success']) {
//         final token = responseData['token'];
//         final userId = responseData['user_id'];

//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         await prefs.setString('token', token);
//         await prefs.setInt('user_id', userId);

//         Navigator.pushReplacementNamed(context, '/home');
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Login failed: ${responseData['message']}')),
//         );
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: ${response.statusCode}')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Login'),
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
//             ElevatedButton(
//               onPressed: () {
//                 login(emailController.text, passwordController.text);
//               },
//               child: Text('Login'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => ForgotPasswordPage()),  // Navigate to ForgotPasswordPage
//                 );
//               },
//               child: Text('Forgot Password?'),
              
//             ),
//             SizedBox(height: 16),
//             Text('Or login with Google'),

//             // Button for Google login
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => GoogleLogin()),  // Navigate to GoogleLogin page
//                 );
//               },
//               child: Text('Login with Google'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }








import 'dart:convert';
import 'package:app/google_signin.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'forgot_password.dart';  // Import the ForgotPasswordPage

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  bool isLoading = false;
  String message = '';

  // Function to handle login
  Future<void> login(String email, String password) async {
    setState(() {
      isLoading = true;
    });
    final url = Uri.parse('http://127.0.0.1:8000/user/login/');
    final response = await http.post(
      url,
      body: jsonEncode({'email': email, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      if (responseData['success']) {
        final token = responseData['token'];
        final userId = responseData['user_id'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setInt('user_id', userId);

        setState(() {
          message = 'Login successful';
          isLoading = false;
        });

        Navigator.pushReplacementNamed(context, '/home');
      } else {
        setState(() {
          message = 'Login failed: ${responseData['message']}';
          isLoading = false;
        });
      }
    } else {
      setState(() {
        message = 'Error: ${response.statusCode}';
        isLoading = false;
      });
    }
  }

  // Login page UI with functionality integrated
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFada7af),  // Background color
      resizeToAvoidBottomInset: true,  // Avoid overflow when keyboard appears
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 80),

                    // Logo image
                    Image.asset(
                      'images/logo.png',
                      height: 250,
                      width: 250,
                      fit: BoxFit.contain,
                    ),

                    const SizedBox(height: 20),

                    // Email field
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Colors.white),
                        prefixIcon: Icon(Icons.email, color: Colors.white),  // Email icon
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                      onSaved: (val) => email = val!.trim(),
                      validator: (val) => val!.isEmpty ? 'Enter email' : null,
                    ),

                    const SizedBox(height: 20),

                    // Password field
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Colors.white),
                        prefixIcon: Icon(Icons.lock, color: Colors.white),  // Password icon
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      obscureText: true,
                      style: const TextStyle(color: Colors.white),
                      onSaved: (val) => password = val!.trim(),
                      validator: (val) => val!.isEmpty ? 'Enter password' : null,
                    ),

                    const SizedBox(height: 5),

                    // Forgot password link
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ForgotPasswordPage(),
                            ),
                          );
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
                        backgroundColor: const Color(0xFF1d0416),  // Button color
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),  // Rounded button
                        ),
                      ),
                      onPressed: () {
                        final form = _formKey.currentState;
                        if (form != null && form.validate()) {
                          form.save();
                          login(email, password);  // Call the login function
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

                    const SizedBox(height: 10),

                    // Display login message
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

                    const SizedBox(height: 16),

                    const Text('Or login with Google', style: TextStyle(color: Colors.white)),

                    // Google login button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GoogleLogin(),
                          ),
                        );
                      },
                      child: const Text('Login with Google'),
                    ),

                    const SizedBox(height: 40),  // Extra space at the bottom
                  ],
                ),
              ),
            ),
    );
  }

  // Function to determine message color based on message content
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
