import 'dart:convert';
import 'package:http/http.dart' as http;

/// Custom exception for handling registration-specific API errors
class SignUpApiException implements Exception {
  final String message;
  final int? statusCode;
  const SignUpApiException(this.message, {this.statusCode});

  @override
  String toString() => 'SignUpApiException: $message [Status: $statusCode]';
}

/// The SignUpRepository handles all network operations for user registration.
class SignUpRepository {
  // Use http://10.0.2.2 for Android Emulator, or your local IP for physical devices.
  // IMPORTANT: Replace this with your actual Node.js API registration endpoint.
  static const String _registrationUrl = 'http://192.168.1.75:5000/api/auth/register';

  final http.Client _client;

  SignUpRepository({http.Client? client}) : _client = client ?? http.Client();

  /// Posts user registration data to the Node.js API.
  Future<bool> registerUser({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phoneNumber,
    required String roleId,
    String profilePicture = "", // Default to empty string
  }) async {
    final uri = Uri.parse(_registrationUrl);

    // 1. Prepare the JSON payload using the EXACT keys required by your Node.js API
    final Map<String, dynamic> payload = {
      "first_name": firstName,
      "last_name": lastName,
      "email_address": email,
      "password": password,
      "phone_number": phoneNumber,
      "role_id": roleId,
      "profile_picture_image": profilePicture,
    };

    try {
      final response = await _client.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          // If your API requires an API key, add it here:
          // 'X-API-Key': 'your_secret_key',
        },
        body: jsonEncode(payload),
      );

      // 2. Process the API response
      if (response.statusCode == 201) {
        // HTTP 201 Created is the standard for successful resource creation
        print('Registration successful! Server response: ${response.body}');
        return true;

      } else {
        // Handle non-201 status codes (4xx, 5xx)
        String errorMessage = 'Registration failed. Server responded with status ${response.statusCode}.';

        try {
          final dynamic errorBody = jsonDecode(response.body);
          // Assuming your Node.js API returns an error message under a 'message' or 'error' key
          if (errorBody is Map<String, dynamic>) {
            errorMessage = errorBody['message'] ?? errorBody['error'] ?? errorMessage;
          }
        } catch (e) {
          // JSON decoding failed for the error body, use default message
        }

        throw SignUpApiException(errorMessage, statusCode: response.statusCode);
      }
    } on http.ClientException {
      // Network connectivity issues (timeout, no internet, server unreachable)
      throw const SignUpApiException('Network error: Could not connect to the registration server.');
    } on FormatException {
      // JSON encoding/decoding issues
      throw const SignUpApiException('Data format error: Invalid JSON response.');
    } catch (e) {
      // Catch the custom API exception or any other unexpected error
      rethrow;
    }
  }
}