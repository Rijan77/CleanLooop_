// import 'package:flutter/material.dart';
//
// class SchedulePickupPage extends StatefulWidget {
//   @override
//   _SchedulePickupPageState createState() => _SchedulePickupPageState();
// }
//
// class _SchedulePickupPageState extends State<SchedulePickupPage> {
//   String? selectedWasteType;
//   String? selectedDate;
//   String? selectedTime;
//   final addressController = TextEditingController();
//   final notesController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Schedule Pickup'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Waste Type Dropdown
//               const Text(
//                 'Select Waste Type',
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//               ),
//               const SizedBox(height: 8),
//               DropdownButtonFormField<String>(
//                 value: selectedWasteType,
//                 items: ['Recyclable', 'Organic', 'Hazardous', 'Others']
//                     .map((type) => DropdownMenuItem(
//                   value: type,
//                   child: Text(type),
//                 ))
//                     .toList(),
//                 onChanged: (value) {
//                   setState(() {
//                     selectedWasteType = value;
//                   });
//                 },
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(),
//                   hintText: 'Choose type',
//                 ),
//               ),
//               const SizedBox(height: 20),
//
//               // Address Input
//               const Text(
//                 'Pickup Address',
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//               ),
//               const SizedBox(height: 8),
//               TextField(
//                 controller: addressController,
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(),
//                   hintText: 'Enter your address',
//                 ),
//               ),
//               const SizedBox(height: 20),
//
//               // Date Picker
//               const Text(
//                 'Select Date',
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//               ),
//               const SizedBox(height: 8),
//               TextField(
//                 readOnly: true,
//                 onTap: () async {
//                   DateTime? pickedDate = await showDatePicker(
//                     context: context,
//                     initialDate: DateTime.now(),
//                     firstDate: DateTime.now(),
//                     lastDate: DateTime(2100),
//                   );
//                   if (pickedDate != null) {
//                     setState(() {
//                       selectedDate = "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
//                     });
//                   }
//                 },
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(),
//                   hintText: selectedDate ?? 'Select date',
//                 ),
//               ),
//               const SizedBox(height: 20),
//
//               // Time Picker
//               const Text(
//                 'Select Time',
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//               ),
//               const SizedBox(height: 8),
//               TextField(
//                 readOnly: true,
//                 onTap: () async {
//                   TimeOfDay? pickedTime = await showTimePicker(
//                     context: context,
//                     initialTime: TimeOfDay.now(),
//                   );
//                   if (pickedTime != null) {
//                     setState(() {
//                       selectedTime = pickedTime.format(context);
//                     });
//                   }
//                 },
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(),
//                   hintText: selectedTime ?? 'Select time',
//                 ),
//               ),
//               const SizedBox(height: 20),
//
//               // Notes Input
//               const Text(
//                 'Additional Notes',
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//               ),
//               const SizedBox(height: 8),
//               TextField(
//                 controller: notesController,
//                 maxLines: 3,
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(),
//                   hintText: 'Enter additional notes (optional)',
//                 ),
//               ),
//               const SizedBox(height: 30),
//
//               // Confirm Button
//               Center(
//                 child: ElevatedButton(
//                   onPressed: () {
//                     if (selectedWasteType != null &&
//                         addressController.text.isNotEmpty &&
//                         selectedDate != null &&
//                         selectedTime != null) {
//                       // Confirm the pickup
//                       _showConfirmationDialog();
//                     } else {
//                       _showErrorSnackbar();
//                     }
//                   },
//                   child: const Text('Confirm Pickup'),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _showConfirmationDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Pickup Confirmed'),
//         content: Text(
//           'Waste Type: $selectedWasteType\n'
//               'Address: ${addressController.text}\n'
//               'Date: $selectedDate\n'
//               'Time: $selectedTime\n'
//               'Notes: ${notesController.text.isEmpty ? "None" : notesController.text}',
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _showErrorSnackbar() {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Please fill all required fields!')),
//     );
//   }
// }

import 'package:flutter/material.dart';

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
        title: const Text('Schedule Pickup'),
        backgroundColor: Colors.green, // AppBar color
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
                  color: Colors.green, // Green text
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
                    borderSide: BorderSide(color: Colors.green), // Green border
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
                    borderSide: BorderSide(color: Colors.green), // Green border
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
                      selectedDate = "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
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
                      _showConfirmationDialog();
                    } else {
                      _showErrorSnackbar();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Confirm Pickup'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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

  void _showErrorSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please fill all required fields!'),
        backgroundColor: Colors.red,
      ),
    );
  }
}
