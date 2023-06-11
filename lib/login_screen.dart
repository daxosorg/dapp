import 'package:dapp/controllers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  final loginController = Get.put(LoginController());

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phone Login'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 32.0),
            Text('Enter your phone number', style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center),
            const SizedBox(height: 32.0),
            TextFormField(
              controller: loginController.phoneController,
              keyboardType: TextInputType.phone,
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(
                labelText: 'Enter your phone number',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone, color: Colors.blue),
              ),
            ),
            const SizedBox(height: 16),
            Obx(
              () => loginController.isOtpSending.value
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: () => loginController.loginWithPhoneNumber(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Text('Send OTP', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
