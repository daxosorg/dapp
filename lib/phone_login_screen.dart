import 'package:dapp/otp_verification_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({Key? key}) : super(key: key);

  @override
  _PhoneLoginScreenState createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final _phoneController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  void _loginWithPhoneNumber() async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: _phoneController.text,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => OtpVerificationScreen(credential: credential),
            ),
          );
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
        },
        codeSent: (String verificationId, int? resendToken) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => OtpVerificationScreen(verificationId: verificationId),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phone Login'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade400,
              Colors.blue.shade900,
            ],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  controller: _phoneController,
                  decoration: const InputDecoration(hintText: 'Enter your phone number', border: InputBorder.none, contentPadding: EdgeInsets.all(16)),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _loginWithPhoneNumber(),
                style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.blue.shade900,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                child: Text('Login', style: TextStyle(color: Colors.blue.shade900)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
