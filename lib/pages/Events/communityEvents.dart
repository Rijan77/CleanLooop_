import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'event.dart';

class CommunityEventsPage extends StatefulWidget {
  const CommunityEventsPage({super.key});

  @override
  _CommunityEventsPageState createState() => _CommunityEventsPageState();
}

class _CommunityEventsPageState extends State<CommunityEventsPage> {
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  bool _isLoading = true;
  List<Event> _events = [];

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    setState(() => _isLoading = true);
    try {
      // Example events - replace with your actual events or load from Firebase
      _events = [
        Event(
          id: "treePlantationDrive",
          title: "Tree Plantation Drive",
          date: DateTime(2025, 1, 10),
          time: "11:00 AM",
          location: "City Square",
          description: "Join us for a community tree planting event!",
        ),
        Event(
          id: "ecoWalkathon",
          title: "Eco-Walkathon",
          date: DateTime(2024, 12, 20),
          time: "6:00 AM",
          location: "River Park",
          description: "Walk for a greener future.",
        ),
        Event(
          id: "wasteManagementWorkshop",
          title: "Waste Management Workshop",
          date: DateTime(2025, 1, 28),
          time: "2:00 PM",
          location: "Community Center",
          description: "Learn about effective waste management practices.",
        ),
        Event(
          id: "sustainabilityFair",
          title: "Sustainability Fair",
          date: DateTime(2025, 1, 16),
          time: "10:00 AM",
          location: "Town Hall",
          description: "Explore sustainable living solutions.",
        ),
      ];
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading events: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  List<Event> _getEventsForDay(DateTime day) {
    return _events.where((event) {
      return isSameDay(event.date, day);
    }).toList();
  }

  // Helper method for phone number validation
  bool _isValidPhoneNumber(String phoneNumber) {
    // Basic phone number validation
    // Modify regex as per your country's phone number format
    final phoneRegex = RegExp(r'^\+?[0-9]{10,14}$');
    return phoneRegex.hasMatch(phoneNumber.replaceAll(RegExp(r'\s'), ''));
  }

  Future<void> _handleParticipation(Event event) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || user.email == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please login to participate')),
      );
      return;
    }

    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    TextEditingController nameController = TextEditingController();
    TextEditingController addressController = TextEditingController();
    TextEditingController emailController = TextEditingController(text: user.email);
    TextEditingController contactController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Participate in ${event.title}'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name *',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: addressController,
                    decoration: const InputDecoration(
                      labelText: 'Address',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: emailController,
                    enabled: false,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: contactController,
                    decoration: const InputDecoration(
                      labelText: 'Contact Number *',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Contact number is required';
                      }
                      if (!_isValidPhoneNumber(value)) {
                        return 'Invalid phone number format';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '* Required fields',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  Navigator.pop(context, true);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF34D399),
              ),
              child: const Text('Join'),
            ),
          ],
        );
      },
    );

    if (result == true) {
      try {
        // Start a batch write
        final batch = FirebaseFirestore.instance.batch();

        // Add participation record
        final participationRef = FirebaseFirestore.instance
            .collection('events')
            .doc(event.id)
            .collection('participants')
            .doc();

        batch.set(participationRef, {
          'userName': nameController.text.trim(),
          'userAddress': addressController.text.trim(),
          'userEmail': user.email,
          'userContact': contactController.text.trim(),
          'participationDate': DateTime.now(),
        });

        // Update user points
        final userRef = FirebaseFirestore.instance
            .collection('users')
            .doc(user.email);

        batch.set(userRef, {
          'points': FieldValue.increment(20),
          'participatedEvents': FieldValue.arrayUnion([event.id]),
        }, SetOptions(merge: true));

        // Commit the batch
        await batch.commit();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Successfully registered for ${event.title}! You earned 20 points!'
              ),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Community Events'),
        backgroundColor: const Color(0xFF34D399),
      ),
      body: Column(
        children: [
          // Calendar Widget
          Card(
            margin: const EdgeInsets.all(8.0),
            elevation: 4,
            child: TableCalendar(
              firstDay: DateTime.now().subtract(const Duration(days: 365)),
              lastDay: DateTime.now().add(const Duration(days: 365)),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              eventLoader: _getEventsForDay,
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              calendarStyle: const CalendarStyle(
                markerDecoration: BoxDecoration(
                  color: Color(0xFF34D399),
                  shape: BoxShape.circle,
                ),
              ),
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
            ),
          ),

          // Events List
          Expanded(
            child: _getEventsForDay(_selectedDay).isEmpty
                ? Center(
              child: Text(
                'No events on this day',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: _getEventsForDay(_selectedDay).length,
              itemBuilder: (context, index) {
                final event = _getEventsForDay(_selectedDay)[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      event.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.access_time, size: 16),
                            const SizedBox(width: 8),
                            Text(event.time),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 16),
                            const SizedBox(width: 8),
                            Text(event.location),
                          ],
                        ),
                        if (event.description != null && event.description!.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(event.description!),
                        ],
                      ],
                    ),
                    trailing: ElevatedButton(
                      onPressed: () => _handleParticipation(event),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF34D399),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                      child: const Text('Join'),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}