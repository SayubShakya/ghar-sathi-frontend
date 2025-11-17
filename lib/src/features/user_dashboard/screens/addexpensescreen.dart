import 'package:flutter/material.dart';

// Dedicated widget for the "Add" screen content
class AddExpensePage extends StatelessWidget {
  const AddExpensePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Scaffold is often used if this page needs its own AppBar, but here
    // we'll just return the content to be embedded in the main Scaffold body.
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_circle_outline, color: Colors.white, size: 80),
          SizedBox(height: 20),
          Text(
            'Hey its me Aayush',
            style: TextStyle(color: Colors.white, fontSize: 32),
          ),
          // You can add your form, inputs, and logic here.
        ],
      ),
    );
  }
}