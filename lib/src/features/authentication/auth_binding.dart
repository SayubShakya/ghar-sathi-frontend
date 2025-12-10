import 'package:get/get.dart';
import 'package:ghar_sathi/src/features/authentication/services/sign_up_services.dart';
import 'package:ghar_sathi/src/features/authentication/controllers/signup_controller.dart';

import 'package:ghar_sathi/src/features/user_credentials/services/role_services.dart';
import 'package:ghar_sathi/src/features/user_credentials/controllers/role_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    // --- Repositories ---
    Get.lazyPut<SignUpRepository>(() => SignUpRepository());
    Get.lazyPut<RoleRepository>(() => RoleRepository());

    // --- Controllers ---
    Get.lazyPut(() => SignUpController(signUpRepository: Get.find()));
    Get.lazyPut(() => RoleController(roleRepository: Get.find()));
  }
}
