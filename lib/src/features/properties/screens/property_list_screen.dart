// lib/src/features/property/screens/property_list_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ghar_sathi/src/features/properties/controllers/property_controller.dart';
import 'dart:typed_data';

import '../models/model_property.dart';

class PropertyListScreen extends StatelessWidget {
  final PropertyController controller = Get.put(PropertyController());

  PropertyListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Marketplace',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF4C3E71), // Dark indigo
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            // Handle menu button press
          },
        ),
      ),
      body: Column(
        children: [
          // Condensed Header with Location & Chips
          Stack(
            children: [
              // Dark indigo background
              Container(
                height: 160,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFF4C3E71),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
              ),

              // White card with location and chips
              Positioned(
                bottom: 15,
                left: 20,
                right: 20,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Location input with search by city
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey[300]!,
                            width: 1,
                          ),
                        ),
                        child: TextField(
                          controller: controller.searchCityController,
                          decoration: InputDecoration(
                            hintText: 'Search by city (e.g. Kathmandu)',
                            hintStyle: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            prefixIcon: Icon(
                              Icons.location_pin,
                              color: Colors.grey[600],
                              size: 20,
                            ),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.search),
                              color: Colors.grey[600],
                              onPressed: () {
                                controller.searchByCity(
                                  controller.searchCityController.text,
                                );
                              },
                            ),
                          ),
                          textInputAction: TextInputAction.search,
                          onSubmitted: (value) => controller.searchByCity(value),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Filter chips row
                      SizedBox(
                        height: 35,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _buildFilterChip('Residential'),
                            const SizedBox(width: 3),
                            _buildFilterChip('Commercial'),
                            const SizedBox(width: 3),
                            _buildFilterChip('Industrial'),
                            const SizedBox(width: 3),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 0), // Space for the overlapping card

          // Property List Section with smooth transition
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Obx(() {
                // Loading State
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Error State
                if (controller.hasError.value) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          controller.errorMessage.value,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16, color: Colors.red),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: controller.retryFetch,
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  );
                }

                // Empty State
                if (controller.propertyList.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          "No properties found.",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                // Property List with "Showing Results" header
                return Column(
                  children: [
                    // Showing Results Header
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Showing Results',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          TextButton(
                            onPressed: controller.retryFetch,
                            child: const Text(
                              'Show more',
                              style: TextStyle(
                                color: Color(0xFF4C3E71),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Property List
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: controller.propertyList.length,
                        itemBuilder: (context, index) {
                          final property = controller.propertyList[index];
                          return _buildPropertyCard(property);
                        },
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  // Filter Chip Component
  Widget _buildFilterChip(String label) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF3E5F5), // Light purple background
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF7B1FA2), // Purple accent border
          width: 1,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF7B1FA2), // Purple accent text
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // Property Card Component with Tap Gesture
  Widget _buildPropertyCard(PropertyModel property) {
    return GestureDetector(
      onTap: () {
        // Navigate to detail screen when property card is tapped
        controller.navigateToPropertyDetail(property);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Prominent full-width property image
              _buildPropertyImage(property),

              // Property details section
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left side - Property info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Property Title
                          Text(
                            property.propertyTitle ?? "No Title",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),

                          // Location
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                size: 16,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  property.location?.city ?? 'Unknown Location',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),

                          // Property Type
                          Text(
                            _getPropertyType(property.propertyTitle ?? ""),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Right side - Rent and Booking Button
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Monthly Rent
                        Text(
                          "Rs.${property.rent ?? 'N/A'}",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 4),

                        // Per month text
                        const Text(
                          "/per month",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // BOOK NOW BUTTON or Booked Status
                        _buildBookingButton(property),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Booking Button Component
  Widget _buildBookingButton(PropertyModel property) {
    // Check if property is available for booking
    final isAvailable = property.isAvailableForBooking;
    final isBooked = !(property.isActive ?? true);

    if (isBooked) {
      // Show Booked status
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.red[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.red),
        ),
        child: const Text(
          'Booked',
          style: TextStyle(
            color: Colors.red,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    } else if (isAvailable) {
      // Show Book Now button
      return Obx(() => ElevatedButton(
        onPressed: controller.isBooking.value
            ? null
            : () {
          controller.showBookingDialog(property);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4C3E71),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        child: controller.isBooking.value
            ? const SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        )
            : const Text(
          'Book Now',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ));
    } else {
      // Show Unavailable status
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text(
          'Unavailable',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
      );
    }
  }

  // Property Image Component
  Widget _buildPropertyImage(PropertyModel property) {
    final imageFuture = property.imageFuture;

    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        color: Colors.grey[300],
      ),
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

          return _buildPropertyImageContent(snapshot.data!);
        },
      ),
    );
  }

  Widget _buildPropertyImageContent(Uint8List imageData) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
      child: Image.memory(
        imageData,
        fit: BoxFit.cover,
        width: double.infinity,
        height: 200,
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return const ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.home, color: Colors.grey, size: 50),
          SizedBox(height: 8),
          Text(
            "No Image",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingImage() {
    return const ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4C3E71)),
        ),
      ),
    );
  }

  Widget _buildErrorImage() {
    return const ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.broken_image, color: Colors.red, size: 50),
          SizedBox(height: 8),
          Text(
            "Failed to load image",
            style: TextStyle(color: Colors.red, fontSize: 12),
          ),
        ],
      ),
    );
  }

  // Helper method to determine property type from title
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

// Booking Confirmation Dialog Widget (Add this at the bottom of the file)
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
              style:
              const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                              fontSize: 12, color: Colors.grey),
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
                        const Icon(Icons.calendar_today,
                            color: Color(0xFF4C3E71)),
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
                        const Icon(Icons.calendar_today_outlined,
                            color: Color(0xFF4C3E71)),
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
                              '${_calculateMonths(_startDate!, _endDate!)} month(s)'),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Divider(height: 1),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total Rent:',
                              style: TextStyle(fontWeight: FontWeight.bold)),
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
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Cancel'),
        ),
        Obx(() => ElevatedButton(
          onPressed: (_startDate != null &&
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
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            ),
          )
              : const Text(
            'Confirm Booking',
            style: TextStyle(color: Colors.white),
          ),
        )),
      ],
    );
  }

  int _calculateMonths(DateTime start, DateTime end) {
    final days = end.difference(start).inDays;
    return (days / 30).ceil();
  }
}