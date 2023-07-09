import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dapp/constants/firebase_storage_keys.dart';
import 'package:dapp/models/buyer_model.dart';
import 'package:dapp/models/order_model.dart';
import 'package:dapp/models/seller_model.dart';
import 'package:dapp/utils/enums.dart';
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

  Rx<SellerModel> selectedSeller = SellerModel(address: " ", name: "Select a seller", userId: " ", userLat: 0.0, userLng: 0.0).obs;

  List<SellerModel> sellers = [];
  Future<List<SellerModel>> fetchSellers() async {
    final QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection(FirebaseStorageKeys.sellers).where("userId", isNotEqualTo: UserDataHelper.getUserId()).get();
    sellers = snapshot.docs.map((doc) => SellerModel.fromJson(doc.data())).toList();
    sellers.insert(0, selectedSeller.value);
    return sellers;
  }

  Future<void> placeOrder() async {
    ScreenLoaderHelper.showLoader(Get.context!);
    try {
      await createAndSaveLatestBuyerData();
      await saveOrderDataToDB();
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
    BuyerModel buyerData = BuyerModel(
      address: deliveryAddressController.text,
      name: userName,
      userId: UserDataHelper.getUserId() ?? "",
      userLat: position.latitude,
      userLng: position.longitude,
    );
    return buyerData.toJson();
  }

  Future<void> saveOrderDataToDB() async {
    String sellerId = selectedSeller.value.userId;
    String buyerId = UserDataHelper.getUserId()!;
    final docRef = FirebaseFirestore.instance.collection(FirebaseStorageKeys.orders).doc();
    OrderModel orderModel = OrderModel(
      orderTime: DateTime.now().toString(),
      orderId: docRef.id,
      quantity: selectedQuantity.value,
      status: OrderStatus.pending.toText(),
      sellerId: sellerId,
      buyerId: "1234567890",
    );
    await docRef.set(orderModel.toJson());
  }

  Future<void> saveBuyerDataToDB({required Map<String, dynamic> dataToBeSaved}) async {
    await FirebaseFirestore.instance.collection(FirebaseStorageKeys.buyers).doc(UserDataHelper.getUserPhone()).set(dataToBeSaved);
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
