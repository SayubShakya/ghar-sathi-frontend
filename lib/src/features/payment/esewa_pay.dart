import 'package:esewa_flutter/esewa_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


class EsewaApp extends StatefulWidget {
  const EsewaApp({super.key, required this.title});

  final String title;

  @override
  State<EsewaApp> createState() => _EsewaAppState();
}

class _EsewaAppState extends State<EsewaApp> {
  String data = '';
  String hasError = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.purple.shade50,
        foregroundColor: const Color(0xFF2C0B4D),
        centerTitle: true,
        title: Text(
          widget.title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet_outlined,
                      size: 32,
                      color: Color(0xFF1B5E20),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Pay with eSewa',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Secure and instant digital payment.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: EsewaPayButton(
                      /// Example Use case - 1
                      paymentConfig: ESewaConfig.dev(
                        amount: 10.0,
                        successUrl: 'https://developer.esewa.com.np/success',
                        failureUrl: 'https://developer.esewa.com.np/failure',
                        secretKey: '8gBm/:&EnhH.1/q',
                        // productCode: 'EPAYTEST', // optional for dev
                      ),
                      onFailure: (result) async {
                        setState(() {
                          data = '';
                          hasError = result;
                        });
                        if (kDebugMode) {
                          print(result);
                        }
                      },
                      onSuccess: (result) async {
                        setState(() {
                          hasError = '';
                          data = result.data!;
                        });
                        if (kDebugMode) {
                          print(result.toJson());
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            if (data.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Payment successful. Data: $data',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF1B5E20),
                  ),
                ),
              ),
            if (hasError.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Payment failed. Message: $hasError',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFFB00020),
                  ),
                ),
              ),
            const Spacer(),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}