import 'package:dio/dio.dart';
import 'package:ghar_sathi/src/features/authentication/models/login_response_model.dart';
import 'package:ghar_sathi/src/features/authentication/services/api_client.dart';


class AuthService {
  // Use the Dio instance from the ApiClient
  // This ensures configuration (like baseUrl) and interceptors are shared.
  final Dio _dio = ApiClient().dio;

  // The endpoint path relative to the base URL
  static const String _loginPath = '/auth/token';

  Future<LoginResponseModel> loginUser(String email, String password) async {
    try {
      // Use the Dio instance from ApiClient and the relative path
      final response = await _dio.post(
        _loginPath,
        data: {
          "email_address": email,
          "password": password,
        },
      );

      // --- Response Handling ---
      if (response.statusCode == 200) {
        return LoginResponseModel.fromJson(response.data);
      } else {
        // Attempt to get a specific error message if available
        final errorMessage = response.data['message'] ?? 'Failed to login with status code ${response.statusCode}';
        throw Exception(errorMessage);
      }
    } on DioException catch (e) {
      // Handle Dio-specific errors (network, timeout, 4xx/5xx responses)
      final errorMsg = e.response?.data['message'] ?? e.message ?? 'Network Error: Could not reach server.';
      throw Exception(errorMsg);
    } catch (e) {
      // General error handling
      throw Exception('An unexpected error occurred during login: ${e.toString()}');
    }
  }
}