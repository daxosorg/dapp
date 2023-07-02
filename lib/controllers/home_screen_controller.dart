import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dapp/constants/string_constants.dart';
import 'package:dapp/controllers/login_controller.dart';
import 'package:dapp/utils/extension_methods.dart';
import 'package:dapp/utils/location_helper.dart';
import 'package:dapp/utils/screen_loader_helper.dart';
import 'package:dapp/utils/user_data_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class HomeScreenController extends GetxController {
  final GeolocatorPlatform geolocator = GeolocatorPlatform.instance;
  Position? position;
  final nameController = TextEditingController(text: UserDataHelper.getUserName());
  final deliveryAddressController = TextEditingController(text: UserDataHelper.getUserAddress());
  List<int> availableQuantities = [1, 2, 3];
  RxInt selectedQuantity = 1.obs;

  void updateQuantity(int value) => selectedQuantity.value = value;

  Future<void> printCurrentAddress({required Position position}) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    for (Placemark placemark in placemarks) {
      String address = "${placemark.street}, ${placemark.locality}, ${placemark.postalCode}, ${placemark.country}";
      log(address);
    }
  }

  Future<void> placeOrder() async {
    ScreenLoaderHelper.showLoader(Get.context!);
    try {
      await createAndSaveLatestBuyerData();
      await saveOrderToDB();
      ScreenLoaderHelper.hideLoader();
      showOrderPlacedDialog();
    } on Exception catch (e) {
      ScreenLoaderHelper.hideLoader();
      e.toString().showToast();
      log(e.toString());
    }
  }

  Future<void> createAndSaveLatestBuyerData() async {
    Map<String, dynamic> buyerData = await createBuyerData();
    await saveBuyerDataToDB(dataToBeSaved: buyerData);
    await saveBuyerDataLocally();
  }

  Future<Map<String, dynamic>> createBuyerData() async {
    Position position = await LocationHelper.getPosition();
    String userName = UserDataHelper.getUserName() ?? nameController.text;
    return {
      "name": userName,
      "address": deliveryAddressController.text,
      "userLat": position.latitude,
      "userLng": position.longitude,
    };
  }

  Future<void> saveOrderToDB() async {
    String sellerUserId = "7983457308";
    String buyerUserId = Get.find<LoginController>().phoneController.text;
    List<String> userIDs = [sellerUserId, buyerUserId];
    userIDs.sort();
    String collectionName = "${userIDs[0]}_${userIDs[0]}";
    final docRef = FirebaseFirestore.instance.collection(StringConstants.allOrders).doc(collectionName).collection(StringConstants.orders).doc();
    await docRef.set({
      "orderTime": "06:30PM",
      "orderid": docRef.id,
      "quantity": selectedQuantity.value,
      "status": "Pending",
    });
  }

  Future<void> saveBuyerDataToDB({required Map<String, dynamic> dataToBeSaved}) async {
    await FirebaseFirestore.instance.collection(StringConstants.buyers).doc(Get.find<LoginController>().phoneController.text).set(dataToBeSaved);
  }

  Future<void> saveBuyerDataLocally() async {
    await UserDataHelper.setUserName(userName: nameController.text);
    await UserDataHelper.setUserAddress(userAddress: deliveryAddressController.text);
  }

  void showOrderPlacedDialog() {
    showDialog(
      context: Get.context!,
      builder: (context) => const Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.done_all_rounded, size: 60, color: Colors.green),
            SizedBox(height: 10),
            Text('Success', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
          ],
        ),
      ),
    );
  }

  /// Checks If Document Exists
  Future<bool> checkIfDocExists({required String docId}) async {
    try {
      var collectionRef = FirebaseFirestore.instance.collection('collectionName');
      var doc = await collectionRef.doc(docId).get();
      return doc.exists;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  void getCurrentLocation() async {
    try {
      //
      await Geolocator.getCurrentPosition(forceAndroidLocationManager: true, desiredAccuracy: LocationAccuracy.best).then((value) async {
        await FirebaseFirestore.instance.collection('buyers').doc('text').set({
          "name": "karan",
          "userLat": value.latitude,
          "userLng": value.longitude,
        }).then((value) {
          ScreenLoaderHelper.hideLoader();
          // Get.to(() => OtpVerificationScreen(credential: credential));
        });
      });
      //
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
      log(e.message.toString());
    }
  }
}
