import 'package:flutter/material.dart';
// Note: You must add the 'get' package to your pubspec.yaml
import 'package:get/get.dart';
import 'package:loginappv2/src/features/authentication/controllers/forget_password_controller.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Instantiate the controller. GetX manages its lifecycle.
    final controller = Get.put(ForgetPasswordController());

    // Determine screen width for responsive padding
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth * 0.08; // 8% of screen width

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // Spacing from the top
                const SizedBox(height: 80),

                // --- Image Placeholder for Abstract Circle ---
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 30),
                    // IMPORTANT: Replace 'assets/your_abstract_image.png'
                    // with the actual path to your image asset.
                    child: Image.asset(
                      'assets/images/forgotPassword.png',
                      width: 140, // Maintain the original size for layout
                      height: 140,
                      errorBuilder: (context, error, stackTrace) {
                        // Fallback in case the image asset path is incorrect
                        // or missing (useful during development).
                        return Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black, width: 2),
                            color: Colors.black,
                          ),
                          child: const Center(
                            child: Text(
                              'Image\nPlaceholder',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // ---------------------------------------------

                // Title
                const Text(
                  'Forget Password',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),

                // Subtitle/Instruction
                const SizedBox(height: 12),
                const Text(
                  'Select one of the options given below to reset your password.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF555555), // Dark gray color
                  ),
                ),

                // Spacing before the input field
                const SizedBox(height: 60),

                // Email Input Field
                TextFormField(
                  // Use the controller from the GetX Controller
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                    hintText: 'E-Mail',
                    hintStyle: const TextStyle(color: Color(0xFF555555)),
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(left: 15, right: 10),
                      child: Icon(Icons.mail_outline, color: Colors.black, size: 24),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 10.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Color(0xFFCCCCCC), width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Color(0xFFCCCCCC), width: 1.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.black, width: 2.0),
                    ),
                  ),
                ),

                // Spacing before the button
                const SizedBox(height: 30),

                // Next Button
                SizedBox(
                  height: 60,
                  child: ElevatedButton(
                    // Call the logic function from the controller
                    onPressed: controller.handleNext ,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black, // Background color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 0, // Remove shadow
                      padding: const EdgeInsets.symmetric(vertical: 18.0),
                    ),
                    child: const Text(
                      'Next',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}