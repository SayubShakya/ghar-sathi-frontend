import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:loginappv2/src/features/user_credentials/controllers/role_controller.dart';
import 'package:loginappv2/src/features/user_credentials/services/role_services.dart'; // Import with alias for fully qualified type

// IMPORTANT: Update these imports based on the exact paths in your project structure:


/// RoleListBinding registers all necessary dependencies (Client, Repository, Controller).
class RoleListBinding extends Bindings {
  @override
  void dependencies() {
    // 1. Register the base HTTP client.
    // We register the specific type <http.Client> and use a tag to easily retrieve it later.
    Get.lazyPut<http.Client>(
          () => http.Client(),
      tag: 'roleHttpClient',
      fenix: true,
    );

    // 2. Register the RoleRepository.
    // We explicitly retrieve the http.Client dependency using Get.find<http.Client>().
    Get.lazyPut<RoleRepository>(
          () => RoleRepository(
        // Inject the registered http.Client instance
        client: Get.find<http.Client>(tag: 'roleHttpClient'),
      ),
      fenix: true,
    );

    // 3. Register the RoleController.
    // We retrieve the registered RoleRepository dependency using Get.find().
    Get.lazyPut<RoleController>(
          () => RoleController(
        // Inject the registered RoleRepository instance
        roleRepository: Get.find<RoleRepository>(),
      ),
      fenix: true,
    );
  }
}