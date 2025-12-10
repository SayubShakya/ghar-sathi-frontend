import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ghar_sathi/src/features/user_credentials/controllers/role_controller.dart';


// Import necessary files from your project structure
import 'package:ghar_sathi/src/features/user_credentials/models/roles_model.dart';
// Relative path to the controller

// NOTE: You must have the RoleRepository and http client setup
// before running this screen. The Binding below shows how to do this.

/// 1. The Screen Widget
class RoleListScreen extends StatelessWidget {
  const RoleListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject the controller if it hasn't been done via a formal GetX route
    // or manually find the existing instance.
    // We assume the binding below has been called, so we use Get.find()
    final RoleController controller = Get.find<RoleController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Roles'),
        actions: [
          // Button to manually trigger a refresh
          Obx(() => IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.isLoading ? null : () => controller.fetchRoles(),
            tooltip: 'Refresh Roles',
          )),
        ],
      ),
      body: Obx(() {
        // Obx listens to the reactive variables (state, roles, errorMessage)

        switch (controller.state.value) {
          case RoleListState.initial:
          // Fetch roles automatically on initial state, ensuring we only do this once
          // after the controller has been initialized.
          // A more robust approach would be to call fetchRoles() in the controller's onInit()
            WidgetsBinding.instance.addPostFrameCallback((_) {
              controller.fetchRoles();
            });
            return const Center(child: Text('Initializing role data...'));

          case RoleListState.loading:
            return const Center(child: CircularProgressIndicator());

          case RoleListState.error:
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 48),
                    const SizedBox(height: 16),
                    Text(
                      'Error: ${controller.errorMessage.value}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => controller.fetchRoles(),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Try Again'),
                    ),
                  ],
                ),
              ),
            );

          case RoleListState.loaded:
            if (controller.roles.isEmpty) {
              return const Center(
                child: Text('No roles found.', style: TextStyle(fontSize: 18)),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: controller.roles.length,
              itemBuilder: (context, index) {
                final role = controller.roles[index];
                return RoleCard(role: role);
              },
            );
        }
      }),
    );
  }
}

/// Helper widget to display a single RoleModel
class RoleCard extends StatelessWidget {
  final RoleModel role;
  const RoleCard({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(
          role.isActive ? Icons.check_circle : Icons.warning,
          color: role.isActive ? Colors.green : Colors.orange,
        ),
        title: Text(role.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('ID: ${role.id}\nCreated: ${role.createdDate.toLocal().toString().split(' ')[0]}'),
        trailing: Text(role.isActive ? 'Active' : 'Inactive'),
      ),
    );
  }
}

// -------------------------------------------------------------
// 2. Dependency Injection Setup (Binding)
// You would place this in a dedicated bindings file (e.g., 'role_binding.dart')
// but it is shown here for context.
// -------------------------------------------------------------

/* import 'package:http/http.dart' as http;
import 'package:ghar_sathi/src/features/user_credentials/services/role_services.dart';

class RoleListBinding extends Bindings {
  @override
  void dependencies() {
    // 1. Register the base HTTP client
    Get.lazyPut<http.Client>(() => http.Client(), tag: 'roleHttpClient');

    // 2. Register the repository, injecting the client
    Get.lazyPut<RoleRepository>(
      () => RoleRepository(client: Get.find(tag: 'roleHttpClient')),
      fenix: true,
    );

    // 3. Register the controller, injecting the repository
    Get.lazyPut<RoleController>(
      () => RoleController(roleRepository: Get.find()),
      fenix: true,
    );
  }
}

// -------------------------------------------------------------
// 3. Example Usage in main.dart
// -------------------------------------------------------------

/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Role App Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      // This is how you would use the Binding
      initialBinding: RoleListBinding(),
      home: const RoleListScreen(),
    );
  }
}
*/
*/