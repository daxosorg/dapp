// A dashboard screen where user have only one button, on pressing it user's current location will be stored to firebase.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  final GeolocatorPlatform geolocator = GeolocatorPlatform.instance;
  Position? position;

  void _getCurrentLocation() async {
    try {
// Check location permission
      LocationPermission permission = await geolocator.checkPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
// Request location permission if not granted
        permission = await geolocator.requestPermission();
      }
      if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
// Get current location
        position = await geolocator.getCurrentPosition();
        setState(() {});
// Store current location to firebase
        await FirebaseFirestore.instance.collection('locations').add({
          'latitude': position!.latitude,
          'longitude': position!.longitude,
          'timestamp': position!.timestamp,
        });
      }
    } on PlatformException catch (e) {
// Handle errors
      print(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(position != null ? '${position!.latitude}, ${position!.longitude}' : 'No location'),
            ElevatedButton(
              onPressed: _getCurrentLocation,
              child: const Text('Get Current Location'),
            ),
          ],
        ),
      ),
    );
  }
}
