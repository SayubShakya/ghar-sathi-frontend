import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ghar_sathi/src/features/user_dashboard/screens/tenant_dashbaords/profile_screen.dart';

// --- GetX Controller (Logic) ---
class AboutUsController extends GetxController {
  // Any specific logic for the About Us page can go here,
  // e.g., fetching version number, showing contact info.

  void onBackTapped() {
    print('Back button tapped, navigating back.');
    Get.to(() => MyAccountScreen());
    // Example GetX navigation: Get.back();
  }
}

// --- AboutUsScreen (Stateless UI) ---
class AboutUsScreen extends StatelessWidget {
  final AboutUsController controller = Get.put(AboutUsController());

  AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Define the colors used in the design
    const Color darkPurple = Color(0xFF2C0B4D);
    const Color lightPinkPurple = Color(0xFFFFF0F5);

    return Scaffold(
      backgroundColor: lightPinkPurple, // Set the background color
      appBar: AppBar(
        backgroundColor: darkPurple,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: controller.onBackTapped, // Linked to GetX Controller
        ),
        title: const Text(
          'About us',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // --- Logo/Image Section ---
            Container(
              margin: const EdgeInsets.only(bottom: 30),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: darkPurple, width: 2),
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(10),
              child: const CircleAvatar(
                radius: 60,
                backgroundColor: Colors.transparent,
                // KEEPING THE PATH EMPTY AS REQUESTED
                backgroundImage: AssetImage(''), // Placeholder for your logo image path
                child: Center(
                  // Fallback if image doesn't load/path is empty, matching the icon in the image
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.house_siding_rounded, color: darkPurple, size: 40),
                      Text(
                        'Ghar Sathi',
                        style: TextStyle(color: darkPurple, fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // --- About the Company Heading ---
            const Text(
              'About the Company',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 15),

            // --- Description Content ---
            const Text(
              "The Smart Space Rental Sathi is Nepal's digital platform that connects space seekers with owners for easy, secure rentals. Whether you need a room, office, or warehouse, Ghar Sathi makes searching, listing, and managing spaces simple and fast. With advanced filters, digital payments, and direct contact options, it ensures a smooth rental experience. Unlike general property sites, Ghar Sathi focuses only on rentals—offering verified listings and hassle-free transactions. From students to entrepreneurs, anyone can find or rent space easily.",
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: Colors.black87,
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 30),

            // --- Tagline/Footer ---
            const Text(
              'Ghar Sathi - Your Smart Rental Companion',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: darkPurple,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}