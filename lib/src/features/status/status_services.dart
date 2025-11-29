import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loginappv2/src/features/status/status_model.dart';

class StatusRepository {
  final Dio _dio = Dio();
  final storage = GetStorage();

  static const String _baseUrl = "http://192.168.1.138:5000/api/statuses";
  // For physical device use your LAN IP

  StatusRepository() {
    _dio.options.headers['Content-Type'] = 'application/json';
  }

  Future<List<PropertyStatus>> fetchStatuses({int page = 1, int limit = 50}) async {
    try {
      final token = storage.read('token'); // read JWT token

      final response = await _dio.get(
        "$_baseUrl?page=$page&limit=$limit",
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );

      final parsed = PaginatedStatusResponse.fromJson(response.data);
      return parsed.data;
    } on DioException catch (e) {
      throw Exception("Failed to load statuses: ${e.response?.data ?? e.message}");
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }
}
