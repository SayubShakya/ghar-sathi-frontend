import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/property_controller.dart';

class PropertyListScreen extends StatelessWidget {
  final PropertyController controller = Get.put(PropertyController());

  PropertyListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Property Listings"),
        actions: [
          // Add refresh button
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.retryFetch,
          ),
        ],
      ),
      body: Obx(() {
        // Show loading indicator
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // Show error message
        if (controller.hasError.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  controller.errorMessage.value,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.red),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: controller.retryFetch,
                  child: const Text('Try Again'),
                ),
              ],
            ),
          );
        }

        // Show empty state
        if (controller.propertyList.isEmpty) {
          return const Center(
            child: Text("No properties found."),
          );
        }

        // Show property list
        return ListView.builder(
          itemCount: controller.propertyList.length,
          itemBuilder: (context, index) {
            final property = controller.propertyList[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: ListTile(
                leading: Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[300],
                  child: property.image.path.isNotEmpty
                      ? Image.network(
                    'http://localhost:5000/uploads/${property.image.filename}',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.home);
                    },
                  )
                      : const Icon(Icons.home),
                ),
                title: Text(property.propertyTitle),
                subtitle: Text("Rent: \$${property.rent} • ${property.location.city}"),
              ),
            );
          },
        );
      }),
    );
  }
}