import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Needed for input formatters
import 'package:get/get.dart';
import 'package:loginappv2/src/features/authentication/controllers/verification_code_controller.dart';


class VerificationCodeScreen extends StatelessWidget {
  const VerificationCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VerificationCodeController());
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth * 0.08;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 120),

                // --- Large 'CODE' Text ---
                const Text(
                  'CO',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                    height: 1.0, // Reduce line spacing
                  ),
                ),
                const Text(
                  'DE',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                    height: 1.0, // Reduce line spacing
                  ),
                ),

                // --- Small 'VERIFICATION' Text ---
                const SizedBox(height: 10),
                const Text(
                  'VERIFICATION',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: Colors.black,
                  ),
                ),

                // --- Instruction Text ---
                const SizedBox(height: 40),
                Text(
                  'Enter the verification code sent at\n${controller.email}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF555555),
                  ),
                ),

                const SizedBox(height: 40),

                // --- OTP Input Fields ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(6, (index) {
                    return _buildOtpField(
                      context,
                      controller.codeControllers[index],
                          (value) => controller.moveToNextField(value, index, context),
                    );
                  }),
                ),

                const SizedBox(height: 40),

                // --- Next Button ---
                SizedBox(
                  height: 60,
                  child: ElevatedButton(
                    onPressed: controller.handleNext,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 18.0),
                    ),
                    child: const Text(
                      'Next',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build a single OTP input box
  Widget _buildOtpField(
      BuildContext context,
      TextEditingController controller,
      ValueChanged<String> onChanged,
      ) {
    // Calculate size based on screen width to ensure responsiveness
    final size = MediaQuery.of(context).size.width / 8;

    return SizedBox(
      width: size,
      height: 60,
      child: TextFormField(
        controller: controller,
        onChanged: onChanged,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1), // Allow only 1 character
          FilteringTextInputFormatter.digitsOnly, // Allow only digits
        ],
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey.shade100, // Light gray background for the boxes
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none, // Remove standard border
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Colors.black, width: 2.0), // Black border when focused
          ),
        ),
      ),
    );
  }
}