// lib/main.dart

import 'package:auth_flutter_app/screens/email_verification_result.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/verification_pending_screen.dart';
import 'screens/forget_password.dart';
import 'package:uni_links/uni_links.dart';
import 'dart:async';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider()..checkAuthStatus(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    _handleIncomingLinks();
  }

  // Handle deep link URLs
  void _handleIncomingLinks() {
    _sub = uriLinkStream.listen((Uri? uri) async {
      if (uri != null) {
        // Handle email verification deep link
        if (uri.path == '/verify-email/') {
          final uid = uri.queryParameters['uid'];
          final token = uri.queryParameters['token'];

          if (uid != null && token != null) {
            // Wait for email verification to complete
            bool isVerified =
                await Provider.of<AuthProvider>(context, listen: false)
                    .verifyEmail(uid, token);

            // After verification, navigate based on result
            if (isVerified) {
              Navigator.pushNamed(context, '/login');
            } else {
              // Handle verification failure
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Verification Failed'),
                  content: const Text(
                      'Email verification failed. Please try again.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Close the dialog
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            }
          }
        }
      }
    }, onError: (err) {
      // Handle deep link errors
      print('Deep link error: $err');
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Auth Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: determineHomeScreen(authProvider),
      routes: {
        '/login': (_) => const LoginScreen(),
        '/register': (_) => const RegisterScreen(),
        '/home': (_) => const HomeScreen(),
        '/verification-pending': (_) => const VerificationPendingScreen(),
        '/email-verified': (context) => EmailVerificationResultScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen()
      },
    );
  }

  Widget determineHomeScreen(AuthProvider authProvider) {
    if (authProvider.isAuthenticated) {
      return const HomeScreen();
    } else if (authProvider.registeredEmail != null) {
      return const VerificationPendingScreen();
    } else {
      return const LoginScreen();
    }
  }
}
