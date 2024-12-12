import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:geocoding/geocoding.dart';

class LocationConfirmationPage extends StatefulWidget {
  const LocationConfirmationPage({super.key});

  @override
  State<LocationConfirmationPage> createState() =>
      _LocationConfirmationPageState();
}

class _LocationConfirmationPageState extends State<LocationConfirmationPage> {
  LatLng? _currentPosition;
  String? _address;
  final loc.Location _locationController = loc.Location();
  bool _isLocationConfirmed = false;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Check if location services are enabled
      bool serviceEnabled = await _locationController.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _locationController.requestService();
        if (!serviceEnabled) {
          setState(() {
            _errorMessage = "Location services are disabled. Please enable them.";
            _isLoading = false;
          });
          return;
        }
      }

      // Check and request location permissions
      loc.PermissionStatus permissionGranted =
      await _locationController.hasPermission();
      if (permissionGranted == loc.PermissionStatus.denied) {
        permissionGranted = await _locationController.requestPermission();
        if (permissionGranted != loc.PermissionStatus.granted) {
          setState(() {
            _errorMessage = "Location permission denied.";
            _isLoading = false;
          });
          return;
        }
      }

      // Get location data
      final location = await _locationController.getLocation();
      final latLng = LatLng(location.latitude!, location.longitude!);

      // Get address from coordinates
      final placemarks =
      await placemarkFromCoordinates(location.latitude!, location.longitude!);
      final placemark = placemarks[0];

      setState(() {
        _currentPosition = latLng;
        _address = "${placemark.name}, ${placemark.locality}, ${placemark.country}";
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Failed to fetch location. Please try again.";
        _isLoading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Confirm Your Location",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
            ? Center(
          child: Text(
            _errorMessage!,
            style: const TextStyle(fontSize: 16, color: Colors.red),
            textAlign: TextAlign.center,
          ),
        )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Google Map
            Expanded(
              flex: 2,
              child: _currentPosition == null
                  ? const Center(
                child: Text(
                  "Location not available.",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              )
                  : GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _currentPosition!,
                  zoom: 15,
                ),
                markers: {
                  Marker(
                    markerId: const MarkerId("user_location"),
                    position: _currentPosition!,
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueBlue),
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
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                textStyle: const TextStyle(fontSize: 16),
              ),
              onPressed: _currentPosition != null && !_isLocationConfirmed
                  ? () {
                setState(() {
                  _isLocationConfirmed = true;
                });
                // Add any further logic here
              }
                  : null,
              child: Text(
                _isLocationConfirmed ? "Location Confirmed" : "Confirm Location",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

