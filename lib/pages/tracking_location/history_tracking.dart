import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';

class HistoryTrackingPage extends StatefulWidget {
  const HistoryTrackingPage({super.key});

  @override
  State<HistoryTrackingPage> createState() => _HistoryTrackingPageState();
}

class _HistoryTrackingPageState extends State<HistoryTrackingPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Map<String, int> stageCounts = {};
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchStageCounts();
  }

  Future<void> _fetchStageCounts() async {
    setState(() {
      isLoading = true;
    });

    final snapshot = await _firestore.collection('truck_history').get();
    for (var doc in snapshot.docs) {
      final stage = doc.data()['stage'] ?? 'Unknown';
      stageCounts[stage] = (stageCounts[stage] ?? 0) + 1;
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<String> _getLocationName(double latitude, double longitude) async {
    try {
      final placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        return "${placemarks.first.locality}, ${placemarks.first.country}";
      }
    } catch (e) {
      debugPrint("Error fetching location name: $e");
    }
    return "Unknown Location";
  }

  // Fetch the driver details from the 'drivers' collection (driver_name)
  Future<String> _getDriverName() async {
    try {
      final driverSnapshot = await _firestore
          .collection('drivers')
          .doc('driverInfo')  // Document ID is 'driverInfo' where driver details are stored
          .get();

      if (driverSnapshot.exists) {
        final driverData = driverSnapshot.data()!;
        return driverData['driver_name'] ?? 'Unknown Driver'; // Return the driver's name
      } else {
        return 'Unknown Driver'; // If no driver info found, return Unknown Driver
      }
    } catch (e) {
      debugPrint("Error fetching driver info: $e");
      return 'Unknown Driver'; // Handle errors
    }
  }

  Widget _buildPieChart() {
    final pieData = stageCounts.entries
        .map((entry) => PieChartSectionData(
      value: entry.value.toDouble(),
      title: "${entry.key} (${entry.value})",
      color: Colors.primaries[stageCounts.keys.toList().indexOf(entry.key) % Colors.primaries.length],
    ))
        .toList();

    return PieChart(
      PieChartData(
        sections: pieData,
        centerSpaceRadius: 40,
        sectionsSpace: 2,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('History Tracking')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildPieChart(),
            ),
          ),
          const Divider(),
          Expanded(
            flex: 3,
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('truck_history').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    final stage = data['stage'] ?? 'Unknown';
                    final location = data['location'] ?? {};
                    final latitude = location['latitude'];
                    final longitude = location['longitude'];
                    final timestamp = data['timestamp']?.toDate().toString() ?? 'Unknown';

                    return FutureBuilder<List<String>>(
                      future: Future.wait([
                        _getLocationName(latitude, longitude),
                        _getDriverName(),  // Fetch the driver name as well
                      ]),
                      builder: (context, locationSnapshot) {
                        if (locationSnapshot.connectionState == ConnectionState.waiting) {
                          return const ListTile(
                            title: Text('Loading...'),
                            subtitle: Text('Location and driver info loading...'),
                          );
                        }

                        final locationName = locationSnapshot.data?[0] ?? "Unknown Location";
                        final driverName = locationSnapshot.data?[1] ?? "Unknown Driver";

                        return ListTile(
                          title: Text(stage),
                          subtitle: Text('Location: $locationName\nDriver: $driverName\nTime: $timestamp'),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}