import 'package:flutter/material.dart';
import 'package:ghar_sathi/src/constants/image_strings.dart';
import 'package:ghar_sathi/src/constants/text_strings.dart';
class LoginHeaderWidget extends StatelessWidget {
  const LoginHeaderWidget({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image(
          image: AssetImage(OnBoardingImage1),
          height: size.height * 0.2,
        ),
        Text(
          LoginTitle,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        Text(
          LoginSubTitle,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}