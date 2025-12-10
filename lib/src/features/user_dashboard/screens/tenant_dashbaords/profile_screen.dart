import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ghar_sathi/src/features/booking/booking_list_screen.dart';
import 'package:ghar_sathi/src/features/user_dashboard/screens/tenant_dashbaords/EditProfilePage.dart';
import 'package:ghar_sathi/src/features/user_dashboard/screens/tenant_dashbaords/aboutus_screen.dart';
import 'package:ghar_sathi/src/features/user_dashboard/screens/tenant_dashbaords/privacy_setting_screen.dart';
import 'package:ghar_sathi/src/features/user_dashboard/screens/tenant_dashbaords/view_my_history.dart' show ViewMyHistoryScreen;

import '../../../authentication/screens/login/login_screen.dart';

// --- GetX Controller (Logic) ---
class MyAccountController extends GetxController {
  // Functions for handling tap events
  void onEditProfileTapped() {
    print('Edit Profile Tapped');

    Get.to(() => EditProfilePage());
  }

  void onViewMyHistoryTapped() {
    print('View My History Tapped');
    Get.to(() => BookingListScreen());
    // Implement navigation or logic here
  }

  void onPrivacyAndSettingsTapped() {
    print('Privacy and Settings Tapped');
    Get.to(() => PrivacySettingsScreen());
  }

  void onAboutUsTapped() {
    print('About Us Tapped, navigating...');
    // Use Get.to() to navigate to the widget
    Get.to(() => AboutUsScreen());
  }

  void onLogoutTapped() {
    print('Logout Tapped');
    Get.defaultDialog(
      title: 'Logout',
      middleText: 'Do you want to logout',
      textConfirm: 'Yes',
      textCancel: 'No',
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.offAll(() => LoginScreen());
      },
      onCancel: () {},
    );
    // ** Implement your actual logout logic here **
    // e.g., clearing user session, navigating to login screen (Get.offAll(() => LoginScreen()))
  }
}

// --- MyAccountScreen (Stateless UI) ---
class MyAccountScreen extends StatelessWidget {
  // Find or put the controller instance
  final MyAccountController controller = Get.put(MyAccountController());

  MyAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C0B4D), // Dark purple
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // Handle back button press
          },
        ),
        title: const Text(
          'My Account',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Top section with profile picture and name
          Container(
            height: 200, // Adjust height as needed
            color: const Color(0xFF2C0B4D), // Dark purple
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
                              border: Border.all(color: const Color(0xFF2C0B4D), width: 2),
                            ),
                            padding: const EdgeInsets.all(4),
                            child: const Icon(
                              Icons.add,
                              color: Color(0xFF2C0B4D),
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Daniel Shakya',
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
          // Clickable options section
          Expanded(
            child: Container(
              color: const Color(0xFFFFF0F5), // Light pink/purple background
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                children: [
                  // Existing Profile Options
                  _buildProfileOption(
                    context,
                    icon: Icons.edit,
                    title: 'Edit Profile',
                    subtitle: 'Edit all the basic profile information associated with your profile',
                    onTap: controller.onEditProfileTapped,
                  ),
                  const SizedBox(height: 10),
                  _buildProfileOption(
                    context,
                    icon: Icons.history,
                    title: 'View My History',
                    subtitle: 'Check all your past activities and bookings in one place',
                    onTap: controller.onViewMyHistoryTapped,
                  ),
                  const SizedBox(height: 10),
                  _buildProfileOption(
                    context,
                    icon: Icons.settings,
                    title: 'Privacy and settings',
                    subtitle: 'Manage your account preferences, privacy, and app settings',
                    onTap: controller.onPrivacyAndSettingsTapped,
                  ),
                  const SizedBox(height: 10),
                  _buildProfileOption(
                    context,
                    icon: Icons.info_outline,
                    title: 'About Us',
                    subtitle: 'Know more about us',
                    onTap: controller.onAboutUsTapped,
                  ),
                  const SizedBox(height: 30), // Extra space before Logout

                  // --- New Logout Button ---
                  _buildLogoutButton(context, onTap: controller.onLogoutTapped),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method for creating the clickable list items
  Widget _buildProfileOption(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
        required VoidCallback onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.deepPurple, size: 30),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 20),
          ],
        ),
      ),
    );
  }

  // Helper method for the Logout Button
  Widget _buildLogoutButton(BuildContext context, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout, color: Colors.red, size: 24),
            SizedBox(width: 10),
            Text(
              'Logout',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}