import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geocoding/geocoding.dart';
import 'package:loginappv2/src/features/image_handle/image_handle_services.dart';
import 'package:loginappv2/src/features/user_dashboard/models/location/model_location.dart';

// Import the PropertyService that has createProperty() and uploadImage()
import 'package:loginappv2/src/features/user_dashboard/services/property_service.dart' hide PropertyTypeModel;

// Import separate services for other features
import 'package:loginappv2/src/features/property_type/property_type_model.dart';
import 'package:loginappv2/src/features/authentication/models/user_model.dart';
import 'package:loginappv2/src/features/image_handle/image_handle_model.dart';

import '../../properties/models/model_property.dart';

class AddListingController extends GetxController {
  // Services
  final PropertyService _propertyService = Get.put(PropertyService());
  final ImageService _imageService = Get.put(ImageService());

  // Form controllers
  final TextEditingController propertyTitleController = TextEditingController();
  final TextEditingController detailedDescriptionController = TextEditingController();
  final TextEditingController rentController = TextEditingController();
  final TextEditingController streetAddressController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();
  final TextEditingController areaNameController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  // Reactive variables
  Rx<File?> coverImage = Rx<File?>(null);
  RxBool isLoading = false.obs;
  RxBool isFetchingCoordinates = false.obs;

  // Location coordinates (will be fetched based on user input)
  RxDouble latitude = 0.0.obs;
  RxDouble longitude = 0.0.obs;

  // Dropdown selections
  RxString selectedStatus = ''.obs;
  RxString selectedPropertyType = ''.obs;

