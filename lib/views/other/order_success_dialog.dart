import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderSuccessDialog extends StatelessWidget {
  const OrderSuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_outline, size: 72, color: Colors.green),
            const SizedBox(height: 16.0),
            const Text('Hooray! Your Order is Confirmed!', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            const SizedBox(height: 16.0),
            const Text('Thank you for choosing our services. Your order has been successfully placed.',
                style: TextStyle(fontSize: 16.0), textAlign: TextAlign.center),
            const SizedBox(height: 24.0),
            ElevatedButton(child: const Text('Continue Shopping'), onPressed: () => Get.back()),
          ],
        ),
      ),
    );
  }
}
