import 'package:flutter/material.dart';
import 'package:fyp_feedback_flow/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectRoleScreen extends StatefulWidget {
  const SelectRoleScreen({super.key});

  @override
  State<SelectRoleScreen> createState() => _SelectRoleScreenState();
}

class _SelectRoleScreenState extends State<SelectRoleScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 2.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Image.asset(
                  'assets/images/logo.png',
                  height: 250,
                  width: 250,
                ),
              ),
            ),
            const Text(
              'Login to your Account',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            _buildLoginButton(context, 'Student', 'student'),
            _buildLoginButton(context, 'Transport Head', 'transportHead'),
            _buildLoginButton(context, 'Driver/Conductor', 'driverConductor'),
            _buildLoginButton(context, 'Faculty/Staff', 'facultyStaff'),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginButton(
    BuildContext context,
    String title,
    String? userType,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ElevatedButton(
        onPressed: () async {
          final prefs = await SharedPreferences.getInstance();
          if (userType != null) {
            await prefs.setString('userType', userType);
            Get.toNamed(AppRoutes.loginScreen);
          } else {
            await prefs.remove('userType');
          }
        },
        child: Text(
          title,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
        ),
      ),
    );
  }
}
