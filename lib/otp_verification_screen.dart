// A screen for verifying otp received from firebase
import 'package:dapp/dashboard_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String? verificationId;
  final PhoneAuthCredential? credential;

  const OtpVerificationScreen({Key? key, this.verificationId, this.credential}) : super(key: key);

  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _otpController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  void _verifyOtp() async {
    try {
      if (widget.verificationId != null) {
        // Create a PhoneAuthCredential with the code
        final credential = PhoneAuthProvider.credential(
          verificationId: widget.verificationId!,
          smsCode: _otpController.text,
        );
        // Sign in with the credential
        await _auth.signInWithCredential(credential);
      } else if (widget.credential != null) {
        // Sign in with the auto verified credential
        await _auth.signInWithCredential(widget.credential!);
      }
      // Navigate to dashboard screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const DashboardScreen(),
        ),
      );
    } catch (e) {
// Handle errors
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP Verification'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _otpController,
              decoration: const InputDecoration(
                hintText: 'Enter the OTP',
              ),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              onPressed: _verifyOtp,
              child: const Text('Verify'),
            ),
          ],
        ),
      ),
    );
  }
}
