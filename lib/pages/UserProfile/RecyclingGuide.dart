import 'package:flutter/material.dart';

class Recyclingguide extends StatefulWidget {
  const Recyclingguide({super.key});

  @override
  State<Recyclingguide> createState() => _RecyclingguideState();
}

class _RecyclingguideState extends State<Recyclingguide> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            floating: true,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 35,),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                "Recycling Guide",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.green, Colors.teal],
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.recycling,
                    size: 80,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                _buildTipCards([
                  {
                    "icon": Icons.watch_later_outlined,
                    "title": "Daily Habit",
                    "color": Colors.blue,
                    "subtitles": [
                      {
                        "heading": "5-Minute Sorting",
                        "content": "Set up separate bins for materials. Sort waste right after use—it only takes seconds!"
                      },
                      {
                        "heading": "Weekly Audit",
                        "content": "Check bins every Sunday. Notice patterns to reduce waste next week."
                      }
                    ]
                  },
                  {
                    "icon": Icons.energy_savings_leaf,
                    "title": "Smart Recycling",
                    "color": Colors.green,
                    "subtitles": [
                      {
                        "heading": "Clean Before Recycling",
                        "content": "Quick rinse containers. Dirty items can contaminate entire batches."
                      },
                      {
                        "heading": "Compress Containers",
                        "content": "Flatten boxes and crush bottles to save space. Remove caps first."
                      }
                    ]
                  },
                  {
                    "icon": Icons.folder_special_outlined,
                    "title": "Special Items",
                    "color": Colors.orange,
                    "subtitles": [
                      {
                        "heading": "Electronics",
                        "content": "Never throw batteries in regular trash. Find e-waste centers nearby."
                      },
                      {
                        "heading": "Plastics Guide",
                        "content": "Check the number in the triangle. Types 1 & 2 are widely recyclable."
                      }
                    ]
                  },
                  {
                    "icon": Icons.smart_button_outlined,
                    "title": "Reduce & Reuse",
                    "color": Colors.purple,
                    "subtitles": [
                      {
                        "heading": "Shopping Smart",
                        "content": "Choose minimal packaging. Bring reusable bags for groceries."
                      },
                      {
                        "heading": "Creative Reuse",
                        "content": "Glass jars make great storage containers. Old newspapers work as gift wrap."
                      }
                    ]
                  },
                ]),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: AnimatedBuilder(
        animation: _scrollController,
        builder: (context, child) {
          return AnimatedOpacity(
            opacity: _scrollController.offset > 100 ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: FloatingActionButton(
              onPressed: () {
                _scrollController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
              child: const Icon(Icons.arrow_upward),
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildTipCards(List<Map<String, dynamic>> tips) {
    return tips.map((tip) {
      return Hero(
        tag: tip["title"],
        child: Card(
          elevation: 4,
          margin: const EdgeInsets.only(bottom: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: InkWell(
            onTap: () => _showDetailDialog(tip),
            borderRadius: BorderRadius.circular(16.0),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: (tip["color"] as Color).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          tip["icon"],
                          size: 28,
                          color: tip["color"] as Color,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          tip["title"],
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: tip["color"] as Color,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: tip["color"] as Color,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...tip["subtitles"].map<Widget>((subtitle) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
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
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  void _showDetailDialog(Map<String, dynamic> tip) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          tip["icon"],
                          size: 32,
                          color: tip["color"] as Color,
                        ),
                        const SizedBox(width: 16),
                        Text(
                          tip["title"],
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: tip["color"] as Color,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    ...tip["subtitles"].map<Widget>((subtitle) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              subtitle["heading"],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              subtitle["content"],
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                                height: 1.6,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}