// lib/src/features/location/location_controller.dart

import 'package:get/get.dart';
import 'package:ghar_sathi/src/features/user_dashboard/models/location/model_location.dart';
import 'package:ghar_sathi/src/features/user_dashboard/services/location_service.dart';


class LocationController extends GetxController {
  final LocationService _locationService = Get.put(LocationService());

  RxList<LocationModel> locations = <LocationModel>[].obs;
  RxString selectedLocationId = ''.obs; // Store selected location's ID
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllLocations();
  }

  void fetchAllLocations() async {
    try {
      isLoading.value = true;
      final result = await _locationService.fetchLocations();
      locations.assignAll(result);
      if (result.isNotEmpty) {
        selectedLocationId.value = result.first.id; // Default to first location
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load locations: $e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }
}
