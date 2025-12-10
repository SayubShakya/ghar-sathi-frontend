import 'package:dio/dio.dart';
import 'package:ghar_sathi/src/features/authentication/services/api_client.dart';

import '../models/model_property.dart';

class PropertyService {
  final Dio _dio = ApiClient().dio;

  Future<List<PropertyModel>> getProperties({
    int page = 1,
    int limit = 5,
    String? city,
  }) async {
    try {
      final Map<String, dynamic> query = {
        "page": page,
        "limit": limit,
      };

      if (city != null && city.isNotEmpty) {
        query["city"] = city;
      }

      final response = await _dio.get("/properties", queryParameters: query);
      // final response = await _dio.get("/users", queryParameters: {
      //   "page": page,
      //   "limit": limit,
      // });
      // print("Response data: ${users}");

      if (response.statusCode == 200) {
        List data = response.data["data"];
        return data.map((json) => PropertyModel.fromJson(json)).toList();
      } else {
        throw Exception("Failed to load properties: ${response.statusCode}");
      }
    } catch (e) {
      print("PropertyService error: $e");
      rethrow;
    }
  }

  Future<PropertyModel> getPropertyById(String id) async {
    try {
      final response = await ApiClient().dio.get('/properties/$id');
      return PropertyModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(
          'Failed to fetch property: ${e.response?.data ?? e.message}');
    } catch (e) {
      throw Exception('Failed to fetch property: $e');
    }
  }
}
