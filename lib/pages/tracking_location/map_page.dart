import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final LatLng _sourceLocation = const LatLng(27.6557, 85.3491); // Initial truck location
  final LatLng _destinationLocation = const LatLng(27.6588, 85.3247); // Destination location
  LatLng? _currentPosition; // User location
  LatLng? _truckPosition; // Truck's current position

  Timer? _truckMovementTimer;
  final double _truckSpeed = 40; // Truck speed in km/h
  double? _distanceToUser;
  double? _distanceToDestination;
  String? _arrivalTimeToUser;
  String? _arrivalTimeToDestination;

  final Location _locationController = Location();
  final Map<PolylineId, Polyline> _polylines = {}; // To hold the polylines

  bool _waitingAtUser = false;

  @override
  void initState() {
    super.initState();
    _truckPosition = _sourceLocation;
    getLocationUpdates();
    startTruckMovement();
  }

  @override
  void dispose() {
    _truckMovementTimer?.cancel();
    super.dispose();
  }

  Future<void> getLocationUpdates() async {
    bool serviceEnabled = await _locationController.serviceEnabled();
    if (!serviceEnabled) serviceEnabled = await _locationController.requestService();

    PermissionStatus permissionGranted = await _locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    _locationController.onLocationChanged.listen((LocationData location) {
      if (location.latitude != null && location.longitude != null) {
        setState(() {
          _currentPosition = LatLng(location.latitude!, location.longitude!);
          updatePolylines();
        });
      }
    });
  }

  void startTruckMovement() {
    _truckMovementTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentPosition == null) return;

      // Move truck towards user first
      if (_distanceToUser == null || _distanceToUser! > 0.01) {
        // Calculate truck's next position towards the user
        LatLng newTruckPosition = moveTowards(_truckPosition!, _currentPosition!, _truckSpeed / 3600);
        setState(() {
          _truckPosition = newTruckPosition;
        });
      }

      // If truck reaches user location, move towards the destination
      if (_distanceToUser != null && _distanceToUser! <= 0.01) {
        if (!_waitingAtUser) {
          // Once at the user location, set the flag to start moving towards the destination
          _waitingAtUser = true;
        }

        // Move towards destination after reaching the user
        LatLng newTruckPosition = moveTowards(_truckPosition!, _destinationLocation, _truckSpeed / 3600);
        setState(() {
          _truckPosition = newTruckPosition;
        });
      }

      // Calculate distances to update the UI
      setState(() {
        _distanceToUser = calculateDistance(
          _truckPosition!.latitude,
          _truckPosition!.longitude,
          _currentPosition!.latitude,
          _currentPosition!.longitude,
        );
        _distanceToDestination = calculateDistance(
          _truckPosition!.latitude,
          _truckPosition!.longitude,
          _destinationLocation.latitude,
          _destinationLocation.longitude,
        );
        _arrivalTimeToUser = calculateArrivalTime(_distanceToUser!, _truckSpeed);
        _arrivalTimeToDestination = calculateArrivalTime(_distanceToDestination!, _truckSpeed);

        updatePolylines();
      });

      // Stop the timer when the truck reaches the destination
      if (_distanceToDestination != null && _distanceToDestination! <= 0.01) {
        timer.cancel();
      }
    });
  }


  LatLng moveTowards(LatLng current, LatLng target, double distance) {
    final double lat1 = current.latitude * pi / 180;
    final double lon1 = current.longitude * pi / 180;
    final double lat2 = target.latitude * pi / 180;
    final double lon2 = target.longitude * pi / 180;

    final double dLat = lat2 - lat1;
    final double dLon = lon2 - lon1;

    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    final double totalDistance = 6371 * c; // Distance in km

    final double fraction = min(distance / totalDistance, 1.0);

    final double newLat = lat1 + fraction * dLat;
    final double newLon = lon1 + fraction * dLon;

    return LatLng(newLat * 180 / pi, newLon * 180 / pi);
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371; // Radius of Earth in km
    final dLat = (lat2 - lat1) * pi / 180;
    final dLon = (lon2 - lon1) * pi / 180;

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1 * pi / 180) * cos(lat2 * pi / 180) * sin(dLon / 2) * sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return R * c; // Distance in km
  }

  String calculateArrivalTime(double distance, double speed) {
    final timeInHours = distance / speed;
    final timeInMinutes = (timeInHours * 60).toInt();
    return "$timeInMinutes min";
  }

  void updatePolylines() {
    _polylines.clear();

    if (_truckPosition != null && _currentPosition != null) {
      _polylines[const PolylineId('truck_to_user')] = Polyline(
        polylineId: const PolylineId('truck_to_user'),
        points: [_truckPosition!, _currentPosition!],
        color: Colors.green,
        width: 5,
      );
    }

    if (_truckPosition != null) {
      _polylines[const PolylineId('truck_to_destination')] = Polyline(
        polylineId: const PolylineId('truck_to_destination'),
        points: [_truckPosition!, _destinationLocation],
        color: Colors.red,
        width: 5,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Truck Tracker"),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Google Map
          Expanded(
            flex: 2,
            child: _currentPosition == null
                ? const Center(child: CircularProgressIndicator())
                : GoogleMap(
              initialCameraPosition: CameraPosition(target: _sourceLocation, zoom: 15),
              markers: {
                Marker(
                  markerId: const MarkerId("truck"),
                  position: _truckPosition!,
                  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
                  infoWindow: const InfoWindow(title: "Truck Location"),
                ),
                Marker(
                  markerId: const MarkerId("user"),
                  position: _currentPosition!,
                  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
                  infoWindow: const InfoWindow(title: "Your Location"),
                ),
                Marker(
                  markerId: const MarkerId("destination"),
                  position: _destinationLocation,
                  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                  infoWindow: const InfoWindow(title: "Destination"),
                ),
              },
              polylines: Set<Polyline>.of(_polylines.values),
            ),
          ),
          const SizedBox(height: 10),
          // Arrival Times and Distances
          Card(
            elevation: 5,
            margin: const EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Distance to User: ${_distanceToUser?.toStringAsFixed(2) ?? "--"} km",
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    "Arrival Time to User: ${_arrivalTimeToUser ?? "--"}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Distance to Destination: ${_distanceToDestination?.toStringAsFixed(2) ?? "--"} km",
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    "Arrival Time to Destination: ${_arrivalTimeToDestination ?? "--"}",
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),

          // Driver Information
          const Card(
            elevation: 5,
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage("assets/images/driver.png"), // Add your driver's picture here
                    radius: 30,
                  ),
                  SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Driver: Tero Bauw Vann", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      Text("Truck Plate: ABC-1234", style: TextStyle(fontSize: 16)),
                      SizedBox(height: 5),
                      Text("Phone Number: 123-456-789", style: TextStyle(fontSize: 16)),
                      SizedBox(height: 5),
                      Text("Truck Model: Thulo Truck", style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}