import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RewardPage extends StatefulWidget {
  const RewardPage({super.key});

  @override
  _RewardPageState createState() => _RewardPageState();
}

class _RewardPageState extends State<RewardPage> {
  int _points = 0;
  List<Map<String, dynamic>> _rewardHistory = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);
    try {
      final userEmail = FirebaseAuth.instance.currentUser?.email;
      if (userEmail != null) {
        // Fetch user points
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userEmail)
            .get();

        // Fetch reward history
        final historySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userEmail)
            .collection('rewardHistory')
            .orderBy('claimedAt', descending: true)
            .get();

        setState(() {
          _points = userDoc.data()?['points'] ?? 0;
          _rewardHistory = historySnapshot.docs
              .map((doc) => doc.data())
              .toList();
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading data: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _claimReward(String title, int requiredPoints, String description) async {
    if (_points < requiredPoints) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Insufficient points!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final userEmail = FirebaseAuth.instance.currentUser?.email;
      if (userEmail == null) return;

      final userRef = FirebaseFirestore.instance.collection('users').doc(userEmail);
      final historyRef = userRef.collection('rewardHistory');

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        // Deduct points
        transaction.update(userRef, {
          'points': FieldValue.increment(-requiredPoints),
        });

        // Add to history
        transaction.set(historyRef.doc(), {
          'rewardTitle': title,
          'pointsSpent': requiredPoints,
          'description': description,
          'claimedAt': DateTime.now(),
        });
      });

      // Refresh data
      await _loadUserData();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Successfully claimed $title!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error claiming reward: $e'),
          backgroundColor: Colors.red,
        ),
      );
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
        title: const Text('Rewards & Points'),
        backgroundColor: const Color(0xFF34D399),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadUserData,
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                // Points Display Card
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF34D399), Color(0xFF059669)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Current Points',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _points.toString(),
                        style: const TextStyle(
                          fontSize: 48,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Participate in events to earn more points!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                // Available Rewards Section
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Available Rewards',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF059669),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Rewards Grid
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              delegate: SliverChildListDelegate([
                _buildRewardCard(
                  'Gift Voucher',
                  50,
                  'Get a \$10 shopping voucher',
                  Icons.card_giftcard,
                ),
                _buildRewardCard(
                  'Tree Plantation',
                  30,
                  'Plant a tree in your name',
                  Icons.park,
                ),
                _buildRewardCard(
                  'Eco Bag',
                  40,
                  'Stylish eco-friendly tote bag',
                  Icons.shopping_bag,
                ),
                _buildRewardCard(
                  'Coffee Voucher',
                  25,
                  'Free coffee at local cafe',
                  Icons.coffee,
                ),
              ]),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.85,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
            ),
          ),

          // Reward History Section
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Reward History',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF059669),
                    ),
                  ),
                ),
                if (_rewardHistory.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'No rewards claimed yet',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  )
                else
                  ..._rewardHistory.map((reward) => _buildHistoryCard(reward)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardCard(String title, int points, String description, IconData icon) {
    final bool canClaim = _points >= points;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: canClaim ? () => _claimReward(title, points, description) : null,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40,
                color: canClaim ? const Color(0xFF059669) : Colors.grey,
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: canClaim ? Colors.black87 : Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: canClaim ? Colors.black54 : Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: canClaim ? const Color(0xFF34D399) : Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$points Points',
                  style: TextStyle(
                    color: canClaim ? Colors.white : Colors.grey[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryCard(Map<String, dynamic> reward) {
    final DateTime claimedAt = (reward['claimedAt'] as Timestamp).toDate();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Color(0xFF34D399),
          child: Icon(Icons.redeem, color: Colors.white),
        ),
        title: Text(
          reward['rewardTitle'],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Claimed on ${_formatDate(claimedAt)}\n${reward['description']}',
        ),
        trailing: Text(
          '-${reward['pointsSpent']} pts',
          style: const TextStyle(
            color: Color(0xFF059669),
            fontWeight: FontWeight.bold,
          ),
        ),
        isThreeLine: true,
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}