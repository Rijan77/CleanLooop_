import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SchedulePickupPage extends StatefulWidget {
  const SchedulePickupPage({super.key});

  @override
  _SchedulePickupPageState createState() => _SchedulePickupPageState();
}

class _SchedulePickupPageState extends State<SchedulePickupPage> {
  String? selectedWasteType;
  String? selectedDate;
  String? selectedTime;
  final addressController = TextEditingController();
  final notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 33,),
          onPressed: () {
            // Navigate back to login page
            Navigator.pop(context);
          },
        ),
        title: const Text('Schedule Pickup'),
        backgroundColor: const Color(0xff34D399),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Waste Type Dropdown
              const Text(
                'Select Waste Type',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedWasteType,
                items: ['Recyclable', 'Organic', 'Hazardous', 'Others']
                    .map((type) => DropdownMenuItem(
                  value: type,
                  child: Text(type),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedWasteType = value;
                  });
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Choose type',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Address Input
              const Text(
                'Pickup Address',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your address',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Date Picker
              const Text(
                'Select Date',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      selectedDate =
                      "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                    });
                  }
                },
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: selectedDate ?? 'Select date',
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Time Picker
              const Text(
                'Select Time',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                readOnly: true,
                onTap: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    setState(() {
                      selectedTime = pickedTime.format(context);
                    });
                  }
                },
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: selectedTime ?? 'Select time',
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Notes Input
              const Text(
                'Additional Notes',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: notesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter additional notes (optional)',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Confirm Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (selectedWasteType != null &&
                        addressController.text.isNotEmpty &&
                        selectedDate != null &&
                        selectedTime != null) {
                      _savePickupDetails();
                    } else {
                      _showErrorSnackbar();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade500,
                    foregroundColor: Colors.black87,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9), // Makes the button rectangular
                    ),

                  ),
                  child: const Text('Confirm Pickup', style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: "calistoga",
                    letterSpacing: 2,
                  ),),
                ),
              ),
              const SizedBox(height: 30),
              const Divider(thickness: 1),
              const Center(
                child: Text(
                  "© 2024 CleanLoop. All rights reserved.",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Save pickup details to Firestore
  void _savePickupDetails() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final String userId = FirebaseAuth.instance.currentUser!.uid; // Current user ID

    try {
      await firestore.collection('pickups').add({
        'userId': userId,
        'waste_type': selectedWasteType,
        'address': addressController.text,
        'date': selectedDate,
        'time': selectedTime,
        'notes': notesController.text.isEmpty ? "None" : notesController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });

      _showConfirmationDialog();
    } catch (e) {
      _showErrorSnackbar();
    }
  }

  // Show confirmation dialog
  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Pickup Confirmed',
          style: TextStyle(color: Colors.green),
        ),
        content: Text(
          'Waste Type: $selectedWasteType\n'
              'Address: ${addressController.text}\n'
              'Date: $selectedDate\n'
              'Time: $selectedTime\n'
              'Notes: ${notesController.text.isEmpty ? "None" : notesController.text}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'OK',
              style: TextStyle(color: Colors.green),
            ),
          ),
        ],
      ),
    );
  }

  // Show error snackbar
  void _showErrorSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please fill all required fields!'),
        backgroundColor: Colors.red,
      ),
    );
  }
}