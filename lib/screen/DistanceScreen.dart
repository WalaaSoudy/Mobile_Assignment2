import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_application_7/store_model.dart';

class DistanceScreen extends StatefulWidget {
  final Store store;

  const DistanceScreen({required this.store});

  @override
  _DistanceScreenState createState() => _DistanceScreenState();
}

class _DistanceScreenState extends State<DistanceScreen> {
  double? distanceInMeters;

  @override
  void initState() {
    super.initState();
    _calculateDistance();
  }

  Future<void> _calculateDistance() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      // Check if location services are enabled
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are not enabled
        return;
      }

      // Request location permissions
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.whileInUse &&
            permission != LocationPermission.always) {
          // Location permissions are denied
          return;
        }
      }

      // Get the current position
      Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Calculate the distance
      double distanceInMeters = await Geolocator.distanceBetween(
        currentPosition.latitude,
        currentPosition.longitude,
        widget.store.latitude,
        widget.store.longitude,
      );

      setState(() {
        this.distanceInMeters = distanceInMeters;
      });
    } catch (e) {
      print('Error calculating distance: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Distance Calculation'),
      ),
      body: Center(
        child: distanceInMeters == null
            ? CircularProgressIndicator()
            : Text('Distance: $distanceInMeters meters'),
      ),
    );
  }
}