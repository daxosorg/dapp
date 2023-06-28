import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class HomeScreenController extends GetxController {
  final GeolocatorPlatform geolocator = GeolocatorPlatform.instance;
  Position? position;
  final nameController = TextEditingController();
  List<int> availableQuantities = [1, 2, 3];
  RxInt selectedQuantity = 1.obs;

  Stream<QuerySnapshot<Map<String, dynamic>>> getMyHangouts(String userId) async* {
    yield* FirebaseFirestore.instance.collection("chats").where('members', arrayContains: userId).snapshots();
  }

  void updateQuantity(int value) => selectedQuantity.value = value;

  void getCurrentLocation() async {
    try {
      LocationPermission permission = await geolocator.checkPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        permission = await geolocator.requestPermission();
      }
      if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
        position = await geolocator.getCurrentPosition();
        await FirebaseFirestore.instance.collection('locations').add({
          'latitude': position!.latitude,
          'longitude': position!.longitude,
          'timestamp': position!.timestamp,
        });
      }
    } on PlatformException catch (e) {
      print(e.message);
    }
  }
}
