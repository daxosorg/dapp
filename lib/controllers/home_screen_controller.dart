import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dapp/constants/string_constants.dart';
import 'package:dapp/models/seller.dart';
import 'package:dapp/utils/extension_methods.dart';
import 'package:dapp/utils/location_helper.dart';
import 'package:dapp/utils/screen_loader_helper.dart';
import 'package:dapp/utils/user_data_helper.dart';
import 'package:dapp/views/other/order_success_dialog.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class HomeScreenController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
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

  Rx<Seller> selectedSeller = Seller(address: " ", name: "Select a seller", userId: " ", userLat: 0.0, userLng: 0.0).obs;

  List<Seller> sellers = [];
  Future<List<Seller>> fetchSellers() async {
    final QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance.collection('sellers').get();
    sellers = snapshot.docs.map((doc) => Seller.fromJson(doc.data())).toList();
    sellers.insert(0, selectedSeller.value);
    return sellers;
  }

  Future<void> placeOrder() async {
    ScreenLoaderHelper.showLoader(Get.context!);
    try {
      await createAndSaveLatestBuyerData();
      await saveOrderToDB();
      ScreenLoaderHelper.hideLoader();
      // showOrderPlacedDialog();
      showOrderSuccessDialog();
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
    String sellerUserId = sellers.firstWhere((element) => element.name == selectedSeller.value.name).userId;
    String buyerUserId = UserDataHelper.getUserId()!;
    List<String> userIDs = [sellerUserId, buyerUserId];
    userIDs.sort();
    String collectionName = "${userIDs[0]}_${userIDs[1]}";
    final docRef = FirebaseFirestore.instance.collection(StringConstants.allOrders).doc(collectionName).collection(StringConstants.orders).doc();
    await docRef.set({
      "orderTime": DateTime.now().toString(),
      "orderid": docRef.id,
      "quantity": selectedQuantity.value,
      "status": "Pending",
    });
  }

  Future<void> saveBuyerDataToDB({required Map<String, dynamic> dataToBeSaved}) async {
    await FirebaseFirestore.instance.collection(StringConstants.buyers).doc(UserDataHelper.getUserPhone()).set(dataToBeSaved);
  }

  Future<void> saveBuyerDataLocally() async {
    await UserDataHelper.setUserName(userName: nameController.text);
    await UserDataHelper.setUserAddress(userAddress: deliveryAddressController.text);
  }

  void showOrderSuccessDialog() => showDialog(context: Get.context!, builder: (BuildContext context) => const OrderSuccessDialog());

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
}
