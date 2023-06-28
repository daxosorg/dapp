import 'package:dapp/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    GetMaterialApp(
      // home: const HomeScreen(),
      home: LoginScreen(),
      // home: const OtpVerificationScreen(),
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
    ),
  );
}
