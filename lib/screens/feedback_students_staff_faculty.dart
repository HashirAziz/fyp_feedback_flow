// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'feedback_submitted_successfully.dart';
import 'chatbot_screen.dart'; // Add this import

class FeedbackStudentsStaffFaculty extends StatefulWidget {
  const FeedbackStudentsStaffFaculty({super.key});

  @override
  State<FeedbackStudentsStaffFaculty> createState() =>
      _FeedbackStudentsStaffFacultyState();
}

class _FeedbackStudentsStaffFacultyState
    extends State<FeedbackStudentsStaffFaculty> {
  final TextEditingController _textFeedbackController = TextEditingController();
  final TextEditingController _voiceFeedbackController =
      TextEditingController();

  @override
  void dispose() {
    _textFeedbackController.dispose();
    _voiceFeedbackController.dispose();
    super.dispose();
  }

  String _response = "";

  // Function to call Flask API
  Future<void> _submitReview() async {
    String review = _textFeedbackController.text;

    if (review.isEmpty) {
      setState(() {
        _response = "Please enter a review.";
      });
      return;
    }

    // API URL (Change this to your server URL)
    final String apiUrl = 'http://192.168.0.106:5000/predict';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'reviews': review}),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          _response = "${data['predicted_sentiments'][0]}";
        });
      } else {
        setState(() {
          _response = "Failed to get response.";
        });
      }
    } catch (e) {
      setState(() {
        _response = "Error: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  height: 250,
                  width: 300,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "How's the service Quality?",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              const Text(
                "Submit your Feedback or Suggestions...",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _textFeedbackController,
                maxLines: 3,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[400],
                  hintText: "Text Feedback/Suggestion",
                  prefixIcon: const Icon(Icons.text_fields, color: Colors.blue),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_textFeedbackController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Please enter your feedback before submitting',
                          ),
                        ),
                      );
                    } else {
                      await _submitReview();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => FeedbackSubmittedSuccessfully(
                                response: _response,
                              ),
                        ),
                      );
                      _textFeedbackController.clear();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: const Size(120, 40),
                  ),
                  child: const Text(
                    "Submit",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _voiceFeedbackController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[400],
                  hintText: "Voice Feedback/Suggestion",
                  prefixIcon: const Icon(Icons.mic, color: Colors.blue),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton(
                  onPressed: () {
                    if (_voiceFeedbackController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Please record your voice feedback before submitting',
                          ),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  const FeedbackSubmittedSuccessfully(),
                        ),
                      );
                      _voiceFeedbackController.clear();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: const Size(120, 40),
                  ),
                  child: const Text(
                    "Submit",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Center(
                child: Text(
                  "Ask Queries",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChatbotScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.chat, color: Colors.white),
                  label: const Text(
                    "FEEDCHAT",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: const Size(250, 40),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
