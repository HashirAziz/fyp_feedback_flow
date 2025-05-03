import 'package:flutter/material.dart';

class TransportHeadScreen extends StatelessWidget {
  const TransportHeadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Image.asset(
                'assets/images/logo.png',
                height: 250,
                width: 250,
              ),
            ),
            const SizedBox(height: 10),
            const Center(
              child: Text(
                'TRANSPORT HEAD',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildButton('View Analytics', () {
              // Navigator.pushNamed(context, '/analytics');
            }),
            _buildButton('View Routes', () {
              // Navigator.pushNamed(context, '/routes');
            }),
            _buildButton('View Live Location', () {
              // Navigator.pushNamed(context, '/liveLocation');
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(String title, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}