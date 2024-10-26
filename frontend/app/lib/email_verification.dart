// email_verification.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EmailVerificationPage extends StatefulWidget {
  final String email;

  const EmailVerificationPage({required this.email, Key? key}) : super(key: key);

  @override
  _EmailVerificationPageState createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  final TextEditingController verificationCodeController = TextEditingController();

  Future<void> verifyEmail(String code) async {
    final url = Uri.parse('http://127.0.0.1:8000/user/verify_email/');
    final response = await http.post(
      url,
      body: jsonEncode({'email': widget.email, 'verification_code': code}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['success']) {
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'])),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${response.statusCode}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify Email'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('A verification code has been sent to your email.'),
            TextField(
              controller: verificationCodeController,
              decoration: InputDecoration(labelText: 'Enter Verification Code'),
            ),
            ElevatedButton(
              onPressed: () {
                verifyEmail(verificationCodeController.text);
              },
              child: Text('Verify'),
            ),
          ],
        ),
      ),
    );
  }
}
