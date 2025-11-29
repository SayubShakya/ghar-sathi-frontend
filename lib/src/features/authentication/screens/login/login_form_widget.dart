import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loginappv2/src/features/authentication/controllers/login_controller.dart';


class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  late final LoginController _controller;

  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  final RxBool _obscurePassword = true.obs;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(LoginController());
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextFormField(
            controller: emailController,
            decoration: const InputDecoration(
              labelText: "E-Mail",
              prefixIcon: Icon(Icons.person_2_outlined),
            ),
          ),
          const SizedBox(height: 20),
          Obx(() => TextFormField(
            controller: passwordController,
            obscureText: _obscurePassword.value,
            decoration: InputDecoration(
              labelText: "Password",
              prefixIcon: const Icon(Icons.password_outlined),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword.value
                      ? Icons.visibility_off
                      : Icons.visibility,
                ),
                onPressed: () => _obscurePassword.value = !_obscurePassword.value,
              ),
            ),
          )),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                final email = emailController.text.trim();
                final password = passwordController.text.trim();

                if (email.isEmpty || password.isEmpty) {
                  Get.snackbar("Error", "Please enter email and password");
                  return;
                }

                _controller.loginUser(email, password);
              },
              child: const Text("LOGIN"),
            ),
          ),
        ],
      ),
    );
  }
}
