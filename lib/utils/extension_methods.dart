import 'package:dapp/utils/enums.dart';
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

extension OrderStatusToText on OrderStatus {
  String toText() => toString().split('.').last;
}
