import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Constants & Widgets
import 'package:ghar_sathi/src/constants/image_strings.dart';
import 'package:ghar_sathi/src/constants/text_strings.dart';
import 'package:ghar_sathi/src/commom_widgets/forms/form_header_widget.dart';
import 'package:ghar_sathi/src/features/authentication/screens/login/login_screen.dart';

// Controllers & Models
import 'package:ghar_sathi/src/features/authentication/controllers/signup_controller.dart';
import 'package:ghar_sathi/src/features/authentication/services/sign_up_services.dart';
import 'package:ghar_sathi/src/features/user_credentials/controllers/role_controller.dart';
import 'package:ghar_sathi/src/features/user_credentials/models/roles_model.dart';
import 'package:ghar_sathi/src/features/user_credentials/services/role_services.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final signUpRepository = Get.isRegistered<SignUpRepository>()
        ? Get.find<SignUpRepository>()
        : Get.put(SignUpRepository());

    final signUpController = Get.isRegistered<SignUpController>()
        ? Get.find<SignUpController>()
        : Get.put(SignUpController(signUpRepository: signUpRepository));

    final roleRepository = Get.isRegistered<RoleRepository>()
        ? Get.find<RoleRepository>()
        : Get.put(RoleRepository());

    final roleController = Get.isRegistered<RoleController>()
        ? Get.find<RoleController>()
        : Get.put(RoleController(roleRepository: roleRepository));

    final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

    if (roleController.state.value == RoleListState.initial) {
      roleController.fetchRoles();
    }

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FormHeaderWidget(
                  image: OnBoardingImage1,
                  title: SignUpTitle,
                  subtitle: SignUpSubTitle,
                ),

                Container(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Form(
                    key: _formkey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // FIRST NAME
                        TextFormField(
                          controller: signUpController.firstName,
                          decoration: const InputDecoration(
                            label: Text("First Name"),
                            prefixIcon: Icon(Icons.person_outline_rounded),
                          ),
                          validator: (value) =>
                          value!.isEmpty ? 'First Name is required' : null,
                        ),
                        const SizedBox(height: 15),

                        // LAST NAME
                        TextFormField(
                          controller: signUpController.lastName,
                          decoration: const InputDecoration(
                            label: Text("Last Name"),
                            prefixIcon: Icon(Icons.person_outline_rounded),
                          ),
                          validator: (value) =>
                          value!.isEmpty ? 'Last Name is required' : null,
                        ),
                        const SizedBox(height: 15),

                        // EMAIL
                        TextFormField(
                          controller: signUpController.email,
                          decoration: const InputDecoration(
                            label: Text("Email"),
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'Email is required';
                            if (!GetUtils.isEmail(value)) return 'Enter a valid email';
                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 15),

                        // PHONE
                        TextFormField(
                          controller: signUpController.phoneNumber,
                          decoration: const InputDecoration(
                            label: Text("Phone No"),
                            prefixIcon: Icon(Icons.numbers),
                          ),
                          validator: (value) => value!.isEmpty ? 'Phone number is required' : null,
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 15),

                        // PASSWORD
                        TextFormField(
                          controller: signUpController.password,
                          obscureText: true,
                          decoration: const InputDecoration(
                            label: Text("Password"),
                            prefixIcon: Icon(Icons.lock_outline),
                          ),
                          validator: (value) => value!.isEmpty ? 'Password is required' : null,
                        ),
                        const SizedBox(height: 15),

                        // ROLE DROPDOWN
                        Obx(() {
                          if (roleController.isLoading) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (roleController.state.value == RoleListState.error) {
                            return Text(
                              'Error loading roles: ${roleController.errorMessage.value}',
                              style: const TextStyle(color: Colors.red),
                            );
                          } else if (roleController.roles.isEmpty) {
                            return const Text('No roles available.', style: TextStyle(color: Colors.grey));
                          } else {
                            return DropdownButtonFormField<String>(
                              value: signUpController.selectedRoleId.value,
                              decoration: const InputDecoration(
                                labelText: "Select Role",
                                prefixIcon: Icon(Icons.work_outline),
                                border: OutlineInputBorder(),
                              ),
                              hint: const Text('Choose a role'),
                              items: roleController.roles.map((role) {
                                return DropdownMenuItem<String>(
                                  value: role.id,
                                  child: Text(role.name),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                signUpController.selectedRoleId.value = newValue;
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) return 'Please select a role';
                                return null;
                              },
                            );
                          }
                        }),
                        const SizedBox(height: 30),

                        // SIGN UP BUTTON
                        SizedBox(
                          width: double.infinity,
                          child: Obx(() => ElevatedButton(
                            onPressed: signUpController.isLoading.isTrue
                                ? null
                                : () async {
                              if (_formkey.currentState!.validate()) {
                                final result = await signUpController.registerUser();
                                if (result == true) {
                                  Get.snackbar(
                                    "Success",
                                    "Account created successfully!",
                                    snackPosition: SnackPosition.TOP,
                                    backgroundColor: Colors.green,
                                    colorText: Colors.white,
                                    margin: const EdgeInsets.all(12),
                                  );

                                  Future.delayed(const Duration(seconds: 1), () {
                                    Get.offAll(() => const LoginScreen());
                                  });
                                }
                              }
                            },
                            child: signUpController.isLoading.isTrue
                                ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 3))
                                : const Text("Sign Up"),
                          )),
                        ),

                        // Footer
                        Column(
                          children: [
                            const SizedBox(height: 10),
                            const Text("OR"),
                            const SizedBox(height: 10),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: () {},
                                icon: const Image(
                                  image: AssetImage(GoogleLogoImage),
                                  width: 20,
                                  height: 20,
                                ),
                                label: const Text("Sign Up with Google"),
                              ),
                            ),
                            TextButton(
                              onPressed: () => Get.to(() => const LoginScreen()),
                              child: const Text("Already have an account? Login"),
                            )
                          ],
                        ),

                      ],
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
