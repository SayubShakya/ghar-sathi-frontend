// lib/src/features/property/screens/property_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ghar_sathi/src/features/properties/controllers/property_controller.dart';

import 'dart:typed_data';

import 'package:ghar_sathi/src/features/properties/models/model_property.dart';

class PropertyDetailScreen extends StatelessWidget {
  final String propertyId;
  final PropertyModel? initialProperty;

  const PropertyDetailScreen({
    super.key,
    required this.propertyId,
    this.initialProperty,
  });

  @override
  Widget build(BuildContext context) {
    // Get the controller inside the build method
    final PropertyController controller = Get.find<PropertyController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      extendBodyBehindAppBar: true,
      body: FutureBuilder<PropertyModel>(
        future: controller.getPropertyById(propertyId),
        builder: (context, snapshot) {
          final property = snapshot.hasData ? snapshot.data! : initialProperty;

          if (property == null &&
              snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (property == null) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red),
                  SizedBox(height: 16),
                  Text(
                    "Failed to load property details",
                    style: TextStyle(fontSize: 16, color: Colors.red),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(flex: 2, child: _buildPropertyImage(property)),
              Expanded(
                flex: 3,
                child: _buildPropertyDetails(
                  property,
                  controller,
                  snapshot.connectionState == ConnectionState.waiting,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPropertyImage(PropertyModel property) {
    final imageFuture = property.imageFuture;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.grey[300]),
      child: imageFuture == null
          ? _buildPlaceholderImage()
          : FutureBuilder<Uint8List?>(
        future: imageFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingImage();
          }

          if (snapshot.hasError || snapshot.data == null) {
            return _buildErrorImage();
          }

          return Image.memory(
            snapshot.data!,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          );
        },
      ),
    );
  }

  Widget _buildPropertyDetails(
      PropertyModel property,
      PropertyController controller,
      bool isLoading,
      ) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                property.propertyTitle ?? "No Title",
                style:
                const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Rs.${property.rent ?? 'N/A'} /per month',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                  _buildAvailabilityStatus(property.isActive ?? true),
                ],
              ),
              const SizedBox(height: 8),

              Row(
                children: [
                  const Icon(Icons.location_on,
                      size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      property.location?.city ?? 'Unknown Location',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),

              Row(
                children: [
                  const Icon(Icons.category, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    _getPropertyType(property.propertyTitle ?? ""),
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),

              if (property.user != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Posted By',
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: const Color(0xFF4C3E71),
                          child: Text(
                            property.user!.firstName?[0] ?? 'U',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${property.user!.firstName ?? ''} ${property.user!.lastName ?? ''}',
                              style:
                              const TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              property.user!.email ?? '',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),

              const SizedBox(height: 16),

              const Text(
                'Description',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              /// ✅ FIXED HERE
              Text(
                property.detailedDescription ??
                    'No description available',
                style: TextStyle(
                  color: Colors.black.withOpacity(0.6),
                ),
              ),

              const SizedBox(height: 24),

              _buildBookingButton(property, controller),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookingButton(
      PropertyModel property,
      PropertyController controller,
      ) {
    final isAvailable = property.isAvailableForBooking;
    final isBooked = !(property.isActive ?? true);

    if (isBooked) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.red[50],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.red),
        ),
        child: const Column(
          children: [
            Icon(Icons.block, color: Colors.red, size: 40),
            SizedBox(height: 8),
            Text(
              'Already Booked',
              style: TextStyle(
                color: Colors.red,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'This property is no longer available for booking',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ],
        ),
      );
    } else if (isAvailable) {
      return Obx(
            () => SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: controller.isBooking.value
                ? null
                : () {
              controller.showBookingDialog(property);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4C3E71),
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: controller.isBooking.value
                ? const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor:
                AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
                : const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calendar_today,
                    color: Colors.white),
                SizedBox(width: 10),
                Text(
                  'Book This Property',
                  style: TextStyle(
                      color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Column(
          children: [
            Icon(Icons.info_outline,
                color: Colors.grey, size: 40),
            SizedBox(height: 8),
            Text(
              'Currently Unavailable',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildPlaceholderImage() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.home, color: Colors.grey, size: 50),
        SizedBox(height: 8),
        Text("No Image", style: TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildLoadingImage() {
    return const Center(
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor:
        AlwaysStoppedAnimation<Color>(Color(0xFF4C3E71)),
      ),
    );
  }

  Widget _buildErrorImage() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.broken_image, color: Colors.red, size: 50),
        SizedBox(height: 8),
        Text(
          "Failed to load image",
          style: TextStyle(color: Colors.red, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildAvailabilityStatus(bool isAvailable) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: isAvailable ? Colors.green : Colors.red,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          isAvailable ? "Available" : "Booked",
          style: TextStyle(
            fontSize: 12,
            color: isAvailable ? Colors.green : Colors.red,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  String _getPropertyType(String title) {
    if (title.toLowerCase().contains('hall')) {
      return 'Commercial Hall';
    } else if (title.toLowerCase().contains('flat')) {
      return 'Residential Flat';
    } else if (title.toLowerCase().contains('house')) {
      return 'Residential House';
    } else if (title.toLowerCase().contains('apartment')) {
      return 'Residential Apartment';
    } else {
      return 'Property';
    }
  }
}
