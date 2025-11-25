import 'package:flutter/material.dart';
import 'package:loginappv2/src/features/authentication/screens/login/login_footer_widget.dart';
import 'package:loginappv2/src/features/authentication/screens/login/login_form_widget.dart';
import 'package:loginappv2/src/features/authentication/screens/login/login_header_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          // making it scrollabale
          child: Container(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LoginHeaderWidget(size: size),
                // for cleaner code view widget is created and instance of the newly created class is only called here
                 LoginForm(),
                LoginFooterWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

