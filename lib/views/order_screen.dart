import 'package:dapp/controllers/order_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderDetailsScreen extends StatelessWidget {
  OrderDetailsScreen({super.key});

  OrdersScreenController ordersScreenController = Get.put(OrdersScreenController(), permanent: true);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
      ),
      body: ListView.builder(
        itemCount: ordersScreenController.orders.length,
        itemBuilder: (context, index) {
          final OrderModel = ordersScreenController.orders[index];
          return ListTile(
            title: Text(OrderModel.orderId),
            subtitle: Text(OrderModel.sellerName),
            onTap: () => ordersScreenController.showOrderDetails(OrderModel),
          );
        },
      ),
    );
  }
}
