// lib/services/auth_service.dart

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl =
      'http://172.24.0.1:8000/api/auth/'; // Update based on your environment

  Future<bool> register({
    required String username,
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required File faceImage, // Pass the captured face image
  }) async {
    final url = Uri.parse('${baseUrl}register/');

    // Prepare multipart request
    var request = http.MultipartRequest('POST', url);
    request.fields['username'] = username;
    request.fields['email'] = email;
    request.fields['password'] = password;
    request.fields['password2'] = password;
    request.fields['first_name'] = firstName;
    request.fields['last_name'] = lastName;

    // Add face image
    var imageFile =
        await http.MultipartFile.fromPath('face_image', faceImage.path);
    request.files.add(imageFile);

    var response = await request.send();

    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    final url = Uri.parse('${baseUrl}login/');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    print('Login response: ${response.statusCode} - ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', data['access']);
      await prefs.setString('refresh_token', data['refresh']);
      return {'success': true};
    } else {
      final errorData = jsonDecode(response.body);
      String errorMessage = '';
      if (errorData['error'] != null) {
        errorMessage = errorData['error'];
      } else if (errorData['detail'] != null) {
        errorMessage = errorData['detail'];
      } else {
        errorMessage = 'Login failed. Please try again.';
      }
      return {'success': false, 'error': errorMessage};
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
  }

  Future<String?> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  Future<bool> isLoggedIn() async {
    String? token = await getAccessToken();
    return token != null;
  }

  Future<bool> resendVerificationEmail({required String email}) async {
    try {
      final url = Uri.parse('${baseUrl}resend-verification/');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      print(
          'Resend Verification Email response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        return true;
      } else {
        // Optionally, parse the error message from response
        print('Failed to resend verification email: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error in resendVerificationEmail: $e');
      return false;
    }
  }

  Future<bool> verifyEmail(String uid, String token) async {
    final url =
        'http://192.168.0.xxx:8000/api/auth/verify-email/?uid=$uid&token=$token'; // Replace xxx with your laptop's IP address

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        // Email verification succeeded
        return true;
      } else {
        // Email verification failed
        print('Failed to verify email: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error verifying email: $e');
      return false;
    }
  }
}
