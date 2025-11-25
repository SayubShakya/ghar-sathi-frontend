import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:loginappv2/src/features/user_credentials/models/roles_model.dart';
import 'package:loginappv2/src/features/user_credentials/services/role_services.dart'; // Ensure RoleApiException is imported

/// Custom exception for handling API-related errors.
class RoleApiException implements Exception {
  final String message;
  final int? statusCode;
  const RoleApiException(this.message, {this.statusCode});

  @override
  String toString() => 'RoleApiException: $message [Status: $statusCode]';
}

/// The RoleRepository handles all data operations (fetching, creating, etc.)
/// related to RoleModel, abstracting the API details.
class RoleRepository {
  // Use 10.0.2.2 for Android emulator connectivity
  static const String _baseUrl = 'http://192.168.1.75:5000/api/roles';
  final http.Client _client;

  // IMPORTANT: Replace this with actual token retrieval logic later!
  // This is a dummy token for testing access to the /api/roles endpoint.
  static const String _temporaryAuthToken = 'YOUR_SECRET_JWT_TOKEN_HERE';

  RoleRepository({http.Client? client}) : _client = client ?? http.Client();

  /// Fetches a list of all roles from the backend API.
  Future<List<RoleModel>> fetchAllRoles() async {
    final uri = Uri.parse(_baseUrl);

    // 1. Define the headers, including the Authorization header
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      // CRITICAL FIX: Include the Authorization header with the JWT token
      'Authorization': 'Bearer $_temporaryAuthToken',
    };

    try {
      // 2. Pass the headers to the GET request
      final response = await _client.get(uri, headers: headers);
      final dynamic decodedBody = jsonDecode(response.body) as dynamic;


      if (response.statusCode == 200) {
        // --- NEW CHECK FOR ERROR BODY ---
        // If the body is a Map and contains an 'error' key, treat it as an unauthorized response.
        if (decodedBody is Map<String, dynamic> && decodedBody.containsKey('error')) {
          // Treating this as an authentication failure if the backend sends 200 with an error body.
          throw RoleApiException(decodedBody['error'] as String, statusCode: response.statusCode);
        }
        // --- END NEW CHECK ---
print('Decoded Body: $decodedBody');

        // If the body is a List, proceed with successful decoding.
        // if (decodedBody is List) {
          final res=PaginatedRolesResponse.fromJson(decodedBody);
          print(res);
          return res.data;

        // } else {
        //   // If it's a 200 OK but the body isn't an expected List or error Map, something is structurally wrong.
        //   throw const RoleApiException('Successful response body is not a list of roles.', statusCode: 200);
        // }

      } else if (response.statusCode == 401) {
        // Handle explicit Authorization failure (e.g., if the backend sends 401)
        final String errorMsg = (decodedBody is Map<String, dynamic> && decodedBody.containsKey('error'))
            ? decodedBody['error'] as String
            : 'Authorization Failed. Token may be expired or invalid.';
        throw RoleApiException(errorMsg, statusCode: 401);
      } else {
        // Handle other non-200/401 status codes
        final String errorMsg = (decodedBody is Map<String, dynamic> && decodedBody.containsKey('error'))
            ? decodedBody['error'] as String
            : 'Failed to load roles from API. Server responded with status code: ${response.statusCode}';

        throw RoleApiException(
          errorMsg,
          statusCode: response.statusCode,
        );
      }
    } on http.ClientException {
      // Network check
      throw const RoleApiException('Network error: Could not connect to the server.');
    } on FormatException {
      // JSON decoding failed
      throw const RoleApiException('Failed to decode server response as valid JSON.', statusCode: 500);
    } catch (e) {
      throw RoleApiException('An unknown error occurred while fetching roles: $e');
    }
  }

  /// Example method to create a new role.
  Future<RoleModel> createRole(String roleName) async {
    final uri = Uri.parse(_baseUrl);

    final Map<String, dynamic> payload = {
      'name': roleName,
    };

    // CRITICAL FIX: Include the Authorization header for POST requests too
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_temporaryAuthToken',
    };


    try {
      final response = await _client.post(
        uri,
        headers: headers, // Pass the headers here
        body: jsonEncode(payload),
      );

      final dynamic decodedBody = jsonDecode(response.body);


      if (response.statusCode == 201) {
        
        if (decodedBody is Map<String, dynamic>) {
          return RoleModel.fromJson(decodedBody);
        } else {
          throw const RoleApiException('Successful response body for creation is not a valid map.', statusCode: 201);
        }
      } else {
        final String errorMsg = (decodedBody is Map<String, dynamic> && decodedBody.containsKey('error'))
            ? decodedBody['error'] as String
            : 'Failed to create role. Server responded with status code: ${response.statusCode}';

        throw RoleApiException(
          errorMsg,
          statusCode: response.statusCode,
        );
      }
    } on http.ClientException {
      throw const RoleApiException('Network error: Could not connect to the server.');
    } on FormatException {
      throw const RoleApiException('Failed to decode server response as valid JSON.', statusCode: 500);
    } catch (e) {
      throw RoleApiException('An unknown error occurred while creating the role: $e');
    }
  }
}