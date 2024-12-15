import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // For authentication

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final LatLng _sourceLocation = const LatLng(27.6862, 85.3149);
  final LatLng _destinationLocation = const LatLng(27.6782, 85.3169);
  LatLng? _currentPosition;
  LatLng? _truckPosition;

  Timer? _truckMovementTimer;
  final double _truckSpeed = 70; // Speed in km/h
  bool _movingToUser = true;

  final Location _locationController = Location();
  final Map<PolylineId, Polyline> _polylines = {};

  late FirebaseFirestore _firestore;
  late FlutterLocalNotificationsPlugin _localNotifications;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Placeholder driver and arrival info
  final String driverName = "Jivan Rai";
  final String driverContact = "+9808888475";
  final String vehicleNumber = "ABC-1977";
  double? _distanceToUser;
  String? _arrivalTimeToUser;
  double? _distanceToDestination;
  String? _arrivalTimeToDestination;

  @override
  void initState() {
    super.initState();
    initializeFirebase();
    _truckPosition = _sourceLocation;
    getLocationUpdates();
    startTruckMovement();
    initializeNotifications();
  }

  @override
  void dispose() {
    _truckMovementTimer?.cancel();
    super.dispose();
  }

  Future<void> initializeFirebase() async {
    try {
      await Firebase.initializeApp();
      _firestore = FirebaseFirestore.instance;
      final email = _auth.currentUser?.email;
      if (email != null) {
        await saveTruckStage('Source', _sourceLocation, email);
        await saveDriverInfoToFirebase(driverName, driverContact, vehicleNumber, _sourceLocation, email);
      }
    } catch (e) {
      debugPrint('Error initializing Firebase: $e');
    }
  }

  Future<void> initializeNotifications() async {
    _localNotifications = FlutterLocalNotificationsPlugin();
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);
    await _localNotifications.initialize(initSettings);
  }

  Future<void> sendNotification(String title, String body) async {
    final email = _auth.currentUser?.email;
    if (email == null) return;

    try {
      await _firestore.collection('notifications').doc(email).collection('user_notifications').add({
        'title': title,
        'body': body,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error saving notification: $e');
    }

    const androidDetails = AndroidNotificationDetails(
      'truck_channel',
      'Truck Notifications',
      channelDescription: 'Notifications for truck tracking',
      importance: Importance.high,
      priority: Priority.high,
    );
    const notificationDetails = NotificationDetails(android: androidDetails);
    await _localNotifications.show(0, title, body, notificationDetails);
  }

  Future<void> saveDriverInfoToFirebase(
      String driverName, String contact, String vehicleNumber, LatLng location, String email) async {
    try {
      await _firestore.collection('users').doc(email).collection('driver_info').doc('info').set({
        'driver_name': driverName,
        'contact': contact,
        'vehicle_number': vehicleNumber,
        'location': {
          'latitude': location.latitude,
          'longitude': location.longitude,
        },
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error saving driver info: $e');
    }
  }

  Future<void> saveTruckStage(String stage, LatLng location, String email) async {
    try {
      await _firestore.collection('users').doc(email).collection('truck_history').doc(stage).set({
        'stage': stage,
        'location': {
          'latitude': location.latitude,
          'longitude': location.longitude,
        },
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error saving stage: $e');
    }
  }

  Future<void> getLocationUpdates() async {
    bool serviceEnabled = await _locationController.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _locationController.requestService();
    }

    PermissionStatus permissionGranted = await _locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    _locationController.onLocationChanged.listen((location) {
      if (location.latitude != null && location.longitude != null) {
        setState(() {
          _currentPosition = LatLng(location.latitude!, location.longitude!);
          updatePolylines();
        });
      }
    });
  }

  void startTruckMovement() {
    _truckMovementTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (_currentPosition == null) return;
      final email = _auth.currentUser?.email;
      if (email == null) return;

      setState(() {
        if (_movingToUser) {
          _distanceToUser = calculateDistance(
            _truckPosition!.latitude,
            _truckPosition!.longitude,
            _currentPosition!.latitude,
            _currentPosition!.longitude,
          );

          if (_distanceToUser! > 0.01) {
            _truckPosition = moveTowards(_truckPosition!, _currentPosition!, _truckSpeed / 3600);
          } else {
            _movingToUser = false;
            sendNotification('Truck Arrived', 'The truck has reached your location.');
            saveTruckStage('User', _truckPosition!, email);
          }
        } else {
          _distanceToDestination = calculateDistance(
            _truckPosition!.latitude,
            _truckPosition!.longitude,
            _destinationLocation.latitude,
            _destinationLocation.longitude,
          );

          if (_distanceToDestination! > 0.01) {
            _truckPosition = moveTowards(_truckPosition!, _destinationLocation, _truckSpeed / 3600);
          } else {
            sendNotification('Truck Arrived', 'The truck has reached the destination.');
            saveTruckStage('Destination', _destinationLocation, email);
            timer.cancel();
          }
        }

        if (_truckPosition != null) {
          saveDriverInfoToFirebase(driverName, driverContact, vehicleNumber, _truckPosition!, email);
        }

        updateArrivalTimes();
        updatePolylines();
      });
    });
  }

  void updateArrivalTimes() {
    if (_distanceToUser != null) {
      _arrivalTimeToUser = "${(_distanceToUser! / _truckSpeed * 60).toStringAsFixed(0)} min";
    }
    if (_distanceToDestination != null) {
      _arrivalTimeToDestination = "${(_distanceToDestination! / _truckSpeed * 60).toStringAsFixed(0)} min";
    }
  }

  LatLng moveTowards(LatLng current, LatLng target, double distance) {
    final lat1 = current.latitude * pi / 180;
    final lon1 = current.longitude * pi / 180;
    final lat2 = target.latitude * pi / 180;
    final lon2 = target.longitude * pi / 180;

    final dLat = lat2 - lat1;
    final dLon = lon2 - lon1;

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    final totalDistance = 6371 * c;

    final fraction = min(distance / totalDistance, 1.0);

    final newLat = lat1 + fraction * dLat;
    final newLon = lon1 + fraction * dLon;

    return LatLng(newLat * 180 / pi, newLon * 180 / pi);
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371;
    final dLat = (lat2 - lat1) * pi / 180;
    final dLon = (lon2 - lon1) * pi / 180;

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1 * pi / 180) * cos(lat2 * pi / 180) * sin(dLon / 2) * sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return R * c;
  }

  void updatePolylines() {
    _polylines.clear();
    if (_truckPosition != null && _currentPosition != null) {
      _polylines[const PolylineId('to_user')] = Polyline(
        polylineId: const PolylineId('to_user'),
        points: [_truckPosition!, _currentPosition!],
        color: Colors.blue,
      );
    }

    if (_truckPosition != null) {
      _polylines[const PolylineId('to_destination')] = Polyline(
        polylineId: const PolylineId('to_destination'),
        points: [_truckPosition!, _destinationLocation],
        color: Colors.green,
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Truck Tracker', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xff34D399),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          _truckPosition != null
              ? GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _truckPosition!,
              zoom: 14,
            ),
            markers: {
              Marker(
                markerId: const MarkerId('user'),
                position: _currentPosition ?? _sourceLocation,
                infoWindow: const InfoWindow(title: 'User Location'),
              ),
              Marker(
                markerId: const MarkerId('truck'),
                position: _truckPosition!,
                infoWindow: const InfoWindow(title: 'Truck Location'),
              ),
              Marker(
                markerId: const MarkerId('destination'),
                position: _destinationLocation,
                infoWindow: const InfoWindow(title: 'Destination Location'),
              ),
            },
            polylines: Set<Polyline>.of(_polylines.values),
            myLocationEnabled: true,
          )
              : const Center(child: CircularProgressIndicator()),
          Positioned(
            bottom: 20,
            left: 10,
            right: 10,
            child: Card(
              color: Colors.green,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage('lib/assets/images/driver.png'),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Driver: $driverName',
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    Text(
                      'Contact: $driverContact',
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    Text(
                      'Vehicle: $vehicleNumber',
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    if (_arrivalTimeToUser != null)
                      Text(
                        'Arrival to user: $_arrivalTimeToUser',
                        style: const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    if (_arrivalTimeToDestination != null)
                      Text(
                        'Arrival to destination: $_arrivalTimeToDestination',
                        style: const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
