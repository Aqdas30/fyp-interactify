// lib/screens/verification_pending_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class VerificationPendingScreen extends StatefulWidget {
  const VerificationPendingScreen({super.key});

  @override
  _VerificationPendingScreenState createState() =>
      _VerificationPendingScreenState();
}

class _VerificationPendingScreenState extends State<VerificationPendingScreen> {
  bool isLoading = false;
  String message = '';

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final email = authProvider.registeredEmail ?? '';

    return Scaffold(
      appBar: AppBar(title: const Text('Verify Your Email')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Registration successful! Please check your email ($email) to verify your account.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      if (email.isEmpty) {
                        setState(() {
                          message = 'No email found to resend verification.';
                        });
                        return;
                      }
                      setState(() {
                        isLoading = true;
                        message = '';
                      });
                      bool success =
                          await authProvider.resendVerificationEmail();
                      setState(() {
                        isLoading = false;
                        message = success
                            ? 'Verification email resent. Please check your inbox.'
                            : 'Failed to resend verification email.';
                      });
                    },
                    child: const Text('Resend Verification Email'),
                  ),
            const SizedBox(height: 10),
            Text(
              message,
              style: TextStyle(color: successColor(message)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text('Already verified? Login'),
            ),
          ],
        ),
      ),
    );
  }

  Color successColor(String msg) {
    if (msg.contains('resent') || msg.contains('successful')) {
      return Colors.green;
    } else if (msg.contains('Failed') || msg.contains('No email')) {
      return Colors.red;
    } else {
      return Colors.black;
    }
  }
}
