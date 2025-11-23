import 'package:flutter/foundation.dart';

@immutable

import 'dart:convert';

// Main Model for the entire response
class PaginatedRolesResponse {
  final List<RoleModel> data;
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  PaginatedRolesResponse({
    required this.data,
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });

  factory PaginatedRolesResponse.fromJson(Map<String, dynamic> json) {
    // Safely parse the list of roles
    final List<dynamic>? dataList = json['data'];

    // Map each item in the list to a Role object
    final List<RoleModel> roles = dataList != null
        ? dataList.map((i) => RoleModel.fromJson(i as Map<String, dynamic>)).toList()
        : [];

    return PaginatedRolesResponse(
      data: roles,
      page: json['page'] as int,
      limit: json['limit'] as int,
      total: json['total'] as int,
      totalPages: json['totalPages'] as int,
    );
  }
}

class RoleModel {
  final String id;
  final String name;
  final bool isActive;
  final DateTime createdDate;
  final DateTime updatedDate;

  const RoleModel({
    required this.id,
    required this.name,
    required this.isActive,
    required this.createdDate,
    required this.updatedDate,
  });

  // Factory constructor to create a RoleModel from a JSON Map
  factory RoleModel.fromJson(Map<String, dynamic> json) {
    return RoleModel(
      id: json['id'] as String,
      name: json['name'] as String,
      isActive: json['is_active'] as bool,
      // Dart's DateTime.parse is perfect for the ISO 8601 string you have
      createdDate: DateTime.parse(json['created_date'] as String),
      updatedDate: DateTime.parse(json['updated_date'] as String),
    );
  }
  static List<RoleModel> listFromJson(List<dynamic> jsonList) {
    return jsonList
        .map((json) => RoleModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  // Method to convert the RoleModel back to a JSON Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'is_active': isActive,
      'created_date': createdDate.toIso8601String(),
      'updated_date': updatedDate.toIso8601String(),
    };
  }
}