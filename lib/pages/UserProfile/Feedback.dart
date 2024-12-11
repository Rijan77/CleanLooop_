import 'package:flutter/material.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final TextEditingController _feedbackController = TextEditingController();
  int _rating = 0;

  void _submitFeedback() {
    if (_feedbackController.text.isEmpty || _rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please provide feedback and select a rating.")),
      );
      return;
    }

    // Handle the feedback submission logic here
    print("Feedback Submitted: ${_feedbackController.text}");
    print("Rating: $_rating stars");

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Thank you for your feedback!")),
    );

    // Clear the form after submission
    _feedbackController.clear();
    setState(() {
      _rating = 0;
    });
  }

  Widget _buildStarRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return IconButton(
          onPressed: () {
            setState(() {
              _rating = index + 1; // Set rating to the star clicked
            });
          },
          icon: Icon(
            Icons.star,
            color: index < _rating ? Colors.orange : Colors.grey,
            size: 30,
          ),
        );
      }),
    );
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
        title: const Text("Feedback", style: TextStyle( fontFamily: "Calistoga",
          fontSize: 22,),),
        backgroundColor: const Color(0xff34D399),
      ),
      body: SingleChildScrollView(
        child : Padding(
          padding: const EdgeInsets.only(top: 35.0, left: 16.0, right: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "We value your feedback!",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                "Let us know your thoughts and suggestions to improve CleanLoop.",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 20),
        
              // Feedback TextField
              TextField(
                controller: _feedbackController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "Write your feedback here...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              const SizedBox(height: 20),
              const Divider(thickness: 1),
              const SizedBox(height: 25),
        
              // Star Rating
              const Text(
                "Rate Us:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 1),
              _buildStarRating(),
        
              // Submit Button
        
              const SizedBox(height: 20),
              const Divider(thickness: 1),
              const SizedBox(height: 175),
        
              Center(
                child: ElevatedButton(
                  onPressed: _submitFeedback,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Submit Feedback",
                    style: TextStyle(fontSize: 18,
                      fontWeight: FontWeight.bold,),
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
