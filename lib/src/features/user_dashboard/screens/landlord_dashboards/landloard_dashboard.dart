import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:loginappv2/src/features/user_credentials/screens/role_screen.dart';
import 'package:loginappv2/src/features/user_dashboard/screens/landlord_dashboards/landlord_add_room_screen.dart';
import 'package:loginappv2/src/features/user_dashboard/screens/landlord_dashboards/landlord_home_screen.dart';
import 'package:loginappv2/src/features/user_dashboard/screens/landlord_dashboards/landlord_statment_screen.dart';
import 'package:loginappv2/src/features/user_dashboard/screens/main_dashboard_screen.dart';

// Import necessary screen widgets (assuming these exist in your project)
// For simplicity, I'm using StatelessWidget placeholders here:

class LandlordPropertiesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(child: Text('Properties List'));
}

class LandlordTenantsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(child: Text('Tenants Management'));
}

class LandlordPaymentsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(child: Text('Payment Tracking'));
}

class LandlordSettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(child: Text('Settings/Profile'));
}

// Assuming this widget exists from the previous request.
class RoomListingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(child: Text('Add New Listing Screen'));
}

// --- Main Landlord Dashboard Widget ---

class LandloardDashboard extends StatefulWidget {
  const LandloardDashboard({super.key});

  @override
  State<LandloardDashboard> createState() => _LandloardDashboardState();
}

class _LandloardDashboardState extends State<LandloardDashboard> {
  // Key to control the navigation bar programmatically (optional)
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  // State variable to track the currently selected page index
  int _page = 2; // Start on the 3rd index (e.g., Properties List)

  // List of screens corresponding to the navigation bar items
  final List<Widget> _pages = [
    LandlordDashboardScreen(),    // Index 0: Payment working
    LandlordTenantsScreen(),     // Index 1: Tenants
    LandlordPropertiesScreen(),  // Index 2: Properties (Center/Initial)
    AddListingScreen(),  // Index 3: Add New Listing working
    LandlordSettingsScreen(),    // Index 4: Settings
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // --- Curved Navigation Bar Implementation ---
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: _page, // Set the current index
        items: const <Widget>[
          Icon(Icons.payment, size: 30),        // Payments
          Icon(Icons.groups_3_outlined, size: 30), // Tenants
          Icon(Icons.house_siding, size: 30),   // Properties
          Icon(Icons.add_home_work_outlined, size: 30), // Add Listing
          Icon(Icons.settings, size: 30),       // Settings
        ],

        // Styling properties
        color: Colors.white,
        buttonBackgroundColor: Colors.white,
        backgroundColor: Colors.blueAccent, // Color of the area behind the curve
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 600),

        // Handle page change when an item is tapped
        onTap: (index) {
          setState(() {
            _page = index; // Update the index
          });
        },
        letIndexChange: (index) => true,
      ),

      // --- Body Content ---
      body: Container(
        color: Colors.blueAccent, // Background color matching the nav bar
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Display the selected page widget from the _pages list
              Expanded(
                child: _pages[_page],
              ),
            ],
          ),
        ),
      ),
    );
  }
}