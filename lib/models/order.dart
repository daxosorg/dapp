class OrderModel {
  final String orderId;
  final String sellerName;
  final String buyerName;
  final int quantity;
  final String status;

  OrderModel({
    required this.orderId,
    required this.sellerName,
    required this.buyerName,
    required this.quantity,
    required this.status,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderId: json['orderId'],
      sellerName: json['sellerName'],
      buyerName: json['buyerName'],
      quantity: json['quantity'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'sellerName': sellerName,
      'buyerName': buyerName,
      'quantity': quantity,
      'status': status,
    };
  }
}
