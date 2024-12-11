import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Enum to define history item types
enum HistoryItemType { reward }

// Model class for a history item
class HistoryItem {
  final HistoryItemType type;
  final Map<String, dynamic> data;
  final DateTime date;

  HistoryItem({required this.type, required this.data, required this.date});
}

class HistoryPage extends StatelessWidget {
  HistoryPage({Key? key}) : super(key: key);

  final String? userEmail = FirebaseAuth.instance.currentUser?.email;

  // Parse a Firestore timestamp into a DateTime, with error handling
  DateTime _parseDate(dynamic dateField) {
    if (dateField is Timestamp) {
      return dateField.toDate();
    } else if (dateField is String) {
      try {
        return DateTime.parse(dateField);
      } catch (_) {
        return DateTime(1970); // Fallback date
      }
    }
    return DateTime(1970); // Fallback for invalid/missing dates
  }

  // Stream to fetch reward history from Firestore
  Stream<List<HistoryItem>> _getRewardHistoryStream() {
    final rewardsStream = FirebaseFirestore.instance
        .collection('users')
        .doc(userEmail) // Use userEmail here to reference the user collection
        .collection('rewardHistory')
        .orderBy('claimedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return HistoryItem(
        type: HistoryItemType.reward,
        data: data,
        date: _parseDate(data['claimedAt']),
      );
    }).toList());

    return rewardsStream;
  }

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
        title: const Text('My Activity',  style: TextStyle( fontSize: 22, fontWeight: FontWeight.w600),),
        centerTitle: true,
        backgroundColor: const Color(0xFF34D399), // Green color
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Trigger reload of the data when needed
            },
          ),
        ],
      ),
      body: StreamBuilder<List<HistoryItem>>(
        stream: _getRewardHistoryStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final rewardHistory = snapshot.data ?? [];

          if (rewardHistory.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'No rewards claimed yet.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: rewardHistory.length,
            itemBuilder: (context, index) {
              return _buildRewardCard(rewardHistory[index]);
            },
          );
        },
      ),
    );
  }

  // Method to build a reward card
  Widget _buildRewardCard(HistoryItem item) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Color(0xFF34D399),
          child: Icon(Icons.redeem, color: Colors.white),
        ),
        title: Text(
          item.data['rewardTitle'] ?? 'Unknown Reward',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Claimed on: ${item.date.toLocal().toString().split(' ')[0]}'),
            const SizedBox(height: 4),
            Text('Description: ${item.data['description'] ?? 'No description'}'),
            const SizedBox(height: 4),
            Text('Points Spent: ${item.data['pointsSpent'] ?? 'N/A'}'),
          ],
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey[600],
        ),
      ),
    );
  }
}
