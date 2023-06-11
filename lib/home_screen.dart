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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
              const SizedBox(height: 32),
              Center(
                child: Obx(
                  () => Column(
                    children: [
                      const Text("How may bottle you need:", style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 10),
                      DropdownButton<int>(
                        value: homeScreenController.selectedQuantity.value,
                        onChanged: (newValue) => homeScreenController.selectedQuantity.value = newValue!,
                        items: homeScreenController.availableQuantities.map((int value) {
                          return DropdownMenuItem(value: value, child: Text(value.toString(), style: const TextStyle(fontSize: 24)));
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Text('Place order', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
