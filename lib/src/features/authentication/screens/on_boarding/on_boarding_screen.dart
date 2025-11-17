import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:loginappv2/src/constants/colors.dart';
import 'package:loginappv2/src/constants/image_strings.dart';
import 'package:loginappv2/src/constants/sizes.dart';
import 'package:loginappv2/src/constants/text_strings.dart';
import 'package:loginappv2/src/features/authentication/models/model_on_boarding.dart';
import 'package:loginappv2/src/features/authentication/screens/on_boarding/on_boarding_page_widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:get/get.dart'; // Import GetX for navigation
import 'package:loginappv2/src/features/authentication/screens/welcome/welcome_screen.dart'; // Import WelcomeScreen

class OnBoardingScreen extends StatefulWidget {
  OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  // Use a single controller variable
  final LiquidController controller = LiquidController();

  int currentPage=0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Define the pages list once
    final pages =[
      OnBoardingPageWidget(
        model: OnBoardingModel(
          image: OnBoardingImage1,
          title: OnBoardingTitle1,
          subTitle: OnBoardingSubTitle1,
          counterText: OnBoardingCounter1,
          height: size.height,
          bgColor: OnBoardingPage1Color,
        ),

      ),
      OnBoardingPageWidget(
        model: OnBoardingModel(
          image: OnBoardingImage1,
          title: OnBoardingTitle2,
          subTitle: OnBoardingSubTitle2,
          counterText: OnBoardingCounter2,
          height: size.height,
          bgColor: OnBoardingPage2Color,
        ),

      ),
      OnBoardingPageWidget(
        model: OnBoardingModel(
          image: OnBoardingImage1,
          title: OnBoardingTitle3,
          subTitle: OnBoardingSubTitle3,
          counterText: OnBoardingCounter3,
          height: size.height,
          bgColor: OnBoardingPage1Color,
        ),

      ),

    ];

    // Removed redundant controller initialization here


    return Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: [
            LiquidSwipe(
              pages:pages,
              slideIconWidget: const Icon(Icons.arrow_back_ios),
              enableSideReveal: true,
              liquidController: controller,
              onPageChangeCallback:onPageChangeCallback,
            ),
            Positioned(
              bottom: 60.0,
              child: OutlinedButton(
                onPressed: () {
                  int nextPage = currentPage + 1;

                  if (nextPage < pages.length) {
                    // If there are more pages, animate to the next one
                    controller.animateToPage(page: nextPage);
                  } else {
                    // *** NAVIGATION TO WELCOME SCREEN ON LAST PAGE CLICK ***
                    Get.off(() => const WelcomeScreen());
                  }
                },
                style: ElevatedButton.styleFrom(
                  side: const BorderSide(color: Colors.black26),
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(20),

                ),
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_forward_ios, color: Colors.white,), // Added const and color for better practice
                ),
              ),

            ),
            Positioned(
              top: 50.0,
              right: 20.0,
              child: TextButton(
                // Skip directly to the Welcome Screen
                onPressed: () => Get.off(() => const WelcomeScreen()),
                child: const Text("Skip",style: TextStyle(fontSize: 18.0,color: Colors.grey),),
              ),


            ),
            Positioned(
              bottom: 10,
              child: AnimatedSmoothIndicator(
                  activeIndex: currentPage, // Use the state variable
                  count: pages.length, // Use the pages list length for count
                  effect: const WormEffect(
                    activeDotColor: Color(0xff272727),
                    dotHeight:5.0,
                    dotWidth: 5.0,
                  )),


            )],

        )
    );
  }

  void onPageChangeCallback(int activePageIndex) {
    setState(() {
      currentPage=activePageIndex;
    });
  }
}

// OnBoardingPageWidget has been updated to use the model's background color for opacity fix.
class OnBoardingPageWidget extends StatelessWidget {
  const OnBoardingPageWidget({
    super.key,
    required this.model,
  });

  final OnBoardingModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30.0),
      // FIX: Using model.bgColor ensures the background is opaque (assuming constants are opaque)
      // and fixes the text overlapping issue.
      color: model.bgColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,

        children:[
          Image(image: AssetImage(model.image),height: model.height * 0.4,),
          Column(
            children: [
              Text(model.title,style: Theme.of(context).textTheme.headlineMedium),
              Text(model.subTitle,textAlign: TextAlign.center),
            ],
          ),
          Text(model.counterText),
          const SizedBox(height: 80.0) // Added const

        ],
      ),
    );
  }
}