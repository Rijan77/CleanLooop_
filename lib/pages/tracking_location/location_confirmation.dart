import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;  // Alias added
import 'package:geocoding/geocoding.dart';

class LocationConfirmationPage extends StatefulWidget {
  const LocationConfirmationPage({super.key});

  @override
  State<LocationConfirmationPage> createState() => _LocationConfirmationPageState();
}

class _LocationConfirmationPageState extends State<LocationConfirmationPage> {
  LatLng? _currentPosition;
  String? _address;
  final loc.Location _locationController = loc.Location();  // Using the alias here
  bool _isLocationConfirmed = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await _locationController.serviceEnabled();
    if (!serviceEnabled) serviceEnabled = await _locationController.requestService();

    loc.PermissionStatus permissionGranted = await _locationController.hasPermission();
    if (permissionGranted == loc.PermissionStatus.denied) {
      permissionGranted = await _locationController.requestPermission();
      if (permissionGranted != loc.PermissionStatus.granted) return;
    }

    _locationController.getLocation().then((location) async {
      setState(() {
        _currentPosition = LatLng(location.latitude!, location.longitude!);
      });

      // Get address from coordinates
      List<Placemark> placemarks = await placemarkFromCoordinates(location.latitude!, location.longitude!);
      Placemark placemark = placemarks[0];

      setState(() {
        _address = "${placemark.name}, ${placemark.locality}, ${placemark.country}";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Confirm Your Location"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Show current location icon and map
            Expanded(
              flex: 2,
              child: _currentPosition == null
                  ? const Center(child: CircularProgressIndicator())
                  : GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _currentPosition!,
                  zoom: 15,
                ),
                markers: {
                  Marker(
                    markerId: const MarkerId("user_location"),
                    position: _currentPosition!,
                    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
                    infoWindow: const InfoWindow(title: "Your Location"),
                  ),
                },
              ),
            ),
            const SizedBox(height: 20),
            // Latitude, Longitude, and Address
            Text(
              "Latitude: ${_currentPosition?.latitude ?? '--'}",
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              "Longitude: ${_currentPosition?.longitude ?? '--'}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              "Address: ${_address ?? '--'}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            // Confirm Location Button
            ElevatedButton(
              onPressed: _currentPosition != null && !_isLocationConfirmed
                  ? () {
                setState(() {
                  _isLocationConfirmed = true;
                });
                // Add any further logic for confirmation
                // For example, navigate to the next screen or save the location
              }
                  : null,
              child: Text(_isLocationConfirmed ? "Location Confirmed" : "Confirm Location"),
            ),
          ],
        ),
      ),
    );
  }
}
