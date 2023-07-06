class Seller {
  final String address;
  final String name;
  final String userId;
  final double userLat;
  final double userLng;

  Seller({
    required this.address,
    required this.name,
    required this.userId,
    required this.userLat,
    required this.userLng,
  });

  factory Seller.fromJson(Map<String, dynamic> json) {
    return Seller(
      address: json['address'],
      name: json['name'],
      userId: json['userId'],
      userLat: json['userLat'].toDouble(),
      userLng: json['userLng'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'name': name,
      'userId': userId,
      'userLat': userLat,
      'userLng': userLng,
    };
  }
}
