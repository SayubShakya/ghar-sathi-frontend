import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loginappv2/src/features/authentication/screens/on_boarding/on_boarding_screen.dart';
import 'package:loginappv2/src/features/authentication/screens/welcome/welcome_screen.dart';

class SplashScreenController extends GetxController
{

  static SplashScreenController get find => Get.find();

  // Controls the animation's visibility (opacity)
  RxBool animate = false.obs;

  Future startAnimation()async {
    // 1. Wait a moment before starting the fade-in animation
    await Future.delayed(const Duration(milliseconds: 300));

    // 2. Start the fade-in animation
    animate.value = true;

    // 3. Wait for the animation to complete plus viewing time (e.g., 3000ms total)
    // The delay should match the total time you want the splash screen displayed.
    await Future.delayed(const Duration(milliseconds: 3000));

    // 4. Navigate to the next screen (e.g., OnBoarding or Welcome)
    // Using Get.off() or Get.offAll() is usually better for splash screens
    // to prevent the user from navigating back to it.

    // If you have an OnBoarding flow:
    // Get.off(() => const OnBoardingScreen());

    // If you go straight to the Welcome Screen:
    Get.off(() => OnBoardingScreen());
  }
}