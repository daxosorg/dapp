import 'dart:developer';

import 'package:dapp/constants/string_constants.dart';
import 'package:dapp/controllers/home_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final homeScreenController = Get.put(HomeScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          height: Get.size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Image.asset('assets/water_jar_image.png'),
              const Spacer(),
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox.shrink(),
                    const Text("Qty:", style: TextStyle(fontSize: 20)),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey), // Border color
                        borderRadius: BorderRadius.circular(8.0), // Border radius
                      ),
                      child: DropdownButton<int>(
                        value: homeScreenController.selectedQuantity.value,
                        onChanged: (newValue) => homeScreenController.selectedQuantity.value = newValue!,
                        iconSize: 0,
                        items: homeScreenController.availableQuantities.map((int value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(value.toString(), style: const TextStyle(fontSize: 24)),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox.shrink(),
                  ],
                ),
              ),
              const SizedBox(height: 24.0),
              TextFormField(
                controller: homeScreenController.nameController,
                keyboardType: TextInputType.multiline,
                style: const TextStyle(color: Colors.black),
                maxLines: null,
                decoration: const InputDecoration(
                  labelText: StringConstants.enterDeliveryAddress,
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.home, color: Colors.blue),
                ),
              ),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: () {
                  printCurrentAddress();
                },
                style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0))),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(StringConstants.orderNow, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> printCurrentAddress() async {
  // Get the latitude and longitude.
  double latitude = 27.16052271653263;
  double longitude = 78.37959755186323;

  // Get the list of Placemark objects.
  List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);

  // Iterate through the Placemark objects and get the full address.
  for (Placemark placemark in placemarks) {
    String address = "${placemark.street}, ${placemark.locality}, ${placemark.postalCode}, ${placemark.country}";
    log(address);
  }
}
