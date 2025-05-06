import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  String _selectedUserType = 'Student';
  bool _isLoading = false;
  final _auth = FirebaseAuth.instance;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, String>?;
    if (args != null && args['userType'] != null) {
      _selectedUserType = args['userType']!;
    }
  }

  Future<void> _sendPasswordResetEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await _auth.sendPasswordResetEmail(email: _emailController.text.trim());
      _showConfirmation();
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Error sending reset email';
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found with that email';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Invalid email format';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Recovery Email Sent'),
        content: Text(
          'Instructions have been sent to ${_emailController.text}\n'
              'Please check your email to reset your password.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Password Recovery',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),
              DropdownButtonFormField<String>(
                value: _selectedUserType,
                dropdownColor: Colors.blue,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Account Type',
                  labelStyle: const TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'Student',
                    child: Text('Student', style:  TextStyle(fontSize: 12, fontWeight: FontWeight.bold,color: Colors.white)),
                  ),
                  DropdownMenuItem(
                    value: 'Transport Head',
                    child: Text('Transport Head', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,color: Colors.white)),
                  ),
                  DropdownMenuItem(
                    value: 'Driver/Conductor',
                    child: Text('Driver/Conductor', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,color: Colors.white)),
                  ),
                  DropdownMenuItem(
                    value: 'Faculty/Staff',
                    child: Text('Faculty/Staff', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,color: Colors.white)),
                  ),
                ],
                onChanged: (String? newValue) {
                  setState(() => _selectedUserType = newValue!);
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Registered Email',
                  labelStyle: const TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _isLoading ? null : _sendPasswordResetEmail,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3591CF),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  minimumSize: const Size(double.infinity, 40),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text(
                  'Send Recovery Instructions',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}