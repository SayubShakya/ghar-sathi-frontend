// login_controller.dart

import 'package:get/get.dart';
import 'package:loginappv2/src/features/authentication/services/auth_service.dart';
import 'package:loginappv2/src/features/authentication/services/token_manager.dart';
import 'package:loginappv2/src/features/user_dashboard/screens/main_dashboard_screen.dart';
import 'package:loginappv2/src/utils/custom_snakbar.dart';


import '../../../utils/full_screen_dailog_loader.dart';
import '../../user_dashboard/screens/landlord_dashboards/landloard_dashboard.dart';


class LoginController extends GetxController {
  final AuthService _authService = AuthService();
  // Use the TokenManager to handle storage operations
  final TokenManager _tokenManager = TokenManager();

  void loginUser(String email, String password) async {
    try {
      FullScreenDialogLoader.showDialog(); // Show loader

      // 1. Call the service to perform the login API call
      final loginResponse = await _authService.loginUser(email, password);
      print("loginResponse:  ${loginResponse.token}");
      // 2. Save token using the dedicated manager
      await _tokenManager.saveAccessToken(loginResponse.token);

      print('LOGIN_CONTROLLER: Token saved and immediately retrieved: ${_tokenManager.getAccessToken()}');

      FullScreenDialogLoader.cancelDialog(); // Hide loader

      CustomSnackbar.showSuccessSnackbar(
        title: "Success",
        message: "Login Successful!",
      );

      // 3. Navigate based on role
      if (loginResponse.role == "LANDLORD" || loginResponse.roleId == "691d847c4ae798894a863e97") {
        Get.offAll(() => LandloardDashboard());
      } else {
        Get.offAll(() => UserDashboard());
      }
    } catch (e) {
      FullScreenDialogLoader.cancelDialog();
      CustomSnackbar.showErrorSnackbar(
        title: "Error",
        message: e.toString().contains('Exception:')
            ? e.toString().split('Exception: ')[1] // Clean up the error message
            : "An unexpected error occurred.",
      );
    }
  }
}