import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:ghar_sathi/src/commom_widgets/chat_page/chat_detail_page.dart';
import 'package:ghar_sathi/src/commom_widgets/chat_page/chat_list_page.dart';
import 'package:ghar_sathi/src/commom_widgets/widgets/change_dashboard.dart';
import 'package:ghar_sathi/src/features/payment/esewa_pay.dart';
import 'package:ghar_sathi/src/features/properties/screens/dashboard.dart';
import 'package:ghar_sathi/src/features/properties/screens/property_list_screen.dart';
import 'package:ghar_sathi/src/features/user_dashboard/screens/addexpensescreen.dart';
import 'package:ghar_sathi/src/features/user_dashboard/screens/map/map_screen.dart';
import 'package:ghar_sathi/src/features/user_dashboard/screens/tenant_dashbaords/home_screen.dart';
import 'package:ghar_sathi/src/features/user_dashboard/screens/tenant_dashbaords/profile_screen.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  int _page = 0;

  // The CORRECTED pages list (5 items for 5 icons)
  final List<Widget> _pages = [
    const Mapspage(), // Index 0
    const EsewaApp(title: 'esewa'), // Index 1
    PropertyListScreen(), // Index 2
    //const RoomListingWidget(),
    ChatListPage(),
    MyAccountScreen(),

  ];

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    const Color darkPurple = Color(0xFF2C0B4D);

    final Color navColor = isDarkMode ? darkPurple : Colors.white;
    final Color buttonColor = isDarkMode ? darkPurple : Colors.white;
    final Color navBackgroundColor = isDarkMode ? Colors.transparent : Colors.white10;
    final Color iconColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: _page,
        // Your 5 icons
        items: <Widget>[
          Icon(Icons.maps_home_work_outlined, size: 30, color: iconColor),
          Icon(Icons.payments, size: 30, color: iconColor),
          Icon(Icons.room_outlined, size: 30, color: iconColor),
          Icon(Icons.message_outlined, size: 30, color: iconColor),
          Icon(Icons.person_2_outlined, size: 30, color: iconColor),
        ],
        color: navColor,
        buttonBackgroundColor: buttonColor,
        backgroundColor: navBackgroundColor,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 600),
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
        letIndexChange: (index) => true,
      ),
      body: _pages[_page], // Directly show the current page without extra containers
    );
  }
}