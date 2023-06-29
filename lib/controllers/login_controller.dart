import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dapp/otp_verification_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final phoneController = TextEditingController(text: "8439228724");
  final nameController = TextEditingController();
  final firebaseAuth = FirebaseAuth.instance;
  RxBool isOtpSending = false.obs;

  void loginWithPhoneNumber() async {
    isOtpSending.value = true;
    try {
      await firebaseAuth.verifyPhoneNumber(
        phoneNumber: "+91${phoneController.text}",
        verificationCompleted: (PhoneAuthCredential credential) async {
          await firebaseAuth.signInWithCredential(credential).then((value) async {
            await Geolocator.getCurrentPosition(forceAndroidLocationManager: true, desiredAccuracy: LocationAccuracy.best).then((value) async {
              await FirebaseFirestore.instance.collection('buyers').doc(phoneController.text).set({
                "name": "karan",
                "userLat": value.latitude,
                "userLng": value.longitude,
              }).then((value) {
                isOtpSending.value = false;
                Get.to(() => OtpVerificationScreen(credential: credential));
              });
            });
          });
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

  Future<void> verifyPhoneNumber() async {
    await firebaseAuth.verifyPhoneNumber(
      phoneNumber: "+91${phoneController.text}",
      verificationCompleted: (PhoneAuthCredential credential) async {
        await firebaseAuth.signInWithCredential(credential);
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
  }
}
