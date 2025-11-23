import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geocoding/geocoding.dart';
import 'package:loginappv2/src/features/user_dashboard/models/location/model_location.dart';
import 'package:loginappv2/src/features/user_dashboard/services/location_service.dart';
import 'package:loginappv2/src/features/user_dashboard/services/property_service.dart';

import '../../models/property_model.dart';

class AddListingController extends GetxController {
  // Inject services
  final PropertyService _propertyService = Get.put(PropertyService());
  // Inject the LocationService to handle location creation
  final LocationService _locationService = Get.put(LocationService());

  // Form Field Controllers
  final TextEditingController propertyTitleController = TextEditingController();
  final TextEditingController detailedDescriptionController = TextEditingController();
  final TextEditingController rentController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController areaNameController = TextEditingController(); // Added for complete LocationModel
  final TextEditingController cityController = TextEditingController(); // Added for complete LocationModel
  final TextEditingController postalCodeController = TextEditingController(); // Added for complete LocationModel


  // Reactive variables for form state
  Rx<File?> coverImage = Rx<File?>(null);
  RxDouble latitude = 0.0.obs;
  RxDouble longitude = 0.0.obs;
  RxString selectedStatus = 'available'.obs;
  RxString selectedPropertyType = 'apartment'.obs;
  RxBool isLoading = false.obs;
  // Reactive variable to store the successfully created location's ID
  RxnString locationId = RxnString();


  // Example lists for dropdowns (you'll fetch these from backend in a real app)
  final List<String> propertyStatuses = ['available', 'rented', 'under_maintenance'];
  final List<String> propertyTypes = ['apartment', 'house', 'room', 'commercial'];

  // --- Image Picking Logic ---
  Future<void> pickCoverImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source, imageQuality: 80);

    if (pickedFile != null) {
      coverImage.value = File(pickedFile.path);
    } else {
      Get.snackbar('Error', 'No image selected', snackPosition: SnackPosition.BOTTOM);
    }
  }

  // --- Geocoding Logic (Address to Lat/Long) ---
  Future<void> geocodeAddress() async {
    isLoading.value = true;
    locationId.value = null; // Clear previous location ID

    // Construct a comprehensive address string for better geocoding results
    final fullAddress = '${addressController.text}, ${cityController.text}, ${postalCodeController.text}';

    try {
      List<Location> locations = await locationFromAddress(fullAddress);
      if (locations.isNotEmpty) {
        latitude.value = locations.first.latitude;
        longitude.value = locations.first.longitude;
        Get.snackbar(
          'Location Found',
          'Lat: ${latitude.value}, Long: ${longitude.value}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade400,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar('Error', 'Could not find coordinates for the given address.', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red.shade400, colorText: Colors.white);
        latitude.value = 0.0;
        longitude.value = 0.0;
      }
    } catch (e) {
      Get.snackbar('Error', 'Geocoding failed: $e', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red.shade400, colorText: Colors.white);
      latitude.value = 0.0;
      longitude.value = 0.0;
    } finally {
      isLoading.value = false;
    }
  }

  // --- Form Submission Logic ---
  Future<void> addProperty() async {
    if (isLoading.value) return; // Prevent multiple submissions
    if (latitude.value == 0.0 || longitude.value == 0.0) {
      Get.snackbar('Error', 'Please geocode the address first.', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isLoading.value = true;
    String? uploadedImageUrl;

    try {
      // 1. Upload Image (if selected)
      if (coverImage.value != null) {
        uploadedImageUrl = await _propertyService.uploadImage(coverImage.value!.path);
        if (uploadedImageUrl == null) {
          throw Exception('Failed to upload cover image.');
        }
      }

      // 2. CREATE LOCATION RECORD AND GET ID
      // This is the crucial step to satisfy the foreign key constraint.
      final newLocation = LocationModel(
        streetAddress: addressController.text,
        areaName: areaNameController.text,
        city: cityController.text,
        postalCode: postalCodeController.text,
        latitude: latitude.value,
        longitude: longitude.value,
        isActive: true,
      );

      final createdLocation = await _locationService.addLocation(newLocation);

      // Check if location was created successfully and an ID was returned
      if (createdLocation.id == null) {
        throw Exception('Backend failed to return an ID for the new location.');
      }
      locationId.value = createdLocation.id;

      // 3. Create Property Model using the new locationId
      final newProperty = PropertyModel(
        propertyTitle: propertyTitleController.text,
        detailedDescription: detailedDescriptionController.text,
        rent: double.tryParse(rentController.text) ?? 0.0,
        coverImageUrl: uploadedImageUrl,
        locationId: locationId.value!, // Use the ID from the created location
        latitude: latitude.value,
        longitude: longitude.value,
        status: selectedStatus.value,
        userId: 'landlordUserId123',
        propertyTypesId: 'propertyTypeId_${selectedPropertyType.value}',
      );

      // 4. Send Property to Backend
      final createdProperty = await _propertyService.createProperty(newProperty);

      if (createdProperty != null) {
        Get.snackbar(
          'Success',
          'Property "${createdProperty.propertyTitle}" listed successfully!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green.shade400,
          colorText: Colors.white,
        );
        clearForm();
        Get.back();
      } else {
        throw Exception('Failed to list property. Backend returned null.');
      }
    } catch (e) {
      // General error handling for image upload, location creation, or property creation
      Get.snackbar(
        'Error',
        'Submission failed: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
      );
      print('Error submitting property: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // --- Form Reset ---
  void clearForm() {
    propertyTitleController.clear();
    detailedDescriptionController.clear();
    rentController.clear();
    addressController.clear();
    areaNameController.clear(); // Clear new fields
    cityController.clear();     // Clear new fields
    postalCodeController.clear(); // Clear new fields
    coverImage.value = null;
    latitude.value = 0.0;
    longitude.value = 0.0;
    selectedStatus.value = 'available';
    selectedPropertyType.value = 'apartment';
    locationId.value = null; // Clear location ID
  }

  @override
  void onClose() {
    propertyTitleController.dispose();
    detailedDescriptionController.dispose();
    rentController.dispose();
    addressController.dispose();
    areaNameController.dispose();
    cityController.dispose();
    postalCodeController.dispose();
    super.onClose();
  }
}