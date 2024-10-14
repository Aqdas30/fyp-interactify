import 'package:flutter/material.dart';
import 'package:uni_links/uni_links.dart';

class EmailVerificationResultScreen extends StatefulWidget {
  const EmailVerificationResultScreen({super.key});

  @override
  _EmailVerificationResultScreenState createState() =>
      _EmailVerificationResultScreenState();
}

class _EmailVerificationResultScreenState
    extends State<EmailVerificationResultScreen> {
  bool? _verificationSuccess;

  @override
  void initState() {
    super.initState();
    _handleIncomingLinks();
  }

  void _handleIncomingLinks() async {
    try {
      final initialLink = await getInitialLink();
      _handleLink(initialLink);
    } on Exception {
      // Handle exception if unable to get the initial link
    }

    // Listen to incoming links when the app is already running
    uriLinkStream.listen(
        (String? link) {
          _handleLink(link);
        } as void Function(Uri? event)?, onError: (err) {
      // Handle exception
    });
  }

  void _handleLink(String? link) {
    if (link != null) {
      final uri = Uri.parse(link);
      if (uri.path == '/email-verified') {
        setState(() {
          _verificationSuccess = uri.queryParameters['success'] == 'true';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Email Verification Result')),
      body: Center(
        child: _verificationSuccess == null
            ? const CircularProgressIndicator()
            : _verificationSuccess!
                ? const Text('Email verified successfully!')
                : const Text('Email verification failed. Please try again.'),
      ),
    );
  }
}
