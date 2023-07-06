import 'package:dapp/constants/string_constants.dart';
import 'package:dapp/controllers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  final loginController = Get.put(LoginController());
  final _formKey = GlobalKey<FormState>();

  LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          height: Get.size.height,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(),
                const Icon(Icons.phone_android_rounded, size: 200, color: Colors.blue),
                // Image.asset('assets/water_jar_image.png'),
                const Spacer(),
                TextFormField(
                  controller: loginController.phoneController,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    labelText: StringConstants.enterYourPhoneNumber,
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone, color: Colors.blue),
                  ),
                  validator: (value) => value?.isEmpty ?? true ? 'Please enter your phone number' : null,
                ),
                const SizedBox(height: 48),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      loginController.loginWithPhoneNumber();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      'Continue',
                      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
