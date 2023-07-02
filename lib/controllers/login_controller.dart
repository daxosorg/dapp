import 'dart:developer';

import 'package:dapp/otp_verification_screen.dart';
import 'package:dapp/utils/screen_loader_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final phoneController = TextEditingController(text: "8439228724");

  final firebaseAuth = FirebaseAuth.instance;

  void loginWithPhoneNumber() async {
    ScreenLoaderHelper.showLoader(Get.context!);
    try {
      await firebaseAuth.verifyPhoneNumber(
        phoneNumber: "+91${phoneController.text}",
        verificationCompleted: (PhoneAuthCredential credential) async {
          await firebaseAuth.signInWithCredential(credential).then((value) async {
            Get.to(() => OtpVerificationScreen(credential: credential));
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          ScreenLoaderHelper.hideLoader();
          log(e.message.toString());
        },
        codeSent: (String verificationId, int? resendToken) {
          ScreenLoaderHelper.hideLoader();
          Get.to(() => OtpVerificationScreen(verificationId: verificationId));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          ScreenLoaderHelper.hideLoader();
        },
      );
    } catch (e) {
      log(e.toString());
    }
  }
}
