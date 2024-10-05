// lib/providers/auth_provider.dart

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';
import 'package:http/http.dart' as http;

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isAuthenticated = false;
  String? _registeredEmail; // To store the email of the newly registered user
  final String baseUrl = 'http://192.168.0.122:8000/api/auth/';

  bool get isAuthenticated => _isAuthenticated;
  String? get registeredEmail => _registeredEmail; // Getter for registeredEmail

  Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required File faceImage, // Pass the face image here
  }) async {
    final url = Uri.parse('${baseUrl}register/');

    var request = http.MultipartRequest('POST', url);
    request.fields['username'] = username;
    request.fields['email'] = email;
    request.fields['password'] = password;
    request.fields['password2'] = password;
    request.fields['first_name'] = firstName;
    request.fields['last_name'] = lastName;

    // Attach face image file
    var imageFile =
        await http.MultipartFile.fromPath('face_image', faceImage.path);
    request.files.add(imageFile);

    try {
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
        return {'success': true}; // Registration successful
      } else if (response.statusCode == 400) {
        var responseBody = jsonDecode(response.body);
        return {
          'success': false,
          'message': responseBody['error'] ?? 'Registration failed'
        }; // Include error message if face already exists
      } else {
        return {'success': false, 'message': 'Unknown error occurred'};
      }
    } catch (error) {
      return {'success': false, 'message': 'Network error'};
    }
  }

  // lib/providers/auth_provider.dart

  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    var result = await _authService.login(
      username: username,
      password: password,
    );
    if (result['success']) {
      _isAuthenticated = true;
    }
    notifyListeners();
    return result;
  }

  Future<void> logout() async {
    await _authService.logout();
    _isAuthenticated = false;
    notifyListeners();
  }

  Future<void> checkAuthStatus() async {
    _isAuthenticated = await _authService.isLoggedIn();
    notifyListeners();
  }

  Future<bool> resendVerificationEmail() async {
    if (_registeredEmail == null) return false;
    bool success =
        await _authService.resendVerificationEmail(email: _registeredEmail!);
    return success;
  }

  // Call AuthService to verify email
  Future<bool> verifyEmail(String uid, String token) async {
    AuthService authService = AuthService();
    bool isVerified = await authService.verifyEmail(uid, token);

    if (isVerified) {
      // Update state
      _isAuthenticated = true;
      notifyListeners(); // This will notify the UI to update
    }

    return isVerified;
  }
}
