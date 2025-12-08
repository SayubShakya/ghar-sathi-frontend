import 'package:loginappv2/src/features/authentication/models/user_model.dart';
import 'package:loginappv2/src/features/booking/booking_model.dart';
import 'package:loginappv2/src/features/user_dashboard/services/property_service.dart';


class BookingListModel {
  final String id;
  final BookingPropertyModel? property;
  final UserModel? user;
  final DateTime startDate;
  final DateTime endDate;
  final StatusModel? status;
  final double totalRent;
  final bool isActive;
  final DateTime createdDate;
  final DateTime updatedDate;

  BookingListModel({
    required this.id,
    this.property,
    this.user,
    required this.startDate,
    required this.endDate,
    this.status,
    required this.totalRent,
    required this.isActive,
    required this.createdDate,
    required this.updatedDate,
  });

  factory BookingListModel.fromJson(Map<String, dynamic>? json) {
    // Handle null json
    if (json == null) {
      return BookingListModel(
        id: '',
        property: null,
        user: null,
        startDate: DateTime.now(),
        endDate: DateTime.now(),
        status: null,
        totalRent: 0.0,
        isActive: false,
        createdDate: DateTime.now(),
        updatedDate: DateTime.now(),
      );
    }

    // Parse dates safely - returns non-nullable DateTime
    DateTime safeParseDate(dynamic dateValue) {
      try {
        if (dateValue == null) return DateTime.now();
        if (dateValue is DateTime) return dateValue;
        if (dateValue is String) {
          return DateTime.parse(dateValue);
        }
        if (dateValue is int) {
          return DateTime.fromMillisecondsSinceEpoch(dateValue * 1000);
        }
        return DateTime.now();
      } catch (e) {
        return DateTime.now();
      }
    }

    // Parse nested objects safely
    BookingPropertyModel? parseProperty(dynamic propertyJson) {
      try {
        if (propertyJson == null) return null;
        if (propertyJson is Map<String, dynamic>) {
          return BookingPropertyModel.fromJson(propertyJson);
        }
        return null;
      } catch (e) {
        return null;
      }
    }

    UserModel? parseUser(dynamic userJson) {
      try {
        if (userJson == null) return null;
        if (userJson is Map<String, dynamic>) {
          return UserModel.fromJson(userJson);
        }
        return null;
      } catch (e) {
        return null;
      }
    }

    StatusModel? parseStatus(dynamic statusJson) {
      try {
        if (statusJson == null) return null;
        if (statusJson is Map<String, dynamic>) {
          return StatusModel.fromJson(statusJson);
        }
        return null;
      } catch (e) {
        return null;
      }
    }

    return BookingListModel(
      id: json['id']?.toString() ?? '',
      property: parseProperty(json['property_id']),
      user: parseUser(json['user_id']),
      startDate: safeParseDate(json['start_date']),
      endDate: safeParseDate(json['end_date']),
      status: parseStatus(json['status_id']),
      totalRent: (json['total_rent'] is num)
          ? (json['total_rent'] as num).toDouble()
          : (json['total_rent'] is String)
          ? double.tryParse(json['total_rent']) ?? 0.0
          : 0.0,
      isActive: json['is_active'] as bool? ?? false,
      createdDate: safeParseDate(json['created_date']),
      updatedDate: safeParseDate(json['updated_date']),
    );
  }

  // Duration in months
  int get durationInMonths {
    try {
      final days = endDate.difference(startDate).inDays;
      return (days / 30).ceil();
    } catch (e) {
      return 0;
    }
  }

  // Format date range
  String get formattedDateRange {
    return '${_formatDate(startDate)} - ${_formatDate(endDate)}';
  }

  String _formatDate(DateTime date) {
    try {
      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    } catch (e) {
      return 'Invalid Date';
    }
  }

  // Format rent with commas
  String get formattedRent {
    return 'Rs.${_formatNumber(totalRent.toInt())}';
  }

  String _formatNumber(int number) {
    try {
      return number.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]},',
      );
    } catch (e) {
      return number.toString();
    }
  }
}
