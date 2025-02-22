import 'package:cleanloop/pages/Notification/overallNotifi.dart';
import 'package:cleanloop/pages/eco_features/historyPage.dart';
import 'package:cleanloop/pages/eco_features/schedulePickUp.dart';
import 'package:cleanloop/pages/tracking_location/map_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'Reward.dart';
import 'pages/Events/communityEvents.dart';
import 'pages/UserProfile/RecyclingGuide.dart';
import 'pages/UserProfile/userProfile.dart';
import 'pages/eco_features/greenMarket.dart';
import 'package:url_launcher/url_launcher.dart';

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
      const HomeScreen(),
      const NotificationPage(),
      HistoryPage(),
      const Userprofile(),

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
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Green Container (Profile Section at the Top)
          Container(
            color: const Color(0xff34D399),
            padding: const EdgeInsets.all(17.0),
            child: Column(
              children: [
                // Profile and Points Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
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
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    color: Colors.white
                                  ),
                                );
                              }
                              return const CircularProgressIndicator();
                            },
                          ),
                            const Text(
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
          // Ad Container (Immediately After Search Bar)
          // Ad Container (Immediately After Search Bar)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Featured Organizations',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 180, // Fixed height to prevent overflow
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      final ngoAds = [
                        {
                          'title': 'WWF Conservation',
                          'description': 'Join our mission to protect wildlife and reduce plastic waste in oceans.',
                          'action': 'Support Now',
                          'icon': Icons.pets,
                          'orgType': 'INGO',
                          'url': 'https://www.wwfnepal.org/'
                        },
                        {
                          'title': 'Green Earth Nepal',
                          'description': 'Local initiative for tree plantation and waste management awareness.',
                          'action': 'Join Campaign',
                          'icon': Icons.forest,
                          'orgType': 'NGO',
                          'url': 'https://cleanupnepal.org.np/'
                        },
                        {
                          'title': 'Clean City Initiative',
                          'description': 'Community-driven program for sustainable urban waste management.',
                          'action': 'Volunteer',
                          'icon': Icons.cleaning_services,
                          'orgType': 'NGO',
                          'url': 'https://cleanupnepal.org.np/waste-management/'
                        },
                      ];

                      final ad = ngoAds[index];

                      return Container(
                        margin: const EdgeInsets.only(right: 16.0),
                        width: 280, // Fixed width
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: Colors.green.shade200,
                              width: 1,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(ad['icon'] as IconData,
                                        size: 24,
                                        color: Colors.green),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            ad['title'] as String,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            ad['orgType'] as String,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Expanded(
                                  child: Text(
                                    ad['description'] as String,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      final url = Uri.parse(ad['url'] as String);
                                      if (await canLaunchUrl(url)) {
                                        await launchUrl(url);
                                      } else {
                                        // Show error message if URL cannot be launched
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text('Could not launch website'),
                                            ),
                                          );
                                        }
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      padding: const EdgeInsets.symmetric(vertical: 8),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: Text(
                                      ad['action'] as String,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),


          // Categories Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
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
                  physics:  const NeverScrollableScrollPhysics(), // Disable inner scroll
                  gridDelegate:  const SliverGridDelegateWithFixedCrossAxisCount(
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
            Navigator.push(context, MaterialPageRoute(builder: (context)=> const MapPage()));
          }

          if (title == "Green Market"){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> const GreenMarketPage()));
          }

          if (title == "Schedule Pickup"){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>const SchedulePickupPage()));
          }

          if (title == "Community Events"){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>const CommunityEventsPage()));
          }
          if (title == "Recycling Guide"){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>const Recyclingguide()));
          }
          if(title == "Rewards & Points"){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>const RewardPage()));
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
            boxShadow: const [
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
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Notifications Screen'),
    );
  }
}

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('My History Screen'),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('User Profile Screen'),
    );
  }
}