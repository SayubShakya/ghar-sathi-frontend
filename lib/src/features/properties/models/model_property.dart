// lib/src/features/property/models/model_property.dart

import 'package:ghar_sathi/src/features/authentication/models/user_model.dart';
import 'package:ghar_sathi/src/features/image_handle/image_handle_model.dart';
import 'package:ghar_sathi/src/features/property_type/property_type_model.dart';
import 'package:ghar_sathi/src/features/status/status_model.dart';
import 'package:ghar_sathi/src/features/user_dashboard/services/property_service.dart' hide PropertyTypeModel, LocationModel;
import '../../user_dashboard/models/location/model_location.dart';
import 'dart:typed_data'; // Required for Uint8List

class PropertyModel {
  final String id;
  final String? propertyTitle;
  final String? detailedDescription;
  final int? rent;
  final bool? isActive;
  final ImageModel? image;
  final LocationModel? location;
  final UserModel? user;
  final PropertyTypeModel? propertyType;
  final StatusModel? status;
  final DateTime? createdDate;
  final DateTime? updatedDate;

  // 🌟 NEW FIELD: This caches the Future for the image bytes
  Future<Uint8List?>? imageFuture;

  PropertyModel({
    required this.id,
    this.propertyTitle,
    this.detailedDescription,
    this.rent,
    this.isActive,
    this.image,
    this.location,
    this.user,
    this.propertyType,
    this.status,
    this.createdDate,
    this.updatedDate,
    this.imageFuture,
  });

  static Map<String, dynamic> _normalize(Map? m) {
    if (m == null) return <String, dynamic>{};
    final map = Map<String, dynamic>.from(m);
    if (map.containsKey('_id') && !map.containsKey('id')) {
      map['id'] = map['_id'];
    }
    return map;
  }

  factory PropertyModel.fromJson(Map<String, dynamic> json) {
    final imageJson = _normalize(json['image_id'] as Map?);
    final userJson = _normalize(json['user_id'] as Map?);
    final propertyTypeJson = _normalize(json['property_types_id'] as Map?);
    final locationJson = _normalize(json['location'] as Map?);

    final statusRaw = json['status_id'];
    final statusJson = statusRaw is String ? {'id': statusRaw} : _normalize(statusRaw as Map?);

    return PropertyModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      propertyTitle: json['property_title']?.toString(),
      detailedDescription: json['detailed_description']?.toString(),
      rent: (json['rent'] is int) ? json['rent'] as int : int.tryParse('${json['rent']}'),
      isActive: json['is_active'] as bool?,
      image: imageJson.isNotEmpty ? ImageModel.fromJson(imageJson) : null,
      location: locationJson.isNotEmpty ? LocationModel.fromJson(locationJson) : null,
      user: userJson.isNotEmpty ? UserModel.fromJson(userJson) : null,
      propertyType: propertyTypeJson.isNotEmpty ? PropertyTypeModel.fromJson(propertyTypeJson) : null,
      status: statusJson.isNotEmpty ? StatusModel.fromJson(statusJson) : null,
      createdDate: DateTime.tryParse(json['created_date']?.toString() ?? ''),
      updatedDate: DateTime.tryParse(json['updated_date']?.toString() ?? ''),
    );
  }

  // JUST ADD THIS METHOD - Everything else stays the same
  Map<String, dynamic> toJson() {
    return {
      'property_title': propertyTitle,
      'detailed_description': detailedDescription,
      'rent': rent,
      'is_active': isActive ?? true,
      'cover_image_url': image?.path,
      'image_id': image?.id,
      'property_types_id': propertyType?.id,
      'user_id': user?.id,
      'status_id': status?.id,
      'location': location?.toJson(),
    };
  }

  // ADD THIS COPYWITH METHOD FOR BOOKING FUNCTIONALITY
  PropertyModel copyWith({
    String? id,
    String? propertyTitle,
    String? detailedDescription,
    int? rent,
    bool? isActive,
    ImageModel? image,
    LocationModel? location,
    UserModel? user,
    PropertyTypeModel? propertyType,
    StatusModel? status,
    DateTime? createdDate,
    DateTime? updatedDate,
    Future<Uint8List?>? imageFuture,
  }) {
    return PropertyModel(
      id: id ?? this.id,
      propertyTitle: propertyTitle ?? this.propertyTitle,
      detailedDescription: detailedDescription ?? this.detailedDescription,
      rent: rent ?? this.rent,
      isActive: isActive ?? this.isActive,
      image: image ?? this.image,
      location: location ?? this.location,
      user: user ?? this.user,
      propertyType: propertyType ?? this.propertyType,
      status: status ?? this.status,
      createdDate: createdDate ?? this.createdDate,
      updatedDate: updatedDate ?? this.updatedDate,
      imageFuture: imageFuture ?? this.imageFuture,
    );
  }

  // Optional: Helper method to check if property is available for booking
  bool get isAvailableForBooking {
    return isActive == true && id.isNotEmpty;
  }

  // Optional: Helper method to get display status
  String get displayStatus {
    if (isActive == true) return 'Available';
    if (isActive == false) return 'Booked';
    return 'Unknown';
  }
}