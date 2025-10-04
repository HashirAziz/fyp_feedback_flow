import 'package:flutter/material.dart';
import 'package:fyp_feedback_flow/routes/app_routes.dart';
import 'package:get/get.dart';

import 'controller/login_screen_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late LoginScreenController _loginScreenController;

  @override
  void initState() {
    super.initState();

    _loginScreenController =
        Get.isRegistered<LoginScreenController>()
            ? Get.find<LoginScreenController>()
            : Get.put(LoginScreenController());
    _loginScreenController.animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _loginScreenController.scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 2.0,
    ).animate(
      CurvedAnimation(
        parent: _loginScreenController.animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    Get.delete<LoginScreenController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: ScaleTransition(
                    scale: _loginScreenController.scaleAnimation,
                    child: Image.asset(
                      'assets/images/logo.png',
                      height: 250,
                      width: 250,
                    ),
                  ),
                ),
                const Text(
                  'Student Login',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _loginScreenController.emailController,
                  decoration: const InputDecoration(
                    hintText: "Email",
                    hintStyle: TextStyle(color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                  style: const TextStyle(color: Colors.black),
                ),
                const SizedBox(height: 10),
                Obx(() {
                  return TextField(
                    controller: _loginScreenController.passwordController,
                    obscureText: !_loginScreenController.passwordVisible.value,
                    decoration: InputDecoration(
                      hintText: "Password",
                      hintStyle: const TextStyle(color: Colors.black),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      fillColor: Colors.white,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _loginScreenController.passwordVisible.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.blue,
                        ),
                        onPressed:
                            _loginScreenController.togglePasswordVisibility,
                      ),
                    ),
                    style: const TextStyle(color: Colors.black),
                  );
                }),
                const SizedBox(height: 20),
                Obx(() {
                  return _loginScreenController.isLoading.value
                      ? const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.blue,
                          ),
                        ),
                      )
                      : ElevatedButton(
                        onPressed: () {
                          _loginScreenController.signInWithEmailPassword();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3591CF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "LOGIN",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      );
                }),
                TextButton(
                  onPressed: () {
                    Get.toNamed(AppRoutes.forgotPasswordScreen);
                  },
                  child: const Text(
                    'Forgot your password?',
                    style: TextStyle(color: Color(0xFF3591CF)),
                  ),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: _loginScreenController.signInWithGoogle,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: Colors.blue),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.g_mobiledata, size: 24),
                      SizedBox(width: 10),
                      Text('Sign in with Google'),
                    ],
                  ),
                ),

                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Get.offNamed(AppRoutes.signUpScreen);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3591CF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "CREATE NEW ACCOUNT",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
