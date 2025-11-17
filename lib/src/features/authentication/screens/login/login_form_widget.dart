import 'package:flutter/material.dart';
import 'package:loginappv2/src/constants/text_strings.dart';
import 'package:get/get.dart';
import 'package:loginappv2/src/features/authentication/screens/forget_password/forget_password_screen.dart';
import 'package:loginappv2/src/features/user_dashboard/screens/main_dashboard_screen.dart';


class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Container(
        //margin: const EdgeInsets.symmetric(vertical:20.0),
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person_2_outlined),
                labelText: "E-Mail",
                hintText: "E-Mail",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.password_outlined),
                labelText: "Password",
                hintText: "Password",
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.remove_red_eye_outlined),
                ),
              ),
            ),
            const SizedBox(height: 5),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => Container(
                      padding: const EdgeInsets.all(30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ForgetPasswordTitle,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          Text(
                            ForgetPasswordSubTitle,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 20),
                          GestureDetector(
                            onTap: ()=>Get.to(() => ForgetPasswordScreen()),
                            child: Container(
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.grey.shade200,
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.email_outlined, size: 30),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "E-Mail",
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyMedium,
                                      ),
                                      Text(
                                        "Reset Via Email",
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyMedium,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: Text("Forget Password?"),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: ()=> Get.to(() => UserDashboard()), child: Text("LOGIN")),
            ),
          ],
        ),
      ),
    );
  }
}
