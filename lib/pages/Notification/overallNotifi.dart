import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

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
        title: const Text("Notifications"),
        centerTitle: true,
        backgroundColor: const Color(0xff34D399),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('notifications') // Firebase collection for notifications
              .orderBy('timestamp', descending: true) // Show newest notifications first
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text(
                  "No Notifications Yet",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }

            // Fetch notifications
            final notifications = snapshot.data!.docs;

            return ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                final title = notification['title'] as String? ?? "No Title";
                final body = notification['body'] as String? ?? "No Details";
                final timestamp = notification['timestamp'] as Timestamp?;

                // Format timestamp
                final timeString = timestamp != null
                    ? DateFormat('yyyy-MM-dd hh:mm a').format(timestamp.toDate())
                    : "Unknown Time";

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: ListTile(
                    leading: const Icon(Icons.notifications, color: Colors.blue),
                    title: Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(body),
                        const SizedBox(height: 4.0),
                        Text(
                          timeString,
                          style: const TextStyle(color: Colors.grey, fontSize: 12.0),
                        ),
                      ],
                    ),
                    onTap: () {
                      // Optional: Add tap functionality for each notification
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}