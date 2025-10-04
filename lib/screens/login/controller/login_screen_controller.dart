import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp_feedback_flow/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreenController extends GetxController {
  late AnimationController animationController;
  late Animation<double> scaleAnimation;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final auth = FirebaseAuth.instance;
  RxBool isLoading = false.obs;
  RxBool passwordVisible = false.obs;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);

  void togglePasswordVisibility() {
    passwordVisible.value = !passwordVisible.value;
  }

  @override
  void onClose() {
    animationController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> signInWithGoogle() async {
    try {
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        Get.back();
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await auth.signInWithCredential(
        credential,
      );

      final String? userType = await Get.dialog<String>(
        AlertDialog(
          title: const Text('Select User Type'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Student'),
                onTap: () => Get.back(result: 'student'),
              ),
              ListTile(
                title: const Text('Transport Head'),
                onTap: () => Get.back(result: 'transportHead'),
              ),
              ListTile(
                title: const Text('Driver/Conductor'),
                onTap: () => Get.back(result: 'driverConductor'),
              ),
              ListTile(
                title: const Text('Faculty/Staff'),
                onTap: () => Get.back(result: 'facultyStaff'),
              ),
            ],
          ),
        ),
      );

      final prefs = await SharedPreferences.getInstance();
      if (userType != null) {
        await prefs.setString('userType', userType);
      } else {
        await prefs.remove('userType');
      }

      Get.back(); // Close the loading dialog

      //? store user info in firestore
      final User? user = userCredential.user;
      if (user != null) {
        final userData = {
          'email': user.email,
          'name': user.displayName,
          'userType': userType ?? 'unknown',
          'route': null,
        };
        // You can save this data to Firestore if needed
        debugPrint('User Data: $userData');
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set(userData, SetOptions(merge: true));
      }

      if (userCredential.user != null) {
        Get.offAllNamed(AppRoutes.homeScreen);
      }
    } catch (error) {
      Get.back(); // Close the loading dialog
      Get.snackbar(
        'Error',
        'Google Sign-In failed. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      debugPrint('Google Sign-In Error: $error');
    }
  }

  Future<void> signInWithEmailPassword() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter both email and password.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      final UserCredential userCredential = await auth
          .signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );

      if (userCredential.user != null) {
        // Navigate to home screen
        Get.offAllNamed(AppRoutes.homeScreen);
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Login failed. Please try again.';
      if (e.code == 'user-not-found') {
        errorMessage = 'No student found with this email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Incorrect password.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Invalid email format.';
      }

      Get.snackbar(
        'Error',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
