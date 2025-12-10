import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ghar_sathi/src/features/authentication/services/token_manager.dart';
import 'package:ghar_sathi/src/features/booking/booking_service.dart';
import 'package:ghar_sathi/src/features/booking/booking_list_screen.dart';

import 'package:ghar_sathi/src/features/image_handle/image_handle_services.dart';
import 'package:ghar_sathi/src/features/user_dashboard/screens/tenant_dashbaords/detail_screen.dart';
import '../Repositories/property_repo.dart';
import '../models/model_property.dart';

class PropertyController extends GetxController {
  final PropertyService _service = PropertyService();
  final ImageService _imageService = ImageService();
  final BookingService _bookingService = BookingService();

  var propertyList = <PropertyModel>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var hasError = false.obs;
  var isBooking = false.obs;
  var bookedProperties = <String>[].obs; // Track booked property IDs

  // Search state for tenant marketplace (by city)
  final TextEditingController searchCityController = TextEditingController();
  var searchCity = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProperties();
    // Load previously booked properties from local storage if needed
    _loadBookedProperties();
  }

  @override
  void onClose() {
    searchCityController.dispose();
    super.onClose();
  }

  Future<void> fetchProperties({int page = 1, int limit = 5, String? city}) async {
    try {
      print('🔄 PropertyController: Starting fetch...');

      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      await _debugTokenCheck();

      final properties = await _service.getProperties(
        page: page,
        limit: limit,
        city: city,
      );

      // Cache the image future and check booking status
      for (var property in properties) {
        final filename = property.image?.filename;
        if (filename != null && filename.isNotEmpty) {
          property.imageFuture = _imageService.fetchImage(filename);
        }

        // Check if property is booked (from local cache or API)
        if (bookedProperties.contains(property.id)) {
          property = property.copyWith(isActive: false);
        }
      }

      propertyList.value = properties;
      print(
        '✅ PropertyController: Successfully loaded ${properties.length} properties',
      );
    } catch (e) {
      print('❌ PropertyController Error: $e');
      hasError.value = true;
      errorMessage.value = e.toString();

      if (e.toString().contains('401') ||
          e.toString().contains('Authentication')) {
        errorMessage.value = 'Login expired. Please log in again.';
        Get.snackbar(
          'Session Expired',
          'Please log in again to continue',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 5),
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to load properties: ${e.toString().replaceAll('Exception: ', '')}',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  // Get single property by ID
  Future<PropertyModel> getPropertyById(String id) async {
    try {
      print('🔄 PropertyController: Fetching property by ID: $id');

      await _debugTokenCheck();
      final property = await _service.getPropertyById(id);

      // Cache the image future for the single property
      final filename = property.image?.filename;
      if (filename != null && filename.isNotEmpty) {
        property.imageFuture = _imageService.fetchImage(filename);
      }

      // Check if property is booked
      if (bookedProperties.contains(id)) {
        return property.copyWith(isActive: false);
      }

      print(
        '✅ PropertyController: Successfully loaded property: ${property.propertyTitle}',
      );
      return property;
    } catch (e) {
      print('❌ PropertyController Error (getPropertyById): $e');
      throw Exception(
        'Failed to load property details: ${e.toString().replaceAll('Exception: ', '')}',
      );
    }
  }

  // --- SEARCH BY CITY (Tenant marketplace) ---
  Future<void> searchByCity(String city) async {
    final trimmed = city.trim();
    searchCity.value = trimmed;

    if (trimmed.isEmpty) {
      // Empty search -> reload all properties without city filter
      await fetchProperties(page: 1, limit: 5, city: null);
    } else {
      await fetchProperties(page: 1, limit: 5, city: trimmed);
    }
  }

  // BOOK PROPERTY METHOD
  Future<Map<String, dynamic>> bookProperty({
    required String propertyId,
    required DateTime startDate,
    required DateTime endDate,
    bool isActive = true,
  }) async {
    try {
      print('🔄 PropertyController: Booking property $propertyId');
      isBooking.value = true;

      // Call booking service
      final bookingResult = await _bookingService.createBooking(
        propertyId: propertyId,
        startDate: startDate,
        endDate: endDate,
        isActive: isActive,
      );

      // Update local property status
      _markPropertyAsBooked(propertyId);

      // Show success message
      Get.snackbar(
        'Success! 🎉',
        'Property booked successfully from ${startDate.day}/${startDate.month}/${startDate.year} to ${endDate.day}/${endDate.month}/${endDate.year}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
        icon: const Icon(Icons.check_circle, color: Colors.white),
      );

      print('✅ PropertyController: Booking successful');
      return bookingResult;
    } catch (e) {
      print('❌ PropertyController Error (bookProperty): $e');

      String errorMsg = 'Failed to book property';
      if (e.toString().contains('401') ||
          e.toString().contains('Authentication')) {
        errorMsg = 'Please login again to book property';
      } else if (e.toString().contains('not available')) {
        errorMsg = 'Property is no longer available';
      } else if (e.toString().contains('network')) {
        errorMsg = 'Network error. Please check your connection';
      }

      Get.snackbar(
        'Booking Failed',
        errorMsg,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
        icon: const Icon(Icons.error, color: Colors.white),
      );

      rethrow;
    } finally {
      isBooking.value = false;
    }
  }

  // Mark property as booked locally
  void _markPropertyAsBooked(String propertyId) {
    try {
      // Add to booked properties list
      if (!bookedProperties.contains(propertyId)) {
        bookedProperties.add(propertyId);
      }

      // Update property in list
      final index = propertyList.indexWhere((p) => p.id == propertyId);
      if (index != -1) {
        final property = propertyList[index];
        propertyList[index] = property.copyWith(isActive: false);
        propertyList.refresh(); // Trigger UI update
        print(
          '✅ PropertyController: Updated property $propertyId status to booked',
        );
      }

      // You might want to save to local storage
      _saveBookedProperties();
    } catch (e) {
      print('❌ Error marking property as booked: $e');
    }
  }

  // Check if property is booked
  bool isPropertyBooked(String propertyId) {
    return bookedProperties.contains(propertyId);
  }

  // Navigate to property detail
  void navigateToPropertyDetail(PropertyModel property) {
    try {
      print('🔄 Navigating to property detail: ${property.id}');
      Get.to(
            () => PropertyDetailScreen(
          propertyId: property.id,
          initialProperty: property, // Pass the object for immediate display
        ),
        transition: Transition.cupertino, // Smooth transition
        duration: const Duration(milliseconds: 300),
      );
    } catch (e) {
      print('❌ Navigation error: $e');
      Get.snackbar(
        'Error',
        'Failed to open property details',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Navigate to booking screen (if you have one)
  void navigateToBookingScreen(PropertyModel property) {
    try {
      print('🔄 Navigating to booking screen for: ${property.id}');
      // You can implement this if you want a separate booking screen
      // Get.to(() => BookingScreen(property: property));
    } catch (e) {
      print('❌ Navigation error: $e');
      Get.snackbar(
        'Error',
        'Failed to open booking screen',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Show booking dialog (called from UI)
  void showBookingDialog(PropertyModel property) {
    try {
      if (property.id == null) {
        Get.snackbar('Error', 'Property ID is missing');
        return;
      }

      if (isPropertyBooked(property.id!) || property.isActive == false) {
        Get.snackbar(
          'Already Booked',
          'This property has already been booked',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      // You can implement a custom dialog or use Get.defaultDialog
      Get.dialog(
        BookingConfirmationDialog(
          property: property,
          onConfirm: (startDate, endDate) async {
            try {
              await bookProperty(
                propertyId: property.id!,
                startDate: startDate,
                endDate: endDate,
              );
              Get.back(); // Close dialog
              Get.dialog(
                AlertDialog(
                  title: const Text('Booking Successful'),
                  content: const Text(
                    'Your room has been booked successfully.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Get.back();
                        Get.to(() => BookingListScreen());
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            } catch (e) {
              // Error already handled in bookProperty method
            }
          },
        ),
        barrierDismissible: false,
      );
    } catch (e) {
      print('❌ Error showing booking dialog: $e');
      Get.snackbar(
        'Error',
        'Failed to open booking dialog',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Debug method to check token status
  Future<void> _debugTokenCheck() async {
    try {
      final tokenManager = TokenManager();
      final token = await tokenManager.getAccessToken();

      print('🔐 Token Debug:');
      print('   - Token exists: ${token != null}');
      print('   - Token length: ${token?.length ?? 0}');
      if (token != null) {
        print(
          '   - Token preview: ${token.substring(0, token.length < 20 ? token.length : 20)}...',
        );
      } else {
        print('   ❌ NO TOKEN FOUND - This will cause 401');
      }
    } catch (e) {
      print('   ❌ Token check error: $e');
    }
  }

  // Method to retry loading properties
  void retryFetch() {
    fetchProperties();
  }

  // Clear booked properties (useful for logout)
  void clearBookedProperties() {
    bookedProperties.clear();
    _saveBookedProperties();
  }

  // Load booked properties from local storage
  void _loadBookedProperties() async {
    try {
      // You can use GetStorage or SharedPreferences here
      // For now, we'll just initialize an empty list
      bookedProperties.value = [];
    } catch (e) {
      print('❌ Error loading booked properties: $e');
    }
  }

  // Save booked properties to local storage
  void _saveBookedProperties() {
    try {
      // Implement local storage saving if needed
      // e.g., GetStorage().write('booked_properties', bookedProperties.toList());
    } catch (e) {
      print('❌ Error saving booked properties: $e');
    }
  }
}

// Simple Booking Dialog Widget
class BookingConfirmationDialog extends StatefulWidget {
  final PropertyModel property;
  final Function(DateTime, DateTime) onConfirm;

  const BookingConfirmationDialog({
    super.key,
    required this.property,
    required this.onConfirm,
  });

  @override
  State<BookingConfirmationDialog> createState() =>
      _BookingConfirmationDialogState();
}

class _BookingConfirmationDialogState extends State<BookingConfirmationDialog> {
  DateTime? _startDate;
  DateTime? _endDate;
  final PropertyController _controller = Get.find<PropertyController>();

  @override
  Widget build(BuildContext context) {
    final property = widget.property;

    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.home, color: Color(0xFF4C3E71)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Book ${property.propertyTitle ?? 'Property'}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Property Info
            Card(
              color: const Color(0xFFF3E5F5),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      property.propertyTitle ?? 'Untitled Property',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Rs.${property.rent ?? '0'}/month',
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (property.location?.city != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          property.location!.city!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Date Pickers
            Column(
              children: [
                // Start Date
                InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (picked != null) {
                      setState(() => _startDate = picked);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          color: Color(0xFF4C3E71),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _startDate == null
                                ? 'Select move-in date'
                                : 'Move-in: ${_startDate!.day}/${_startDate!.month}/${_startDate!.year}',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // End Date
                InkWell(
                  onTap: () async {
                    final firstDate = _startDate ?? DateTime.now();
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: firstDate.add(const Duration(days: 30)),
                      firstDate: firstDate,
                      lastDate: firstDate.add(const Duration(days: 365)),
                    );
                    if (picked != null) {
                      setState(() => _endDate = picked);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_outlined,
                          color: Color(0xFF4C3E71),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _endDate == null
                                ? 'Select move-out date'
                                : 'Move-out: ${_endDate!.day}/${_endDate!.month}/${_endDate!.year}',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Rent Calculation
            if (_startDate != null && _endDate != null && property.rent != null)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Duration:'),
                          Text(
                            '${_calculateMonths(_startDate!, _endDate!)} month(s)',
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Divider(height: 1),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total Rent:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Rs.${property.rent! * _calculateMonths(_startDate!, _endDate!)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
        Obx(
              () => ElevatedButton(
            onPressed:
            (_startDate != null &&
                _endDate != null &&
                !_controller.isBooking.value)
                ? () {
              widget.onConfirm(_startDate!, _endDate!);
            }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4C3E71),
            ),
            child: _controller.isBooking.value
                ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
                : const Text(
              'Confirm Booking',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  int _calculateMonths(DateTime start, DateTime end) {
    final days = end.difference(start).inDays;
    return (days / 30).ceil();
  }
}
