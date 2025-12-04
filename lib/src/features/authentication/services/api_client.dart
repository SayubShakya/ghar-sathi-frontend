// api_client.dart
import 'package:dio/dio.dart';
import 'package:loginappv2/src/features/authentication/services/token_manager.dart';

class ApiClient {
  ApiClient._internal() {
    _init();
  }

  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;

  late final Dio dio;
  bool _isRefreshing = false;

  void _init() {
    final baseOptions = BaseOptions(

      baseUrl: 'http://10.10.8.103:5000/api',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    dio = Dio(baseOptions);

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          try {
            // Skip adding token for login endpoint
            if (options.path.contains('/auth/token')) {
              return handler.next(options);
            }

            final token = await TokenManager().getAccessToken();
            print('Interceptor fetched token: ${token != null ? "[REDACTED]" : "null"}');

            if (token != null && token.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $token';
            } else {
              options.headers.remove('Authorization');
            }

            print('Request -> ${options.method} ${options.uri}');
          } catch (e) {
            print('Error retrieving token in interceptor: $e');
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('Response <- ${response.statusCode} ${response.requestOptions.path}');
          return handler.next(response);
        },
        onError: (DioException err, handler) async {
          if (err.response?.statusCode == 401) {
            print('Received 401 from ${err.requestOptions.path}');

            // Don't try to refresh token for auth endpoints
            if (err.requestOptions.path.contains('/auth/')) {
              await TokenManager().clearAccessToken();
              return handler.next(err);
            }

            // Try to refresh token
            if (!_isRefreshing) {
              _isRefreshing = true;
              try {
                // Implement your token refresh logic here
                // final newToken = await _refreshToken();
                // if (newToken != null) {
                //   await TokenManager().saveAccessToken(newToken);
                //   // Retry the original request
                //   final response = await dio.request(
                //     err.requestOptions.path,
                //     data: err.requestOptions.data,
                //     queryParameters: err.requestOptions.queryParameters,
                //     options: Options(
                //       method: err.requestOptions.method,
                //       headers: {'Authorization': 'Bearer $newToken'},
                //     ),
                //   );
                //   return handler.resolve(response);
                // }
              } catch (refreshError) {
                print('Token refresh failed: $refreshError');
                await TokenManager().clearAccessToken();
                // Navigate to login screen
                // Get.offAllNamed(Routes.LOGIN);
              } finally {
                _isRefreshing = false;
              }
            }
          }
          return handler.next(err);
        },
      ),
    );
  }

  // Add this method for token refresh
  Future<String?> _refreshToken() async {
    try {
      // Implement your token refresh logic
      // final response = await dio.post('/auth/refresh');
      // return response.data['token'];
      return null;
    } catch (e) {
      print('Token refresh error: $e');
      return null;
    }
  }
}