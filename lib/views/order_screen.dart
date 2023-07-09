import 'package:dapp/controllers/order_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderDetailsScreen extends StatelessWidget {
  OrderDetailsScreen({super.key});

  OrdersScreenController ordersScreenController = Get.put(OrdersScreenController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Orders')),
      body: Obx(
        () => ListView.builder(
          itemCount: ordersScreenController.orders.length,
          itemBuilder: (context, index) {
            final orderData = ordersScreenController.orders[index];
            return ListTile(
              title: Text(orderData.buyerId),
              subtitle: Text(orderData.sellerId),
            );
          },
        ),
      ),
    );
  }
}
