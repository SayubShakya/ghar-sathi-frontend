import 'package:flutter/material.dart';
import 'package:loginappv2/src/constants/colors.dart';
import 'package:loginappv2/src/constants/image_strings.dart';
import 'package:loginappv2/src/constants/text_strings.dart';
import 'package:get/get.dart';
import 'package:loginappv2/src/features/authentication/screens/login/login_screen.dart';
import 'package:loginappv2/src/features/authentication/screens/signup/signup_screen.dart';


class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var brightness = MediaQuery.of(context).platformBrightness;
    final isDarkMode= brightness==Brightness.dark;


    return Scaffold(
      backgroundColor: isDarkMode?Colors.black12:Colors.indigo,
      body: Container(
        padding: EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image(image: AssetImage(OnBoardingImage1),height: height*0.6,),
            Column(

              children: [
                Text(WelcomeTitle,style: Theme.of(context).textTheme.headlineMedium,),
                Text(WelcomeSubTitle,style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center),
              ],
            ),
            Row(
              children: [
                Expanded(child: OutlinedButton(
                    onPressed: () => Get.to(()=>LoginScreen()),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(),
                      foregroundColor: Colors.white,
                      side: BorderSide(color: Colors.white),
                      padding: EdgeInsets.symmetric(vertical: 15.0),


                    ),

                    child: Text("LOGIN"))),
                SizedBox(width: 10,),
                Expanded(child: ElevatedButton(
                    onPressed: ()=>Get.to(()=>SignupScreen()),
                    style: OutlinedButton.styleFrom(
                      elevation: 0,
                      shape: RoundedRectangleBorder(),
                      foregroundColor: SecondaryColor,
                      side: BorderSide(color: SecondaryColor),
                      padding: EdgeInsets.symmetric(vertical: 15.0),


                    ),

                    child: Text("REGISTER"))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
