import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ghar_sathi/src/constants/image_strings.dart';
import 'package:ghar_sathi/src/constants/text_strings.dart';
import 'package:ghar_sathi/src/constants/sizes.dart';
import 'package:ghar_sathi/src/features/authentication/controllers/splash_screen_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key); // Added const

  @override
  State<SplashScreen> createState() => _SplashScreenState(); // Corrected syntax
}

class _SplashScreenState extends State<SplashScreen> {
  // Use 'late' for efficiency
  late final SplashScreenController splashController;

  @override
  void initState() {
    super.initState();
    // Get.put ensures the controller is initialized here
    splashController = Get.put(SplashScreenController());
    splashController.startAnimation();
  }

  @override
  Widget build(BuildContext context) {
    // Use the app background color for the scaffold
    final bg = Theme.of(context).colorScheme.background;

    // Check if the logo asset path is a variable named 'SplashImage'
    const String logoPath = SplashImage;

    return Scaffold(
      backgroundColor: bg,
      body: Center(
        child: Obx(
              () => AnimatedOpacity(
            // FIX: Use a short, sensible duration for the fade-in
            duration: const Duration(milliseconds: 800),

            // FIX: Start at 0.0 (transparent) and animate to 1.0 (opaque)
            opacity: splashController.animate.value ? 1.0 : 0.0,

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Display the logo
                Image.asset(
                  logoPath,
                  width: MediaQuery.of(context).size.width * 0.4,
                ),
                const SizedBox(height: DefaultSize),

                // App Name
                Text(
                  AppName,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),

                // Tagline
                Text(
                  AppTagLine,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}