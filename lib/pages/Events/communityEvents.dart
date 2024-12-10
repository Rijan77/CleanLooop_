import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'event.dart'; // Import the Event class

class CommunityEventsPage extends StatefulWidget {
  const CommunityEventsPage({super.key});

  @override
  _CommunityEventsPageState createState() => _CommunityEventsPageState();
}

class _CommunityEventsPageState extends State<CommunityEventsPage> {
  // Calendar state
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  // Hardcoded event data with unique IDs
  List<Event> events = [
    Event(
      id: "treePlantationDrive",
      title: "Tree Plantation Drive",
      date: DateTime(2024, 12, 16),
      time: "11:00 AM",
      location: "City Square",
    ),
    Event(
      id: "ecoWalkathon",
      title: "Eco-Walkathon",
      date: DateTime(2024, 12, 20),
      time: "6:00 AM",
      location: "River Park",
    ),
    Event(
      id: "wasteManagementWorkshop",
      title: "Waste Management Workshop",
      date: DateTime(2024, 12, 28),
      time: "2:00 PM",
      location: "Community Center",
    ),
    Event(
      id: "sustainabilityFair",
      title: "Sustainability Fair",
      date: DateTime(2025, 1, 5),
      time: "10:00 AM",
      location: "Town Hall",
    ),
  ];

  // Get events for a specific day
  List<Event> _getEventsForDay(DateTime day) {
    return events.where((event) {
      return event.date.year == day.year &&
          event.date.month == day.month &&
          event.date.day == day.day;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community Events'),
        backgroundColor: Colors.green[700],
      ),
      body: Column(
        children: [
          // Calendar Widget
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime.utc(2020, 01, 01),
            lastDay: DateTime.utc(2025, 12, 31),
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.green[400],
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.blue[700],
                shape: BoxShape.circle,
              ),
              weekendTextStyle: TextStyle(color: Colors.green[900]),
              defaultTextStyle: TextStyle(color: Colors.green[800]),
              outsideTextStyle: TextStyle(color: Colors.green[300]),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
              ),
              leftChevronIcon: Icon(Icons.chevron_left, color: Colors.green[800]),
              rightChevronIcon: Icon(Icons.chevron_right, color: Colors.green[800]),
            ),
            eventLoader: _getEventsForDay,
          ),

          // Event List
          Expanded(
            child: ListView.builder(
              itemCount: _getEventsForDay(_selectedDay).length,
              itemBuilder: (context, index) {
                final event = _getEventsForDay(_selectedDay)[index];
                return Card(
                  color: Colors.blue[50],
                  child: ListTile(
                    title: Text(
                      event.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red[900],
                      ),
                    ),
                    subtitle: Text(
                      '${event.time} | ${event.location}',
                      style: TextStyle(color: Colors.green[800]),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.add, color: Colors.green[700]),
                      onPressed: () => _showParticipationDialog(context, event),
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

  // Show dialog to participate in an event
  void _showParticipationDialog(BuildContext context, Event event) {
    TextEditingController nameController = TextEditingController();
    TextEditingController addressController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController contactController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Participate in ${event.title}'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Full Name'),
                ),
                TextField(
                  controller: addressController,
                  decoration: const InputDecoration(labelText: 'Address'),
                ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: contactController,
                  decoration: const InputDecoration(labelText: 'Contact Number'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                String userName = nameController.text.trim();
                String userAddress = addressController.text.trim();
                String userEmail = emailController.text.trim();
                String userContact = contactController.text.trim();

                if (userName.isNotEmpty && userEmail.isNotEmpty && userContact.isNotEmpty) {
                  // Save participant under the selected event
                  await FirebaseFirestore.instance
                      .collection('events')
                      .doc(event.id)
                      .collection('participants')
                      .add({
                    'userName': userName,
                    'userAddress': userAddress,
                    'userEmail': userEmail,
                    'userContact': userContact,
                  });

                  Navigator.of(context).pop(); // Close the dialog
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('$userName, you have successfully registered for ${event.title}!'),
                  ));
                } else {
                  // Show error if fields are empty
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Please fill in all required fields!'),
                  ));
                }
              },
              child: const Text('Join'),
            ),
          ],
        );
      },
    );
  }
}