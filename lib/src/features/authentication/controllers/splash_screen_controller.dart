import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ghar_sathi/src/features/authentication/screens/on_boarding/on_boarding_screen.dart';
import 'package:ghar_sathi/src/features/authentication/screens/welcome/welcome_screen.dart';

class SplashScreenController extends GetxController {
  static SplashScreenController get find => Get.find();

  RxBool animate = false.obs;

  Future<void> startAnimation() async {
    // 1. Start fade-in immediately
    animate.value = true;

    // 2. Keep splash visible for 15 seconds (Example: changed from 10 to 15)
    await Future.delayed(const Duration(seconds: 15)); // <--- INCREASE THE NUMBER HERE

    // 3. Navigate to the next screen
    Get.off(() => WelcomeScreen());
  }
}