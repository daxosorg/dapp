import 'dart:developer';

import 'package:dapp/constants/string_constants.dart';
import 'package:dapp/controllers/login_controller.dart';
import 'package:dapp/home_screen.dart';
import 'package:dapp/utils/extension_methods.dart';
import 'package:dapp/utils/login_status_helper.dart';
import 'package:dapp/utils/screen_loader_helper.dart';
import 'package:dapp/utils/user_data_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OtpVerificationScreenController extends GetxController {
  OtpVerificationScreenController({required this.verificationId, required this.credential});
  String? verificationId;
  PhoneAuthCredential? credential;
  final otpController = TextEditingController(text: "111111");
  final auth = FirebaseAuth.instance;

  void verifyOtp() async {
    try {
      ScreenLoaderHelper.showLoader(Get.context!);
      if (verificationId != null) {
        final credential = PhoneAuthProvider.credential(verificationId: verificationId!, smsCode: otpController.text);
        await auth.signInWithCredential(credential);
        ScreenLoaderHelper.hideLoader();
      } else if (credential != null) {
        await auth.signInWithCredential(credential!);
        ScreenLoaderHelper.hideLoader();
      }
      await UserDataHelper.setUserName(userName: Get.find<LoginController>().phoneController.text);
      Get.off(() => const HomeScreen());
      await LoginStatusHelper.setLoginStatus(isUserLoggedIn: true);
      UserDataHelper.setUserPhone(phoneNumber: Get.find<LoginController>().phoneController.text);
    } catch (e) {
      ScreenLoaderHelper.hideLoader();
      StringConstants.wrongOTP.showToast();
      log(e.toString());
    }
  }
}
