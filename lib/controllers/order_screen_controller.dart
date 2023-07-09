import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dapp/constants/firebase_storage_keys.dart';
import 'package:dapp/models/order_model.dart';
import 'package:dapp/utils/user_data_helper.dart';
import 'package:dapp/views/order_screen.dart';
import 'package:get/get.dart';

class OrdersScreenController extends GetxController {
  final RxList<OrderModel> orders = <OrderModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    CollectionReference allOrdersCollection = FirebaseFirestore.instance.collection(FirebaseStorageKeys.orders);
    QuerySnapshot querySnapshot = await allOrdersCollection.where("buyerId", isEqualTo: UserDataHelper.getUserId()).get();
    List<QueryDocumentSnapshot> orderDocuments = querySnapshot.docs;

    for (QueryDocumentSnapshot orderDocument in orderDocuments) {
      orders.add(OrderModel.fromJson(orderDocument.data() as Map<String, dynamic>));
    }
    orders.map((element) {
      log(element.toString());
    });
  }

  void showOrderDetails(OrderModel OrderModel) {
    Get.to(() => OrderDetailsScreen());
  }
}
