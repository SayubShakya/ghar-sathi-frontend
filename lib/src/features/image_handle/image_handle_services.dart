// lib/src/features/image/services/image_service.dart

import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path/path.dart';
import 'dart:typed_data';
import 'package:loginappv2/src/features/authentication/services/token_manager.dart';

class ImageService {
  // Use the IP address, replacing 'localhost'
  static const String _serverBaseUrl = 'http://10.10.9.216:5000';

  // Endpoint for POST (Uploading the image)
  static const String _uploadUrl = '$_serverBaseUrl/api/images/upload-image';

  // Base URL for GET (Fetching the image)
  static const String _fetchBaseUrl = '$_serverBaseUrl/uploads/';

  final TokenManager _tokenManager = TokenManager();

  // --- 1. UPLOAD METHOD (Updated with JWT Authentication) ---

  /// Uploads the image file and returns the filename from the server response.
  Future<String?> uploadImage(File imageFile) async {
    try {
      print('🔄 ImageService: Starting image upload...');

      var request = http.MultipartRequest('POST', Uri.parse(_uploadUrl));

      // Add JWT token to headers
      final token = await _tokenManager.getAccessToken();
      if (token != null && token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
        print('🔐 ImageService: JWT token added to request');
      } else {
        print('⚠️ ImageService: No JWT token found - upload might fail if backend requires auth');
      }

      request.files.add(
        http.MultipartFile(
          'file', // Key must match the backend field name
          imageFile.readAsBytes().asStream(),
          imageFile.lengthSync(),
          filename: basename(imageFile.path),
        ),
      );

      print('📤 ImageService: Sending image upload request...');
      var response = await request.send();

      print('📡 ImageService: Upload response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        final decoded = jsonDecode(responseData);

        // **CRITICAL CHANGE:** Returning the filename, which is needed for fetching.
        // The JSON response contains: "image": { "filename": "..." }
        final filename = decoded['image']['filename'] as String?;
        print('✅ ImageService: Image uploaded successfully: $filename');
        return filename;
      } else if (response.statusCode == 401) {
        print('❌ ImageService: Unauthorized - Token might be invalid or expired');
        throw Exception('Authentication failed. Please login again.');
      } else {
        print('❌ ImageService: Failed to upload image. Status: ${response.statusCode}');
        throw Exception('Failed to upload image: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ ImageService: Error uploading image: $e');
      rethrow;
    }
  }

  // --- 2. FETCH METHOD (Updated with better error handling) ---

  /// Fetches the raw image bytes from the server using the provided filename.
  /// Returns null if fetching fails.
  Future<Uint8List?> fetchImage(String filename) async {
    // Construct the full URL, e.g., http://10.10.10.35:5000/uploads/room.jpg
    final String getImageUrl = '$_fetchBaseUrl$filename';

    try {
      print('🔄 ImageService: Fetching image: $filename');

      final response = await http.get(Uri.parse(getImageUrl));

      print('📡 ImageService: Fetch response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        // The response body is the raw image data (bytes)
        print('✅ ImageService: Image fetched successfully');
        return response.bodyBytes;
      } else if (response.statusCode == 404) {
        print('❌ ImageService: Image not found: $filename');
        return null;
      } else {
        print('❌ ImageService: Failed to fetch image. Status: ${response.statusCode} for URL: $getImageUrl');
        return null;
      }
    } catch (e) {
      print('❌ ImageService: Error fetching image: $e');
      return null;
    }
  }

  // --- 3. NEW METHOD: Check if image exists ---
  Future<bool> checkImageExists(String filename) async {
    try {
      final String getImageUrl = '$_fetchBaseUrl$filename';
      final response = await http.head(Uri.parse(getImageUrl));

      return response.statusCode == 200;
    } catch (e) {
      print('❌ ImageService: Error checking image existence: $e');
      return false;
    }
  }
}