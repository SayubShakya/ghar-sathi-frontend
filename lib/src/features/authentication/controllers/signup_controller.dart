import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ghar_sathi/src/features/authentication/services/sign_up_services.dart';

class SignUpController extends GetxController {
    static SignUpController get instance => Get.find();

    final SignUpRepository _signUpRepo;
    SignUpController({required SignUpRepository signUpRepository})
        : _signUpRepo = signUpRepository;

    // --- Form Controllers ---
    final email = TextEditingController();
    final password = TextEditingController();
    final firstName = TextEditingController();
    final lastName = TextEditingController();
    final phoneNumber = TextEditingController();

    // --- Reactive State ---
    final selectedRoleId = Rx<String?>(null);
    final isLoading = false.obs;
    final profilePictureImage = Rx<String>('');

    // --- Registration Logic ---
    Future<bool> registerUser() async {
        if (isLoading.isTrue) return false;

        if (selectedRoleId.value == null || selectedRoleId.value!.isEmpty) {
            Get.snackbar(
                'Error',
                'Please select a user role.',
                snackPosition: SnackPosition.BOTTOM,
                colorText: Colors.red,
            );
            return false;
        }

        isLoading.value = true;

        try {
            final success = await _signUpRepo.registerUser(
                firstName: firstName.text.trim(),
                lastName: lastName.text.trim(),
                email: email.text.trim(),
                password: password.text.trim(),
                phoneNumber: phoneNumber.text.trim(),
                roleId: selectedRoleId.value!,
                profilePicture: profilePictureImage.value,
            );

            if (success) {
                return true;
            } else {
                throw Exception("Registration failed unexpectedly.");
            }
        } on SignUpApiException catch (e) {
            Get.snackbar(
                'Registration Failed',
                e.message,
                snackPosition: SnackPosition.BOTTOM,
                colorText: Colors.red,
            );
            return false;
        } catch (e) {
            Get.snackbar(
                'Error',
                'An unexpected error occurred. Please check your connection.',
                snackPosition: SnackPosition.BOTTOM,
                colorText: Colors.red,
            );
            return false;
        } finally {
            isLoading.value = false;
        }
    }
}
