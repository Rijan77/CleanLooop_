import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import for FirebaseAuth
import 'package:intl/intl.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final String? currentUserEmail = FirebaseAuth.instance.currentUser?.email;

    if (currentUserEmail == null) {
      return const Center(
        child: Text(
          "User not signed in.",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    print("Current User Email: $currentUserEmail"); // Debugging line

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Notifications",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xff34D399),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('notifications') // Correct top-level collection
            .doc(currentUserEmail) // Use current user's email document
            .collection('user_notifications') // Subcollection for notifications
            .orderBy('timestamp', descending: true) // Order by timestamp
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            print("Error: ${snapshot.error}"); // Debugging line
            return const Center(child: Text("Error loading notifications."));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No Notifications Yet",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          final notifications = snapshot.data!.docs;
          print("Notifications Data: $notifications"); // Debugging line

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              final title = notification['title'] as String? ?? "No Title";
              final body = notification['body'] as String? ?? "No Details";
              final timestamp = notification['timestamp'] as Timestamp?;

              final timeString = timestamp != null
                  ? DateFormat('yyyy-MM-dd hh:mm a').format(timestamp.toDate())
                  : "Unknown Time";

              return Card(
                color: Colors.green,
                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ListTile(
                  leading: const Icon(Icons.notifications, color: Colors.blue),
                  title: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        body,
                        style: const TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        timeString,
                        style: const TextStyle(color: Colors.white60, fontSize: 12.0),
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
    );
  }
}
