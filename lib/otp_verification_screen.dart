import 'package:dapp/controllers/otp_verfication_screen_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OtpVerificationScreen extends StatelessWidget {
  const OtpVerificationScreen({Key? key, this.verificationId, this.credential}) : super(key: key);

  final String? verificationId;
  final PhoneAuthCredential? credential;

  @override
  Widget build(BuildContext context) {
    final otpVerificationScreenController = Get.put(
      OtpVerificationScreenController(
        verificationId: verificationId,
        credential: credential,
      ),
    );

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          height: Get.size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Image.asset('assets/water_jar_image.png'),
              const Spacer(),
              TextFormField(
                controller: otpVerificationScreenController.otpController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Enter OTP sent to your phone',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock_outline),
                ),
              ),
              const SizedBox(height: 48),
              Obx(
                () => otpVerificationScreenController.isVerifyingOtp.value
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ElevatedButton(
                        onPressed: otpVerificationScreenController.verifyOtp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Text('Verify', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white)),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
