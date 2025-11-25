// lib/src/features/image/services/image_service.dart

import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path/path.dart';

class ImageService {
  static const String _uploadUrl = 'http://192.168.1.75:5000/api/images/upload-image';

  Future<String?> uploadImage(File imageFile) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(_uploadUrl));

      // Attach the image
      request.files.add(
        http.MultipartFile(
          'file', // Make sure this key matches your backend field name
          imageFile.readAsBytes().asStream(),
          imageFile.lengthSync(),
          filename: basename(imageFile.path),
        ),
      );

      // Send the request
      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        final decoded = jsonDecode(responseData);

        // Return the image_id from backend
        return decoded['image']['id'] as String?;
      } else {
        print('Failed to upload image. Status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }
}
