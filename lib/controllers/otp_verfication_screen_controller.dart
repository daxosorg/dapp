import 'package:dapp/constants/string_constants.dart';
import 'package:dapp/home_screen.dart';
import 'package:dapp/utils/extension_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OtpVerificationScreenController extends GetxController {
  OtpVerificationScreenController({required this.verificationId, required this.credential});
  String? verificationId;
  PhoneAuthCredential? credential;
  final otpController = TextEditingController(text: "111111");
  final auth = FirebaseAuth.instance;
  RxBool isVerifyingOtp = false.obs;

  void verifyOtp() async {
    try {
      isVerifyingOtp.value = true;
      if (verificationId != null) {
        final credential = PhoneAuthProvider.credential(
          verificationId: verificationId!,
          smsCode: otpController.text,
        );
        await auth.signInWithCredential(credential);
        isVerifyingOtp.value = false;
      } else if (credential != null) {
        await auth.signInWithCredential(credential!);
        isVerifyingOtp.value = false;
      }

      Get.to(() => const HomeScreen());
    } catch (e) {
      isVerifyingOtp.value = false;
      StringConstants.wrongOTP.showToast();
      print(e);
    }
  }
}
