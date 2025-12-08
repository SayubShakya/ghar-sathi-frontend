import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loginappv2/src/features/image_handle/image_handle_services.dart';
import 'package:loginappv2/src/features/user_dashboard/screens/landlord_dashboards/landlord_add_room_screen.dart';

import '../../properties/Repositories/property_repo.dart';
import '../../properties/models/model_property.dart';


// --- GetX Controller (Logic) ---
class LandlordDashboardController extends GetxController {
  final PropertyService _propertyService = PropertyService();
  final ImageService _imageService = ImageService();

  // Status IDs from your database
  static const String availableStatusId = "691ed3fda42db82e1cec0dfc";
  static const String bookedStatusId = "691ed432a42db82e1cec0dff";
  // Observable list of properties from API
  final RxList<PropertyModel> properties = <PropertyModel>[].obs;

  // Loading and error states
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  // Pagination
  final RxInt currentPage = 1.obs;
  final RxInt totalPages = 1.obs;
  final RxInt totalItems = 0.obs;
  final RxBool isLoadMore = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProperties();
  }

  Future<void> fetchProperties({bool loadMore = false}) async {
    try {
      if (!loadMore) {
        isLoading.value = true;
        hasError.value = false;
        currentPage.value = 1;
      } else {
        isLoadMore.value = true;
      }

      print('🔄 LandlordDashboardController: Fetching properties page ${currentPage.value}');

      final fetchedProperties = await _propertyService.getProperties(
        page: currentPage.value,
        limit: 10,
      );

      // Cache images for properties
      for (var property in fetchedProperties) {
        final filename = property.image?.filename;
        if (filename != null && filename.isNotEmpty) {
          property.imageFuture = _imageService.fetchImage(filename);
        }
      }

      if (loadMore) {
        properties.addAll(fetchedProperties);
      } else {
        properties.value = fetchedProperties;
      }

      // Debug: Print status of each property
      for (var property in fetchedProperties) {
        print('📋 Property: ${property.propertyTitle}');
        print('   - Status ID: ${property.status?.id}');
        print('   - Status Name: ${property.status?.name}');
        print('   - isActive: ${property.isActive}');
        print('   - Display Status: ${getDisplayStatus(property)}');
        print('   - Is Available: ${isPropertyAvailable(property)}');
      }

      totalItems.value = properties.length;

      print('✅ LandlordDashboardController: Successfully loaded ${fetchedProperties.length} properties');

    } catch (e) {
      print('❌ LandlordDashboardController Error: $e');
      hasError.value = true;
      errorMessage.value = e.toString();

      if (!loadMore) {
        Get.snackbar(
          'Error',
          'Failed to load properties: ${e.toString().replaceAll('Exception: ', '')}',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      isLoading.value = false;
      isLoadMore.value = false;
    }
  }

  // ✅ CORRECTED: Get display status based on status_id
  String getDisplayStatus(PropertyModel property) {
    final statusId = property.status?.id;

    // Check by status ID first (your database IDs)
    if (statusId == availableStatusId) {
      return 'AVAILABLE';
    } else if (statusId == bookedStatusId) {
      return 'BOOKED';
    }

    // If status has name field (sometimes populated)
    final statusName = property.status?.name;
    if (statusName != null) {
      final upperName = statusName.toUpperCase();
      if (upperName.contains('AVAILABLE') ||
          upperName.contains('ACTIVE') ||
          upperName == 'AVAILABLE') {
        return 'AVAILABLE';
      } else if (upperName.contains('BOOK') ||
          upperName == 'BOOKED' ||
          upperName == 'BOOKING') {
        return 'BOOKED';
      }
    }

    // Final fallback to isActive (should not be needed with correct status IDs)
    if (property.isActive == true) return 'AVAILABLE';
    if (property.isActive == false) return 'BOOKED';

    return 'UNKNOWN';
  }

  // ✅ CORRECTED: Check if property is available based on status_id
  bool isPropertyAvailable(PropertyModel property) {
    final statusId = property.status?.id;

    // Property is available ONLY if status_id is the AVAILABLE status ID
    return statusId == availableStatusId;
  }

  // Get display type from propertyType name
  String getDisplayType(PropertyModel property) {
    final typeName = property.propertyType?.name ?? '';
    if (typeName.isNotEmpty) {
      return typeName[0].toUpperCase() + typeName.substring(1).toLowerCase();
    }
    return 'Unknown';
  }

  // Format rent with commas
  String formatRent(int? rent) {
    if (rent == null) return 'Rs.0';
    return 'Rs.${_formatNumber(rent)}';
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
    );
  }

  // Count available properties
  int get availablePropertiesCount {
    return properties.where((p) => isPropertyAvailable(p)).length;
  }

  Future<void> refreshProperties() async {
    await fetchProperties(loadMore: false);
  }

  void loadMoreProperties() {
    if (!isLoadMore.value && currentPage.value < totalPages.value) {
      currentPage.value++;
      fetchProperties(loadMore: true);
    }
  }

  void onAddPropertyTapped() {
    print('Add New Property tapped.');
    Get.to(() => AddListingScreen());
  }

  void onUpdatePropertyTapped(PropertyModel property) {
    print('Update Property tapped: ${property.propertyTitle}');
    // Implement update logic
  }

  void onDeletePropertyTapped(PropertyModel property) {
    print('Delete Property tapped: ${property.propertyTitle}');
    Get.dialog(
      AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text('Are you sure you want to delete "${property.propertyTitle}"?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              Get.snackbar(
                'Success',
                'Property deleted successfully',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void onPropertyItemTapped(PropertyModel property) {
    print('Property ${property.propertyTitle} tapped.');
    // Navigate to property detail screen
    }
}