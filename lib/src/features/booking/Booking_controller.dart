// lib/src/features/booking/controllers/booking_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loginappv2/src/features/booking/booking_service.dart';

import 'booking_property_model.dart';

class BookingController extends GetxController {
  final BookingService _bookingService = BookingService();

  // Booking list
  final RxList<BookingListModel> bookings = <BookingListModel>[].obs;
  final RxList<BookingListModel> cancelledBookings = <BookingListModel>[].obs;

  // State management
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isLoadMore = false.obs;

  // Pagination
  final RxInt currentPage = 1.obs;
  final RxInt totalPages = 1.obs;
  final RxInt totalItems = 0.obs;

  // Filters
  final RxBool showCancelled = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBookings();
  }

  Future<void> fetchBookings({bool loadMore = false}) async {
    try {
      if (!loadMore) {
        isLoading.value = true;
        hasError.value = false;
        currentPage.value = 1;
      } else {
        isLoadMore.value = true;
      }

      print(
        '🔄 BookingController: Fetching bookings page ${currentPage.value}',
      );

      final response = await _bookingService.getUserBookings(
        page: currentPage.value,
        limit: 10,
        includeInactive: showCancelled.value,
      );

      // Check if response is null
      if (response == null) {
        throw Exception('API returned null response');
      }

      // Debug: Print raw response
      print('📦 Raw API Response type: ${response.runtimeType}');
      print('📦 Raw API Response keys: ${response.keys.toList()}');

      // Check if data exists
      if (response['data'] == null) {
        print('⚠ No booking data found in response');
        // Clear existing data if this is not loadMore
        if (!loadMore) {
          bookings.clear();
          cancelledBookings.clear();
        }

        // Update pagination info
        totalItems.value = response['total'] ?? 0;
        totalPages.value = response['totalPages'] ?? 1;

        return;
      }

      // Parse bookings
      final List<dynamic> bookingsJson = response['data'] is List
          ? response['data']
          : [];

      print('📊 Number of bookings in response: ${bookingsJson.length}');

      if (bookingsJson.isEmpty) {
        print('⚠ Empty bookings list received');
        if (!loadMore) {
          bookings.clear();
          cancelledBookings.clear();
        }
      } else {
        // Print first booking for debugging
        if (bookingsJson.isNotEmpty) {
          print('🔍 First booking JSON: ${bookingsJson.first}');
        }

        final fetchedBookings = bookingsJson
            .map((json) {
              try {
                return BookingListModel.fromJson(json);
              } catch (e, stackTrace) {
                print('❌ Error parsing booking: $e');
                print('❌ Stack trace: $stackTrace');
                print('❌ Problematic JSON: $json');
                return null;
              }
            })
            .where((booking) => booking != null && booking.id.isNotEmpty)
            .cast<BookingListModel>()
            .toList();

        print('✅ Successfully parsed ${fetchedBookings.length} bookings');

        // Separate active and cancelled bookings
        final active = fetchedBookings.where((b) => b.isActive).toList();
        final cancelled = fetchedBookings.where((b) => !b.isActive).toList();

        if (loadMore) {
          bookings.addAll(active);
          cancelledBookings.addAll(cancelled);
        } else {
          bookings.value = active;
          cancelledBookings.value = cancelled;
        }

        print(
          '✅ BookingController: Loaded ${bookings.length} active, ${cancelledBookings.length} cancelled bookings',
        );
      }

      // Update pagination info
      totalItems.value = response['total'] ?? 0;
      totalPages.value = response['totalPages'] ?? 1;

      // Clear error state on success
      hasError.value = false;
      errorMessage.value = '';
    } catch (e, stackTrace) {
      print('❌ BookingController Error: $e');
      print('❌ Stack trace: $stackTrace');

      hasError.value = true;

      // Show a user-friendly error message
      final errorString = e.toString();
      if (errorString.contains('Null') || errorString.contains('null')) {
        errorMessage.value =
            'Server returned invalid data format. Please try again later.';
      } else if (errorString.contains('Exception:')) {
        errorMessage.value = errorString.replaceAll('Exception: ', '');
      } else if (errorString.contains('Failed host lookup')) {
        errorMessage.value =
            'No internet connection. Please check your network.';
      } else {
        errorMessage.value = 'Failed to load bookings. Please try again.';
      }

      // Clear data on error if not loading more
      if (!loadMore) {
        bookings.clear();
        cancelledBookings.clear();
      }

      if (!loadMore) {
        Get.snackbar(
          'Error',
          errorMessage.value,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } finally {
      isLoading.value = false;
      isLoadMore.value = false;
      update(); // Ensure UI updates
    }
  }

  Future<void> refreshBookings() async {
    await fetchBookings(loadMore: false);
  }

  void loadMoreBookings() {
    if (!isLoadMore.value && currentPage.value < totalPages.value) {
      currentPage.value++;
      fetchBookings(loadMore: true);
    }
  }

  // Get list to display based on filter
  List<BookingListModel> get displayBookings {
    if (showCancelled.value) {
      return [...bookings, ...cancelledBookings];
    }
    return bookings.toList();
  }

  // Cancel a booking (soft delete in UI)
  Future<void> cancelBooking(BookingListModel booking) async {
    try {
      // Get property title safely
      final propertyTitle =
          booking.property?.propertyTitle ?? 'Unknown Property';

      // Show confirmation dialog
      final confirmed = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('Cancel Booking'),
          content: Text(
            'Are you sure you want to cancel booking for "$propertyTitle"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              child: const Text(
                'Yes, Cancel',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      );

      if (confirmed == true) {
        // Mark as cancelled locally
        final index = bookings.indexWhere((b) => b.id == booking.id);
        if (index != -1) {
          final cancelledBooking = BookingListModel(
            id: booking.id,
            property: booking.property,
            user: booking.user,
            startDate: booking.startDate,
            endDate: booking.endDate,
            status: booking.status,
            totalRent: booking.totalRent,
            isActive: false,
            // Mark as inactive
            createdDate: booking.createdDate,
            updatedDate: DateTime.now(),
          );

          bookings.removeAt(index);
          cancelledBookings.add(cancelledBooking);

          // Trigger UI updates
          bookings.refresh();
          cancelledBookings.refresh();

          // In future: Call API
          // await _bookingService.cancelBooking(booking.id);

          Get.snackbar(
            'Booking Cancelled',
            'Booking for "$propertyTitle" has been cancelled',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.orange,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
        }
      }
    } catch (e) {
      print('❌ Error cancelling booking: $e');
      Get.snackbar(
        'Error',
        'Failed to cancel booking: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }

  // Edit booking dates
  void editBooking(BookingListModel booking) {
    // Get property title safely
    final propertyTitle = booking.property?.propertyTitle ?? 'Unknown Property';

    // For now, show a message
    // In future, open booking dialog with pre-filled dates
    Get.snackbar(
      'Edit Booking',
      'Edit functionality for "$propertyTitle" will be available soon',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  // Toggle cancelled bookings visibility
  void toggleCancelledVisibility() {
    showCancelled.value = !showCancelled.value;
    if (showCancelled.value && cancelledBookings.isEmpty) {
      // Refresh to include cancelled if needed
      refreshBookings();
    }
  }

  // Clear all data (useful for logout)
  void clearData() {
    bookings.clear();
    cancelledBookings.clear();
    currentPage.value = 1;
    totalPages.value = 1;
    totalItems.value = 0;
    hasError.value = false;
    errorMessage.value = '';
    showCancelled.value = false;
  }
}
