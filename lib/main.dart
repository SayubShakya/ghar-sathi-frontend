import 'package:flutter/material.dart';
import 'package:loginappv2/src/features/authentication/screens/on_boarding/on_boarding_screen.dart';
import 'package:loginappv2/src/features/authentication/screens/welcome/welcome_screen.dart';
import 'package:loginappv2/src/utils/theme/theme.dart';
import 'package:loginappv2/src/features/authentication/screens/splash_screen/splash_screen.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: AppTheme.lightTheme  ,
      darkTheme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      home: SplashScreen(),
    );
  }
}
