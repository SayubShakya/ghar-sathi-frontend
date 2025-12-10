import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ghar_sathi/firebase_options.dart';
import 'package:ghar_sathi/src/features/authentication/auth_binding.dart';
import 'package:ghar_sathi/src/features/authentication/screens/on_boarding/on_boarding_screen.dart';
import 'package:ghar_sathi/src/features/authentication/screens/welcome/welcome_screen.dart';
import 'package:ghar_sathi/src/features/user_credentials/screens/role_list_binding.dart';
import 'package:ghar_sathi/src/features/user_dashboard/screens/main_dashboard_screen.dart';
import 'package:ghar_sathi/src/repository/authentication_repository/authentication_repository.dart';
import 'package:ghar_sathi/src/utils/theme/theme.dart';
import 'package:ghar_sathi/src/features/authentication/screens/splash_screen/splash_screen.dart';
import 'package:get/get.dart';

import 'src/features/user_credentials/screens/role_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform).then((value)=> Get.put(AuthenticationRepository()));
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Ghar Sathi',
      theme: AppTheme.lightTheme  ,
      darkTheme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
    initialBinding:  AppBinding(),

      home: SplashScreen(),
    );
  }
}