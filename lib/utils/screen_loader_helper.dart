import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScreenLoaderHelper {
  static void showLoader(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(onWillPop: () async => false, child: const Center(child: CircularProgressIndicator())),
    );
  }

  static void hideLoader() => Get.back();
}
