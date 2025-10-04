import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nameController = TextEditingController();
  RxString selectedBusRoute = ''.obs;
  RxBool showPassword = false.obs;
  RxBool showConfirmPassword = false.obs;
  RxList<String> busRoutes =
      <String>[
        'Select Bus Route',
        'NUML Bus #1',
        'NUML Bus #2',
        'NUML Bus #3',
        'NUML Bus #4',
        'NUML Bus #5',
        'NUML Bus #6',
        'NUML Bus #7',
        'NUML Bus #8',
        'NUML Bus #9',
        'NUML Bus #10',
      ].obs;
  final auth = FirebaseAuth.instance;
  RxBool isLoading = false.obs;

  void toggleShowPassword() {
    showPassword.value = !showPassword.value;
  }

  void toggleShowConfirmPassword() {
    showConfirmPassword.value = !showConfirmPassword.value;
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  Future<void> createAccount(GlobalKey<FormState> formKey) async {
    if (!formKey.currentState!.validate()) return;

    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar(
        'Error',
        'Passwords do not match',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      await auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final prefs = await SharedPreferences.getInstance();
      String? userType = prefs.getString('userType');

      //? store data in firebase firestore users collection
      final userId = auth.currentUser?.uid;
      if (userId != null) {
        await FirebaseFirestore.instance.collection('users').doc(userId).set({
          'email': emailController.text.trim(),
          'name': nameController.text.trim(),
          'userType': userType ?? 'unknown',
          'route':
              selectedBusRoute.value != 'Select Bus Route'
                  ? selectedBusRoute.value
                  : null,
        });
      }

      Get.snackbar(
        'Success',
        'Account created successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Account creation failed';
      if (e.code == 'weak-password') {
        errorMessage = 'Password is too weak (min 6 characters)';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'Email is already registered';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Invalid email format';
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
