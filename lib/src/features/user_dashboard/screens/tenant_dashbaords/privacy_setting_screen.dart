import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../commom_widgets/widgets/change_dashboard.dart';

// --- GetX Controller (Logic) ---
class PrivacySettingsController extends GetxController {
  RxBool isDarkModeEnabled = false.obs; // Observable for dark mode switch

  void onBackTapped() {
    print('Back button tapped on Privacy & Settings.');
    Get.back(); // Navigate back
  }

  void onLinkedPaymentMethodsTapped() {
    print('Linked Payment Methods tapped.');
    // Implement navigation or logic for payment methods
  }

  void onToggleDarkMode(bool value) {
    isDarkModeEnabled.value = value;
    print('Dark mode toggled to: ${isDarkModeEnabled.value}');
    // Implement logic to change app theme here
  }
}

// --- PrivacySettingsScreen (Stateless UI) ---
class PrivacySettingsScreen extends StatelessWidget {
  final PrivacySettingsController controller = Get.put(PrivacySettingsController());

  PrivacySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Define the colors used in the design
    const Color darkPurple = Color(0xFF2C0B4D);
    const Color lightGreyBackground = Color(0xFFF5F5F5); // General light background
    const Color sectionHeaderColor = Colors.black54;

    return Scaffold(
      backgroundColor: lightGreyBackground, // General background color
      appBar: AppBar(
        backgroundColor: darkPurple,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: controller.onBackTapped,
        ),
        title: const Text(
          'Privacy & Settings',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // --- Top Profile Section ---
          Container(
            height: 200, // Similar height to MyAccountScreen
            color: darkPurple,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        // Using a person icon as a placeholder
                        child: Icon(
                          Icons.person,
                          size: 70,
                          color: Colors.deepPurple,
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: GestureDetector(
                          onTap: () {
                            print("Add/Edit photo tapped");
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: darkPurple, width: 2),
                            ),
                            padding: const EdgeInsets.all(4),
                            child: const Icon(
                              Icons.add,
                              color: darkPurple,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Sayub Shakya',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // --- Settings List Section ---
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 10),
              children: [
                // Payments Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Text(
                    'Payments',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: sectionHeaderColor),
                  ),
                ),
                _buildSettingItem(
                  context,
                  title: 'Linked Payment Methods',
                  onTap: controller.onLinkedPaymentMethodsTapped,
                  showArrow: true, // Show arrow for navigation
                ),
                const SizedBox(height: 10), // Spacing between sections

                // Preferences Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Text(
                    'Preferences',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: sectionHeaderColor),
                  ),
                ),
                _buildSettingItem(
                  context,
                  title: 'Darkmode',
                  trailingWidget: Obx(() => Switch(
                    value: controller.isDarkModeEnabled.value,
                    onChanged: controller.onToggleDarkMode,
                    activeColor: darkPurple, // Color when switch is on
                  )),
                  // No onTap for the row when there's a switch
                ),
                const SizedBox(height: 30),

                // --- Room Listing Widget (New Content) ---
                const RoomListingWidget(), // Replaced the ElevatedButton
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method for creating individual setting items
  Widget _buildSettingItem(
      BuildContext context, {
        required String title,
        VoidCallback? onTap, // Made optional for items with trailing widgets like Switch
        Widget? trailingWidget,
        bool showArrow = false,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        color: Colors.white, // White background for list item
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 17,
                color: Colors.black87,
              ),
            ),
            if (trailingWidget != null)
              trailingWidget
            else if (showArrow)
              const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 20),
          ],
        ),
      ),
    );
  }
}