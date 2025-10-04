import 'package:flutter/material.dart';
import 'package:fyp_feedback_flow/routes/app_routes.dart';
import 'package:fyp_feedback_flow/screens/signup/controller/signup_controller.dart';
import 'package:get/get.dart';

class CreateNewAccountScreen extends StatefulWidget {
  const CreateNewAccountScreen({super.key});

  @override
  State<CreateNewAccountScreen> createState() => _CreateNewAccountScreenState();
}

class _CreateNewAccountScreenState extends State<CreateNewAccountScreen> {
  late SignupController _signupController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _signupController =
        Get.isRegistered<SignupController>()
            ? Get.find<SignupController>()
            : Get.put(SignupController());
  }

  @override
  void dispose() {
    Get.delete<SignupController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.offNamed(AppRoutes.loginScreen);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 250,
                    width: 250,
                  ),
                ),
                const Text(
                  'Create a New Account',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _signupController.emailController,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    hintText: "Email",
                    hintStyle: TextStyle(color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                //? Name Field
                TextFormField(
                  controller: _signupController.nameController,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    hintText: "Name",
                    hintStyle: TextStyle(color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                //? Dropdown for Bus Selection
                Obx(() {
                  return DropdownButtonFormField<String>(
                    value:
                        _signupController.selectedBusRoute.value.isEmpty
                            ? null
                            : _signupController.selectedBusRoute.value,
                    items:
                        _signupController.busRoutes
                            .map(
                              (bus) => DropdownMenuItem(
                                value: bus,
                                child: Text(bus),
                              ),
                            )
                            .toList(),
                    onChanged: (value) {
                      _signupController.selectedBusRoute.value = value ?? '';
                    },
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                      hintText: 'Select Bus',
                      hintStyle: TextStyle(color: Colors.black),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a bus';
                      }
                      return null;
                    },
                  );
                }),
                const SizedBox(height: 10),
                Obx(() {
                  return TextFormField(
                    controller: _signupController.passwordController,
                    obscureText: !_signupController.showPassword.value,
                    style: const TextStyle(color: Colors.black),
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
                          _signupController.showPassword.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          _signupController.toggleShowPassword();
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  );
                }),
                const SizedBox(height: 10),
                Obx(() {
                  return TextFormField(
                    controller: _signupController.confirmPasswordController,
                    obscureText: !_signupController.showConfirmPassword.value,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      hintText: "Confirm Password",
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
                          _signupController.showConfirmPassword.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          _signupController.toggleShowConfirmPassword();
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != _signupController.passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  );
                }),
                const SizedBox(height: 30),
                Obx(() {
                  return ElevatedButton(
                    onPressed:
                        _signupController.isLoading.value
                            ? null
                            : () {
                              _signupController.createAccount(_formKey);
                            },
                    child:
                        _signupController.isLoading.value
                            ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                            : const Text('Create Account'),
                  );
                }),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Get.offNamed(AppRoutes.loginScreen);
                  },
                  child: const Text(
                    'Already have an account? Login',
                    style: TextStyle(color: Color(0xFF3591CF), fontSize: 14),
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
