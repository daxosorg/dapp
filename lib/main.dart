import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'otp_verification_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    GetMaterialApp(
      // home: const HomeScreen(),
      home: const OtpVerificationScreen(),
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
    ),
  );
}
