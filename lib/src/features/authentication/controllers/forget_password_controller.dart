import 'package:flutter/material.dart';
// Note: You must add the 'get' package to your pubspec.yaml
import 'package:get/get.dart';
import 'package:ghar_sathi/src/features/authentication/screens/otp_code/verification_code_screen.dart';


class ForgetPasswordController extends GetxController {
  // 1. The TextEditingController is managed here, outside the StatelessWidget
  final TextEditingController emailController = TextEditingController();

  // RxString or RxBool can be used if you need reactive state (e.g., loading spinner)
  // final isLoading = false.obs;

  @override
  void onClose() {
    // 2. GetX automatically disposes the controller when it's no longer used,
    // ensuring no memory leaks from the TextEditingController.
    emailController.dispose();
    super.onClose();
  }

  void handleNext() {
    final email = emailController.text.trim();
    print('Attempting to reset password for: $email');

    // Basic Validation Check (Added for robustness)
    if (email.isEmpty || !GetUtils.isEmail(email)) {
      // Use GetX snackbar for error message
      Get.snackbar(
        'Error',
        'Please enter a valid email address.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }

    // 1. Display the snackbar notification
    Get.snackbar(
      'Password Reset Initiated',
      'Sending code to $email...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black,
      colorText: Colors.white,
      duration: const Duration(seconds: 1), // Short duration for quick navigation
    );

    // 2. Navigate after the snackbar has had a chance to show
    // We pass the email as an argument so the next screen can display it.
    Future.delayed(const Duration(seconds: 1), () {
      Get.to(() => const VerificationCodeScreen(),);
    });
  }
}