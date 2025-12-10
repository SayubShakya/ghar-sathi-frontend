// lib/src/features/location/services/location_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ghar_sathi/src/features/user_dashboard/models/location/model_location.dart';


class LocationService {
  static const String _baseUrl = 'http://10.10.8.98:5000/api/locations?page=1&limit=5';
  final http.Client _client;

  LocationService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<LocationModel>> fetchLocations() async {
    final uri = Uri.parse(_baseUrl);

    try {
      final response = await _client.get(uri, headers: {
        'Content-Type': 'application/json',
        // Add 'Authorization': 'Bearer YOUR_TOKEN' if needed
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> decoded = jsonDecode(response.body);
        final List<dynamic> dataList = decoded['data'];
        return dataList.map((json) => LocationModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch locations. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching locations: $e');
    }
  }
}
