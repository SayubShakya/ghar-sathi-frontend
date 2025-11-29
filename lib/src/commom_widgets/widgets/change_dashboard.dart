import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loginappv2/src/features/user_dashboard/screens/landlord_dashboards/landloard_dashboard.dart';
// Note: You must ensure this import path is correct for your project structure
// For this example, I'll comment it out to allow the code to compile stand-alone.
// import 'package:loginappv2/src/features/user_dashboard/screens/landlord_dashboards/landloard_dashboard.dart';

// --- Room Listing Widget (Replaces Switch to Landlord Button) ---
class RoomListingWidget extends StatelessWidget {
  const RoomListingWidget({super.key});

  // A function to handle the tap event and navigate
  void _onTapHandler() {
    print('ROOM खाली छ? List Now! tapped.');

    Get.off(() => LandloardDashboard());
  }

  @override
  Widget build(BuildContext context) {
    // Use GestureDetector to make the entire card tappable
    return GestureDetector(
      onTap: _onTapHandler,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0), // Reduced vertical padding
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              // This gives the elevated card effect
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // --- Text Content Section ---
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    // Title: "ROOM खाली छ? List Now!"
                    Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: 'ROOM खाली छ?',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: ' List Now!',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.red.shade700, // Matching the red text
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    // Subtitle: Nepali Text
                    Text(
                      // Placeholder for the Nepali Subtitle
                      'भाडावाल, Room-mate, Guest पाउन Room Sewa App मा कोठा, फ्ल्याट, वा घर राख्नुहोस्।',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16.0),
              // --- Icon Section ---
              Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  // The House Icon
                  Icon(
                    Icons.house_sharp,
                    size: 50.0,
                    color: Colors.red.shade700, // Matching the red icon
                  ),
                  // The Plus Icon overlay
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2), // White border for separation
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}