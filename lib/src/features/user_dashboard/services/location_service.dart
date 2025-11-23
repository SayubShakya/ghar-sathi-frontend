import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:loginappv2/src/features/user_dashboard/models/location/model_location.dart'; // Make sure to add 'http: ^latest_version' to your pubspec.yaml

// Note: You must ensure the 'http' package is added to your pubspec.yaml.

/// The LocationService (Repository) is responsible for data access via a REST API.
class LocationService {
  static const String _baseUrl = 'http://localhost:5000/api/locations';

  /// Fetches a list of all active locations.
  Future<List<LocationModel>> getActiveLocations() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));

      if (response.statusCode == 200) {
        // The API is assumed to return a JSON array
        final List<dynamic> jsonList = jsonDecode(response.body);

        // Map the list to models and filter for active ones (if the API doesn't filter)
        return jsonList
            .map((json) => LocationModel.fromJson(json))
            .where((loc) => loc.isActive == true)
            .toList();
      } else {
        // Handle server errors (e.g., 404, 500)
        throw Exception('Failed to load locations. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network errors (e.g., connection refused)
      throw Exception('Network error during fetchLocations: $e');
    }
  }

  /// Adds a new location to the "database".
  Future<LocationModel> addLocation(LocationModel newLocation) async {
    try {
      // Note: newLocation.id will be null here, and that is correctly omitted from the request body by toJson()
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(newLocation.toJson()),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        // Assume API returns the created object, NOW with a server-assigned ID
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        print('LocationService: Successfully added new location');
        return LocationModel.fromJson(jsonResponse);
      } else {
        final errorBody = jsonDecode(response.body);
        throw Exception('Failed to add location. Status code: ${response.statusCode}. Error: ${errorBody['message'] ?? 'Unknown Error'}');
      }
    } catch (e) {
      throw Exception('Network error during addLocation: $e');
    }
  }

  // Placeholder removed, relying on model's 'id' field

  /// Updates an existing location.
  Future<LocationModel> updateLocation(LocationModel updatedLocation) async {
    if (updatedLocation.id == null) {
      throw Exception('Cannot update location: ID is required for PUT operation.');
    }
    // Now using the actual ID from the model
    final updateUrl = '$_baseUrl/${updatedLocation.id}';

    try {
      final response = await http.put(
        Uri.parse(updateUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(updatedLocation.toJson()),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        print('LocationService: Updated location successfully');
        // Return the API response, which might contain updated fields/timestamps
        return LocationModel.fromJson(jsonResponse);
      } else {
        final errorBody = jsonDecode(response.body);
        throw Exception('Failed to update location. Status code: ${response.statusCode}. Error: ${errorBody['message'] ?? 'Unknown Error'}');
      }
    } catch (e) {
      throw Exception('Network error during updateLocation: $e');
    }
  }

  /// Soft deletes a location (sends an update to set isActive to false).
  Future<void> deleteLocation(LocationModel locationToDelete) async {
    if (locationToDelete.id == null) {
      throw Exception('Cannot deactivate location: ID is required for soft-delete.');
    }
    // Now using the actual ID from the model
    final deleteUrl = '$_baseUrl/${locationToDelete.id}';

    // Create a payload to explicitly set is_active to false
    // We update the existing toJson() map, assuming the API accepts all fields or just the status change.
    final Map<String, dynamic> deletePayload = locationToDelete.toJson();
    deletePayload['is_active'] = false;

    try {
      final response = await http.put( // Using PUT for soft-delete update
        Uri.parse(deleteUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(deletePayload),
      );

      if (response.statusCode == 200) {
        print('LocationService: Deactivated location via API');
      } else {
        final errorBody = jsonDecode(response.body);
        throw Exception('Failed to delete/deactivate location. Status code: ${response.statusCode}. Error: ${errorBody['message'] ?? 'Unknown Error'}');
      }
    } catch (e) {
      throw Exception('Network error during deleteLocation: $e');
    }
  }
}