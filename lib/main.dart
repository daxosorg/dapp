import 'package:dapp/views/home_screen.dart';
import 'package:dapp/views/login_screen.dart';
import 'package:dapp/utils/login_status_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  runApp(
    GetMaterialApp(
      home: LoginStatusHelper.isUserLoggedIn() ?  HomeScreen() : LoginScreen(),
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
    ),
  );
}
