import 'package:dapp/constants/string_constants.dart';
import 'package:dapp/controllers/home_screen_controller.dart';
import 'package:dapp/models/seller_model.dart';
import 'package:dapp/utils/extension_methods.dart';
import 'package:dapp/utils/login_status_helper.dart';
import 'package:dapp/utils/screen_loader_helper.dart';
import 'package:dapp/views/login_screen.dart';
import 'package:dapp/views/order_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  final homeScreenController = Get.put(HomeScreenController());

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          height: Get.size.height,
          child: Stack(
            children: [
              Form(
                key: homeScreenController.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    Image.asset('assets/water_jar_image.png'),
                    const Spacer(),
                    const SizedBox(height: 24.0),
                    Row(
                      children: [
                        Expanded(
                          child: FutureBuilder<List<SellerModel>>(
                            future: homeScreenController.fetchSellers(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const SizedBox.shrink();
                              } else if (snapshot.hasError) {
                                return const Text('Error fetching sellers');
                              } else if (snapshot.hasData) {
                                return Container(
                                  height: 56.0,
                                  padding: const EdgeInsets.symmetric(horizontal: 14),
                                  decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(8.0)),
                                  child: DropdownButtonHideUnderline(
                                    child: Obx(
                                      () => DropdownButton<SellerModel>(
                                        value: homeScreenController.selectedSeller.value,
                                        onChanged: (newValue) => homeScreenController.selectedSeller.value = newValue!,
                                        items: snapshot.data!.map((seller) {
                                          return DropdownMenuItem(value: seller, child: Text(seller.name));
                                        }).toList(),
                                        icon: const Icon(Icons.arrow_drop_down, color: Colors.blue),
                                        hint: const Text("Select a seller"),
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                return const CircularProgressIndicator();
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 16.0), // Add some spacing between the fields
                        Expanded(
                          child: Container(
                            height: 56.0,
                            decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(8.0)),
                            alignment: Alignment.center,
                            child: DropdownButtonHideUnderline(
                              child: Obx(
                                () => DropdownButton<int>(
                                  value: homeScreenController.selectedQuantity.value,
                                  onChanged: (newValue) => homeScreenController.selectedQuantity.value = newValue!,
                                  icon: const Icon(Icons.arrow_drop_down, color: Colors.blue),
                                  hint: const Text('Select Quantity'),
                                  iconSize: 24,
                                  elevation: 16,
                                  items: homeScreenController.availableQuantities.map((int value) {
                                    return DropdownMenuItem(value: value, child: Text(value.toString()));
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24.0),
                    TextFormField(
                      controller: homeScreenController.nameController,
                      keyboardType: TextInputType.name,
                      style: const TextStyle(color: Colors.black),
                      decoration: const InputDecoration(
                        labelText: AppStrings.enterYourName,
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person, color: Colors.blue),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24.0),
                    TextFormField(
                      controller: homeScreenController.deliveryAddressController,
                      keyboardType: TextInputType.multiline,
                      style: const TextStyle(color: Colors.black),
                      maxLines: null,
                      decoration: const InputDecoration(
                        labelText: AppStrings.enterDeliveryAddress,
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.home, color: Colors.blue),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your delivery address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 48),
                    ElevatedButton(
                      onPressed: () {
                        if (homeScreenController.formKey.currentState!.validate()) {
                          if (homeScreenController.selectedSeller.value.name == "Select a seller") {
                            "Please select a seller".showToast();
                          } else {
                            homeScreenController.placeOrder();
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Text(
                          AppStrings.orderNow,
                          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 32,
                left: 10,
                child: InkWell(
                  onTap: () async {
                    Get.to(() => OrderDetailsScreen());
                  },
                  child: const Text(
                    "Order List",
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                ),
              ),
              Positioned(
                top: 32,
                right: 10,
                child: InkWell(
                  onTap: () async {
                    ScreenLoaderHelper.showLoader(context);
                    await FirebaseAuth.instance.signOut();
                    await LoginStatusHelper.setLoginStatus(isUserLoggedIn: false);
                    ScreenLoaderHelper.hideLoader();
                    Get.offAll(() => LoginScreen());
                  },
                  child: const Text(
                    "Logout",
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
