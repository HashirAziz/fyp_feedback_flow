import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
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
              const SizedBox(height: 20),
              const Text(
                'Login to your Account',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              _buildLoginButton(
                context,
                'Student',
                '/studentsLogin',
              ),
              _buildLoginButton(
                context,
                'Transport Head',
                '/adminStaffFacultyLogin',
                'Transport Head',
              ),
              _buildLoginButton(
                context,
                'Driver/Conductor',
                '/adminStaffFacultyLogin',
                'Driver/Conductor',
              ),
              _buildLoginButton(
                context,
                'Faculty/Staff',
                '/adminStaffFacultyLogin',
                'Faculty/Staff',
              ),
              const SizedBox(height: 15),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/createNewAccount');
                },
                child: const Text(
                  "Don't have an account? Sign up",
                  style: TextStyle(
                    color: Color(0xFF3591CF),
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton(
      BuildContext context,
      String title,
      String route, [
        String? userType,
      ]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ElevatedButton(
        onPressed: () {
          if (userType != null) {
            Navigator.pushNamed(
              context,
              route,
              arguments: {'userType': userType},
            );
          } else {
            Navigator.pushNamed(context, route);
          }
        },
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}