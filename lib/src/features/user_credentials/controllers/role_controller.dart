
import 'package:ghar_sathi/src/features/user_credentials/models/roles_model.dart';
import 'package:ghar_sathi/src/features/user_credentials/services/role_services.dart';
import 'package:get/get.dart';

/// The state representation for the role fetching process.
enum RoleListState { initial, loading, loaded, error }

/// RoleController manages the state of the list of roles and communicates
/// with the RoleRepository to fetch data using GetX's reactive approach.
class RoleController extends GetxController {
  final RoleRepository _roleRepository;

  // --- Reactive State (Observable) ---
  // .obs makes these variables observable. Any change automatically updates Obx/GetBuilder widgets.
  final state = RoleListState.initial.obs;
  final roles = <RoleModel>[].obs; // RxList for dynamic list management
  final errorMessage = ''.obs;

  // Constructor requires the repository for dependency injection.
  // In a real GetX application, this often involves Get.put() or bindings.
  RoleController({required RoleRepository roleRepository})
      : _roleRepository = roleRepository;

  // --- Public Getters (Accessed via .value for Rx variables) ---
  // These are often used for computed properties in the UI.
  bool get isLoading => state.value == RoleListState.loading;

  /// Fetches all roles from the repository and updates the state.
  Future<void> fetchRoles() async {
    // Check loading status via the reactive variable
    if (state.value == RoleListState.loading) return;

    state.value = RoleListState.loading; // Update state reactively

    try {
      final fetchedRoles = await _roleRepository.fetchAllRoles();

      // Successfully loaded data: update the reactive list
      // assignAll efficiently replaces all elements and notifies listeners once.
      roles.assignAll(fetchedRoles);
      state.value = RoleListState.loaded;

    } on RoleApiException catch (e) {
      // Handle specific API errors
      errorMessage.value = 'API Error: ${e.message}';
      state.value = RoleListState.error;

    } catch (e) {
      // Handle other potential errors (e.g., parsing)
      errorMessage.value = 'Unknown Error: Could not fetch roles. $e';
      state.value = RoleListState.error;
    }
  }

  /// Example method for creating a role, which updates the state and list reactively.
  Future<bool> createNewRole(String roleName) async {
    state.value = RoleListState.loading;
    try {
      // Call the repository to create the role
      final newRole = await _roleRepository.createRole(roleName);

      // If successful, append to the reactive list (automatically triggers UI update)
      roles.add(newRole);
      state.value = RoleListState.loaded;

      return true;

    } on RoleApiException catch (e) {
      errorMessage.value = 'Failed to create role: ${e.message}';
      state.value = RoleListState.error;
      return false;

    } catch (e) {
      errorMessage.value = 'Creation failed due to unknown error.';
      state.value = RoleListState.error;
      return false;
    }
  }
}