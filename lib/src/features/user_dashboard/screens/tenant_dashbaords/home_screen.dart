import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ghar_sathi/src/features/user_dashboard/screens/tenant_dashbaords/detail_screen.dart';

class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF4C3E71), // Dark purple background
      appBar: AppBar(
        backgroundColor: Color(0xFF4C3E71),
        elevation: 0,
        title: Text(
          'Marketplace',
          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: Icon(Icons.menu, color: Colors.white),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.grey),
                      SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Lalitpur, Kathmandu',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildPropertyTypeChip('Residential'),
                      _buildPropertyTypeChip('Commercial'),
                      _buildPropertyTypeChip('Industrial'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Showing Results',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Show more',
                            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      GestureDetector(
                        onTap: () {
                          // Navigation to the detail screen is kept
                         // Get.to(() => DetailScreen());
                        },
                        child: _buildPropertyCard(
                          'assets/property1.jpg', // Make sure to add images to your assets folder
                          '1 Big Hall at Lalitpur',
                          'Mahalaxmi, Lalitpur',
                          'Residential',
                          'Rs. 19000 /per month',
                          true,
                        ),
                      ),
                      SizedBox(height: 16),
                      _buildPropertyCard(
                        'assets/property2.jpg', // Make sure to add images to your assets folder
                        'A Flat at Rent',
                        'Mahalaxmi, Lalitpur',
                        'Commercial',
                        'Rs. 18000 /per month',
                        false,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      // --- REMOVED BOTTOM NAVIGATION BAR AND FLOATING ACTION BUTTON ---
      // bottomNavigationBar: BottomNavigationBar(...)
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked
      // floatingActionButton: FloatingActionButton(...)
    );
  }

  Widget _buildPropertyTypeChip(String text) {
    return Chip(
      label: Text(text, style: TextStyle(color: Colors.purple)),
      backgroundColor: Colors.purple.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }

  Widget _buildPropertyCard(String imagePath, String title, String location, String type, String price, bool available) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            child: Image.asset(
              imagePath,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  '$location',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                Text(
                  type,
                  style: TextStyle(color: Colors.grey[600]),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      price,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.purple),
                    ),
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: available ? Colors.green : Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 4),
                        Text(
                          available ? 'Available' : 'Booked',
                          style: TextStyle(color: available ? Colors.green : Colors.red),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}