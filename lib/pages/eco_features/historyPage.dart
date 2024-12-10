import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryPage extends StatelessWidget {
  final String userId;

  const HistoryPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Activity'),
        backgroundColor: Colors.green,
      ),
      body: StreamBuilder<QuerySnapshot>(
        // Stream without filters for testing
        stream: FirebaseFirestore.instance.collection('pickups').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No history available.'));
          }

          final pickups = snapshot.data!.docs;

          return ListView.builder(
            itemCount: pickups.length,
            itemBuilder: (context, index) {
              final data = pickups[index].data() as Map<String, dynamic>;
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.restore, color: Colors.green),
                  title: Text(data['waste_type'] ?? 'Unknown'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Date: ${data['date'] ?? 'N/A'}'),
                      Text('Time: ${data['time'] ?? 'N/A'}'),
                      Text('Address: ${data['address'] ?? 'N/A'}'),
                      if (data['notes'] != null && data['notes'].isNotEmpty)
                        Text('Notes: ${data['notes']}'),
                    ],
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, color: Colors.green),
                ),
              );
            },
          );
        },
      ),
    );
  }
}