import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loginappv2/src/features/user_dashboard/screens/landlord_dashboards/landlord_add_room_screen.dart';

// --- Data Model for Property Listing ---
class Property {
  final String title;
  final String type;
  final String status;
  final String rent;

  Property({
    required this.title,
    required this.type,
    required this.status,
    required this.rent,
  });
}

// --- GetX Controller (Logic) ---
class LandlordDashboardController extends GetxController {
  // Observable list of properties (dummy data for now)
  final RxList<Property> properties = <Property>[
    Property(title: '1 hall', type: 'Residential', status: 'AVAILABLE', rent: 'Rs.19,000'),
    Property(title: 'Double room', type: 'Commercial', status: 'AVAILABLE', rent: 'Rs.15,000'),
    Property(title: 'Large Warehouse', type: 'Industrial', status: 'BOOKED', rent: 'Rs.40,000'),
    Property(title: 'Office Suite', type: 'Commercial', status: 'AVAILABLE', rent: 'Rs.80,000'),
    Property(title: 'Single Flat', type: 'Residential', status: 'BOOKED', rent: 'Rs.10,000'),
  ].obs;

  void onAddPropertyTapped() {
    print('Add New Property tapped.');
    Get.to(AddListingScreen());
  }

  void onUpdatePropertyTapped() {
    print('Update Property tapped.');
    // Implement logic to update a selected property
  }

  void onDeletePropertyTapped() {
    print('Delete Property tapped.');
    // Implement logic to delete a selected property
  }

  void onPropertyItemTapped(Property property) {
    print('Property ${property.title} tapped.');
    // Implement logic for viewing/editing a specific property
  }
}

// --- LandlordDashboardScreen (Stateless UI) ---
class LandlordDashboardScreen extends StatelessWidget {
  final LandlordDashboardController controller = Get.put(LandlordDashboardController());

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeCard(),
            const SizedBox(height: 24),
            _buildHeaderSection(),
            const SizedBox(height: 20),
            _buildPropertyTable(), // This now contains the horizontal scroll view
            const SizedBox(height: 30),
            _buildActionButtons(),
          ],
        ),
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
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.white, size: 22),
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
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
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
                    'You have ${controller.properties.length} properties listed',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Obx(
                      () => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${controller.properties.where((p) => p.status == 'AVAILABLE').length} Available',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.emoji_objects_outlined,
                color: Colors.white, size: 32),
          ),
        ],
      ),
    );
  }

  // UPDATED HEADER SECTION - Simplified without image references
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
              style: TextStyle(
                color: textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: controller.onAddPropertyTapped,
          icon: const Icon(Icons.add, color: Colors.white, size: 18),
          label: const Text('Add New',
              style: TextStyle(color: Colors.white, fontSize: 14)),
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
      child: Obx(
            () => SingleChildScrollView( // WRAPPER FOR HORIZONTAL SCROLLING
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

  // UPDATED Property Row - Using Fixed Widths
  Widget _buildPropertyRow(Property property) {
    final bool isAvailable = property.status == 'AVAILABLE';

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
                property.title,
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
                property.type,
                style: TextStyle(
                  color: textSecondary,
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Status
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
                      property.status,
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
                      property.rent,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: textPrimary,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                    ),
                    Text(
                      'per month',
                      style: TextStyle(
                        color: textSecondary,
                        fontSize: 10,
                      ),
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

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: controller.onUpdatePropertyTapped,
            icon: const Icon(Icons.edit_outlined, size: 18),
            label: const Text('Update Property',
                style: TextStyle(fontSize: 14)),
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
            onPressed: controller.onDeletePropertyTapped,
            icon: const Icon(Icons.delete_outline, size: 18),
            label: const Text('Delete Property',
                style: TextStyle(fontSize: 14)),
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