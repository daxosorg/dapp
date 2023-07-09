// To parse this JSON data, do
//
//     final orderModel = orderModelFromJson(jsonString);

import 'dart:convert';

OrderModel orderModelFromJson(String str) => OrderModel.fromJson(json.decode(str));

String orderModelToJson(OrderModel data) => json.encode(data.toJson());

class OrderModel {
  String orderTime;
  String orderId;
  int quantity;
  String status;
  String sellerId;
  String buyerId;

  OrderModel({
    required this.orderTime,
    required this.orderId,
    required this.quantity,
    required this.status,
    required this.sellerId,
    required this.buyerId,
  });

  OrderModel copyWith({
    String? orderTime,
    String? orderId,
    int? quantity,
    String? status,
    String? sellerId,
    String? buyerId,
  }) =>
      OrderModel(
        orderTime: orderTime ?? this.orderTime,
        orderId: orderId ?? this.orderId,
        quantity: quantity ?? this.quantity,
        status: status ?? this.status,
        sellerId: sellerId ?? this.sellerId,
        buyerId: buyerId ?? this.buyerId,
      );

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        orderTime: json["orderTime"],
        orderId: json["orderId"],
        quantity: json["quantity"],
        status: json["status"],
        sellerId: json["sellerId"],
        buyerId: json["buyerId"],
      );

  Map<String, dynamic> toJson() => {
        "orderTime": orderTime,
        "orderId": orderId,
        "quantity": quantity,
        "status": status,
        "sellerId": sellerId,
        "buyerId": buyerId,
      };
}
