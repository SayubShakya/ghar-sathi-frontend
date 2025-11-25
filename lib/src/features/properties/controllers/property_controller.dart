import 'package:get/get.dart';
import 'package:loginappv2/src/features/authentication/services/token_manager.dart';
import '../Repositories/property_repo.dart';
import '../models/model_property.dart';

class PropertyController extends GetxController {
  final PropertyService _service = PropertyService();

  var propertyList = <PropertyModel>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs; // ← Track error messages
  var hasError = false.obs;  // ← Track error state

  @override
  void onInit() {
    super.onInit();
    fetchProperties();
  }

  Future<void> fetchProperties({int page = 1, int limit = 5}) async {
    try {
      print('🔄 PropertyController: Starting fetch...');

      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      // Add debug to check token
      await _debugTokenCheck();

      final properties = await _service.getProperties(page: page, limit: limit);
      propertyList.value = properties;

      print('✅ PropertyController: Successfully loaded ${properties.length} properties');

    } catch (e) {
      print('❌ PropertyController Error: $e');
      hasError.value = true;
      errorMessage.value = e.toString();

      // Show user-friendly error message
      if (e.toString().contains('401') || e.toString().contains('Authentication')) {
        errorMessage.value = 'Login expired. Please log in again.';
        Get.snackbar(
          'Session Expired',
          'Please log in again to continue',
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 5),
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to load properties: ${e.toString().replaceAll('Exception: ', '')}',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  // Debug method to check token status
  Future<void> _debugTokenCheck() async {
    try {
      // You'll need to import TokenManager
      // import 'package:loginappv2/src/features/authentication/services/token_manager.dart';
      final tokenManager = TokenManager();
      final token = await tokenManager.getAccessToken();

      print('🔐 Token Debug:');
      print('   - Token exists: ${token != null}');
      print('   - Token length: ${token?.length ?? 0}');
      if (token != null) {
        print('   - Token preview: ${token.substring(0, token.length < 20 ? token.length : 20)}...');
      } else {
        print('   ❌ NO TOKEN FOUND - This will cause 401');
      }
    } catch (e) {
      print('   ❌ Token check error: $e');
    }
  }

  // Method to retry loading properties
  void retryFetch() {
    fetchProperties();
  }
}