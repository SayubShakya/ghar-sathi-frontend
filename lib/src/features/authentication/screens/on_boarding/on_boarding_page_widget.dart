import 'package:flutter/material.dart';
import 'package:loginappv2/src/constants/image_strings.dart';
import 'package:loginappv2/src/constants/text_strings.dart';
import 'package:loginappv2/src/features/authentication/models/model_on_boarding.dart';

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
      color: Color(0x40132EAE),
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
          SizedBox(height: 80.0)

        ],
      ),
    );
  }
}