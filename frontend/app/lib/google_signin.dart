// google_login.dart

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GoogleLogin extends StatefulWidget {
  @override
  _GoogleLoginState createState() => _GoogleLoginState();
}

class _GoogleLoginState extends State<GoogleLogin> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: '1030778154810-b4lihvrr092eq2aucudopsfql613qt6h.apps.googleusercontent.com',  // Your Google Web Client ID
    scopes: ['email'],
  );

  Future<void> handleGoogleLogin() async {
    try {
      GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // The user canceled the login
        return;
      }

      // Retrieve authentication details from the googleUser
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      String accessToken = googleAuth.accessToken!;

      // Send this access token to your Django backend for validation
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/auth/convert-token/'),
        body: {
          'grant_type': 'convert_token',
          'client_id': 'your-django-client-id',
          'client_secret': 'your-django-client-secret',
          'backend': 'google-oauth2',
          'token': accessToken,
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final token = responseData['access_token'];

        // Store the token in SharedPreferences for future use
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        // Navigate to the home page after successful login
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        throw Exception('Failed to log in with Google');
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Google Login")),
      body: Center(
        child: ElevatedButton(
          onPressed: handleGoogleLogin,
          child: Text("Login with Google"),
        ),
      ),
    );
  }
}