  // Dropdown lists
  RxList<DropdownItem> statusList = <DropdownItem>[].obs;
  RxList<DropdownItem> propertyTypeList = <DropdownItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadDropdownData();
  }

  // Load dropdown data
  void loadDropdownData() {
    statusList.assignAll([
      DropdownItem(id: 'available', name: 'Available'),
      DropdownItem(id: 'rented', name: 'Rented'),
      DropdownItem(id: 'under_maintenance', name: 'Under Maintenance'),
    ]);

    propertyTypeList.assignAll([
      DropdownItem(id: 'apartment', name: 'Apartment'),
      DropdownItem(id: 'house', name: 'House'),
      DropdownItem(id: 'room', name: 'Room'),
      DropdownItem(id: 'commercial', name: 'Commercial'),
    ]);
  }

  // --- Image Picker ---
  Future<void> pickCoverImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(source: source, imageQuality: 80);
      if (pickedFile != null) {
        coverImage.value = File(pickedFile.path);
      } else {
        Get.snackbar('Error', 'No image selected', snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image: $e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  // --- Get Coordinates from Address using Geocoding ---
  Future<void> getCoordinatesFromAddress() async {
    if (streetAddressController.text.isEmpty ||
        areaNameController.text.isEmpty ||
        cityController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter street address, area, and city',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      isFetchingCoordinates.value = true;

      // Combine address components for better geocoding accuracy
      String fullAddress = '${streetAddressController.text}, ${areaNameController.text}, ${cityController.text}, Nepal';

      print('🔄 Geocoding address: $fullAddress');

      // Use geocoding package to convert address to coordinates
      List<Location> locations = await locationFromAddress(fullAddress);

      if (locations.isNotEmpty) {
        Location location = locations.first;
        latitude.value = location.latitude;
        longitude.value = location.longitude;

        print('✅ Address geocoded successfully:');
        print('   📍 Latitude: ${latitude.value}');
        print('   📍 Longitude: ${longitude.value}');
        print('   📍 Full Address: $fullAddress');

        Get.snackbar('Success', 'Coordinates fetched successfully!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: Duration(seconds: 3));
      } else {
        print('❌ No locations found for address: $fullAddress');
        Get.snackbar('Not Found', 'Could not find coordinates for this address. Please check the address and try again.',
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 4));
      }
    } catch (e) {
      print('❌ Error geocoding address: $e');

      // More specific error messages
      if (e.toString().contains('NoResultFoundException') || e.toString().contains('no results')) {
        Get.snackbar('Address Not Found', 'The address could not be found. Please check the spelling and try again.',
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 4));
      } else if (e.toString().contains('network') || e.toString().contains('Internet')) {
        Get.snackbar('Network Error', 'Please check your internet connection and try again.',
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 4));
      } else {
        Get.snackbar('Error', 'Failed to get coordinates: ${e.toString()}',
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 4));
      }
    } finally {
      isFetchingCoordinates.value = false;
    }
  }

  // --- Add Property ---
  Future<void> addProperty() async {
    if (isLoading.value) return;

    // Validate required fields
    if (selectedStatus.value.isEmpty ||
        selectedPropertyType.value.isEmpty ||
        streetAddressController.text.isEmpty ||
        postalCodeController.text.isEmpty ||
        propertyTitleController.text.isEmpty ||
        detailedDescriptionController.text.isEmpty ||
        rentController.text.isEmpty ||
        areaNameController.text.isEmpty ||
        cityController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill all required fields',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    // Validate coordinates are fetched
    if (latitude.value == 0.0 || longitude.value == 0.0) {
      Get.snackbar('Error', 'Please get location coordinates first by clicking "Get Coordinates"',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isLoading.value = true;

    try {
      String? imageUrl;

      // --- Image Upload Section ---
      if (coverImage.value != null) {
        try {
          print('🔄 Starting image upload...');
          final filename = await _imageService.uploadImage(coverImage.value!);

          if (filename != null && filename.isNotEmpty) {
            imageUrl = 'http://10.10.9.216:5000/uploads/$filename';
            print('✅ Image uploaded successfully: $imageUrl');
          } else {
            Get.snackbar('Error', 'Failed to upload image - no filename returned',
                snackPosition: SnackPosition.BOTTOM);
            isLoading.value = false;
            return;
          }
        } catch (e) {
          print('❌ Image upload error: $e');
          Get.snackbar('Error', 'Failed to upload image: $e',
              snackPosition: SnackPosition.BOTTOM);
          isLoading.value = false;
          return;
        }
      } else {
        print('ℹ️ No cover image selected, proceeding without image');
      }

      // Create PropertyModel with user-input location and fetched coordinates
      final newProperty = PropertyModel(
        id: '',
        propertyTitle: propertyTitleController.text,
        detailedDescription: detailedDescriptionController.text,
        rent: int.tryParse(rentController.text) ?? 0,
        isActive: true,
        image: imageUrl != null ? ImageModel(path: imageUrl) : null,
        propertyType: PropertyTypeModel(
          id: selectedPropertyType.value,
          name: '',
          isActive: true,
          createdDate: DateTime.now().toIso8601String(),
          updatedDate: DateTime.now().toIso8601String(),
        ),
        user: UserModel(
          id: 'current-user-id',
          firstName: 'Demo',
          lastName: 'User',
          email: 'demo@example.com',
        ),
        location: LocationModel(
          id: '',
          streetAddress: streetAddressController.text,
          areaName: areaNameController.text,
          city: cityController.text,
          postalCode: postalCodeController.text,
          latitude: latitude.value,
          longitude: longitude.value,
          isActive: true,
        ),
      );

      // Create property using PropertyService
      final createdProperty = await _propertyService.createProperty(newProperty);

      if (createdProperty != null) {
        Get.snackbar('Success', 'Property listed successfully!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: Duration(seconds: 3));
        clearForm();
        Get.back();
      } else {
        Get.snackbar('Error', 'Failed to list property',
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 3));
      }

    } catch (e) {
      print('❌ Property creation error: $e');
      Get.snackbar('Error', 'Failed to create property: $e',
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 4));
    } finally {
      isLoading.value = false;
    }
  }

  void clearForm() {
    propertyTitleController.clear();
    detailedDescriptionController.clear();
    rentController.clear();
    streetAddressController.clear();
    postalCodeController.clear();
    areaNameController.clear();
    cityController.clear();
    coverImage.value = null;
    selectedStatus.value = '';
    selectedPropertyType.value = '';
    latitude.value = 0.0;
    longitude.value = 0.0;
  }

  @override
  void onClose() {
    propertyTitleController.dispose();
    detailedDescriptionController.dispose();
    rentController.dispose();
    streetAddressController.dispose();
    postalCodeController.dispose();
    areaNameController.dispose();
    cityController.dispose();
    super.onClose();
  }
}

// --- Simple model for dropdowns ---
class DropdownItem {
  final String id;
  final String name;
  DropdownItem({required this.id, required this.name});
}