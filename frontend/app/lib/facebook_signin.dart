// facebook_login.dart

import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class FacebookLogin extends StatefulWidget {
  @override
  _FacebookLoginState createState() => _FacebookLoginState();
}

class _FacebookLoginState extends State<FacebookLogin> {
  Future<void> handleFacebookLogin() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;

        // Send this access token to your Django backend
        final response = await http.post(
          Uri.parse('http://127.0.0.1:8000/auth/convert-token/'),
          body: {
            'grant_type': 'convert_token',
            'client_id': 'your-django-client-id',
            'client_secret': 'your-django-client-secret',
            'backend': 'facebook',
            // 'token': accessToken.token,
          },
        );

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          final token = responseData['access_token'];

          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);

          Navigator.pushReplacementNamed(context, '/home');
        } else {
          throw Exception('Failed to log in with Facebook');
        }
      } else {
        print(result.message);
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Facebook Login")),
      body: Center(
        child: ElevatedButton(
          onPressed: handleFacebookLogin,
          child: Text("Login with Facebook"),
        ),
      ),
    );
  }
}
