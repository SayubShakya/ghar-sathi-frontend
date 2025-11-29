import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loginappv2/src/features/user_dashboard/controllers/add_listing_controller.dart';

class AddListingScreen extends StatelessWidget {
  const AddListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AddListingController controller = Get.put(AddListingController());
    final _formKey = GlobalKey<FormState>();

    // Load dropdown data once
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadDropdownData();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Property'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),

      body: Obx(
            () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // -------------------------------
                // Property Title
                // -------------------------------
                TextFormField(
                  controller: controller.propertyTitleController,
                  decoration: const InputDecoration(
                    labelText: 'Property Title *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.title),
                  ),
                  validator: (value) =>
                  value!.isEmpty ? 'Enter property title' : null,
                ),
                const SizedBox(height: 16),

                // -------------------------------
                // Description
                // -------------------------------
                TextFormField(
                  controller: controller.detailedDescriptionController,
                  minLines: 3,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: 'Detailed Description *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.description),
                  ),
                  validator: (value) =>
                  value!.isEmpty ? 'Enter description' : null,
                ),
                const SizedBox(height: 16),

                // -------------------------------
                // Rent
                // -------------------------------
                TextFormField(
                  controller: controller.rentController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Rent Amount *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.money),
                    suffixText: 'NPR',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter rent amount';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Enter valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // -------------------------------
                // STATUS DROPDOWN
                // -------------------------------
                Obx(() => DropdownButtonFormField<String>(
                  value: controller.selectedStatus.value.isEmpty
                      ? null
                      : controller.selectedStatus.value,
                  decoration: const InputDecoration(
                    labelText: 'Status *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.info_outline),
                  ),
                  items: controller.statusList
                      .map((s) => DropdownMenuItem(
                    value: s.id,
                    child: Text(s.name),
                  ))
                      .toList(),
                  onChanged: (value) =>
                  controller.selectedStatus.value =
                      value ?? '',
                  validator: (value) =>
                  value == null ? 'Select status' : null,
                )),

                const SizedBox(height: 16),

                // -------------------------------
                // PROPERTY TYPE DROPDOWN
                // -------------------------------
                Obx(() => DropdownButtonFormField<String>(
                  value: controller.selectedPropertyType.value.isEmpty
                      ? null
                      : controller.selectedPropertyType.value,
                  decoration: const InputDecoration(
                    labelText: 'Property Type *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.category),
                  ),
                  items: controller.propertyTypeList
                      .map((t) => DropdownMenuItem(
                    value: t.id,
                    child: Text(t.name),
                  ))
                      .toList(),
                  onChanged: (value) =>
                  controller.selectedPropertyType.value =
                      value ?? '',
                  validator: (value) =>
                  value == null ? 'Select property type' : null,
                )),

                const SizedBox(height: 20),

                // -------------------------------
                // LOCATION SECTION
                // -------------------------------
                const Text(
                  "Location Details",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                // Street Address
                TextFormField(
                  controller: controller.streetAddressController,
                  decoration: const InputDecoration(
                    labelText: 'Street Address *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.home),
                    hintText: 'e.g., Lazimpat Road 12',
                  ),
                  validator: (value) =>
                  value!.isEmpty ? 'Enter street address' : null,
                ),
                const SizedBox(height: 16),

                // Area Name
                TextFormField(
                  controller: controller.areaNameController,
                  decoration: const InputDecoration(
                    labelText: 'Area Name *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.location_city),
                    hintText: 'e.g., Lazimpat',
                  ),
                  validator: (value) =>
                  value!.isEmpty ? 'Enter area name' : null,
                ),
                const SizedBox(height: 16),

                // City
                TextFormField(
                  controller: controller.cityController,
                  decoration: const InputDecoration(
                    labelText: 'City *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.location_city),
                    hintText: 'e.g., Kathmandu',
                  ),
                  validator: (value) =>
                  value!.isEmpty ? 'Enter city' : null,
                ),
                const SizedBox(height: 16),

                // Postal Code
                TextFormField(
                  controller: controller.postalCodeController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Postal Code *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.markunread_mailbox),
                    hintText: 'e.g., 44600',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter postal code';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // -------------------------------
                // GET COORDINATES BUTTON
                // -------------------------------
                Obx(() => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: controller.isFetchingCoordinates.value
                        ? null
                        : controller.getCoordinatesFromAddress,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    icon: controller.isFetchingCoordinates.value
                        ? SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                        : Icon(Icons.location_on),
                    label: controller.isFetchingCoordinates.value
                        ? Text('Fetching Coordinates...')
                        : Text('Get Coordinates from Address'),
                  ),
                )),

                const SizedBox(height: 16),

                // -------------------------------
                // COORDINATES DISPLAY
                // -------------------------------
                Obx(() => controller.latitude.value != 0.0 && controller.longitude.value != 0.0
                    ? Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Coordinates Ready',
                              style: TextStyle(
                                color: Colors.green[800],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Lat: ${controller.latitude.value.toStringAsFixed(6)}',
                              style: TextStyle(color: Colors.green[700]),
                            ),
                            Text(
                              'Lng: ${controller.longitude.value.toStringAsFixed(6)}',
                              style: TextStyle(color: Colors.green[700]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
                    : Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info, color: Colors.orange, size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Click "Get Coordinates" to fetch location coordinates',
                          style: TextStyle(color: Colors.orange[800]),
                        ),
                      ),
                    ],
                  ),
                ),
                ),

                const SizedBox(height: 20),

                // -------------------------------
                // COVER IMAGE PICKER
                // -------------------------------
                const Text(
                  "Cover Image",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                Obx(() {
                  return Container(
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: controller.coverImage.value == null
                        ? Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () => controller
                                .pickCoverImage(ImageSource.gallery),
                            icon: const Icon(Icons.photo),
                            label: const Text("Gallery"),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton.icon(
                            onPressed: () => controller
                                .pickCoverImage(ImageSource.camera),
                            icon: const Icon(Icons.camera_alt),
                            label: const Text("Camera"),
                          ),
                        ],
                      ),
                    )
                        : Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            controller.coverImage.value!,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          right: 10,
                          top: 10,
                          child: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => controller.coverImage.value = null,
                          ),
                        )
                      ],
                    ),
                  );
                }),

                const SizedBox(height: 25),

                // -------------------------------
                // SUBMIT BUTTON
                // -------------------------------
                // SizedBox(
                //   width: double.infinity,
                //   child: ElevatedButton(
                //     onPressed: () {
                //       if (_formKey.currentState!.validate()) {
                //         controller.addProperty();
                //       }
                //     },
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: Colors.green,
                //       padding: const EdgeInsets.symmetric(vertical: 15),
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(8),
                //       ),
                //     ),
                //     child: controller.isLoading.value
                //         ? const SizedBox(
                //       height: 20,
                //       width: 20,
                //       child: CircularProgressIndicator(
                //         strokeWidth: 2,
                //         valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                //       ),
                //     )
                //         : const Text(
                //       "LIST PROPERTY NOW",
                //       style: TextStyle(fontSize: 18, color: Colors.white),
                //     ),
                //   ),
                // ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: null, // This automatically disables the button
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "LIST PROPERTY NOW",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}