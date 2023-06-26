import 'package:dapp/otp_verification_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final phoneController = TextEditingController(text: "8439228724");
  final nameController = TextEditingController();
  final auth = FirebaseAuth.instance;
  RxBool isOtpSending = false.obs;

  void loginWithPhoneNumber() async {
    isOtpSending.value = true;
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: "+91${phoneController.text}",
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);
          isOtpSending.value = false;
          Get.to(() => OtpVerificationScreen(credential: credential));
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
        },
        codeSent: (String verificationId, int? resendToken) {
          isOtpSending.value = false;
          Get.to(() => OtpVerificationScreen(verificationId: verificationId));
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      print(e);
    }
  }
}
