import 'package:cleanloop/pages/schedulePickUp.dart';
import 'package:cleanloop/pages/tracking_location/map_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'RecyclingGuide.dart';
import 'UserProfile/userProfile.dart';
import 'communityEvents.dart';
import 'greenMarket.dart';

class WasteCleaningHomePage extends StatefulWidget {
  const WasteCleaningHomePage({super.key});

  @override
  _WasteCleaningHomePageState createState() => _WasteCleaningHomePageState();
}

class _WasteCleaningHomePageState extends State<WasteCleaningHomePage> {
  int _currentIndex = 0; // To track the selected tab

  final List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _screens.addAll([
      HomeScreen(),
      NotificationsScreen(),
      HistoryScreen(),
      Userprofile(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'My History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

// Home Screen
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Green Container (Profile Section at the Top)
          Container(
            color: Colors.green,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Profile and Points Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(
                              'https://via.placeholder.com/150'), // Profile Image
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:  [
                          StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection("users")
                                .where("email", isEqualTo: FirebaseAuth.instance.currentUser?.email)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.active &&
                                  snapshot.hasData &&
                                  snapshot.data!.docs.isNotEmpty) {
                                return Text(
                                  snapshot.data!.docs[0]["name"],
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    color: Colors.white
                                  ),
                                );
                              }
                              return CircularProgressIndicator();
                            },
                          ),
                            Text(
                              'Keep your city clean!',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Text(
                      'Points: 120',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Search Bar
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search services or categories...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // Ad Container (Immediately After Search Bar)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.lightGreen[100],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.green, width: 2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '🌱 Plant a tree today!',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Join our green initiative and earn rewards while contributing to a healthier planet.',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Handle start now action
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    label: const Text('Start Now'),
                    icon: const Icon(Icons.arrow_forward),
                  ),
                ],
              ),
            ),
          ),

          // Categories Section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Categories',
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                GridView.builder(
                  itemCount: 6,
                  shrinkWrap: true, // Ensures the grid fits within the scroll
                  physics:  NeverScrollableScrollPhysics(), // Disable inner scroll
                  gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // 3 items per row
                    crossAxisSpacing: 8, // Horizontal spacing
                    mainAxisSpacing: 8, // Vertical spacing
                  ),
                  itemBuilder: (context, index) {
                    final categories = [
                      ['Schedule Pickup', Icons.schedule],
                      ['Waste Tracking', Icons.track_changes],
                      ['Recycling Guide', Icons.restore_from_trash],
                      ['Community Events', Icons.event],
                      ['Rewards & Points', Icons.card_giftcard],
                      ['Green Market', Icons.eco],
                    ];
                    return _buildCategoryCard(
                        context,
                        categories[index][0] as String,
                        categories[index][1] as IconData);
                  },
                ),
              ],
            ),
          ),

          // Recycling Tips Section
        ],
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, String title, IconData icon) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 2,
      child: InkWell(
        onTap: () {
          if (title=="Waste Tracking"){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> MapPage()));
          }

          if (title == "Green Market"){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> GreenMarketPage()));
          }

          if (title == "Schedule Pickup"){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>SchedulePickupPage()));
          }

          if (title == "Community Events"){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>CommunityEventsPage()));
          }
          if (title == "Recycling Guide"){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>Recyclingguide()));
          }


          // Handle category selection
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.green),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildTipCards(List<Map<String, dynamic>> tips) {
    return tips.map((tip) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(4, 4),
                blurRadius: 6,
              ),
              BoxShadow(
                color: Colors.white,
                offset: Offset(-4, -4),
                blurRadius: 6,
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    tip["icon"],
                    size: 28,
                    color: Colors.green,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    tip["title"],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...tip["subtitles"].map<Widget>((subtitle) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subtitle["heading"],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle["content"],
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      );
    }).toList();
  }
}

// Dummy Screens
class NotificationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Notifications Screen'),
    );
  }
}

class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('My History Screen'),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('User Profile Screen'),
    );
  }
}