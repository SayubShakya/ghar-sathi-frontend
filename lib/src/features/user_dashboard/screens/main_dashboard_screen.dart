import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:loginappv2/src/features/user_dashboard/screens/addexpensescreen.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  int _page = 0;

  // Placeholder pages list (widgets corresponding to the nav bar icons)
  final List<Widget> _pages = [
    // ------------------------------------
    const AddExpensePage(), // <<< NEW WIDGET
    // ------------------------------------
    const Center(child: Text('Page 2: List', style: TextStyle(color: Colors.white, fontSize: 32))),
    const Center(child: Text('Page 3: Compare', style: TextStyle(color: Colors.white, fontSize: 32))),
    const Center(child: Text('Page 4: Split', style: TextStyle(color: Colors.white, fontSize: 32))),
    const Center(child: Text('Page 5: Profile', style: TextStyle(color: Colors.white, fontSize: 32))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          key: _bottomNavigationKey,
          index: _page,
          items: const <Widget>[
            Icon(Icons.add, size: 30),
            Icon(Icons.list, size: 30),
            Icon(Icons.compare_arrows, size: 30),
            Icon(Icons.call_split, size: 30),
            Icon(Icons.perm_identity, size: 30),
          ],
          color: Colors.white,
          buttonBackgroundColor: Colors.white,
          backgroundColor: Colors.blueAccent,
          animationCurve: Curves.easeInOut,
          animationDuration: const Duration(milliseconds: 600),
          onTap: (index) {
            setState(() {
              _page = index;
            });
          },
          letIndexChange: (index) => true,
        ),
        body: Container(
          color: Colors.blueAccent,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // The current page widget is now correctly inserted here
                // Note: We remove the programmatic button control from the page content
                // so the new page widget is the only thing displayed.
                Expanded(
                  child: _pages[_page],
                ),

                // Button to demonstrate programmatic control using the key
                ElevatedButton(
                  child: const Text('Go To Page of index 1'),
                  onPressed: () {
                    final CurvedNavigationBarState? navBarState =
                        _bottomNavigationKey.currentState;
                    navBarState?.setPage(1);
                  },
                ),
                // Added padding for the button
                const SizedBox(height: 50),
              ],
            ),
          ),
        ));
  }
}