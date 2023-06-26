import 'package:dapp/constants/string_constants.dart';
import 'package:dapp/controllers/home_screen_controller.dart';
import 'package:flutter/material.dart';
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
      appBar: AppBar(
        title: const Text('Home'),
      ),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Image.asset('assets/water_jar_image.png'),
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 32),
                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text("Bottles you need:", style: TextStyle(fontSize: 20)),
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
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: homeScreenController.nameController,
                    keyboardType: TextInputType.phone,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      labelText: StringConstants.enterYourName,
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.person, color: Colors.blue),
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0))),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Text('Order Now', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
