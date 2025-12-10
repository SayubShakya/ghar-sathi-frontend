import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ghar_sathi/src/features/user_dashboard/screens/landlord_dashboards/landlord_add_room_screen.dart';

// Import the controller (make sure the path is correct)
import '../../../properties/models/model_property.dart';
import '../../controllers/landlord_dashboard_controller.dart';

// --- LandlordDashboardScreen (Stateless UI) ---
class LandlordDashboardScreen extends StatelessWidget {
  final LandlordDashboardController controller = Get.put(
    LandlordDashboardController(),
  );

  LandlordDashboardScreen({super.key});

  // Define enhanced color palette
  static const Color darkPurple = Color(0xFF2C0B4D);
  static const Color lightPinkBackground = Color(0xFFFDF2F8);
  static const Color cardWhite = Color(0xFFFFFFFF);
  static const Color availableGreen = Color(0xFF10B981);
  static const Color bookedRed = Color(0xFFEF4444);
  static const Color buttonRed = Color(0xFFDC3545);
  static const Color buttonGreen = Color(0xFF28A745);
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color borderColor = Color(0xFFE5E7EB);
  static const Color accentPurple = Color(0xFF8B5CF6);

  // Define Fixed Column Widths for horizontal scrolling
  static const double titleColumnWidth = 180;
  static const double typeColumnWidth = 120;
  static const double statusColumnWidth = 150;
  static const double rentColumnWidth = 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightPinkBackground,
      appBar: _buildAppBar(),
      body: Obx(() {
        if (controller.isLoading.value && controller.properties.isEmpty) {
          return _buildLoadingState();
        }

        Widget _buildSearchBar() {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: cardWhite,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.location_on, color: textSecondary),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: controller.searchCityController,
                    decoration: const InputDecoration(
                      hintText: 'Search by city (e.g. Kathmandu)',
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(color: textPrimary, fontSize: 14),
                    textInputAction: TextInputAction.search,
                    onSubmitted: (value) => controller.searchByCity(value),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search, color: textSecondary),
                  onPressed: () {
                    controller.searchByCity(controller.searchCityController.text);
                  },
                ),
              ],
            ),
          );
        }

        if (controller.hasError.value && controller.properties.isEmpty) {
          return _buildErrorState();
        }

        return RefreshIndicator(
          onRefresh: () => controller.refreshProperties(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWelcomeCard(),
                const SizedBox(height: 24),
                _buildSearchBar(),
                const SizedBox(height: 20),
                _buildHeaderSection(),
                const SizedBox(height: 20),
                _buildPropertyTable(),
                const SizedBox(height: 20),
                if (controller.isLoadMore.value) _buildLoadMoreIndicator(),
                if (controller.properties.isNotEmpty &&
                    controller.currentPage.value <
                        controller.totalPages.value &&
                    !controller.isLoadMore.value)
                  _buildLoadMoreButton(),
                const SizedBox(height: 30),
                _buildActionButtons(),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: darkPurple),
          const SizedBox(height: 20),
          Text(
            'Loading properties...',
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
          const Icon(Icons.error_outline, size: 64, color: bookedRed),
          const SizedBox(height: 20),
          Text(
            'Failed to load properties',
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
            onPressed: () => controller.refreshProperties(),
            style: ElevatedButton.styleFrom(
              backgroundColor: darkPurple,
              foregroundColor: Colors.white,
            ),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      toolbarHeight: 80,
      backgroundColor: darkPurple,
      elevation: 0,
      leading: Container(
        margin: const EdgeInsets.only(left: 16),
        child: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 22,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      title: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Landlord Dashboard',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Manage your properties',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white54, width: 2),
            ),
            child: const CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 22, color: darkPurple),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [darkPurple, accentPurple],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: darkPurple.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome Back!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Obx(
                      () => Text(
                    'You have ${controller.totalItems.value} properties listed',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ),
                const SizedBox(height: 12),
                Obx(() {
                  // ✅ FIXED: Use controller.availablePropertiesCount instead of isActive
                  final availableCount = controller.availablePropertiesCount;
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '$availableCount Available',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.emoji_objects_outlined,
              color: Colors.white,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Properties',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textPrimary,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Manage all your rental spaces',
              style: TextStyle(color: textSecondary, fontSize: 14),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: controller.onAddPropertyTapped,
          icon: const Icon(Icons.add, color: Colors.white, size: 18),
          label: const Text(
            'Add New',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: darkPurple,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            elevation: 2,
          ),
        ),
      ],
    );
  }

  Widget _buildPropertyTable() {
    if (controller.properties.isEmpty && !controller.isLoading.value) {
      return _buildEmptyState();
    }

    return Container(
      decoration: BoxDecoration(
        color: cardWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(color: borderColor, width: 1),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Table Header
            _buildTableHeader(),
            // Table Rows
            ...controller.properties.map((property) {
              return _buildPropertyRow(property);
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: cardWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Column(
        children: [
          Icon(
            Icons.house_outlined,
            size: 64,
            color: textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: 20),
          Text(
            'No Properties Found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Add your first property to get started',
            style: TextStyle(color: textSecondary, fontSize: 14),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: controller.onAddPropertyTapped,
            style: ElevatedButton.styleFrom(
              backgroundColor: darkPurple,
              foregroundColor: Colors.white,
            ),
            child: const Text('Add New Property'),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: lightPinkBackground.withOpacity(0.5),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        border: Border(bottom: BorderSide(color: borderColor, width: 1)),
      ),
      child: Row(
        children: [
          // Column 1: PROPERTY (Fixed Width)
          SizedBox(
            width: titleColumnWidth,
            child: Text(
              'PROPERTY',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: textSecondary,
                fontSize: 12,
                letterSpacing: 0.5,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Column 2: TYPE (Fixed Width)
          SizedBox(
            width: typeColumnWidth,
            child: Text(
              'TYPE',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: textSecondary,
                fontSize: 12,
                letterSpacing: 0.5,
              ),
            ),
          ),
          // Column 3: STATUS (Fixed Width)
          SizedBox(
            width: statusColumnWidth,
            child: Text(
              'STATUS',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: textSecondary,
                fontSize: 12,
                letterSpacing: 0.5,
              ),
            ),
          ),
          // Column 4: RENT (Fixed Width)
          SizedBox(
            width: rentColumnWidth,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                'RENT',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: textSecondary,
                  fontSize: 12,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyRow(PropertyModel property) {
    // ✅ FIXED: Use controller.isPropertyAvailable() instead of property.isActive
    final bool isAvailable = controller.isPropertyAvailable(property);
    final displayStatus = controller.getDisplayStatus(property);
    final displayType = controller.getDisplayType(property);
    final formattedRent = controller.formatRent(property.rent);

    return GestureDetector(
      onTap: () => controller.onPropertyItemTapped(property),
      child: Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: borderColor, width: 1)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            // Property Title
            SizedBox(
              width: titleColumnWidth,
              child: Text(
                property.propertyTitle ?? 'Untitled Property',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: textPrimary,
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Type
            SizedBox(
              width: typeColumnWidth,
              child: Text(
                displayType,
                style: TextStyle(color: textSecondary, fontSize: 14),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // ✅ FIXED STATUS: Now uses correct isAvailable based on status_id
            SizedBox(
              width: statusColumnWidth,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isAvailable
                      ? availableGreen.withOpacity(0.1)
                      : bookedRed.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isAvailable ? availableGreen : bookedRed,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: isAvailable ? availableGreen : bookedRed,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      displayStatus,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: isAvailable ? availableGreen : bookedRed,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Rent
            SizedBox(
              width: rentColumnWidth,
              child: Align(
                alignment: Alignment.centerRight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      formattedRent,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: textPrimary,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                    ),
                    Text(
                      'per month',
                      style: TextStyle(color: textSecondary, fontSize: 10),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadMoreIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Center(child: CircularProgressIndicator(color: darkPurple)),
    );
  }

  Widget _buildLoadMoreButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () => controller.loadMoreProperties(),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: darkPurple,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: darkPurple),
          ),
        ),
        child: const Text('Load More Properties'),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              if (controller.properties.isNotEmpty) {
                Get.snackbar(
                  'Info',
                  'Please select a property first',
                  snackPosition: SnackPosition.BOTTOM,
                );
              }
            },
            icon: const Icon(Icons.edit_outlined, size: 18),
            label: const Text(
              'Update Property',
              style: TextStyle(fontSize: 14),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonGreen,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
              elevation: 2,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              if (controller.properties.isNotEmpty) {
                Get.snackbar(
                  'Info',
                  'Please select a property first',
                  snackPosition: SnackPosition.BOTTOM,
                );
              }
            },
            icon: const Icon(Icons.delete_outline, size: 18),
            label: const Text(
              'Delete Property',
              style: TextStyle(fontSize: 14),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonRed,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
              elevation: 2,
            ),
          ),
        ),
      ],
    );
  }
}
