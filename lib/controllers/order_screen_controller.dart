import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dapp/constants/string_constants.dart';
import 'package:dapp/models/order.dart';
import 'package:dapp/utils/extension_methods.dart';
import 'package:dapp/utils/screen_loader_helper.dart';
import 'package:dapp/views/order_screen.dart';
import 'package:get/get.dart';

class OrdersScreenController extends GetxController {
  final List<OrderModel> orders = [];

  Future<void> fetchOrders() async {
    ScreenLoaderHelper.showLoader(Get.context!);
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance.collection(StringConstants.allOrders).get();
      var orders = snapshot.docs.map((doc) => OrderModel.fromJson(doc.data())).toList();
      ScreenLoaderHelper.hideLoader();
    } on Exception catch (e) {
      ScreenLoaderHelper.hideLoader();
      e.toString().showToast();
      log(e.toString());
    }
  }

  void showOrderDetails(OrderModel OrderModel) {
    Get.to(() => OrderDetailsScreen());
  }
}
