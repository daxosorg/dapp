import 'package:dapp/constants/string_constants.dart';
import 'package:dapp/controllers/home_screen_controller.dart';
import 'package:dapp/utils/login_status_helper.dart';
import 'package:dapp/utils/screen_loader_helper.dart';
import 'package:dapp/views/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  final controller = Get.put(HomeScreenController());
  final _formKey = GlobalKey<FormState>();

  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          height: Get.size.height,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  InkWell(
                    onTap: () async {
                      ScreenLoaderHelper.showLoader(context);
                      await FirebaseAuth.instance.signOut();
                      await LoginStatusHelper.setLoginStatus(isUserLoggedIn: false);
                      ScreenLoaderHelper.hideLoader();
                      Get.offAll(() => LoginScreen());
                    },
                    child: Image.asset('assets/water_jar_image.png'),
                  ),
                  const Spacer(),
                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const SizedBox.shrink(),
                        const Text("Qty:", style: TextStyle(fontSize: 20)),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                          decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(8.0)),
                          child: DropdownButton<int>(
                            value: controller.selectedQuantity.value,
                            onChanged: (newValue) => controller.selectedQuantity.value = newValue!,
                            iconSize: 0,
                            items: controller.availableQuantities.map((int value) {
                              return DropdownMenuItem(value: value, child: Text(value.toString(), style: const TextStyle(fontSize: 24)));
                            }).toList(),
                          ),
                        ),
                        const SizedBox.shrink(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  TextFormField(
                    controller: controller.nameController,
                    keyboardType: TextInputType.name,
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                      labelText: StringConstants.enterYourName,
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person, color: Colors.blue),
                    ),
                    validator: (value) => value?.isEmpty ?? true ? 'Please enter your name' : null,
                  ),
                  const SizedBox(height: 24.0),
                  TextFormField(
                    controller: controller.deliveryAddressController,
                    keyboardType: TextInputType.multiline,
                    style: const TextStyle(color: Colors.black),
                    maxLines: null,
                    decoration: const InputDecoration(
                      labelText: StringConstants.enterDeliveryAddress,
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.home, color: Colors.blue),
                    ),
                    validator: (value) => value?.isEmpty ?? true ? 'Please enter your delivery address' : null,
                  ),
                  const SizedBox(height: 48),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        controller.placeOrder();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(
                        StringConstants.orderNow,
                        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 16,
                right: 16,
                child: IconButton(
                  onPressed: () async {
                    ScreenLoaderHelper.showLoader(context);
                    await FirebaseAuth.instance.signOut();
                    await LoginStatusHelper.setLoginStatus(isUserLoggedIn: false);
                    ScreenLoaderHelper.hideLoader();
                    Get.offAll(() => LoginScreen());
                  },
                  icon: const Icon(Icons.logout, color: Colors.blue, size: 32),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
