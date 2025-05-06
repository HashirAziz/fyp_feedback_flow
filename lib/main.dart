import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/student_login_screen.dart';
import 'screens/login_screen_admin_staff_faculty.dart';
import 'screens/create_new_account.dart';
import 'screens/feedback_students_staff_faculty.dart';
import 'screens/feedback_submitted_successfully.dart';
import 'screens/transport_head_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/chatbot_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Enable debug logging
  //await FirebaseAuth.instance.setSettings(
  //appVerificationDisabledForTesting: true,
  //);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[400],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3591CF),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/adminStaffFacultyLogin': (context) {
          final args =
              ModalRoute.of(context)?.settings.arguments
                  as Map<String, String>?;
          final userType =
              args != null && args.containsKey('userType')
                  ? args['userType']!
                  : 'Unknown';
          return LoginScreenAdminStaffFaculty(userType: userType);
        },
        '/createNewAccount': (context) => const CreateNewAccountScreen(),
        '/studentsLogin': (context) => const StudentsLoginScreen(),
        '/feedback': (context) => FeedbackStudentsStaffFaculty(),
        '/feedbackSubmitted':
            (context) => const FeedbackSubmittedSuccessfully(),
        '/transportHead': (context) => const TransportHeadScreen(),
        '/forgotPassword': (context) => const ForgotPasswordScreen(),
        '/feedbackSubmittedSuccesfully':
            (context) => const FeedbackSubmittedSuccessfully(),
        '/chatbot': (context) => const ChatbotScreen(),
      },
    );
  }
}
