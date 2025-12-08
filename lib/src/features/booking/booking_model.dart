// lib/src/features/booking/models/booking_list_model.dart
import 'package:loginappv2/src/features/authentication/models/user_model.dart';
import 'package:loginappv2/src/features/status/status_model.dart';
import 'package:loginappv2/src/features/user_dashboard/services/property_service.dart';

// Simplified property model for booking response
class BookingPropertyModel {
  final String id;
  final String? propertyTitle;
  final String? detailedDescription;
  final String? imageId; // String ID, not object
  final int? rent;
  final String? locationId; // String ID, not object
  final String? statusId; // String ID, not object
  final String? userId; // String ID, not object
  final String? propertyTypesId; // String ID, not object
  final bool? isActive;

  BookingPropertyModel({
    required this.id,
    this.propertyTitle,
    this.detailedDescription,
    this.imageId,
    this.rent,
    this.locationId,
    this.statusId,
    this.userId,
    this.propertyTypesId,
    this.isActive,
  });

  factory BookingPropertyModel.fromJson(Map<String, dynamic> json) {
    return BookingPropertyModel(
      id: json['id']?.toString() ?? '',
      propertyTitle: json['property_title']?.toString(),
      detailedDescription: json['detailed_description']?.toString(),
      imageId: json['image_id']?.toString(),
      rent: (json['rent'] is int)
          ? json['rent'] as int
          : int.tryParse('${json['rent']}'),
      locationId: json['location_id']?.toString(),
      statusId: json['status_id']?.toString(),
      userId: json['user_id']?.toString(),
      propertyTypesId: json['property_types_id']?.toString(),
      isActive: json['is_active'] as bool?,
    );
  }
}

// Main booking list model
class BookingListModel {
  final String id;
  final BookingPropertyModel property;
  final UserModel user;
  final DateTime startDate;
  final DateTime endDate;
  final StatusModel status;
  final double totalRent;
  final bool isActive;
  final DateTime createdDate;
  final DateTime updatedDate;

  BookingListModel({
    required this.id,
    required this.property,
    required this.user,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.totalRent,
    required this.isActive,
    required this.createdDate,
    required this.updatedDate,
  });

  factory BookingListModel.fromJson(Map<String, dynamic> json) {
    return BookingListModel(
      id: json['id']?.toString() ?? '',
      property: BookingPropertyModel.fromJson(json['property_id']),
      user: UserModel.fromJson(json['user_id']),
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      status: StatusModel.fromJson(json['status_id']),
      totalRent: (json['total_rent'] as num).toDouble(),
      isActive: json['is_active'] as bool,
      createdDate: DateTime.parse(json['created_date']),
      updatedDate: DateTime.parse(json['updated_date']),
    );
  }

  // Duration in months
  int get durationInMonths {
    final days = endDate.difference(startDate).inDays;
    return (days / 30).ceil();
  }

  // Format date range
  String get formattedDateRange {
    return '${_formatDate(startDate)} - ${_formatDate(endDate)}';
  }

  String _formatDate(DateTime date) {
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
  }

  // Format rent with commas
  String get formattedRent {
    return 'Rs.${_formatNumber(totalRent.toInt())}';
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}
