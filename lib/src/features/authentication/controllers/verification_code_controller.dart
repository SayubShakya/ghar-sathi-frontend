import 'package:flutter/material.dart';
// Note: You must add the 'get' package to your pubspec.yaml
import 'package:get/get.dart';

class VerificationCodeController extends GetxController {
  // Controllers for the 6 OTP input fields
  final List<TextEditingController> codeControllers = List.generate(
    6,
        (index) => TextEditingController(),
  );

  // This value would ideally come from the previous screen (e.g., Get.arguments)
  final String email = 'support@codingwitht.com';

  @override
  void onClose() {
    // Dispose of all controllers to prevent memory leaks
    for (var controller in codeControllers) {
      controller.dispose();
    }
    super.onClose();
  }

  // Combines all 6 digits into a single string
  String get fullCode {
    return codeControllers.map((c) => c.text).join();
  }

  // Focus node to move focus to the next field
  void moveToNextField(String value, int index, BuildContext context) {
    if (value.length == 1 && index < 5) {
      // Moves focus to the next field
      FocusScope.of(context).nextFocus();
    }
    if (value.isEmpty && index > 0) {
      // Moves focus to the previous field on backspace/delete
      FocusScope.of(context).previousFocus();
    }
  }

  void handleNext() {
    final code = fullCode;

    if (code.length != 6) {
      Get.snackbar(
        'Error',
        'Please enter the complete 6-digit code.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }

    print('Verifying code: $code for $email');

    // Simulate API verification success
    Get.snackbar(
      'Verification Success',
      'The code $code has been successfully verified.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

    // --- Navigation to the next screen (e.g., Create New Password Screen) ---
    // You would use Get.to(() => const CreateNewPasswordScreen());
  }
}