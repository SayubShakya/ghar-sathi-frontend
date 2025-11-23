import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:loginappv2/firebase_options.dart';
import 'package:loginappv2/src/features/authentication/screens/on_boarding/on_boarding_screen.dart';
import 'package:loginappv2/src/features/authentication/screens/welcome/welcome_screen.dart';
import 'package:loginappv2/src/features/user_credentials/screens/role_list_binding.dart';
import 'package:loginappv2/src/features/user_dashboard/screens/main_dashboard_screen.dart';
import 'package:loginappv2/src/repository/authentication_repository/authentication_repository.dart';
import 'package:loginappv2/src/utils/theme/theme.dart';
import 'package:loginappv2/src/features/authentication/screens/splash_screen/splash_screen.dart';
import 'package:get/get.dart';

import 'src/features/user_credentials/screens/role_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform).then((value)=> Get.put(AuthenticationRepository()));
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

      initialBinding: RoleListBinding(),

      home: UserDashboard(),
    );
  }
}
