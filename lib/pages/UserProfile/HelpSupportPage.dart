import 'package:flutter/material.dart';

import 'Feedback.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff34D399),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 36,),
          onPressed: () {
            // Navigate back to login page
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Help & Support",
          style: TextStyle(
            fontFamily: "Calistoga",
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Frequently Asked Questions (FAQs)",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const ExpansionTile(
                title: Text(
                  "How does CleanLoop work?",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "CleanLoop helps you manage household waste efficiently by providing tracking tools, recycling guidelines, and connections to local waste collection services. It also includes gamified features to encourage eco-friendly habits.",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              const ExpansionTile(
                title: Text(
                  "How can I track my waste?",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Use the 'Waste Tracker' feature to log and monitor your waste disposal and recycling activities. You'll also earn points for reducing waste.",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              const ExpansionTile(
                title: Text(
                  "How do I report issues?",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "To report issues, go to the 'Contact Us' section below and share your concerns via email or phone.",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Divider(thickness: 1),
              const SizedBox(height: 16),
              const Text(
                "Contact Us",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.email, color: Colors.green),
                title: const Text(
                  "Email Us",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: const Text("support@cleanloop.com"),
                onTap: () {
                  // Add email functionality
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.phone, color: Colors.green),
                title: const Text(
                  "Call Us",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: const Text("+977 98408704441"),
                onTap: () {
                  // Add call functionality
                },
              ),
              const Divider(),
              const SizedBox(height: 24),
              const Divider(thickness: 1),
              const SizedBox(height: 16),
              const Text(
                "App Feedback",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "We value your feedback! Share your thoughts, suggestions, or concerns to help us improve CleanLoop.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const FeedbackPage()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade500,
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.2,
                      vertical: screenHeight * 0.015,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Submit Feedback",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
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
}
