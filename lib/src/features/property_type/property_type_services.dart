import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ghar_sathi/src/features/property_type/property_type_model.dart';


class PropertyTypeService {
  final Dio _dio = Dio();
  final storage = GetStorage();

  final String baseUrl = "http://10.10.8.98:5000/api";

  Future<List<PropertyTypeModel>> getPropertyTypes() async {
    try {
      String? token = storage.read("token");

      final response = await _dio.get(
        "$baseUrl/property-types?page=1&limit=5",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );

      List data = response.data["data"];
      return data.map((e) => PropertyTypeModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception("Failed to load property types: $e");
    }
  }
}
