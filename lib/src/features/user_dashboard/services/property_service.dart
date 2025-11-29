import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:loginappv2/src/features/authentication/services/token_manager.dart';
import '../../properties/models/model_property.dart';
import '../models/model_property.dart';

class PropertyService {
  final String _baseUrl = "http://192.168.1.214:5000/api/properties";
  final String _uploadImageUrl = "http://192.168.1.214:5000/api/images/upload-image";

  final TokenManager _tokenManager = TokenManager();

  // Helper for API Headers with JWT Token
  Future<Map<String, String>> _getHeaders({bool isMultipart = false}) async {
    final token = await _tokenManager.getAccessToken();

    final headers = {
      if (!isMultipart) 'Content-Type': 'application/json; charset=UTF-8',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };

    print('🔐 Request headers - Token present: ${token != null && token.isNotEmpty}');
    return headers;
  }

  // --- Create Property ---
  Future<dynamic> createProperty(PropertyModel property) async {
    try {
      print('🔄 Creating property...');

      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: headers,
        body: jsonEncode(property.toJson()),
      );

      print('📡 Create Property Response - Status: ${response.statusCode}');

      if (response.statusCode == 201) {
        print('✅ Property created successfully');
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        print('❌ Unauthorized - Token might be invalid or expired');
        throw Exception('Authentication failed. Please login again.');
      } else {
        print('❌ Failed to create property: ${response.statusCode} ${response.body}');
        throw Exception('Failed to create property: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error creating property: $e');
      rethrow;
    }
  }

  // --- Upload Image ---
  Future<Map<String, dynamic>?> uploadImage(String imagePath) async {
    try {
      print('🔄 Uploading image...');

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(_uploadImageUrl),
      );

      // Add JWT token to headers
      final token = await _tokenManager.getAccessToken();
      if (token != null && token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      request.files.add(await http.MultipartFile.fromPath('file', imagePath));

      var response = await request.send();

      print('📡 Image Upload Response - Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final respStr = await response.stream.bytesToString();
        final Map<String, dynamic> data = jsonDecode(respStr);
        print('✅ Image uploaded successfully');
        return data;
      } else if (response.statusCode == 401) {
        print('❌ Unauthorized - Token might be invalid or expired');
        throw Exception('Authentication failed. Please login again.');
      } else {
        print('❌ Failed to upload image: ${response.statusCode}');
        throw Exception('Failed to upload image: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error uploading image: $e');
      rethrow;
    }
  }

  // --- Fetch Property Types ---
  Future<List<PropertyTypeModel>> getPropertyTypes({int page = 1, int limit = 50}) async {
    try {
      print('🔄 Fetching property types...');

      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse("http://192.168.1.214:5000/api/property-types?page=$page&limit=$limit"),
        headers: headers,
      );

      print('📡 Property Types Response - Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'] as List;
        print('✅ Property types fetched successfully: ${data.length} items');
        return data.map((json) => PropertyTypeModel.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        print('❌ Unauthorized - Token might be invalid or expired');
        throw Exception('Authentication failed. Please login again.');
      } else {
        print('❌ Failed to fetch property types: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('❌ Error fetching property types: $e');
      return [];
    }
  }

  // --- Fetch Statuses ---
  Future<List<StatusModel>> getStatuses({int page = 1, int limit = 50}) async {
    try {
      print('🔄 Fetching statuses...');

      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse("http://192.168.1.214:5000/api/statuses?page=$page&limit=$limit"),
        headers: headers,
      );

      print('📡 Statuses Response - Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'] as List;
        print('✅ Statuses fetched successfully: ${data.length} items');
        return data.map((json) => StatusModel.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        print('❌ Unauthorized - Token might be invalid or expired');
        throw Exception('Authentication failed. Please login again.');
      } else {
        print('❌ Failed to fetch statuses: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('❌ Error fetching statuses: $e');
      return [];
    }
  }
}

// --- Models for PropertyType, Status ---
class PropertyTypeModel {
  final String id;
  final String name;

  PropertyTypeModel({required this.id, required this.name});

  factory PropertyTypeModel.fromJson(Map<String, dynamic> json) {
    return PropertyTypeModel(
      id: json['id'],
      name: json['name'] ?? '',
    );
  }
}

class StatusModel {
  final String id;
  final String name;

  StatusModel({required this.id, required this.name});

  factory StatusModel.fromJson(Map<String, dynamic> json) {
    return StatusModel(
      id: json['id'],
      name: json['name'] ?? '',
    );
  }
}