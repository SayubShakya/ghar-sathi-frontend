// lib/src/features/booking/services/booking_service.dart
import 'package:dio/dio.dart';
import 'package:loginappv2/src/features/authentication/services/api_client.dart';
import 'package:loginappv2/src/features/booking/booking_property_model.dart';

class BookingService {
  final Dio _dio = ApiClient().dio;

  // Create booking (existing)
  Future<Map<String, dynamic>> createBooking({
    required String propertyId,
    required DateTime startDate,
    required DateTime endDate,
    bool isActive = true,
  }) async {
    try {
      final formattedStartDate =
          "${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}";
      final formattedEndDate =
          "${endDate.year}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}";

      final response = await _dio.post(
        '/bookings',
        data: {
          'property_id': propertyId,
          'start_date': formattedStartDate,
          'end_date': formattedEndDate,
          'is_active': isActive,
        },
      );

      return response.data;
    } on DioException catch (e) {
      if (e.response != null) {
        final errorData = e.response!.data;
        throw Exception(errorData['error'] ?? 'Booking failed');
      }
      rethrow;
    }
  }

  // ✅ NEW: Get user bookings with pagination
  Future<Map<String, dynamic>> getUserBookings({
    int page = 1,
    int limit = 10,
    bool includeInactive = false,
  }) async {
    try {
      print('📤 Fetching bookings page $page, limit $limit');

      final response = await _dio.get(
        '/bookings',
        queryParameters: {
          'page': page,
          'limit': limit,
          'includeInactive': includeInactive.toString(),
        },
      );

      print('✅ Bookings API response received');

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to fetch bookings: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('❌ Bookings API error: ${e.message}');
      if (e.response != null) {
        final errorData = e.response!.data;
        throw Exception(errorData['error'] ?? 'Failed to fetch bookings');
      }
      throw Exception('Network error: ${e.message}');
    }
  }

  // ✅ NEW: Parse booking list from API response
  Future<List<BookingListModel>> getBookingsList({
    int page = 1,
    int limit = 10,
    bool includeInactive = false,
  }) async {
    try {
      final response = await getUserBookings(
        page: page,
        limit: limit,
        includeInactive: includeInactive,
      );

      final List<dynamic> bookingsJson = response['data'];
      return bookingsJson
          .map((json) => BookingListModel.fromJson(json))
          .toList();
    } catch (e) {
      print('❌ Error parsing bookings: $e');
      rethrow;
    }
  }

  // ✅ NEW: Cancel booking (soft delete - UI only for now)
  // In future, replace with actual API call
  Future<void> cancelBooking(String bookingId) async {
    // For now, just simulate success
    // When backend is ready, implement:
    // final response = await _dio.delete('/bookings/$bookingId');
    await Future.delayed(const Duration(milliseconds: 500));
    print('📝 Booking $bookingId marked as cancelled (UI only)');
  }
}
