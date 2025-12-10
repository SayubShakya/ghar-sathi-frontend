// lib/src/features/booking/screens/booking_list_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ghar_sathi/src/features/booking/booking_controller.dart';

import 'booking_property_model.dart';

class BookingListScreen extends StatelessWidget {
  final BookingController controller = Get.put(BookingController());

  BookingListScreen({super.key});

  // Color palette
  static const Color primaryColor = Color(0xFF4C3E71);
  static const Color backgroundColor = Color(0xFFF8F9FA);
  static const Color cardColor = Colors.white;
  static const Color activeGreen = Color(0xFF10B981);
  static const Color cancelledRed = Color(0xFFEF4444);
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color borderColor = Color(0xFFE5E7EB);
  static const Color warningOrange = Color(0xFFF59E0B);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: _buildAppBar(),
      body: Obx(() {
        // Loading state
        if (controller.isLoading.value && controller.bookings.isEmpty) {
          return _buildLoadingState();
        }

        // Error state
        if (controller.hasError.value && controller.bookings.isEmpty) {
          return _buildErrorState();
        }

        return RefreshIndicator(
          onRefresh: () => controller.refreshBookings(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                // Stats and filters
                _buildHeaderSection(),

                // Bookings list
                _buildBookingsList(),

                // Load more indicator/button
                if (controller.isLoadMore.value) _buildLoadMoreIndicator(),

                if (controller.bookings.isNotEmpty &&
                    controller.currentPage.value <
                        controller.totalPages.value &&
                    !controller.isLoadMore.value)
                  _buildLoadMoreButton(),

                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      }),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(
        'My Bookings',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: primaryColor,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Get.back(),
      ),
      actions: [
        Obx(
          () => IconButton(
            icon: Icon(
              controller.showCancelled.value
                  ? Icons.visibility
                  : Icons.visibility_off,
              color: Colors.white,
            ),
            onPressed: () => controller.toggleCancelledVisibility(),
            tooltip: controller.showCancelled.value
                ? 'Hide Cancelled'
                : 'Show Cancelled',
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: primaryColor),
          const SizedBox(height: 20),
          Text(
            'Loading your bookings...',
            style: TextStyle(color: textSecondary, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: cancelledRed),
          const SizedBox(height: 20),
          Text(
            'Failed to load bookings',
            style: TextStyle(
              color: textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              controller.errorMessage.value,
              textAlign: TextAlign.center,
              style: TextStyle(color: textSecondary, fontSize: 14),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => controller.refreshBookings(),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          const Text(
            'Booking History',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 8),

          // Stats
          Obx(() {
            final totalBookings =
                controller.bookings.length +
                controller.cancelledBookings.length;
            final activeBookings = controller.bookings.length;

            return Row(
              children: [
                _buildStatCard(
                  title: 'Total',
                  value: totalBookings.toString(),
                  color: primaryColor,
                ),
                const SizedBox(width: 12),
                _buildStatCard(
                  title: 'Active',
                  value: activeBookings.toString(),
                  color: activeGreen,
                ),
                const SizedBox(width: 12),
                _buildStatCard(
                  title: 'Cancelled',
                  value: controller.cancelledBookings.length.toString(),
                  color: cancelledRed,
                ),
              ],
            );
          }),

          const SizedBox(height: 16),

          // Filter info
          Obx(() {
            if (controller.showCancelled.value) {
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: warningOrange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: warningOrange),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: warningOrange, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Showing all bookings including cancelled',
                        style: TextStyle(color: warningOrange, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox();
          }),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(color: textSecondary, fontSize: 12)),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingsList() {
    return Obx(() {
      final displayBookings = controller.displayBookings;

      if (displayBookings.isEmpty) {
        return _buildEmptyState();
      }

      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        itemCount: displayBookings.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final booking = displayBookings[index];
          return _buildBookingCard(booking);
        },
      );
    });
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Icon(
            Icons.calendar_today,
            size: 64,
            color: textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: 20),
          Text(
            'No Bookings Found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            controller.showCancelled.value
                ? 'No bookings found in your history'
                : 'You have no active bookings',
            textAlign: TextAlign.center,
            style: TextStyle(color: textSecondary, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingCard(BookingListModel booking) {
    final isCancelled = !booking.isActive;
    final propertyTitle =
        booking.property?.propertyTitle ?? 'Untitled Property';
    final propertyRent = booking.property?.rent;
    final userName = booking.user?.firstName != null
        ? '${booking.user?.firstName ?? ''} ${booking.user?.lastName ?? ''}'
              .trim()
        : null;
    final statusName = booking.status?.name?.toUpperCase() ?? 'BOOKING';

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: isCancelled ? cancelledRed.withOpacity(0.3) : borderColor,
          width: isCancelled ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Property header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isCancelled
                  ? cancelledRed.withOpacity(0.05)
                  : primaryColor.withOpacity(0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                // Property icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isCancelled
                        ? cancelledRed.withOpacity(0.2)
                        : primaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.home,
                    color: isCancelled ? cancelledRed : primaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),

                // Property title
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        propertyTitle,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isCancelled ? cancelledRed : textPrimary,
                          decoration: isCancelled
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        propertyRent != null
                            ? 'Monthly Rent: Rs.${propertyRent}'
                            : 'Monthly Rent: N/A',
                        style: TextStyle(
                          fontSize: 12,
                          color: isCancelled
                              ? cancelledRed.withOpacity(0.8)
                              : textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Status badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isCancelled
                        ? cancelledRed.withOpacity(0.1)
                        : statusName.contains('BOOK')
                        ? activeGreen.withOpacity(0.1)
                        : warningOrange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isCancelled
                          ? cancelledRed
                          : statusName.contains('BOOK')
                          ? activeGreen
                          : warningOrange,
                    ),
                  ),
                  child: Text(
                    isCancelled ? 'CANCELLED' : statusName,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: isCancelled
                          ? cancelledRed
                          : statusName.contains('BOOK')
                          ? activeGreen
                          : warningOrange,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Booking details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date range
                _buildDetailRow(
                  icon: Icons.calendar_today,
                  title: 'Booking Period',
                  value: booking.formattedDateRange,
                ),
                const SizedBox(height: 12),

                // Duration
                _buildDetailRow(
                  icon: Icons.access_time,
                  title: 'Duration',
                  value: '${booking.durationInMonths} month(s)',
                ),
                const SizedBox(height: 12),

                // Total rent
                _buildDetailRow(
                  icon: Icons.currency_rupee,
                  title: 'Total Rent',
                  value: booking.formattedRent,
                  valueStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isCancelled ? cancelledRed : activeGreen,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 12),

                // Tenant info (if user is landlord)
                if (userName != null && userName.isNotEmpty)
                  _buildDetailRow(
                    icon: Icons.person,
                    title: 'Booked By',
                    value: userName,
                  ),

                const SizedBox(height: 16),

                // Action buttons (only for active bookings)
                if (!isCancelled)
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => controller.editBooking(booking),
                          icon: const Icon(Icons.edit, size: 16),
                          label: const Text('Edit Dates'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: primaryColor,
                            side: BorderSide(color: primaryColor),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => controller.cancelBooking(booking),
                          icon: const Icon(Icons.cancel, size: 16),
                          label: const Text('Cancel'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: cancelledRed.withOpacity(0.1),
                            foregroundColor: cancelledRed,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ],
                  ),

                // Cancelled info
                if (isCancelled)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: cancelledRed.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: cancelledRed.withOpacity(0.2)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: cancelledRed, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'This booking was cancelled',
                            style: TextStyle(
                              color: cancelledRed,
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String title,
    required String value,
    TextStyle? valueStyle,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: textSecondary),
        const SizedBox(width: 8),
        Text('$title: ', style: TextStyle(color: textSecondary, fontSize: 14)),
        Expanded(
          child: Text(
            value,
            style:
                valueStyle ??
                TextStyle(
                  color: textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget _buildLoadMoreIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Center(child: CircularProgressIndicator(color: primaryColor)),
    );
  }

  Widget _buildLoadMoreButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: ElevatedButton(
          onPressed: () => controller.loadMoreBookings(),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: primaryColor),
            ),
          ),
          child: const Text('Load More Bookings'),
        ),
      ),
    );
  }
}
