import 'package:flutter/material.dart';
import 'package:ghar_sathi/src/constants/image_strings.dart';
import 'package:get/get.dart';
import 'package:ghar_sathi/src/features/authentication/screens/signup/signup_screen.dart';

class LoginFooterWidget extends StatelessWidget {
  const LoginFooterWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text("OR"),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            icon: Image(
              image: AssetImage(GoogleLogoImage),
              width: 20.0,
            ),
            onPressed: () {},
            label: const Text("Continue with Google"),
          ),
        ),
        const SizedBox(height: 10.0),
        TextButton(
          onPressed: ()=> Get.to(SignupScreen()),
          child: Text.rich(
            TextSpan(
                text: "Don't have an Account?",
                style: Theme.of(context).textTheme.bodySmall,
                children:[
                  const TextSpan(
                    text: "SignUp",
                    style: TextStyle(color: Colors.blue),
                  )]
            ),
          ),
        )],
    );
  }
}
