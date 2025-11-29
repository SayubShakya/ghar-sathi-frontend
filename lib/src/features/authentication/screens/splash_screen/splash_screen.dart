import 'package:flutter/material.dart';
import 'package:get/get.dart';
// Note: Keeping your existing imports for constants and welcome screen
import 'package:loginappv2/src/constants/image_strings.dart';
import 'package:loginappv2/src/constants/text_strings.dart';
import 'package:loginappv2/src/constants/sizes.dart';
import 'package:loginappv2/src/features/authentication/controllers/splash_screen_controller.dart';
import 'package:loginappv2/src/features/authentication/screens/welcome/welcome_screen.dart';


class SplashScreen extends StatelessWidget {
  SplashScreen({Key? key}) : super(key: key);

  final splashController = Get.put(SplashScreenController());


  @override
  Widget build(BuildContext context) {
    // Start the animation as soon as the widget is built
    splashController.startAnimation();

    return Scaffold(
      // Optional: Set background color if needed, otherwise defaults to white
      // backgroundColor: BackgroundColor,
      body: Center(
        child: Obx(
              () => AnimatedOpacity(
            // Animation duration is set on the opacity
            duration: const Duration(milliseconds: 5000),
            opacity: splashController.animate.value ? 1 : 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 1. Centered Brand Logo (SplashImage)
                Image(
                  image: AssetImage(SplashImage),
                  // Set a specific size or use a fraction of the screen size
                  width: MediaQuery.of(context).size.width * 0.4,
                ),

                const SizedBox(height: DefaultSize), // Use your defined size constant

                // 2. App Name
                Text(
                  AppName,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),

                // 3. App Tagline
                Text(
                  AppTagLine,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge, // Adjust style as needed
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}