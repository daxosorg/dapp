import 'package:flutter/material.dart';
import 'package:get/get.dart';

extension StringToastExtension on String {
  void showToast() {
    Get.snackbar(
      'Oops',
      this,
      backgroundColor: Colors.black54,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }
}
